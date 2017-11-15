Spree.ready(function() {
  return $("[data-hook=adjustments_new_coupon_code] #add_coupon_code").click(
    function() {
      if ($("#coupon_code").val().length === 0) {
        return;
      }
      return Spree.ajax({
        type: "PUT",
        url: Spree.routes.apply_coupon_code(order_number),
        data: {
          coupon_code: $("#coupon_code").val(),
          token: Spree.api_key
        },
        success: function() {
          return window.location.reload();
        },
        error: function(msg) {
          if (msg.responseJSON["error"]) {
            return show_flash("error", msg.responseJSON["error"]);
          } else {
            return show_flash(
              "error",
              "There was a problem adding this coupon code."
            );
          }
        }
      });
    }
  );
});
