// variant autocompletion
var formatVariantResult, variantTemplate;

variantTemplate = HandlebarsTemplates["variants/autocomplete"];

formatVariantResult = function(variant) {
  return variantTemplate({
    variant: variant
  });
};

$.fn.variantAutocomplete = function(searchOptions = {}) {
  return this.select2({
    placeholder: Spree.translations.variant_placeholder,
    minimumInputLength: 3,
    initSelection: function(element, callback) {
      return Spree.ajax({
        url: Spree.routes.variants_api + "/" + element.val(),
        success: callback
      });
    },
    ajax: {
      url: Spree.routes.variants_api,
      datatype: "json",
      quietMillis: 500,
      params: {
        headers: {
          "X-Spree-Token": Spree.api_key
        }
      },
      data: (term, page) => {
        var searchData;
        searchData = {
          q: {
            product_name_or_sku_cont: term
          },
          token: Spree.api_key
        };
        return _.extend(searchData, searchOptions);
      },
      results: function(data, page) {
        window.variants = data["variants"];
        return {
          results: data["variants"]
        };
      }
    },
    formatResult: formatVariantResult,
    formatSelection: function(variant, container, escapeMarkup) {
      if (variant.options_text) {
        return Select2.util.escapeMarkup(
          `${variant.name} (${variant.options_text})`
        );
      } else {
        return Select2.util.escapeMarkup(variant.name);
      }
    }
  });
};
