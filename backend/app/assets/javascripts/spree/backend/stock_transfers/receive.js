Spree.ready(function() {
  if ($("#received-transfer-items").length > 0) {
    Spree.StockTransfers.VariantForm.initializeForm(false);
    Spree.StockTransfers.VariantForm.beginListeningForReceive();
    return Spree.StockTransfers.CountUpdateForms.beginListening(true);
  }
});
