(function() {
  var defaultLocale = document.documentElement.lang;

  Spree.formatMoney = function(amount, currency, options) {
    options = (options || {});
    var locale = options.locale || defaultLocale;
    var format = new Intl.NumberFormat(locale, {style: 'currency', currency: currency})
    return format.format(amount)
  }
})()
