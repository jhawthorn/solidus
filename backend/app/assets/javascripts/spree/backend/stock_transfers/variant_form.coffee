class VariantForm
  @initializeForm: (isBuilding) ->
    autoCompleteEl().variantAutocomplete({ in_stock_only: isBuilding })
    resetVariantAutocomplete()
    if isBuilding
      beginListeningForAdd()
    else
      beginListeningForReceive()

  beginListeningForReceive = ->
    variantSelector = autoCompleteEl()
    # Search result selected
    variantSelector.on 'select2-selecting', (ev) =>
      ev.preventDefault()
      receiveTransferItem(ev.val)

  beginListeningForAdd = ->
    variantSelector = autoCompleteEl()
    # Search result selected
    variantSelector.on 'select2-selecting', (ev) =>
      ev.preventDefault()
      createTransferItem(ev.val)

  autoCompleteEl = ->
    @variantAutocomplete ?= $('[data-hook="transfer_item_selection"]').find('.variant_autocomplete')
    @variantAutocomplete

  resetVariantAutocomplete = ->
    autoCompleteEl().select2('val', '').trigger('change').select2('open')

  createTransferItem = (variantId) ->
    stockTransferNumber = $("#stock_transfer_number").val()
    $(".select2-results").html("<li class='select2-no-results'>#{Spree.translations.adding_match}</li>")
    transferItemRow = $("[data-variant-id='#{variantId}']")
    if transferItemRow.length > 0
      transferItemId = transferItemRow.parents('tr:first').data('transfer-item-id')
      expectedQuantity = parseInt($("#number-update-#{transferItemId}").find('.js-number-update-text').text().trim(), 10)
      transferItem = new Spree.TransferItem
        id: transferItemId
        stockTransferNumber: stockTransferNumber
        expectedQuantity: expectedQuantity + 1
      transferItem.update(updateSuccessHandler, errorHandler)
    else
      transferItem = new Spree.TransferItem
        stockTransferNumber: stockTransferNumber
        variantId: variantId
        expectedQuantity: 1
      transferItem.create(createSuccessHandler, errorHandler)

  receiveTransferItem = (variantId) ->
    stockTransferNumber = $("#stock_transfer_number").val()
    $(".select2-results").html("<li class='select2-no-results'>#{Spree.translations.receiving_match}</li>")
    stockTransfer = new Spree.StockTransfer
      number: stockTransferNumber
    stockTransfer.receive(variantId, receiveSuccessHandler, errorHandler)

  createSuccessHandler = (transferItem) =>
    successHandler(transferItem, false)
    show_flash('success', Spree.translations.created_successfully)

  updateSuccessHandler = (transferItem) =>
    successHandler(transferItem, false)
    show_flash('success', Spree.translations.updated_successfully)

  receiveSuccessHandler = (stockTransfer, variantId) =>
    receivedItem =
      id: stockTransfer.received_item.id
      variant: stockTransfer.received_item.variant
      received_quantity: stockTransfer.received_item.received_quantity
    successHandler(receivedItem, true)
    Spree.StockTransfers.ReceivedCounter.updateTotal()
    show_flash('success', Spree.translations.received_successfully)

  successHandler = (transferItem, isReceiving) =>
    resetVariantAutocomplete()
    rowTemplate = HandlebarsTemplates['stock_transfers/transfer_item']
    templateAttributes =
      id: transferItem.id
      isReceiving: isReceiving
      variantId: transferItem.variant.id
      variantDisplayAttributes: formatVariantDisplayAttributes(transferItem.variant)
      variantOptions: formatVariantOptionValues(transferItem.variant)
      variantImageURL: transferItem.variant.images[0]?.small_url

    if isReceiving
      templateAttributes["receivedQuantity"] = transferItem.received_quantity
    else
      templateAttributes["expectedQuantity"] = transferItem.expected_quantity

    $el = $(rowTemplate(templateAttributes))
    $("tr[data-transfer-item-id='#{transferItem.id}']").remove()
    $el.prependTo($("#listing_transfer_items > tbody"))
    new Spree.StockTransfers.TransferItemView({el: $el, isReceiving: isReceiving})
    $("#listing_transfer_items").prop('hidden', false)
    $(".no-objects-found").prop('hidden', true)

  errorHandler = (errorData) ->
    resetVariantAutocomplete()
    errorMessage = if errorData.responseJSON?.error? and !errorData.responseJSON.errors?
      errorData.responseJSON.error
    else
      errorData.responseText
    show_flash('error', errorMessage)

  formatVariantDisplayAttributes = (variant) ->
    displayAttributes = JSON.parse($("#variant_display_attributes").val())
    _.map(displayAttributes, (attribute) =>
      label: Spree.translations[attribute.translation_key]
      value: variant[attribute.attr_name]
    )

  formatVariantOptionValues = (variant) ->
    optionValues = variant.option_values
    optionValues = _.sortBy(optionValues, 'option_type_presentation')
    _.map(optionValues, (optionValue) ->
      option_type: optionValue.option_type_presentation
      option_value: optionValue.presentation
    )

Spree.StockTransfers ?= {}
Spree.StockTransfers.VariantForm = VariantForm
