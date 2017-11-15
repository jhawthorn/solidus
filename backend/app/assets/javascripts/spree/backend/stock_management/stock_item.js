Spree.StockItem = Backbone.Model.extend({
  urlRoot: function() {
    return Spree.routes.stock_items_api(this.get("stock_location_id"));
  },
  paramRoot: "stock_item"
});
