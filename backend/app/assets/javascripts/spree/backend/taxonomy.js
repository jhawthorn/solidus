var TaxonTreeView;

Handlebars.registerHelper("isRootTaxon", function() {
  return this.parent_id == null;
});

TaxonTreeView = Backbone.View.extend({
  create_taxon: function({ name, parent_id, child_index }) {
    return Spree.ajax({
      type: "POST",
      dataType: "json",
      url: `${this.model.url()}/taxons`,
      data: {
        taxon: { name, parent_id, child_index }
      },
      complete: this.redraw_tree
    });
  },
  update_taxon: function({ id, parent_id, child_index }) {
    return Spree.ajax({
      type: "PUT",
      dataType: "json",
      url: `${this.model.url()}/taxons/${id}`,
      data: {
        taxon: { parent_id, child_index }
      },
      error: this.redraw_tree
    });
  },
  delete_taxon: function({ id }) {
    return Spree.ajax({
      type: "DELETE",
      dataType: "json",
      url: `${this.model.url()}/taxons/${id}`,
      error: this.redraw_tree
    });
  },
  render: function() {
    var taxons_template;
    taxons_template = HandlebarsTemplates["taxons/tree"];
    return this.$el
      .html(
        taxons_template({
          taxons: [this.model.get("root")]
        })
      )
      .find("ul")
      .sortable({
        connectWith: "#taxonomy_tree ul",
        placeholder: "sortable-placeholder ui-state-highlight",
        tolerance: "pointer",
        cursorAt: {
          left: 5
        }
      });
  },
  redraw_tree: function() {
    return this.model.fetch({
      url: this.model.url() + "?set=nested"
    });
  },
  resize_placeholder: function(e, ui) {
    var handleHeight;
    handleHeight = ui.helper.find(".taxon").outerHeight();
    return ui.placeholder.height(handleHeight);
  },
  restore_sort_targets: function() {
    return $(".ui-sortable-over").removeClass("ui-sortable-over");
  },
  highlight_sort_targets: function(e, ui) {
    this.restore_sort_targets();
    return ui.placeholder.parents("ul").addClass("ui-sortable-over");
  },
  handle_move: function(e, ui) {
    var el;
    if (ui.sender != null) {
      return;
    }
    el = ui.item;
    return this.update_taxon({
      id: el.data("taxon-id"),
      parent_id: el
        .parent()
        .closest("li")
        .data("taxon-id"),
      child_index: el.index()
    });
  },
  handle_delete: function(e) {
    var el;
    el = $(e.target).closest("li");
    if (confirm(Spree.translations.are_you_sure_delete)) {
      this.delete_taxon({
        id: el.data("taxon-id")
      });
      return el.remove();
    }
  },
  handle_add_child: function(e) {
    var child_index, el, name, parent_id;
    el = $(e.target).closest("li");
    parent_id = el.data("taxon-id");
    name = "New node";
    child_index = 0;
    return this.create_taxon({ name, parent_id, child_index });
  },
  handle_create: function(e) {
    var child_index, name, parent_id;
    e.preventDefault();
    name = "New node";
    parent_id = this.model.get("root").id;
    child_index = 0;
    return this.create_taxon({ name, parent_id, child_index });
  },
  events: {
    sortstart: "resize_placeholder",
    sortover: "highlight_sort_targets",
    sortstop: "restore_sort_targets",
    sortupdate: "handle_move",
    "click .js-taxon-delete": "handle_delete",
    "click .js-taxon-add-child": "handle_add_child"
  },
  initialize: function() {
    _.bindAll(this, "redraw_tree", "handle_create");
    $(".add-taxon-button").on("click", this.handle_create);
    this.listenTo(this.model, "sync", this.render);
    return this.redraw_tree();
  }
});

Spree.ready(function() {
  var model;
  if ($("#taxonomy_tree").length) {
    model = new Spree.Models.Taxonomy({
      id: $("#taxonomy_tree").data("taxonomy-id")
    });
    return new TaxonTreeView({
      el: $("#taxonomy_tree"),
      model: model
    });
  }
});
