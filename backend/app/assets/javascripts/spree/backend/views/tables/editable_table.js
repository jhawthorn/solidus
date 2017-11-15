var base;

(base = Spree.Views).Tables || (base.Tables = {});

Spree.Views.Tables.EditableTable = class EditableTable {
  static add($el) {
    return new Spree.Views.Tables.EditableTableRow({
      el: $el
    });
  }

  static append(html) {
    var $row;
    $row = $(html);
    $("#images-table")
      .removeClass("hidden")
      .find("tbody")
      .append($row);
    $row.find(".select2").select2();
    $(".no-objects-found").hide();
    return this.add($row);
  }
};
