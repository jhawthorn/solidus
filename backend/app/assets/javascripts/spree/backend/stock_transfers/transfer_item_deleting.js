var TransferItemDeleting;

TransferItemDeleting = (function() {
  var errorHandler, successHandler;

  class TransferItemDeleting {
    static beginListening() {
      return $("body").on(
        "click",
        '#listing_transfer_items [data-action="remove"]',
        ev => {
          var stockTransferNumber, transferItem, transferItemId;
          ev.preventDefault();
          if (confirm(Spree.translations.are_you_sure_delete)) {
            transferItemId = $(ev.currentTarget).data("id");
            stockTransferNumber = $("#stock_transfer_number").val();
            transferItem = new Spree.TransferItem({
              id: transferItemId,
              stockTransferNumber: stockTransferNumber
            });
            return transferItem.destroy(successHandler, errorHandler);
          }
        }
      );
    }
  }

  successHandler = transferItem => {
    $(`[data-transfer-item-id='${transferItem.id}']`).remove();
    return show_flash("success", Spree.translations.deleted_successfully);
  };

  errorHandler = errorData => {
    return show_flash("error", errorData.responseText);
  };

  return TransferItemDeleting;
})();

if (Spree.StockTransfers == null) {
  Spree.StockTransfers = {};
}

Spree.StockTransfers.TransferItemDeleting = TransferItemDeleting;
