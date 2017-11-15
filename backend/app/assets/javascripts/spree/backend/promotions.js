// Tiered Calculator

var TieredCalculatorView, initTieredCalculators;

TieredCalculatorView = Backbone.View.extend({
  initialize: function() {
    var base, ref, results, value;
    this.calculatorName = this.$(".js-tiers").data("calculator");
    this.tierFieldsTemplate =
      HandlebarsTemplates[
        `promotions/calculators/fields/${this.calculatorName}`
      ];
    this.originalTiers = this.$(".js-tiers").data("original-tiers");
    this.formPrefix = this.$(".js-tiers").data("form-prefix");
    ref = this.originalTiers;
    results = [];
    for (base in ref) {
      value = ref[base];
      results.push(
        this.$(".js-tiers").append(
          this.tierFieldsTemplate({
            baseField: {
              value: base
            },
            valueField: {
              name: this.tierInputName(base),
              value: value
            }
          })
        )
      );
    }
    return results;
  },
  events: {
    "click .js-add-tier": "onAdd",
    "click .js-remove-tier": "onRemove",
    "change .js-base-input": "onChange"
  },
  tierInputName: function(base) {
    return `${this.formPrefix}[calculator_attributes][preferred_tiers][${
      base
    }]`;
  },
  onAdd: function(event) {
    event.preventDefault();
    return this.$(".js-tiers").append(
      this.tierFieldsTemplate({
        valueField: {
          name: null
        }
      })
    );
  },
  onRemove: function(event) {
    event.preventDefault();
    return $(event.target)
      .parents(".tier")
      .remove();
  },
  onChange: function(event) {
    var valueInput;
    valueInput = $(event.target)
      .parents(".tier")
      .find(".js-value-input");
    return valueInput.attr("name", this.tierInputName($(event.target).val()));
  }
});

initTieredCalculators = function() {
  return $(".js-tiered-calculator").each(function() {
    if (!$(this).data("has-view")) {
      $(this).data("has-view", true);
      return new TieredCalculatorView({
        el: this
      });
    }
  });
};

window.initPromotionActions = function() {
  var addOptionValue,
    optionValueSelectNameTemplate,
    optionValueTemplate,
    originalOptionValues;
  // Add classes on promotion items for design
  $(document).on("mouseover", "a.delete", function(event) {
    return $(this)
      .parent()
      .addClass("action-remove");
  });
  $(document).on("mouseout", "a.delete", function(event) {
    return $(this)
      .parent()
      .removeClass("action-remove");
  });
  $("#promotion-filters")
    .find(".variant_autocomplete")
    .variantAutocomplete();

  // Option Value Promo Rule

  if ($(".promo-rule-option-values").length) {
    optionValueSelectNameTemplate =
      HandlebarsTemplates["promotions/rules/option_values_select"];
    optionValueTemplate = HandlebarsTemplates["promotions/rules/option_values"];
    addOptionValue = function(product, values) {
      var optionValue, paramPrefix;
      paramPrefix = $(".promo-rule-option-values")
        .find(".param-prefix")
        .data("param-prefix");
      $(".js-promo-rule-option-values").append(
        optionValueTemplate({
          productSelect: {
            value: product
          },
          optionValuesSelect: {
            value: values
          },
          paramPrefix: paramPrefix
        })
      );
      optionValue = $(
        ".js-promo-rule-option-values .promo-rule-option-value"
      ).last();
      optionValue
        .find(".js-promo-rule-option-value-product-select")
        .productAutocomplete({
          multiple: false
        });
      optionValue
        .find(".js-promo-rule-option-value-option-values-select")
        .optionValueAutocomplete({
          productSelect: ".js-promo-rule-option-value-product-select"
        });
      if (product === null) {
        optionValue
          .find(".js-promo-rule-option-value-option-values-select")
          .prop("disabled", true);
      }
    };
    originalOptionValues = $(".js-original-promo-rule-option-values").data(
      "original-option-values"
    );
    if (!$(".js-original-promo-rule-option-values").data("loaded")) {
      if ($.isEmptyObject(originalOptionValues)) {
        addOptionValue(null, null);
      } else {
        $.each(originalOptionValues, addOptionValue);
      }
    }
    $(".js-original-promo-rule-option-values").data("loaded", true);
    $(document).on("click", ".js-add-promo-rule-option-value", function(event) {
      event.preventDefault();
      addOptionValue(null, null);
    });
    $(document).on("click", ".js-remove-promo-rule-option-value", function() {
      $(this)
        .parents(".promo-rule-option-value")
        .remove();
    });
    $(document).on(
      "change",
      ".js-promo-rule-option-value-product-select",
      function() {
        var optionValueSelect, paramPrefix;
        optionValueSelect = $(this)
          .parents(".promo-rule-option-value")
          .find("input.js-promo-rule-option-value-option-values-select");
        paramPrefix = $(".promo-rule-option-values")
          .find(".param-prefix")
          .data("param-prefix");
        optionValueSelect.attr(
          "name",
          optionValueSelectNameTemplate({
            product_id: $(this).val(),
            param_prefix: paramPrefix
          }).trim()
        );
        optionValueSelect
          .prop("disabled", $(this).val() === "")
          .select2("val", "");
      }
    );
  }
  return initTieredCalculators();
};

Spree.ready(initPromotionActions);
