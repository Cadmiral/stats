# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready(function() {



  // call the tablesorter plugin and apply the ui theme widget
 


  $("#todays_games").tablesorter(
  	{sortList: [[0,0], [1,0]],

    theme : 'jui', // theme "jui" and "bootstrap" override the uitheme widget option in v2.7+

    headerTemplate : '{content} {icon}', // needed to add icon for jui theme

    // widget code now contained in the jquery.tablesorter.widgets.js file
    widgets : ['uitheme', 'zebra'],

    widgetOptions : {
      // zebra striping class names - the uitheme widget adds the class names defined in
      // $.tablesorter.themes to the zebra widget class names
      zebra   : ["even", "odd"],

      // set the uitheme widget to use the jQuery UI theme class names
      // ** this is now optional, and will be overridden if the theme name exists in $.tablesorter.themes **
      // uitheme : 'jui'
    }

  });
});

$(document).ready(function() {

  // Extend the themes to change any of the default class names ** NEW **
  $.extend($.tablesorter.themes.jui, {
    // change default jQuery uitheme icons - find the full list of icons here: http://jqueryui.com/themeroller/ (hover over them for their name)
    table      : 'ui-widget ui-widget-content ui-corner-all', // table classes
    caption    : 'ui-widget-content ui-corner-all',
    header     : 'ui-widget-header ui-corner-all ui-state-default', // header classes
    footerRow  : '',
    footerCells: '',
    icons      : 'ui-icon', // icon class added to the <i> in the header
    sortNone   : 'ui-icon-carat-2-n-s',
    sortAsc    : 'ui-icon-carat-1-n',
    sortDesc   : 'ui-icon-carat-1-s',
    active     : 'ui-state-active', // applied when column is sorted
    hover      : 'ui-state-hover',  // hover class
    filterRow  : '',
    even       : 'ui-widget-content', // odd row zebra striping
    odd        : 'ui-state-default'   // even row zebra striping
  });

});
