Spree.ready(function() {
  var hideEditMemoForm;
  if (!($("#sc_memo_edit_form").length > 0)) {
    return;
  }
  $(".js-edit-memo").on("click", ev => {
    var originalValue;
    ev.preventDefault();
    originalValue = $("#memo-edit-row").data("original-value");
    $("#sc_memo_edit_form")
      .find("[name='store_credit[memo]']")
      .val(originalValue);
    $("#memo-display-row").addClass("hidden");
    return $("#memo-edit-row").removeClass("hidden");
  });
  $(".js-save-memo").on("click", function(ev) {
    ev.preventDefault();
    return Spree.ajax($("#sc_memo_edit_form").attr("url"), {
      data: $("#sc_memo_edit_form").serialize(),
      dataType: "json",
      method: "put",
      success: response => {
        var newValue;
        newValue = $("#sc_memo_edit_form")
          .find("[name='store_credit[memo]']")
          .val();
        $("#memo-edit-row").data("original-value", newValue);
        $("#memo-display-row")
          .find(".js-memo-text")
          .text(newValue);
        hideEditMemoForm();
        return show_flash("success", response.message);
      },
      error: (xhr, status) => {
        return show_flash("error", xhr.responseJSON.message);
      }
    });
  });
  $(".js-cancel-memo").on("click", ev => {
    ev.preventDefault();
    return hideEditMemoForm();
  });
  return (hideEditMemoForm = function() {
    $("#memo-edit-row").addClass("hidden");
    return $("#memo-display-row").removeClass("hidden");
  });
});
