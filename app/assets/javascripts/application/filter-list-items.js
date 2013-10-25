(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var filter = {
    _types: {},
    
    init: function() {
      var $filtered_list = $('.js-filtered-list');
      
      filter.$results = $('.results-list', $filtered_list);
      filter.$form = $('form.js-filter', $filtered_list);
      
      filter.$form.find('input,select').click( filter.refresh_filter );
    },
    
    refresh_filter: function() {
      filter.get_options();
      filter.update_results();
    },
    
    get_options: function() {
      $('#support-filter input', filter.$form).each( function() {
        filter._types[this.value] = this.checked;
      });
    },
    
    update_results: function() {
      console.log('update_results', filter.$results);
      
      var total_matches = 0;
      
      $('li', filter.$results).each( function() {
        var $item = $(this),
            found = false;
        
        // first, filter out any with non-matching support types
        support_types:
        for ( var key in filter._types ) {
          if ( filter._types[key] ) {
            if ( $item.data('types').indexOf(key) >= 0 ) {
              // only needs one type to match, not all (OR)
              found = true;
              break support_types;
            }
          }
        }
        
        if ( !found ) {
          $item.hide();
        }
        else {
          $item.show();
          total_matches++;
        }
      });
    }
    
    
  };
  
  root.GOVUK.filterListItems = filter;
}).call(this);
