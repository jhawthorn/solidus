//= require solidus_admin/html.sortable

Spree.ready(function() {
  var sortables = sortable(
    'table.sortable tbody', {
      items: 'tr:not(.unsortable)',
      forcePlaceholderSize: true
    });

  _.each(sortables, function(table) {
    table.addEventListener('sortupdate', function(e) {
      var positions = {};
      _.each(e.detail.newStartList, function(el, index) {
        var idAttr = el.id;
        if (idAttr) {
          var objId = idAttr.split('_').slice(-1);
          positions['positions['+objId+']'] = index + 1;
        }
      });

      Spree.ajax({
        type: 'POST',
        dataType: 'script',
        url: $(table).parent('table').data("sortable-link"),
        data: positions,
      });
    });
  });
});
