var NumberFieldUpdater;

NumberFieldUpdater = (function() {
  var resetInput, toggleButtonVisibility, toggleForm, toggleReadOnly;

  class NumberFieldUpdater {
    static hideReadOnly(id) {
      toggleReadOnly(id, false);
      return resetInput(id);
    }

    static showReadOnly(id) {
      return toggleReadOnly(id, true);
    }

    static showForm(id) {
      return toggleForm(id, true);
    }

    static hideForm(id) {
      return toggleForm(id, false);
    }

    static successHandler(id, newNumber) {
      $(`#number-update-${id} span`).text(newNumber);
      this.hideForm(id);
      return this.showReadOnly(id);
    }
  }

  toggleReadOnly = function(id, show) {
    var cssDisplay;
    toggleButtonVisibility("edit", id, show);
    toggleButtonVisibility("remove", id, show);
    cssDisplay = show ? "block" : "none";
    return $(`#number-update-${id} span`).css("display", cssDisplay);
  };

  toggleForm = function(id, show) {
    var cssDisplay;
    toggleButtonVisibility("cancel", id, show);
    toggleButtonVisibility("save", id, show);
    cssDisplay = show ? "block" : "none";
    return $(`#number-update-${id} input[type='number']`).css(
      "display",
      cssDisplay
    );
  };

  toggleButtonVisibility = function(buttonAction, id, show) {
    var cssDisplay;
    cssDisplay = show ? "inline-block" : "none";
    return $(`[data-action='${buttonAction}'][data-id='${id}']`).css(
      "display",
      cssDisplay
    );
  };

  resetInput = function(id) {
    var countText, tableCell;
    tableCell = $(`#number-update-${id}`);
    countText = tableCell
      .find("span")
      .text()
      .trim();
    return tableCell.find("input[type='number']").val(countText);
  };

  return NumberFieldUpdater;
})();

Spree.NumberFieldUpdater = NumberFieldUpdater;
