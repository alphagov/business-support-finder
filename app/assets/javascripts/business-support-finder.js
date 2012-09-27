
var GOVUK = GOVUK || {};

GOVUK.BusinessSupportFinder = {
  init: function () {
    $(".search-picker").on("click", "li[data-slug] a.add", {
      linkText: "Remove",
      target: ".picked-items"
    }, GOVUK.BusinessSupportFinder.swapper);

    // event handler to remove a list item from the picked list.
    $(".picked-items").on("click", "li[data-slug] a.remove", {
      linkText: "Add",
      target: ".search-picker"
    }, GOVUK.BusinessSupportFinder.swapper);
  },

  swapper: function(event) {

    function createNextUrl() {
      var sector_slugs = $('.picked-items li').map(function() { return $(this).data('slug'); }).get();
      return window.location.pathname.replace(/\/[^\/]+$/, "/stage") + "?sectors=" + sector_slugs.join("_");
    }

    event.preventDefault();

    var li = $(this).parent(), // the list item that is being moved
        source = $(event.delegateTarget), // container for list that item is coming from
        target = $(event.data.target), // container for list that item is going to
        targetList = $("ul", target);

    // Move and update the li
    li.remove();
    $('a', li)
      .removeClass()
      .addClass(event.data.linkText.toLowerCase())
      .text(event.data.linkText);
    targetList.append(li);

    // sort the target list
    var newlis = $('>li', targetList);
    newlis.remove();
    newlis = $.makeArray(newlis).sort(function(a, b) {
      return $("span", a).text().localeCompare($("span", b).text());
    });
    targetList.append(newlis);

    // show/hide picked-items hint and next link
    if (event.data.target === ".picked-items") { // adding an item
      $(".hint", target).removeClass("hint").addClass("hidden");
      if ($("#next-step").length === 0) {
        target.append('<div class="button-container"><a class="button medium" id="next-step">Next step</a></div>');
      }
    } else if (source.find("li").length === 0) { // removing an item
      $(".hidden", source).removeClass("hidden").addClass("hint");
      $("#next-step").remove();
    }

    // update Next link URL
    $("#next-step").attr("href", createNextUrl());
  }
};

$(function() {
  GOVUK.BusinessSupportFinder.init();
});
