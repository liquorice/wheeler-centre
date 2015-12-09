var request = require("superagent");

function fetchCommentCount(discussionID) {
  return request
    .get("/flarum/api/discussions/" + discussionID)
    .set("Accept", "application/json");
}

/**
 * Get the comment count for a given discussion and update the passed `el`
 * with relevant text.
 * @param  {Node}   el    The element we want to hold our count
 * @param  {Object} props Various options:
 *                        - {Number} discussionID
 *                        - {String} singular*
 *                        - {String} plural*
 *                        - {String} prefix*
 *                        - {String} suffix*
 *                        - {String} noCommentMessage*
 * @return {Void}
 */
module.exports = function flarumCommentCount(el, props) {
  if (!props.discussionID) return;
  var fetch = fetchCommentCount(props.discussionID);

  var singular = props.singular || "comment";
  var plural   = props.plural || "comments";

  fetch.end(function(error, response) {
    if (!response.ok) return;
    var body = JSON.parse(response.text);
    var count = body.data.attributes.commentsCount;
    if (count !== undefined || count !== null) {
      var text = "";

      // Show noCommentMessage if there are no comments
      if (count === 0 && props.noCommentMessage) {
        text = props.noCommentMessage;
      } else {
        // Set the prefix
        if (props.prefix) {
          text += props.prefix;
        }

        // Set the comment count
        text += count + " ";
        text += (count === 1) ? singular : plural;

        // Set the suffix
        if (props.suffix) {
          text += props.suffix;
        }
      }
      // Set in the text
      el.textContent = text;
    }
  });
};

