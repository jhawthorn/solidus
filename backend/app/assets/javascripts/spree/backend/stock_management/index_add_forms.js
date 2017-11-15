Spree.AddStockItemView = Backbone.View.extend({
  initialize: function() {
    this.$countInput = this.$("[name='count_on_hand']");
    this.$locationSelect = this.$("[name='stock_location_id']");
    return (this.$backorderable = this.$("[name='backorderable']"));
  },
  events: {
    "click .submit": "onSubmit"
  },
  validate: function() {
    var locationSelectContainer;
    locationSelectContainer = this.$locationSelect.siblings(
      ".select2-container"
    );
    locationSelectContainer.toggleClass("error", !this.$locationSelect.val());
    this.$countInput.toggleClass("error", !this.$countInput.val());
    return (
      locationSelectContainer.hasClass("error") ||
      this.$countInput.hasClass("error")
    );
  },
  onSuccess: function() {
    var editView, selectedStockLocationOption, stockLocationName;
    selectedStockLocationOption = this.$locationSelect.find("option:selected");
    stockLocationName = selectedStockLocationOption.text().trim();
    selectedStockLocationOption.remove();
    editView = new Spree.EditStockItemView({
      model: this.model,
      stockLocationName: stockLocationName
    });
    editView.$el.insertBefore(this.$el);
    this.model = new Spree.StockItem({
      variant_id: this.model.get("variant_id"),
      stock_location_id: this.model.get("stock_location_id")
    });
    if (this.$locationSelect.find("option").length === 1) {
      // blank value
      return this.remove();
    } else {
      this.$locationSelect.select2();
      this.$countInput.val("");
      return this.$backorderable.prop("checked", false);
    }
  },
  onSubmit: function(ev) {
    var options;
    ev.preventDefault();
    if (this.validate()) {
      return;
    }
    this.model.set({
      backorderable: this.$backorderable.prop("checked"),
      count_on_hand: this.$countInput.val(),
      stock_location_id: this.$locationSelect.val()
    });
    options = {
      success: () => {
        this.onSuccess();
        return show_flash("success", Spree.translations.created_successfully);
      },
      error: (model, response, options) => {
        return show_flash("error", response.responseText);
      }
    };
    return this.model.save(null, options);
  }
});

Spree.ready(function() {
  return $(".js-add-stock-item").each(function() {
    var $el, model;
    $el = $(this);
    model = new Spree.StockItem({
      variant_id: $el.data("variant-id")
    });
    return new Spree.AddStockItemView({
      el: $el,
      model: model
    });
  });
});
