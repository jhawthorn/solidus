var StockTransfer;

StockTransfer = class StockTransfer {
  constructor(options = {}) {
    this.number = options.number;
    this.transferItems = options.transferItems;
  }

  receive(variantId, successHandler, errorHandler) {
    return Spree.ajax({
      url: Spree.routes.receive_stock_transfer_api(this.number),
      type: "POST",
      data: {
        variant_id: variantId
      },
      success: stockTransfer => {
        return successHandler(stockTransfer, variantId);
      },
      error: function(errorData) {
        return errorHandler(errorData);
      }
    });
  }
};

Spree.StockTransfer = StockTransfer;
