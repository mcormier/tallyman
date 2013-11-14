"use strict";

var cookieName = "d3";
var settings = new Object();
settings.liftPanel = ''; 
var doNothing = function doNothing() {}
var closeDrawer = doNothing;
var onTouchHold = false;
var iPadPopover = null;
var liftSheetIds = ["liftSheetestimatesOpt",
                    "liftSheetoneToTenSpreadOpt",
                    "liftSheetvolumeEstimateOpt", 
                    "liftSheetnoneOpt"];
var loadTime = null;



function saveSettings() {
  var str = JSON.stringify(settings);
  PPUtils.setCookie(cookieName, str, 20*365);
}

function loadSettings() {
  var c = PPUtils.getCookie(cookieName);
  if (c != null) { 
    settings = JSON.parse(c);
    if ( settings.liftPanel != '' ) {
      var panel = $className(settings.liftPanel);
      toggleVisibility(panel, true);
    }
  }
}

function handleUpdateReady(e) {
  var appCache = window.applicationCache;
  appCache.swapCache();
  var now = new Date();
  var diffInMillSeconds = now.getTime() - loadTime.getTime();

  // If the user is on a fast connection and the cache was 
  // reloaded and swapped in less than a second then reload
  // the page without asking.  If the connection/machine is
  // is slower then ask if they want to reload the page.
  if ( diffInMillSeconds < 1000 || 
       confirm('New version available. Load?') ) {
    window.location.reload();
  }

}

function init() { 
  loadTime = new Date();
  //window.applicationCache.addEventListener('updateready', handleUpdateReady);
  loadSettings(); 
}

function bindIDArrayToClick( idArray, callback) {
  for(var i=0; i < idArray.length; i++) {
    PPUtils.bind("click", $(idArray[i]), callback);
  }
}




  function toggleVisibility(elements, visible) {
    if ( elements.length == 0 ) return;
    var opacity = visible == true ? 1 : 0;

    for (var i = 0; i < elements.length; i++ ) {
       elements[i].style.opacity = opacity
    }

  }

  function toggle(clazz) {

    var panel = $className(clazz);

    if (settings.liftPanel == clazz ) {
      settings.liftPanel = ''; 
      toggleVisibility(panel, false);
    } else {
      // Something else is currently being displayed.
      var otherPanel = $className(settings.liftPanel);
      toggleVisibility(otherPanel, false);
      settings.liftPanel = clazz; 
      toggleVisibility(panel, true);
    }
  }
   
  function handleKeyEvent(evt) {
    var keyCode = String.fromCharCode(evt.keyCode); 
    if ( keyCode == 'e' ) { toggle('estimates'); } 
    //if ( keyCode == 'v' ) { toggle('volumeEstimate'); } 
    if ( keyCode == 's' ) { toggle('oneToTenSpread'); } 
    //if ( keyCode == 'f' ) { toggleFullScreen(); } 
    saveSettings();
  }




PPUtils.bind("load", window, init);
PPUtils.bind("keypress", document, handleKeyEvent);

function type(d) {
    d.weight = +d.weight;     // coerce to number
    d.reps = +d.reps;         // coerce to number
    d.day = new Date(d.day);
    return d;
  }

var gDim = { 'w': 780, 'h': 300, 'margin': 80 };

// TODO - tell one master object to load the lifts.tsv file
new PPRepGraph("d3Graphdeadlift", "lifts.tsv", "Deadlift", type, gDim);
new PPRepGraph("d3Graphshoulderpress", "lifts.tsv", "Shoulder Press", type, gDim);
new PPRepGraph("d3Graphbacksquat", "lifts.tsv", "Back Squat", type, gDim);
new PPRepGraph("d3Graphclean", "lifts.tsv", "Clean", type, gDim);
new PPRepGraph("d3Graphfrontsquat", "lifts.tsv", "Front Squat", type, gDim);
new PPRepGraph("d3Graphcleanandjerk", "lifts.tsv", "Clean & Jerk", type, gDim);
new PPRepGraph("d3Graphsquatclean", "lifts.tsv", "Squat Clean", type, gDim);
new PPRepGraph("d3Graphpushjerk", "lifts.tsv", "Push Jerk", type, gDim);
new PPRepGraph("d3Graphpushpress", "lifts.tsv", "Push Press", type, gDim);
new PPRepGraph("d3Graphoverheadsquat", "lifts.tsv", "Overhead Squat", type, gDim);
new PPRepGraph("d3Graphsnatch", "lifts.tsv", "Snatch", type, gDim);
new PPRepGraph("d3Graphsquatsnatch", "lifts.tsv", "Squat Snatch", type, gDim);
new PPRepGraph("d3Graphsotspress", "lifts.tsv", "Sots Press", type, gDim);



var pDim = { 'w': 150, 'h': 150 };

var totalFunc = function(d) { return d.total };
var forEachFunc = function(d) { d.total = +d.total; };

var fillFunc_ = function(d) { return d.data.digital; };
var labelFunc = function(d) {
  if ( d.data.digital === "0" ) { return "Analog"; }
  if ( d.data.digital === "1" ) { return "Digital"; }
  return d.data.digital;
  };


new PPPieGraph("booksreadGraph", "books.tsv", pDim, totalFunc, forEachFunc, fillFunc_, labelFunc );

var m_fillFunc_ = function(d) { return d.data.used; };
var m_labelFunc = function(d) {
  if ( d.data.used === "0" ) { return "New"; }
  if ( d.data.used === "1" ) { return "Pre-owned"; }
  return d.data.used;
  };



new PPPieGraph("albumspurchasedGraph", "music.tsv", pDim, totalFunc, forEachFunc, m_fillFunc_, m_labelFunc );

