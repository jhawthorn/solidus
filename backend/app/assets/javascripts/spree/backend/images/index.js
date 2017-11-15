Spree.ready(function() {
  return $("#new_image_link").click(function(event) {
    event.preventDefault();
    $(".no-objects-found").hide();
    $(this).hide();
    return Spree.ajax({
      type: "GET",
      url: this.href,
      success: function(r) {
        $("#images").html(r);
        return $("select.select2").select2();
      }
    });
  });
});
