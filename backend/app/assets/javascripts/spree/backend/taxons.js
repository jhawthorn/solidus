Spree.ready(function() {
  var focusDraggable,
    formatTaxon,
    lowerDraggable,
    moveDraggable,
    productListTemplate,
    productTemplate,
    raiseDraggable,
    saveSort,
    sortable,
    sortupdate;
  productTemplate = HandlebarsTemplates["products/sortable"];
  productListTemplate = function(products) {
    return (
      products.map(productTemplate).join("") ||
      `<h4>${Spree.translations.no_results}</h4>`
    );
  };
  raiseDraggable = function(draggable) {
    draggable.prev().insertAfter(draggable);
    return sortupdate(draggable);
  };
  lowerDraggable = function(draggable) {
    draggable.next().insertBefore(draggable);
    return sortupdate(draggable);
  };
  focusDraggable = function(e) {
    return $(e.srcElement).focus();
  };
  moveDraggable = function(e) {
    if (e.keyCode === $.ui.keyCode.UP) {
      return raiseDraggable($(e.currentTarget));
    } else if (e.keyCode === $.ui.keyCode.DOWN) {
      return lowerDraggable($(e.currentTarget));
    }
  };
  saveSort = function(event, ui) {
    return Spree.ajax({
      url: Spree.routes.classifications_api,
      method: "PUT",
      data: {
        product_id: ui.item.data("product-id"),
        taxon_id: $("#taxon_id").val(),
        position: ui.item.index()
      }
    });
  };
  sortable = $("#taxon_products")
    .sortable()
    .on({
      sortstart: focusDraggable,
      sortstop: focusDraggable,
      sortupdate: saveSort
    })
    .on(
      {
        click: focusDraggable,
        keydown: moveDraggable
      },
      ".sort_item"
    );
  sortupdate = _.debounce(function(draggable) {
    return sortable.trigger("sortupdate", {
      item: draggable
    });
  }, 250);
  formatTaxon = function(taxon) {
    return Select2.util.escapeMarkup(taxon.pretty_name);
  };
  $("#taxon_id").select2({
    dropdownCssClass: "taxon_select_box",
    placeholder: Spree.translations.find_a_taxon,
    ajax: {
      url: Spree.routes.taxons_search,
      params: {
        headers: {
          "X-Spree-Token": Spree.api_key
        }
      },
      data: function(term, page) {
        return {
          per_page: 50,
          page: page,
          q: {
            name_cont: term
          }
        };
      },
      results: function(data) {
        return {
          results: data["taxons"],
          more: data.current_page < data.pages
        };
      }
    },
    formatResult: formatTaxon,
    formatSelection: formatTaxon
  });
  return $("#taxon_id").on("change", function(e) {
    return Spree.ajax({
      url: Spree.routes.taxon_products_api,
      data: {
        id: e.val,
        simple: 1
      },
      success: function(data) {
        return sortable.html(productListTemplate(data.products));
      }
    });
  });
});
