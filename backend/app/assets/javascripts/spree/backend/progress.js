Spree.ready(function() {
  $(document).ajaxStart(function() {
    return $("#progress").show();
  });
  return $(document).ajaxStop(function() {
    return $("#progress").hide();
  });
});
