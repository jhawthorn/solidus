# variant autocompletion

variantTemplate = HandlebarsTemplates["variants/autocomplete"]

formatVariantResult = (variant) ->
  image = variant.images[0].mini_url if variant["images"][0] isnt undefined and variant["images"][0].mini_url isnt undefined
  variantTemplate(
    variant: variant
    image: image
  )

$.fn.variantAutocomplete = (searchOptions = {}) ->
  @select2
    placeholder: Spree.translations.variant_placeholder
    initSelection: (element, callback) ->
      if element.val()
        Spree.ajax
          url: Spree.routes.variants_api + "/" + element.val()
          success: callback
    ajax:
      url: Spree.routes.variants_api
      datatype: "json"
      delay: 500
      params: { "headers": { "X-Spree-Token": Spree.api_key } }
      data: (params) =>
        searchData =
          q:
            product_name_or_sku_cont: params.term
          token: Spree.api_key
        _.extend(searchData, searchOptions)

      processResults: (data, params) ->
        window.variants = data["variants"]
        return {
          results: data["variants"]
          pagination: {
            more: params.page < data.pages
          }
        }

    templateResult: (data) ->
      if data.loading
        data.text
      else
        formatVariantResult(data)
    templateSelection: (data) ->
      HandlebarsTemplates['variants/autocomplete_selection'](data)
    escapeMarkup: (markup) -> markup
