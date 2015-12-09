// Custom Heracles admin JS goes here.
//= stub jquery
//= stub viewloader

//= require_self

//= require ./admin/components/bulk_publication_controller
//= require ./admin/fields/field_external_video
//= require_tree ./admin/insertables
//= require_tree ./admin/lightboxes

window.HeraclesAdmin.options = {
  embedlyParams: {
    youtube_modestbranding: 1
  }
};

function initialise() {
  var views = {
    createDiscussion: function($el, el, props) {
      $el.on("click", function(e) {
        e.preventDefault();
        HeraclesAdmin.availableLightboxes.helper("FlarumDiscussionLightbox", props);
      })
    }
  };
  viewloader.execute(views);
}

$(document).ready(initialise);
$(document).on("page:change", initialise);
