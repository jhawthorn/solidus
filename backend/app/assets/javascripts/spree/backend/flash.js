var fadeOutTime, showTime;

showTime = 5000;

fadeOutTime = 500;

Spree.ready(function() {
  var $initialFlash;
  // Make flash messages dissapear
  // We only want to target the flash messages which are initially on the page.
  // Otherwise we risk hiding messages added by show_flash
  $initialFlash = $(".flash");
  return setTimeout(function() {
    return $initialFlash.fadeOut(fadeOutTime);
  }, showTime);
});

window.show_flash = function(type, message) {
  var $flashWrapper, flash_div;
  $flashWrapper = $(".js-flash-wrapper");
  flash_div = $(`<div class="flash ${type}" />`);
  $flashWrapper.prepend(flash_div);
  return flash_div
    .html(message)
    .show()
    .delay(showTime)
    .fadeOut(fadeOutTime);
};
