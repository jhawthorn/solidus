Spree.ready(function() {
  return $(".inline-editable-table tr").each(function() {
    return Spree.Views.Tables.EditableTable.add($(this));
  });
});
