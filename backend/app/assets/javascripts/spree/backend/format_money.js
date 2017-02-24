//= require 'solidus_admin/Intl.js'
//= require 'solidus_admin/Intl-en.js'

// This following uses Intl.NumberFormat from the ECMAScript
// Internationalization API.
//
// This is supported on all out target browsers (IE11+). However, it isn't
// supported by phantomjs, for which we require the above polyfill.

(function() {
  var defaultLocale = document.documentElement.lang;

  Spree.formatMoney = function(amount, currency, options) {
    options = (options || {});
    var locale = options.locale || defaultLocale;
    var format = new Intl.NumberFormat(locale, {style: 'currency', currency: currency})
    return format.format(amount)
  }
})()
