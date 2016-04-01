$(document).ready ->
  if $('#received-transfer-items').length > 0
    new Spree.StockTransfers.VariantForm
      isBuilding: false

    $("#close-transfer-button").on('click', (ev) ->
      ev.preventDefault()
      $('#close-stock-transfer-warning').show()
    )

    $("#cancel-close-link").on('click', (ev) ->
      ev.preventDefault()
      $('#close-stock-transfer-warning').hide()
    )
