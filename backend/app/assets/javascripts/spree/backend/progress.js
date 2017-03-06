//= require 'solidus_admin/nprogress'

(function() {
  var counter = 0;

  $(document).ajaxStart(function() {
    if(counter == 0) {
      NProgress.start();
    } else {
      NProgress.inc();
    }
    counter += 1;
  });

  $(document).ajaxStop(function() {
    counter -= 1;
    if(counter == 0) {
      NProgress.done();
    } else {
      NProgress.inc();
    }
  });
})();
