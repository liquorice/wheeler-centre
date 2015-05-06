// Custom Heracles admin JS goes here.

//= require_self

//= require ./admin/components/bulk_publication_controller
//= require ./admin/fields/field_external_video
//= require_tree ./admin/insertables

window.HeraclesAdmin.options = {
  embedlyParams: {
    youtube_modestbranding: 1
  }
};

