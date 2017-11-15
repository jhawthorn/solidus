var Tabs;

Tabs = class Tabs {
  constructor(el1) {
    this.overflowTabs = this.overflowTabs.bind(this);
    this.el = el1;
    this.$tabList = $(this.el);
    this.$tabs = this.$tabList.find("li:not(.tabs-dropdown)");
    this.tabs = this.$tabs.toArray();
    this.$tabList.append(
      "<li class='tabs-dropdown'><a href='#'></a><ul></ul></li>"
    );
    this.$dropdown = this.$tabList.find(".tabs-dropdown");
    this.setWidths();
    this.initEvents();
  }

  initEvents() {
    $(window).on("resize", this.overflowTabs);
    return this.overflowTabs();
  }

  setWidths() {
    this.tabWidths = this.tabs.map(function(tab) {
      return tab.offsetWidth;
    });
    return (this.totalTabsWidth = this.tabWidths.reduce(function(
      previousValue,
      currentValue
    ) {
      return previousValue + currentValue;
    }));
  }

  overflowTabs() {
    var containerWidth,
      dropdownActive,
      widthDifference,
      widthDifferenceWithDropdown;
    containerWidth = this.$tabList[0].offsetWidth;
    if (!this.lastKnownWidth) {
      this.lastKnownWidth = containerWidth;
    }
    widthDifference = this.totalTabsWidth - containerWidth;
    widthDifferenceWithDropdown = widthDifference + this.dropdownWidth();
    dropdownActive = this.$dropdown.find("li").length;
    if (containerWidth <= this.lastKnownWidth) {
      // The window is being sized down or we've just loaded the page
      if (
        (dropdownActive && widthDifferenceWithDropdown > 0) ||
        (!dropdownActive && widthDifference > 0)
      ) {
        this.hideTabsToFit(widthDifferenceWithDropdown);
      }
    }
    if (containerWidth > this.lastKnownWidth) {
      // The window is getting larger
      this.showTabsToFit(widthDifference);
    }
    return (this.lastKnownWidth = containerWidth);
  }

  dropdownWidth() {
    // If the dropdown isn't initiated we need to provide
    // our best guess of the size it will take up
    return this.$dropdown[0].offsetWidth || 50;
  }

  hideTabsToFit(widthDifference) {
    var j, len, tab, tabWidth, tabs;
    this.$tabList.addClass("tabs-overflowed");
    tabs = this.tabs.slice().reverse();
    for (j = 0, len = tabs.length; j < len; j++) {
      tab = tabs[j];
      // Bail if things are now fitting
      if (widthDifference <= 0) {
        return;
      }
      if ($(tab).hasClass("in-dropdown") || $(tab).hasClass("active")) {
        // Skip items already in the dropdown or active
        continue;
      }
      tabWidth = tab.offsetWidth;
      this.totalTabsWidth -= tabWidth;
      widthDifference -= tabWidth;
      $(tab)
        .appendTo(this.$dropdown.find("ul"))
        .addClass("in-dropdown");
    }
  }

  showTabsToFit(widthDifference) {
    var i, j, len, ref, tab, tabWidth;
    ref = this.tabs.slice();
    for (i = j = 0, len = ref.length; j < len; i = ++j) {
      tab = ref[i];
      if (!$(tab).hasClass("in-dropdown")) {
        // Skip items that aren't already in the dropdown
        continue;
      }
      // Get our tab's width from the array
      // We can't measure it here because it's hidden in the dropdown
      tabWidth = this.tabWidths[i];
      if (widthDifference + tabWidth > 0) {
        // Bail if there's no room for this tab
        break;
      }
      this.totalTabsWidth += tabWidth;
      widthDifference += tabWidth;
      $(tab)
        .insertBefore(this.$dropdown)
        .removeClass("in-dropdown");
    }
    // Reset styles if our dropdown is now empty
    if (this.$dropdown.find("li").length === 0) {
      return this.$tabList.removeClass("tabs-overflowed");
    }
  }
};

window.onload = function() {
  var el, j, len, ref, results;
  ref = $(".tabs");
  results = [];
  for (j = 0, len = ref.length; j < len; j++) {
    el = ref[j];
    results.push(new Tabs(el));
  }
  return results;
};
