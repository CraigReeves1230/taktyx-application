/**
 * Defines global variables
 */

window.taktyx.app = window.taktyx.app || angular.module('app', []);

///////////////------ Utility Functions ------//////////////////
window.taktyx.util = window.taktyx.util || {};
window.taktyx.ajax_loading = false;

/**
 * Retreives a cookie from the document header
 * @param cname
 * @returns {*}
 */
window.taktyx.util.getCookie = function (cname) {
  var name = cname + "=";
  var ca = document.cookie.split(';');
  for(var i = 0; i <ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') {
      c = c.substring(1);
    }
    if (c.indexOf(name) == 0) {
      return c.substring(name.length,c.length);
    }
  }
  return "";
};

/**
 * Get URL parameter from URL
 * @param sParam
 * @returns {boolean}
 */
window.taktyx.util.getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1)),
        sURLVariables = sPageURL.split('&'),
        sParameterName,
        i;

    for (i = 0; i < sURLVariables.length; i++) {
        sParameterName = sURLVariables[i].split('=');

        if (sParameterName[0] === sParam) {
            return sParameterName[1] === undefined ? true : sParameterName[1];
        }
    }
};

/**
 * Show AJAX Loader
 */
window.taktyx.util.showAJAXLoader = function () {

  // Create div for loader
  if(!window.taktyx.ajax_loading) {

    window.taktyx.ajax_loading = true;

    var background = $("<div></div>");
    background.addClass('loader-background');

    var element = $("<div><img src='/assets/img/squares.gif'/></div>");
    element.addClass('loader');

    $("body").prepend(element).prepend(background);

    element.fadeIn(500);
    background.fadeIn(500);
  }
};

/**
 * Kill AJAX Loader
 */
window.taktyx.util.killAJAXLoader = function () {

  // Kill div loader
  window.taktyx.ajax_loading = false;
  $('.loader-background').fadeOut(500, function () { $(this).remove(); });
  $('.loader').fadeOut(500, function () { $(this).remove(); });

};