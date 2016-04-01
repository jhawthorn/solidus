EditTransferItemView = Backbone.View.extend
  initialize: (options) ->
    @isReceiving = options.isReceiving

  events:
    'click .fa-edit': "onEdit"
    'click .fa-void': "onCancel"
    'click .fa-check': "onSubmit"
    'click .fa-trash': "onDelete"

  onEdit: (ev) ->
    ev.preventDefault()
    transferItemId = $(ev.currentTarget).data('id')
    Spree.NumberFieldUpdater.hideReadOnly(transferItemId)
    Spree.NumberFieldUpdater.showForm(transferItemId)

  onCancel: (ev) ->
    ev.preventDefault()
    transferItemId = $(ev.currentTarget).data('id')
    Spree.NumberFieldUpdater.hideForm(transferItemId)
    Spree.NumberFieldUpdater.showReadOnly(transferItemId)

  onSubmit: (ev) ->
    ev.preventDefault()
    transferItemId = $(ev.currentTarget).data('id')
    stockTransferNumber = $("#stock_transfer_number").val()
    quantity = parseInt($("#number-update-#{transferItemId} input[type='number']").val(), 10)

    itemAttributes =
      id: transferItemId
      stockTransferNumber: stockTransferNumber
    quantityKey = if @isReceiving then 'receivedQuantity' else 'expectedQuantity'
    itemAttributes[quantityKey] = quantity
    transferItem = new Spree.TransferItem(itemAttributes)
    transferItem.update(@onEditSuccess, @onError)

  onEditSuccess: (transferItem) =>
    if $('#received-transfer-items').length > 0
      Spree.NumberFieldUpdater.successHandler(transferItem.id, transferItem.received_quantity)
      Spree.StockTransfers.ReceivedCounter.updateTotal()
    else
      Spree.NumberFieldUpdater.successHandler(transferItem.id, transferItem.expected_quantity)
    show_flash("success", Spree.translations.updated_successfully)

  onDelete: (ev) ->
    ev.preventDefault()
    if confirm(Spree.translations.are_you_sure_delete)
      transferItemId = $(ev.currentTarget).data('id')
      stockTransferNumber = $("#stock_transfer_number").val()

      transferItem = new Spree.TransferItem
        id: transferItemId
        stockTransferNumber: stockTransferNumber
      transferItem.destroy(@onEditSuccess, @onError)

  onDeleteSuccess: (transferItem) ->
    $("[data-transfer-item-id='#{transferItem.id}']").remove()
    show_flash("success", Spree.translations.deleted_successfully)

  onError: (errorData) =>
    show_flash("error", errorData.responseText)

Spree.StockTransfers ?= {}
Spree.StockTransfers.CountUpdateForms =
  beginListening: (isReceiving) ->
    new EditTransferItemView
      el: $('body')
      isReceiving: isReceiving
