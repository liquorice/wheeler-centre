//= require jquery

window.HeraclesAdmin.helpers.getCSRFToken = function() {
  return $('meta[name="csrf-token"]').attr('content');
};
