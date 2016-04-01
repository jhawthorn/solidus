class TransferItemView extends Backbone.View
  initialize: (options) ->
    @isReceiving = options.isReceiving
    stockTransferNumber = $("#stock_transfer_number").val()
    @collection = new Spree.TransferItemCollection null,
      stockTransferNumber: stockTransferNumber
    @model = new Spree.TransferItem({id: @$el.data('transfer-item-id')}, {collection: @collection})

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
    quantity = parseInt($("#number-update-#{transferItemId} input[type='number']").val(), 10)
    quantityKey = if @isReceiving then 'received_quantity' else 'expected_quantity'
    @model.set(quantityKey, quantity)
    @model.save null,
      success: @onEditSuccess
      error: @onError

  onEditSuccess: (transferItem) =>
    if @isReceiving
      Spree.NumberFieldUpdater.successHandler(transferItem.id, transferItem.get('received_quantity'))
      Spree.StockTransfers.ReceivedCounter.updateTotal()
    else
      Spree.NumberFieldUpdater.successHandler(transferItem.id, transferItem.get('expected_quantity'))
    show_flash("success", Spree.translations.updated_successfully)

  onDelete: (ev) ->
    ev.preventDefault()
    if confirm(Spree.translations.are_you_sure_delete)
      transferItemId = $(ev.currentTarget).data('id')
      stockTransferNumber = $("#stock_transfer_number").val()

      @model.destroy
        success: @onDeleteSuccess
        error: @onError

  onDeleteSuccess: (transferItem) =>
    @remove()
    show_flash("success", Spree.translations.deleted_successfully)

  onError: (_, response) =>
    show_flash("error", response.responseText)

Spree.StockTransfers ?= {}
Spree.StockTransfers.TransferItemView = TransferItemView

$ ->
  $('#stock-transfer-transfer-items .stock-table tr').each ->
    new Spree.StockTransfers.TransferItemView
      isReceiving: false
      el: @

  $('#received-transfer-items .stock-table tr').each ->
    new Spree.StockTransfers.TransferItemView
      isReceiving: true
      el: @
