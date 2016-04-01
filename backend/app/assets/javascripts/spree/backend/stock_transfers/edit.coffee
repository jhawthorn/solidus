$(document).ready ->
  if $('#stock-transfer-transfer-items').length > 0
    new Spree.StockTransfers.VariantForm
      isBuilding: true

    $("#ready-to-ship-transfer-button").on('click', (ev) ->
      ev.preventDefault()
      $('#finalize-stock-transfer-warning').show()
    )

    $("#cancel-finalize-link").on('click', (ev) ->
      ev.preventDefault()
      $('#finalize-stock-transfer-warning').hide()
    )
