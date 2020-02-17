//= require lodash
//= require heracles/admin/superagent.js
//= require heracles/admin/emitter.js
//= require heracles/admin/exif.js
//= require heracles/admin/utils/get-csrf-token

;(function() {

/**
 * preSign
 * Return a promise that gets an S3 signature
 * rejects on error, resolves on success
 * @param  {Array}   files: Array of files to upload
 * @param  {String}  token: CSRF token
 * @return {Promise}
 */

function preSign(file, token, emitter) {
  var data = {
    "file_name": file.name,
    "content_type": file.type
  };

  return new Promise(function(resolve, reject) {

    emitter.emit("presign-started");

    superagent
      .post(HeraclesAdmin.baseURL + "api/sites/" + HeraclesAdmin.siteSlug + "/assets/presign")
      .send(data)
      .set({
        "X-CSRF-Token": token,
        Accept: "application/json"
      })
      .end(function(err, res){
        if (err) reject(err);
        resolve(JSON.parse(res.text));
      });

  });
}


/**
 * formData
 * Build up and return a FormData object
 *
 * @param {String} as: Define the type of form data
 * @param {Object} file: a file object
 * @param {Object} fields: key/value from preSign response
 * @return {Object} FormData
 */

function formData(as, file, fields) {
  var data = new FormData();

  if(fields) {
    Object.keys(fields).forEach(function(key) {
      data.append(key, fields[key]);
    });
  }

  data.append(as, file, file.name);
  return data;
}



/**
 * uploadToS3
 */

function uploadToS3(res, file, token, emitter) {
  var url = res.url;
  var data = formData(res.as, file, res.fields);
  var key = res.fields.key;

  return new Promise(function(resolve, reject) {

    emitter.emit("upload-started");

    superagent
      .post(url)
      .send(data)
      .set({
        "X-CSRF-Token": token,
        Accept: "application/json"
      })
      .on("progress", function(e) {
        emitter.emit("upload-progress", e);
      })
      .end(function(err, res){
        if (err) reject(err);
        res.original_path = key;
        emitter.emit("upload-complete", data);
        resolve(res);
      });
  });
}


/**
 * persistToDatabase
 * Return a promise that posts to the Mercury database
 * Build data to post from uploadToS3() reponse and file object
 * rejects on error, resolves on success
 *
 * @param  {Object} res: response from uploadToS3()
 * @param  {String} token: csrf-token
 * @param  {Object} file: file object
 */

function persistToDatabase(res, file, metadata, token, emitter) {

  var originalPath = res.original_path;

  var data = {
    "original_path": originalPath,
    "file_name": file.name,
    "content_type": file.type
  };
  data = _.extend({}, data, metadata);

  emitter.emit("persist-started");

  return new Promise(function(resolve, reject) {

    superagent
      .post(HeraclesAdmin.baseURL + "api/sites/" + HeraclesAdmin.siteSlug + "/assets")
      .send(data)
      .set({
        "X-CSRF-Token": token,
        Accept: "application/json"
      })
      .end(function(err, res){
        if (err) reject(err);
        emitter.emit("persist-complete");
        resolve(JSON.parse(res.text));
      });
  });
}


/**
 * correctImageMetadata
 */
function correctImageMetadata(file, metadata) {
  var rawRatio = metadata.raw_width / metadata.raw_height;

  return new Promise(function(resolve, reject) {
    EXIF.getData(file, function () {
      var correctedOrientation;
      var rawOrientation = EXIF.getTag(this, "Orientation");

      // Set the correction to square or landscape to start with
      var initialOrientation = "landscape";
      if (rawRatio === 1) {
        initialOrientation = "square";
      } else if (rawRatio < 1) {
        initialOrientation = "portrait";
      }

      // Set the default corrected orientation
      correctedOrientation = initialOrientation;
      // And a default set of raw height/width values
      metadata.corrected_width = metadata.raw_width;
      metadata.corrected_height = metadata.raw_height;

      if (rawOrientation !== undefined) {

        // Flip orientation based on the EXIF orientation values 1,2,3,4 are
        // variations on the _correct_ orientation, and 5,6,7,8 are rotated
        // versions. Some of those indicate mirrored values but we don't care
        // about that since we're not storing it.
        if (rawOrientation >= 5) {
          if (correctedOrientation === "landscape") {
            correctedOrientation = "portrait";
          } else if (correctedOrientation === "portrait") {
            correctedOrientation = "landscape";
          }
          // Flip the width/height for metadata
          metadata.corrected_width = metadata.raw_height;
          metadata.corrected_height = metadata.raw_width;
        }
      }
      metadata.corrected_orientation = correctedOrientation;
      metadata.raw_orientation = rawOrientation;
      resolve(metadata);
    });
  });
}



/**
 * Parse file metadata
 */
function parseMetadata(file, emitter) {
  var isImage = file.type.match("image.*");

  return new Promise(function(resolve, reject) {

    var metadata = {
      size: file.size
    };
    var isImage = file.type.match("image.*");

    if (isImage) {
      var reader = new FileReader();
      reader.onload = (function(f) {
        var image = new Image();

        image.onload = function() {
          var rawHeight = image.height;
          var rawWidth = image.width;

          metadata.raw_height = rawHeight;
          metadata.raw_width = rawWidth;

          correctImageMetadata(file, metadata).then(function(data) {
            resolve(data);
          });
        };
        image.onerror = function(err) {
          reject(err);
        };
        image.src = f.target.result;
      });
      reader.onerror = function(err) {
        reject(err);
      };
      reader.readAsDataURL(file);
    } else {
      resolve(metadata);
    }
  });
}


/**
 * module.exports equivalent since we're not yet using CommonJS
 *
 * Main exposed function. Uploads a `file` to S3 and returns an
 * event emitter
 */

window.HeraclesAdmin.helpers.uploadImageToS3 = function(file) {
  var token = window.HeraclesAdmin.helpers.getCSRFToken();
  var emitter = new Emitter();
  emitter.emit("started");

  preSign(file, token, emitter)
    .then(function(res) {
      var upload = uploadToS3(res, file, token, emitter);
      var metadata = parseMetadata(file, emitter);

      return Promise.all([upload, metadata]);
    })
    .then(function(args) {
      var res = args[0];
      var metadata = args[1];
      return persistToDatabase(res, file, metadata, token, emitter);
    })
    .then(function(res) {
      emitter.emit("complete", res);
    })
    .catch(function(err) {
      emitter.emit("error", err);
    });

  return emitter;
};


})();
