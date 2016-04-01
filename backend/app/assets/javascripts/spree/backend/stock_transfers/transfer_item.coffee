TransferItem = Backbone.Model.extend
  paramRoot: 'transfer_item'

Spree.TransferItemCollection = Backbone.Collection.extend
  initialize: (models, options) ->
    @stockTransferNumber = options.stockTransferNumber

  url: ->
    Spree.routes.create_transfer_items_api(@stockTransferNumber)

  parse: (resp, options) ->
    resp.transfer_items

Spree.TransferItem = TransferItem
