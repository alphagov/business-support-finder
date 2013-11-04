(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var filter = {
    _types: {},
    _options: {},
    
    init: function() {
      var $filtered_list = $('.js-filtered-list');
      
      filter.$results = $('.results-list', $filtered_list);
      filter.$form = $('form.js-filter', $filtered_list);
      filter.$count = $('.results-count', $filtered_list);
      
      filter.$form.find('input,select').bind( 'change click', filter.refresh_filter );
      filter.$form.find('#filter-submit').hide();
    },
    
    refresh_filter: function() {
      filter.get_options();
      filter.update_results();
    },
    
    get_options: function() {
      $('#support-filter input', filter.$form).each( function() {
        filter._types[this.value] = this.checked;
      });
      $('.filter-exclusive select', filter.$form).each( function() {
        filter._options[this.name] = this.value;
      });
    },
    
    update_results: function() {
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

        support_options:
        if ( found ) {
          for ( var key in filter._options ) {
            var value = filter._options[key];
            if ( $item.data(key).indexOf(value) < 0 ) {
              // all must match (AND)
              found = false;
              break support_options;
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
        
        filter.$count.text(total_matches);
      });
    }
  };
  
  root.GOVUK.filterListItems = filter;
}).call(this);
