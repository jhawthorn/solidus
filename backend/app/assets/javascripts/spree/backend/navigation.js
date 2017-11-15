var checkSideBarFit, navHeight;

navHeight = function() {
  return (
    $(".admin-nav-header").outerHeight() +
    $(".admin-nav-menu").outerHeight() +
    $(".admin-nav-footer").outerHeight()
  );
};

checkSideBarFit = function() {
  return $(".admin-nav").toggleClass("fits", navHeight() < $(window).height());
};

Spree.ready(function() {
  $(".admin-nav-sticky, .admin-nav").stick_in_parent();
  checkSideBarFit();
  return $(window).on("resize", checkSideBarFit);
});
