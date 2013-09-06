/*jslint
 browser: true,
 white: true,
 plusplus: true,
 vars: true,
 nomen: true */
/*global jQuery */
if(typeof window.GOVUK === 'undefined'){ window.GOVUK = {}; }
if(typeof window.GOVUK.support === 'undefined'){ window.GOVUK.support = {}; }

window.GOVUK.support.history = function() {
  return window.history && window.history.pushState && window.history.replaceState;
};
(function($) {
  "use strict";

  var documentFilter = {
    loading: false,
    $form: null,
    formType: '',
    staticData: null,

    getData: function(params) {
      var $form = this.$form,
          $submitButton = $form.find('input[type=submit]');

      $.ajax($form.attr('action'), {
        cache: false,
        dataType:'json',
        data: params,
        complete: function(){
          //documentFilter.loading = false;
        },
        success: function(data) {
          documentFilter.staticData = data;
        },
        error: function() {
          $submitButton.removeAttr('disabled');
        }
      });
    },
    filterParams: function(params) {
      var supportFilters = [],
          tempParams = [],
          mappings = {
            "business-type-option": "sectors",
            "business-stage-option": "stages",
            "types[]": "support_types",
            "location": "locations"
          };
      $.map(params, function (param) {
        if (param.name === 'types[]') {
          supportFilters.push(param.value);
        }
        else { tempParams.push(param); }
      });

      if (supportFilters.length) { 
        params = tempParams;
        params.push({ 'name': 'types[]', 'value': supportFilters }); 
        tempParams = [];
      }

      $.map(params, function (param) {
        param.name = mappings[param.name];
        return param;
      });

      return params;
    },
    sortData: function(params) {
      var items = this.staticData,
          itemNum = items.length,
          results = [],

          paramInItem = function(item, param) {
            if (typeof item[param.name] !== 'undefined' && $.inArray(param.value, item[param.name])) {
              return true;
            }
            return false;
          },
          
          isValidItem = function(item) {
            var paramNum = params.length,
                paramName,
                paramValues,
                param,
                valueMatches,
                paramMatches = 0;

            while (paramNum--) {
              if ($.isArray(params[paramNum].value)) {
                valueMatches = 0;
                paramName = params[paramNum].name;
                paramValues = params[paramNum].value;
                $.map(params[paramNum].value, function (paramValue) {
                  if (paramInItem(item, { 'name': paramName, 'value': paramValue})) { valueMatches++; }
                });
                if (valueMatches === paramValues.length) { paramMatches++ }
              }
              else {
                param = params[paramNum];
                if (param.value === 'all') {
                  paramMatches++;
                }
                else {
                  if (paramInItem(item, param)) { paramMatches++ }
                }
              }
            }

            return (paramMatches === params.length);
          };

      while (itemNum--) {
        if (isValidItem(items[itemNum])) {
          results.push(items[itemNum]);
        }
      }
      return results;
    },
    renderTable: function(data) {
      $('.js-filter-results').mustache('documents-_filter_table', data);
    },
    updateAtomFeed: function(data) {
      if (data.atom_feed_url) {
        $(".feeds .feed").attr("href", data.atom_feed_url);
      }
    },
    updateEmailSignup: function(data) {
      if (data.email_signup_url) {
        $(".feeds .govdelivery").attr("href", data.email_signup_url);
      }
    },
    updateFeeds: function(data) {
      $(".feeds").removeClass('js-hidden');
      documentFilter.updateAtomFeed(data);
      documentFilter.updateEmailSignup(data);
    },
    submitFilters: function(e){
      e.preventDefault();
      var $form = documentFilter.$form,
          $submitButton = $form.find('input[type=submit]'),
          url = $form.attr('action'),
          jsonUrl = url + ".json",
          params = $form.serializeArray(),
          data;

      $('.submit .button').addClass('disabled');
      $(".filter-results-summary").find('.selections').text("Loading results…");
      $(".feeds").addClass('js-hidden');
      //documentFilter.loading = true;
      // TODO: make a spinny updating thing
      /*
      $.ajax(jsonUrl, {
        cache: false,
        dataType:'json',
        data: params,
        complete: function(){
          documentFilter.loading = false;
        },
        success: function(data) {
          documentFilter.updateFeeds(data);
          if (data.results) {
            documentFilter.renderTable(data);
            documentFilter.liveResultCounter(data);
          }

          var newUrl = url + "?" + $form.serialize();
          history.pushState(documentFilter.currentPageState(), null, newUrl);
          //window._gaq && _gaq.push(['_trackPageview', newUrl]);
        },
        error: function() {
          $submitButton.removeAttr('disabled');
        }
      });
      */
      params = documentFilter.filterParams(params);
      data = documentFilter.sortData(params);
      documentFilter.renderTable(data);
      documentFilter.liveResultCounter(data);
    },
    urlWithout: function(object, value){
      var url = window.location.search,
          reg = new RegExp('&?'+object+'%5B%5D='+value+'&?');

      return url.replace(reg, '&')
    },
    urlWithoutLocation: function(words, index){
      var url = window.location.search,
          reg = new RegExp('locations=[^&]+'),
          newLocations = [],
          i, _i;

      for(i=0,_i=words.length; i<_i; i++){
        if(i !== index){
          newLocations.push(words[i]);
        }
      }
      return url.replace(reg, 'keywords='+ newLocations.join('+'));
    },
    liveResultCounter: function(data) {
      var $counter = $('.filter-results-summary span'),
          count = parseInt($counter.text(), 10);
    },
    currentPageState: function() {
      return {
        html: $('.js-filter-results').html(),
        selected: $.map(documentFilter.$form.find('select'), function(n) {
          var $n = $(n),
              id = $n.attr('id'),
              titles = [],
              values = [];
          $("#" + id  + " option:selected").each(function(){
            titles.push($(this).text());
            values.push($(this).attr('value'));
          });
          return {id: id, value: values, title: titles};
        }),
        text: $.map(documentFilter.$form.find('input[type=text]'), function(n) {
          var $n = $(n);
          return {id: $n.attr('id'), value: $n.val()};
        }),
        checked: $.map(documentFilter.$form.find('input[type=radio]:checked, input[type=checkbox]:checked'), function(n) {
          var $n = $(n);
          return {id: $n.attr('id'), value: $n.val()};
        })
      };
    },
    onPopState: function(event) {
      if (event.state && event.state.html) {
        $('.js-filter-results').html(event.state.html);
        $.each(event.state.selected, function(i, selected) {
          $("#" + selected.id).val(selected.value);
        });
        $.each(event.state.text, function(i, text) {
          $("#" + text.id).val(text.value);
        });
        $.each(event.state.checked, function(i, checked) {
          $("#" + checked.id).attr('checked', true);
        });
      }
    }
  };
  window.GOVUK.documentFilter = documentFilter;

  var enableDocumentFilter = function() {
    if (window.ieVersion && ieVersion === 6) {
      return this;
    }
    this.each(function(){
      if (window.GOVUK.support.history()) {
        var $form = $(this),
            params = $form.serializeArray();
        $(window).on('popstate', function(evet) {
          documentFilter.onPopState(event);
        });
        documentFilter.$form = $form;
        documentFilter.formType = $form.attr('action').split('/').pop();

        params = documentFilter.filterParams(params);
        documentFilter.getData(params);

        history.replaceState(documentFilter.currentPageState(), null);
        $form.submit(documentFilter.submitFilters);
        $form.find('select, input[name=location]:radio, input:checkbox').change(function(e){
          $form.submit();
        });

        var delay = (function(){
          var timer = 0;
          return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
          }
        })();

        $('#location-filter').find('input[name=location]').keyup(function () {
          delay(function () {
            $form.submit();
          }, 600);
        });

        $(".submit").addClass("js-hidden");
      }
    });

    return this;
  }

  $.fn.extend({
    enableDocumentFilter: enableDocumentFilter
  });
})(jQuery);
