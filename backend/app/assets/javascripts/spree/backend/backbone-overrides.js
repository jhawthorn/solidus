var oldSync,
  indexOf = [].indexOf;

Backbone.ajax = Spree.ajax;

oldSync = Backbone.sync;

Backbone.sync = function(method, model, options) {
  var beforeSend, data, postMethods;
  beforeSend = options.beforeSend;
  options.beforeSend = function(xhr) {
    var token;
    token = $('meta[name="csrf-token"]').attr("content");
    if (token) {
      xhr.setRequestHeader("X-CSRF-Token", token);
    }
    if (beforeSend) {
      return beforeSend.apply(this, arguments);
    }
  };
  // Allow for submitting requests the "rails way"
  // E.g. { model_name: model_attributes }
  // conditional and contentType are the same as vanilla backbone, save the
  // paramRoot check.
  postMethods = ["update", "create", "patch"];
  if (
    (model != null ? model.paramRoot : void 0) &&
    !options.data &&
    indexOf.call(postMethods, method) >= 0
  ) {
    options.contentType = "application/json";
    data = {};
    data[model.paramRoot] = model.toJSON(options);
    options.data = JSON.stringify(data);
  }
  return oldSync(method, model, options);
};
