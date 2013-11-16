"use strict";

var cookieName = "d3";
var settings = {};
settings.liftPanel = '';



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

function init() { loadSettings(); }

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
    if ( keyCode == 's' ) { toggle('oneToTenSpread'); }
    saveSettings();
  }


PPUtils.bind("load", window, init);
PPUtils.bind("keypress", document, handleKeyEvent);



var gDim = { 'w': 780, 'h': 300, 'margin': 80 };

var liftsNames = ["Deadlift", "Shoulder Press", "Clean", "Front Squat", "Push Jerk",
                  "Overhead Squat", "Snatch"];

new PPRepGraphOrchestrator(liftsNames, "lifts.tsv",  gDim);


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
  if ( d.data.used === "1" ) { return "Pre-loved"; }
  return d.data.used;
  };



new PPPieGraph("albumspurchasedGraph", "music.tsv", pDim, totalFunc, forEachFunc, m_fillFunc_, m_labelFunc );

