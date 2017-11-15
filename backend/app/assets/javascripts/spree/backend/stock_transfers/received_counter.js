var ReceivedCounter;

ReceivedCounter = class ReceivedCounter {
  static updateTotal() {
    var newTotal;
    newTotal = _.reduce(
      $(".js-number-update-text"),
      function(memo, el) {
        return (
          memo +
          parseInt(
            $(el)
              .text()
              .trim(),
            10
          )
        );
      },
      0
    );
    return $("#total-received-quantity").text(newTotal);
  }
};

if (Spree.StockTransfers == null) {
  Spree.StockTransfers = {};
}

Spree.StockTransfers.ReceivedCounter = ReceivedCounter;
