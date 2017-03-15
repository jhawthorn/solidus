//= require solidus_admin/select2

$.fn.select2.defaults.set("debug", true);

jQuery(function($) {
  // Make select beautiful
  $('select.select2').select2({
    minimumResultsForSearch: 8
  });
})
