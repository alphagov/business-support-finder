
var GOVUK = GOVUK || {};

GOVUK.BusinessSupportFinder = (function () {
  var selectedItems = (function () {
    var items = [];

    return {
      add: function(id) {
        items.push(id + '');
      },
      remove: function(id) {
        var idx = items.length,
            found = false,
            tmpArr = [];

        while (idx--) {
            if (items[idx] !== id) {
                tmpArr.push(items[idx]);
            } else {
                found = true;
            }
        }

        items = tmpArr;

        return found;
      },
      contains: function(id) {
        var idx = $.inArray(id, items);

        if (idx === -1) {
            return false
        }

        return true;
      },
      get: function() {
        return items.slice(0);
      }
    };
  }());

  return {
    init: function () {
      var checkExisting = function () {
        var $pickedItems = $('.picked-items ul li');
        if ($pickedItems.length) {
          $pickedItems.each(function (idx) {
            var id = $(this).data('slug');

            selectedItems.add(id);
          });
        }
      };

      checkExisting();

      $(".search-picker").on("click", "li[data-slug] a.add", {
        linkText: "Remove",
        action: "add"
        
      }, GOVUK.BusinessSupportFinder.swapper);

      // event handler to remove a list item from the picked list.
      $(".picked-items, .search-picker").on("click", "li[data-slug] a.remove", {
        linkText: "Add",
        action: "remove"
      }, GOVUK.BusinessSupportFinder.swapper);
    },

    swapper: function(event) {

      function createNextUrl() {
        var sector_slugs = selectedItems.get();
        return window.location.pathname.replace(/\/[^\/]+$/, "/stage") + "?sectors=" + sector_slugs.join("_");
      }

      event.preventDefault();

      var li = $(this).parent(), // the list item that is being moved
          source = $(event.delegateTarget), // container for list that item is coming from
          target = $('.picked-items'), // container for list that item is going to
          targetList = $("ul", target),
          newli = li.clone(),
          itemLabel = $('span', newli),
          prefix = 'sector',
          itemId,
          newlis;

      if (event.data.action === 'add') {

        li.addClass('selected')
          .find('a')
          .removeClass('add')
          .addClass('remove')
          .text(event.data.linkText);

        // Move and update the li
        itemId = itemLabel.attr('id').replace(prefix + '-', '');
        itemLabel.attr('id', prefix + '-' + itemId + '-selected');
        $('a', newli)
          .removeClass()
          .addClass(event.data.linkText.toLowerCase())
          .attr('aria-labelledby', prefix + '-' + itemId + '-selected') 
          .text(event.data.linkText);
        targetList.append(newli);

        // show/hide picked-items hint and next link
        $(".hint", target).removeClass("hint").addClass("hidden");
        if ($("#next-step").length === 0) {
          target.append('<div class="button-container"><a class="button medium" id="next-step">Next step</a></div>');
        }

        selectedItems.add(itemId);
      } else {
        
        itemId = $(this).attr('aria-labelledby').replace('-selected', '');

        $('#' + itemId + '-selected').parent('li').remove();
        $('#' + itemId).parent('li')
          .removeClass('selected')
          .find('a')
          .removeClass('remove')
          .addClass('add')
          .text(event.data.linkText);

        if (source.find("li").length === 0) { // removing an item
          $(".hidden", source).removeClass("hidden").addClass("hint");
          $("#next-step").remove();
        }

        selectedItems.remove(itemId.replace(prefix + '-', '')); 
      }

      if (selectedItems.get().length > 0) {
        // sort the target list
        newlis = $('>li', targetList);

        newlis.remove();
        newlis = $.makeArray(newlis).sort(function(a, b) {
          return $("span", a).text().localeCompare($("span", b).text());
        });
        targetList.append(newlis);

        
      }

      // update Next link URL
      $("#next-step").attr("href", createNextUrl());
    }
  }
}());

$(function() {
  GOVUK.BusinessSupportFinder.init();
});
