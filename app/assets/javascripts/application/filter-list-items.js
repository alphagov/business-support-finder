(function () {
  "use strict"
  var root = this,
      $ = root.jQuery;
  if(typeof root.GOVUK === 'undefined') { root.GOVUK = {}; }

  var filter = {
    _types: {},
    _options: {},
    
    init: function() {
      var has_history_api = window.history
                            && window.history.pushState
                            && window.history.replaceState;
      
      if ( !has_history_api )
        return false;
      
      var $filtered_list = $('.js-filtered-list');
      
      filter.$results = $('.results-list', $filtered_list);
      filter.$form = $('form.js-filter', $filtered_list);
      filter.$count = $('.results-count', $filtered_list);
      
      filter.initialise_history_api();
      filter.$form.find('input,select').on( 'change', filter.refresh_filter );
      
      filter.$form.find('#filter-submit').hide();
    },
    
    refresh_filter: function() {
      filter.get_options();
      filter.update_history_api();
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
    },
    
    initialise_history_api: function() {
      history.replaceState( filter.current_page_state(), null );
      $(window).on('popstate', filter.handle_popstate);
    },
    handle_popstate: function(jq_ev) {
      var event = jq_ev.originalEvent,
          state = event.state;
      
      if ( state == null )
        return false;
      
      filter.$form.find('select').each( function() {
        var $this = $(this);
        $this.attr( 'value', state[ $this.attr('id') ] );
      });
      filter.$form.find('input[type=checkbox]').each( function() {
        var $this = $(this);
        $this.attr( 'checked', state[ $this.attr('id') ] );
      });
      
      filter.get_options();
      filter.update_results();
    },
    current_page_state: function() {
      var state = {};
      
      filter.$form.find('select').each( function() {
        var $this = $(this);
        state[ $this.attr('id') ] = $this.attr('value');
      });
      filter.$form.find('input[type=checkbox]').each( function() {
        var $this = $(this);
        state[ $this.attr('id') ] = $this.attr('checked');
      });
      
      return state;
    },
    update_history_api: function() {
      var new_url = filter.$form.attr('action')
                    + '?' +  filter.$form.serialize();
      
      history.pushState( filter.current_page_state(), null, new_url );
      window._gaq && _gaq.push(['_trackPageview', new_url]);
    }
  };
  
  root.GOVUK.filterListItems = filter;
}).call(this);
