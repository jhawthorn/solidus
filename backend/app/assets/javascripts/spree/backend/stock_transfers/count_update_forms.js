var CountUpdateForms;

CountUpdateForms = (function() {
  var errorHandler, successHandler;

  class CountUpdateForms {
    static beginListening(isReceiving) {
      // Edit
      $("body").on(
        "click",
        '#listing_transfer_items [data-action="edit"]',
        ev => {
          var transferItemId;
          ev.preventDefault();
          transferItemId = $(ev.currentTarget).data("id");
          Spree.NumberFieldUpdater.hideReadOnly(transferItemId);
          return Spree.NumberFieldUpdater.showForm(transferItemId);
        }
      );
      // Cancel
      $("body").on(
        "click",
        '#listing_transfer_items [data-action="cancel"]',
        ev => {
          var transferItemId;
          ev.preventDefault();
          transferItemId = $(ev.currentTarget).data("id");
          Spree.NumberFieldUpdater.hideForm(transferItemId);
          return Spree.NumberFieldUpdater.showReadOnly(transferItemId);
        }
      );
      // Submit
      return $("body").on(
        "click",
        '#listing_transfer_items [data-action="save"]',
        ev => {
          var itemAttributes,
            quantity,
            quantityKey,
            stockTransferNumber,
            transferItem,
            transferItemId;
          ev.preventDefault();
          transferItemId = $(ev.currentTarget).data("id");
          stockTransferNumber = $("#stock_transfer_number").val();
          quantity = parseInt(
            $(`#number-update-${transferItemId} input[type='number']`).val(),
            10
          );
          itemAttributes = {
            id: transferItemId,
            stockTransferNumber: stockTransferNumber
          };
          quantityKey = isReceiving ? "receivedQuantity" : "expectedQuantity";
          itemAttributes[quantityKey] = quantity;
          transferItem = new Spree.TransferItem(itemAttributes);
          return transferItem.update(successHandler, errorHandler);
        }
      );
    }
  }

  successHandler = transferItem => {
    if ($("#received-transfer-items").length > 0) {
      Spree.NumberFieldUpdater.successHandler(
        transferItem.id,
        transferItem.received_quantity
      );
      Spree.StockTransfers.ReceivedCounter.updateTotal();
    } else {
      Spree.NumberFieldUpdater.successHandler(
        transferItem.id,
        transferItem.expected_quantity
      );
    }
    return show_flash("success", Spree.translations.updated_successfully);
  };

  errorHandler = errorData => {
    return show_flash("error", errorData.responseText);
  };

  return CountUpdateForms;
})();

if (Spree.StockTransfers == null) {
  Spree.StockTransfers = {};
}

Spree.StockTransfers.CountUpdateForms = CountUpdateForms;
