var PaymentRowView;

PaymentRowView = Backbone.View.extend({
  events: {
    "click .js-edit": "onEdit",
    "click .js-save": "onSave",
    "click .js-cancel": "onCancel"
  },
  onEdit: function(e) {
    e.preventDefault();
    return this.$el.addClass("editing");
  },
  onCancel: function(e) {
    e.preventDefault();
    return this.$el.removeClass("editing");
  },
  onSave: function(e) {
    var amount, options;
    e.preventDefault();
    amount = this.$(".js-edit-amount").val();
    options = {
      success: (model, response, options) => {
        this.$(".js-display-amount").text(model.attributes.display_amount);
        return this.$el.removeClass("editing");
      },
      error: (model, response, options) => {
        return show_flash("error", response.responseJSON.error);
      }
    };
    return this.model.save(
      {
        amount: amount
      },
      options
    );
  }
});

Spree.ready(function() {
  var Payment, order_id;
  order_id = $("#payments").data("order-id");
  Payment = Backbone.Model.extend({
    urlRoot: Spree.routes.payments_api(order_id)
  });
  return $("tr.payment").each(function() {
    var model;
    model = new Payment({
      id: $(this).data("payment-id")
    });
    return new PaymentRowView({
      el: this,
      model: model
    });
  });
});
