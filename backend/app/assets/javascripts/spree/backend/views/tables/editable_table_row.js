Spree.Views.Tables.EditableTableRow = Backbone.View.extend({
  events: {
    "select2-open": "onEdit",
    "focus input": "onEdit",
    "click [data-action=save]": "onSave",
    "click [data-action=cancel]": "onCancel",
    "keyup input": "onKeypress"
  },
  onEdit: function(e) {
    if (this.$el.hasClass("editing")) {
      return;
    }
    this.$el.addClass("editing");
    return this.$el.find("input, select").each(function() {
      var $input;
      $input = $(this);
      return $input.data("original-value", $input.val());
    });
  },
  onCancel: function(e) {
    e.preventDefault();
    this.$el.removeClass("editing");
    return this.$el.find("input, select").each(function() {
      var $input, originalValue;
      $input = $(this);
      originalValue = $input.data("original-value");
      return $input.val(originalValue).change();
    });
  },
  onSave: function(e) {
    e.preventDefault();
    return Spree.ajax(
      this.$el.find(".actions [data-action=save]").attr("href"),
      {
        data: this.$el.find("select, input").serialize(),
        dataType: "json",
        method: "put",
        success: response => {
          return this.$el.removeClass("editing");
        },
        error: response => {
          return show_flash("error", response.responseJSON.error);
        }
      }
    );
  },
  ENTER_KEY: 13,
  ESC_KEY: 27,
  onKeypress: function(e) {
    var key;
    key = e.keyCode || e.which;
    switch (key) {
      case this.ENTER_KEY:
        return this.onSave(e);
      case this.ESC_KEY:
        return this.onCancel(e);
    }
  }
});
