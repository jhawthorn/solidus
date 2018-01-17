Handlebars.registerHelper('isRootTaxon', function() {
  return this.parent_id == null;
});

var TaxonTreeView = Backbone.View.extend({
  create_taxon: function({name, parent_id, child_index}) {
    Spree.ajax({
      type: "POST",
      dataType: "json",
      url: `${this.model.url()}/taxons`,
      data: {
        taxon: {name, parent_id, child_index}
      },
      complete: this.redraw_tree
    });
  },

  update_taxon: function({id, parent_id, child_index}) {
    Spree.ajax({
      type: "PUT",
      dataType: "json",
      url: `${this.model.url()}/taxons/${id}`,
      data: {
        taxon: {parent_id, child_index}
      },
      error: this.redraw_tree
    });
  },

  delete_taxon: function({id}) {
    Spree.ajax({
      type: "DELETE",
      dataType: "json",
      url: `${this.model.url()}/taxons/${id}`,
      error: this.redraw_tree
    });
  },

  render: function() {
    /* Cleanup any existing sortable */
    sortable(this.el.querySelectorAll('ul'), 'destroy');

    var taxons_template = HandlebarsTemplates["taxons/tree"];
    this.$el.html(taxons_template({
      taxons: [this.model.get("root")]
    }));

    var ul = sortable(
      this.el.querySelectorAll('ul'), {
        connectWith: this.cid,
        forcePlaceholderSize: true,
        placeholderClass: 'sortable-placeholder ui-state-highlight',
      });

    ul[0].addEventListener('sortupdate', this.handle_move.bind(this));
  },

  redraw_tree: function() {
    this.model.fetch({
      url: this.model.url() + '?set=nested'
    });
  },

  handle_move: function(e, ui) {
    var el = $(e.detail.item);
    this.update_taxon({
      id: el.data('taxon-id'),
      parent_id: el.parent().closest('li').data('taxon-id'),
      child_index: el.index()
    });
  },

  handle_delete: function(e) {
    var el;
    el = $(e.target).closest('li');
    if (confirm(Spree.translations.are_you_sure_delete)) {
      this.delete_taxon({
        id: el.data('taxon-id')
      });
      el.remove();
    }
  },

  handle_add_child: function(e) {
    var child_index, el, name, parent_id;
    el = $(e.target).closest('li');
    parent_id = el.data('taxon-id');
    name = 'New node';
    child_index = 0;
    this.create_taxon({name, parent_id, child_index});
  },

  handle_create: function(e) {
    var child_index, name, parent_id;
    e.preventDefault();
    name = 'New node';
    parent_id = this.model.get("root").id;
    child_index = 0;
    this.create_taxon({name, parent_id, child_index});
  },

  events: {
    'click .js-taxon-delete': 'handle_delete',
    'click .js-taxon-add-child': 'handle_add_child'
  },

  initialize: function() {
    _.bindAll(this, 'redraw_tree', 'handle_create');
    $('.add-taxon-button').on('click', this.handle_create);
    this.listenTo(this.model, 'sync', this.render);
    this.redraw_tree();
  }
});

Spree.ready(function() {
  if ($('#taxonomy_tree').length) {
    var model = new Spree.Models.Taxonomy({
      id: $('#taxonomy_tree').data("taxonomy-id")
    });
    new TaxonTreeView({
      el: $('#taxonomy_tree'),
      model: model
    });
  }
});
