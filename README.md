Backbone.Hypermedia
===================
Replacement Model and Collection components which interop with the media type application/hal+json

Example Usage
============
``` javascript
MyModel = HAL.Model.extend({
  /* custom properties go here */
});

var instance = new MyModel({
  _links: {
    self: {
      href: '/example',
    },
    eg: {
      href: '/boo'
    }
  },
  _embedded: {
    foo: {
      _links: {
        self: {
          href: '/embedded'
        }
      },
      foo_prop: 'foo_val'
    }
  },
  prop: 'val',
  other_prop: 'other_val'
});

instance.url()          // #=> '/example'
instance.get('prop')    // #=> 'val'
instance.get('_links')  // #=> undefined
```

Source Code
===========
The library is written in CoffeeScript. The source files are contained
in the lib directory. If you make changes to these, you can rebuild the
javascript using the command `cake compile`.
