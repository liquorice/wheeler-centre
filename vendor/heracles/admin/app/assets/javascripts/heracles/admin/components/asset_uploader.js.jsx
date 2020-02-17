//= require jquery
//= require heracles/admin/components/s3_uploader

/** @jsx React.DOM */

;(function() {

var uploadImageToS3 = HeraclesAdmin.helpers.uploadImageToS3;

var S3UploadComponent = React.createClass({

  uploads: [],
  uploadsProgressPercentages: [],
  uploadsSizes: [],

  getInitialState: function() {
    return {
      state: 'ready',
      uploadProgress: 0.02,
      uploadCount: 0,
      uploadsComplete: 0
    };
  },

  componentWillMount: function() {
    return this.bindEvents(document.documentElement);
  },

  bindEvents: function(doc) {
    var $doc = $(doc);
    var self = this;

    doc.addEventListener("dragover", function(e) {
      e.preventDefault();
      $doc.addClass("asset-dropover");
    });

    doc.addEventListener("end", function(e) {
      e.preventDefault();
      $doc.removeClass("asset-dropover");
    });

    doc.addEventListener("drop", function(e) {
      $doc.removeClass("asset-dropover");
      e.preventDefault();
      self.handleFileDrop(e.dataTransfer.files);
    });

    $doc.on('mouseup', function() {
      $doc.removeClass("asset-dropover");
    });
  },

  onFileSelect: function(e) {
    this.onSubmit();
  },

  onSubmit: function(e) {
    if (e) {
      e.preventDefault();
    }
    var input = this.refs.fileInput.getDOMNode();
    var files = input.files;
    this.uploadFiles(files);
  },

  uploadFiles: function(files) {
    var self = this;
    var newUploads = _.map(files, function(file, index) {
      // Actual index is based on an uploads that already exist
      var actualIndex = self.uploads.length + index;
      self.uploadsSizes.push(file.size);
      self.uploadsProgressPercentages.push(0);

      var uploadEmitter = uploadImageToS3(file);

      // Set progress
      uploadEmitter.on("upload-progress", function(e) {
        var decimalPercentage = e.percent / 100;
        self.uploadsProgressPercentages[index] = decimalPercentage;
        self.calculateProgress();
      });

      // Update on completion
      uploadEmitter.on("complete", function(e) {
        self.calculateCompletion();
      });

      return uploadEmitter;
    });
    this.uploads = this.uploads.concat(newUploads);

    var uploadCount = this.uploads.length;

    this.setState({
      state: "uploading",
      uploadCount: uploadCount
    });
  },

  handleFileDrop: function(files) {
    this.uploadFiles(files);
  },

  calculateProgress: function() {
    var self = this;
    var sumProgressSize = _.sum(_.map(this.uploadsProgressPercentages, function(percentage, index) {
      var size = self.uploadsSizes[index];
      return percentage * size;
    }));
    var sumTotalSizes = _.sum(this.uploadsSizes);
    var percentageTotal = sumProgressSize / sumTotalSizes;

    this.setState({
      uploadProgress: percentageTotal
    });
  },

  calculateCompletion: function() {
    $(document).trigger("AssetUploader:uploadComplete");
    var uploadsComplete = this.state.uploadsComplete + 1;
    if (uploadsComplete < this.uploads.length) {
      this.setState({
        uploadsComplete: uploadsComplete
      });
    } else {
      // All in-progress uploads are complete
      this.uploadsProgressPercentages = [];
      this.uploadsSizes = [];
      this.uploads = [];
      this.setState({
        state: "ready",
        uploadsComplete: 0,
        uploadProgress: 0.02
      });
    }
  },

  renderUploader: function() {
    if (this.state.state === "uploading") {
      return(
        <div>
          <p>Uploading — {this.state.uploadsComplete}/{this.state.uploadCount} complete</p>
          <progress className="asset-uploader-progress" key="file" value={this.state.uploadProgress}></progress>
        </div>
      );
    } else {
      return(
        <form encType="multipart/form-data" method="post" onSubmit={this.onSubmit}>
          <div className="asset-uploader-upload-button">
            <p>Click or drop files to upload</p>
            <input ref="fileInput" type="file" onChange={this.onFileSelect} className="asset-uploader-file-input" multiple />
          </div>
        </form>
      );
    }
  },

  render: function() {
    return (
      <div className="asset-uploader">
        {this.renderUploader()}
      </div>
    );
  }

});


HeraclesAdmin.S3UploadComponent = S3UploadComponent;

window.HeraclesAdmin.views.assetUploader = function($el, el, props) {
  React.renderComponent(
    S3UploadComponent(props),
    el
  );
};

})();
