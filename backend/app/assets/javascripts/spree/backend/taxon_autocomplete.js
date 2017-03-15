$.fn.taxonAutocomplete = function () {
  'use strict';

  this.select2({
      placeholder: Spree.translations.taxon_placeholder,
      multiple: true,
      initSelection: function (element, callback) {
        var ids = element.val(),
            count = ids.split(",").length;

        Spree.ajax({
          type: "GET",
          url: Spree.routes.taxons_search,
          data: {
            ids: ids,
            per_page: count,
            without_children: true
          },
          success: function (data) {
            callback(data['taxons']);
          }
        });
      },
      ajax: {
        url: Spree.routes.taxons_search,
        datatype: 'json',
        data: function (params) {
          return {
            per_page: 50,
            page: params.page,
            without_children: true,
            q: {
              name_cont: params.term
            },
            token: Spree.api_key
          };
        },
        processResults: function (data, page) {
          var more = page < data.pages;
          return {
            results: data['taxons'],
            more: more
          };
        }
      },
      formatResult: function (taxon, container, query, escapeMarkup) {
        return escapeMarkup(taxon.pretty_name);
      },
      formatSelection: function (taxon, container, escapeMarkup) {
        return escapeMarkup(taxon.pretty_name);
      }
    });
};

$(document).ready(function () {
  $('#product_taxon_ids, .taxon_picker').taxonAutocomplete();
});
