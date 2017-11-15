var TransferItem;

TransferItem = class TransferItem {
  constructor(options = {}) {
    this.id = options.id;
    this.variantId = options.variantId;
    this.receivedQuantity = options.receivedQuantity;
    this.expectedQuantity = options.expectedQuantity;
    this.stockTransferNumber = options.stockTransferNumber;
  }

  create(successHandler, errorHandler) {
    return Spree.ajax({
      url: Spree.routes.create_transfer_items_api(this.stockTransferNumber),
      type: "POST",
      data: {
        transfer_item: {
          variant_id: this.variantId,
          expected_quantity: this.expectedQuantity
        }
      },
      success: function(transferItem) {
        return successHandler(transferItem);
      },
      error: function(errorData) {
        return errorHandler(errorData);
      }
    });
  }

  update(successHandler, errorHandler) {
    var itemAttrs;
    itemAttrs =
      this.receivedQuantity != null
        ? {
            received_quantity: this.receivedQuantity
          }
        : this.expectedQuantity != null
          ? {
              expected_quantity: this.expectedQuantity
            }
          : {};
    return Spree.ajax({
      url: Spree.routes.update_transfer_items_api(
        this.stockTransferNumber,
        this.id
      ),
      type: "PUT",
      data: {
        transfer_item: itemAttrs
      },
      success: function(transferItem) {
        return successHandler(transferItem);
      },
      error: function(errorData) {
        return errorHandler(errorData);
      }
    });
  }

  destroy(successHandler, errorHandler) {
    return Spree.ajax({
      url: Spree.routes.update_transfer_items_api(
        this.stockTransferNumber,
        this.id
      ),
      type: "DELETE",
      success: function(transferItem) {
        return successHandler(transferItem);
      },
      error: function(errorData) {
        return errorHandler(errorData);
      }
    });
  }
};

Spree.TransferItem = TransferItem;
