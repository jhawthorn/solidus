var errorHandler;

errorHandler = function(model, response, options) {
  return show_flash("error", response.responseText);
};

Spree.EditStockItemView = Backbone.View.extend({
  tagName: "tr",
  initialize: function(options) {
    this.stockLocationName = options.stockLocationName;
    this.editing = false;
    return this.render();
  },
  events: {
    "click .edit": "onEdit",
    "click .submit": "onSubmit",
    "click .cancel": "onCancel"
  },
  template: HandlebarsTemplates["stock_items/stock_location_stock_item"],
  render: function() {
    var renderAttr;
    renderAttr = {
      stockLocationName: this.stockLocationName,
      editing: this.editing
    };
    _.extend(renderAttr, this.model.attributes);
    this.$el.attr("data-variant-id", this.model.get("variant_id"));
    this.$el.html(this.template(renderAttr));
    return this;
  },
  onEdit: function(ev) {
    ev.preventDefault();
    this.editing = true;
    return this.render();
  },
  onCancel: function(ev) {
    ev.preventDefault();
    this.model.set(this.model.previousAttributes());
    this.editing = false;
    return this.render();
  },
  onSuccess: function() {
    this.editing = false;
    this.render();
    return show_flash("success", Spree.translations.updated_successfully);
  },
  onSubmit: function(ev) {
    var backorderable, countOnHand, options;
    ev.preventDefault();
    backorderable = this.$("[name=backorderable]").prop("checked");
    countOnHand = parseInt(this.$("input[name='count_on_hand']").val(), 10);
    this.model.set({
      count_on_hand: countOnHand,
      backorderable: backorderable
    });
    options = {
      success: () => {
        return this.onSuccess();
      },
      error: errorHandler
    };
    return this.model.save(
      {
        force: true
      },
      options
    );
  }
});

Spree.ready(function() {
  return $(".js-edit-stock-item").each(function() {
    var $el, model;
    $el = $(this);
    model = new Spree.StockItem($el.data("stock-item"));
    return new Spree.EditStockItemView({
      el: $el,
      stockLocationName: $el.data("stock-location-name"),
      model: model
    });
  });
});
