(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var filter = {
    init: function() {
      console.log('filtering ready');
    },
  };
  
  root.GOVUK.filterListItems = filter;
}).call(this);
