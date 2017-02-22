# solidus\_backend

Backend contains the controllers, views, and assets making up the admin interface of solidus.

## Assets

Browsers we support in the admin (as of 2017-02-21):

* IE 11+
* Edge
* Safari 10+
* Chrome
* Firefox
* PhantomJS 2.1.1 (a requirement for testing, on an unfortunately old WebKit)

### Javascript

Can be found in [app/assets/javascripts/spree/backend/](./app/assets/javascripts/spree/backend/)

Our JavaScripts are in a state of transition. As a Rails engine, we can't
easily adapt a transpiler which would allow us to use ECMAScript >= 6 without
putting a setup and deployment burden on our users.

It is clear in the JavaScript community that ES6, and not CoffeeScript, is the
way forward. And though we can't currently use ES6, we should be writing our JS
in the way that can most easily be upgraded.

Out scripts are written in a mix of CoffeeScript and JavaScript. Plain-ol
JavaScript (ES5) is preferred for all new files, but converting existing files
from CoffeeScript is discouraged.

### Stylesheets

Can be found in [app/assets/stylesheets/spree/backend/](./app/assets/stylesheets/spree/backend/)

The stylesheets are written in SCSS and include all of [bourbon](http://bourbon.io/docs/) and [bootstrap 4 alpha](http://v4-alpha.getbootstrap.com/).

When running the application there is a styleguide available at:

```
/admin/style_guide
```

## Testing

Create the test site

    bundle exec rake test_app

Run the tests

    bundle exec rake spec
