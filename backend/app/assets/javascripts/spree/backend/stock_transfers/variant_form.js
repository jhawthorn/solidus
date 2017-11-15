var VariantForm;

VariantForm = (function() {
  var autoCompleteEl,
    createSuccessHandler,
    createTransferItem,
    errorHandler,
    formatVariantDisplayAttributes,
    formatVariantOptionValues,
    receiveSuccessHandler,
    receiveTransferItem,
    resetVariantAutocomplete,
    successHandler,
    updateSuccessHandler;

  class VariantForm {
    static initializeForm(isBuilding) {
      autoCompleteEl().variantAutocomplete({
        in_stock_only: isBuilding
      });
      return resetVariantAutocomplete();
    }

    static beginListeningForReceive() {
      var variantSelector;
      variantSelector = autoCompleteEl();
      // Search result selected
      variantSelector.on("select2-selecting", ev => {
        ev.preventDefault();
        return receiveTransferItem(ev.val);
      });
      // Search results came back from the server
      return variantSelector.on("select2-loaded", ev => {
        if (ev.items.results.length === 1) {
          return receiveTransferItem(ev.items.results[0].id);
        }
      });
    }

    static beginListeningForAdd() {
      var variantSelector;
      variantSelector = autoCompleteEl();
      // Search result selected
      variantSelector.on("select2-selecting", ev => {
        ev.preventDefault();
        return createTransferItem(ev.val);
      });
      // Search results came back from the server
      return variantSelector.on("select2-loaded", ev => {
        if (ev.items.results.length === 1) {
          return createTransferItem(ev.items.results[0].id);
        }
      });
    }
  }

  autoCompleteEl = function() {
    if (this.variantAutocomplete == null) {
      this.variantAutocomplete = $(
        '[data-hook="transfer_item_selection"]'
      ).find(".variant_autocomplete");
    }
    return this.variantAutocomplete;
  };

  resetVariantAutocomplete = function() {
    return autoCompleteEl()
      .select2("val", "")
      .trigger("change");
  };

  createTransferItem = function(variantId) {
    var expectedQuantity,
      stockTransferNumber,
      transferItem,
      transferItemId,
      transferItemRow;
    stockTransferNumber = $("#stock_transfer_number").val();
    $(".select2-results").html(
      `<li class='select2-no-results'>${Spree.translations.adding_match}</li>`
    );
    transferItemRow = $(`[data-variant-id='${variantId}']`);
    if (transferItemRow.length > 0) {
      transferItemId = transferItemRow
        .parents("tr:first")
        .data("transfer-item-id");
      expectedQuantity = parseInt(
        $(`#number-update-${transferItemId}`)
          .find(".js-number-update-text")
          .text()
          .trim(),
        10
      );
      transferItem = new Spree.TransferItem({
        id: transferItemId,
        stockTransferNumber: stockTransferNumber,
        expectedQuantity: expectedQuantity + 1
      });
      return transferItem.update(updateSuccessHandler, errorHandler);
    } else {
      transferItem = new Spree.TransferItem({
        stockTransferNumber: stockTransferNumber,
        variantId: variantId,
        expectedQuantity: 1
      });
      return transferItem.create(createSuccessHandler, errorHandler);
    }
  };

  receiveTransferItem = function(variantId) {
    var stockTransfer, stockTransferNumber;
    stockTransferNumber = $("#stock_transfer_number").val();
    $(".select2-results").html(
      `<li class='select2-no-results'>${
        Spree.translations.receiving_match
      }</li>`
    );
    stockTransfer = new Spree.StockTransfer({
      number: stockTransferNumber
    });
    return stockTransfer.receive(
      variantId,
      receiveSuccessHandler,
      errorHandler
    );
  };

  createSuccessHandler = transferItem => {
    successHandler(transferItem, false);
    return show_flash("success", Spree.translations.created_successfully);
  };

  updateSuccessHandler = transferItem => {
    successHandler(transferItem, false);
    return show_flash("success", Spree.translations.updated_successfully);
  };

  receiveSuccessHandler = (stockTransfer, variantId) => {
    var receivedItem;
    receivedItem = {
      id: stockTransfer.received_item.id,
      variant: stockTransfer.received_item.variant,
      received_quantity: stockTransfer.received_item.received_quantity
    };
    successHandler(receivedItem, true);
    Spree.StockTransfers.ReceivedCounter.updateTotal();
    return show_flash("success", Spree.translations.received_successfully);
  };

  successHandler = (transferItem, isReceiving) => {
    var htmlOutput, rowTemplate, templateAttributes;
    resetVariantAutocomplete();
    rowTemplate = HandlebarsTemplates["stock_transfers/transfer_item"];
    templateAttributes = {
      id: transferItem.id,
      isReceiving: isReceiving,
      variantId: transferItem.variant.id,
      variantDisplayAttributes: formatVariantDisplayAttributes(
        transferItem.variant
      ),
      variantOptions: formatVariantOptionValues(transferItem.variant),
      variantImage: transferItem.variant.images[0]
    };
    if (isReceiving) {
      templateAttributes["receivedQuantity"] = transferItem.received_quantity;
    } else {
      templateAttributes["expectedQuantity"] = transferItem.expected_quantity;
    }
    htmlOutput = rowTemplate(templateAttributes);
    $(`tr[data-transfer-item-id='${transferItem.id}']`).remove();
    if ($("#listing_transfer_items tbody tr:first").length > 0) {
      $("#listing_transfer_items tbody tr:first").before(htmlOutput);
    } else {
      $("#listing_transfer_items tbody").html(htmlOutput);
    }
    $("#listing_transfer_items").prop("hidden", false);
    $(".no-objects-found").prop("hidden", true);
    return $(`tr[data-transfer-item-id='${transferItem.id}']`).fadeIn();
  };

  errorHandler = function(errorData) {
    var errorMessage, ref;
    resetVariantAutocomplete();
    errorMessage =
      ((ref = errorData.responseJSON) != null ? ref.error : void 0) != null &&
      errorData.responseJSON.errors == null
        ? errorData.responseJSON.error
        : errorData.responseText;
    return show_flash("error", errorMessage);
  };

  formatVariantDisplayAttributes = function(variant) {
    var displayAttributes;
    displayAttributes = JSON.parse($("#variant_display_attributes").val());
    return _.map(displayAttributes, attribute => {
      return {
        label: Spree.translations[attribute.translation_key],
        value: variant[attribute.attr_name]
      };
    });
  };

  formatVariantOptionValues = function(variant) {
    var optionValues;
    optionValues = variant.option_values;
    optionValues = _.sortBy(optionValues, "option_type_presentation");
    return _.map(optionValues, function(optionValue) {
      return {
        option_type: optionValue.option_type_presentation,
        option_value: optionValue.presentation
      };
    });
  };

  return VariantForm;
})();

if (Spree.StockTransfers == null) {
  Spree.StockTransfers = {};
}

Spree.StockTransfers.VariantForm = VariantForm;
