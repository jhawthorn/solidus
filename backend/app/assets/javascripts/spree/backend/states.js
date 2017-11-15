Spree.ready(function() {
  var $cancel_button, $country_select, $form, $new_state, $new_state_link;
  $new_state = $("#new_state");
  if ($new_state.length) {
    $new_state_link = $("#new_state_link");
    $country_select = $("#country");
    $cancel_button = $new_state.find(".fa-remove");
    $form = $new_state.find("form");
    $new_state.hide();
    $new_state_link.click(function(e) {
      e.preventDefault();
      $new_state.show();
      return $new_state_link.hide();
    });
    $cancel_button.click(function(e) {
      e.preventDefault();
      $new_state.hide();
      return $new_state_link.show();
    });
    return $country_select.on("change", function(e) {
      return $form.attr(
        "action",
        $form
          .attr("action")
          .replace(/countries\/(\d+)/, `countries/${$country_select.val()}`)
      );
    });
  }
});
