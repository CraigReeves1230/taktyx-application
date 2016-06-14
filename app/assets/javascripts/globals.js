/**
 * Defines global variables
 */

window.taktyx.app = window.taktyx.app || angular.module('app', []);

///////////////------ Utility Functions ------//////////////////
window.taktyx.util = window.taktyx.util || {};

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