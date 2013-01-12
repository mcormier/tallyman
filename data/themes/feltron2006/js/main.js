"use strict";

var cookieName = "feltron2006";
var settings = new Object();
settings.liftPanel = ''; 
var doNothing = function doNothing() {}
var closeDrawer = doNothing;
var onTouchHold = false;

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

function init() { 
  loadSettings(); 

  PPUtils.bind("click", $('macroHistoryLink'), toggleMacroWorkoutData );
  PPUtils.bind("click", $('shortcutsToggle'), toggleShortcutDrawer);
  PPUtils.bind("click", $('drawer-overlay'), overlayClicked);

  PPUtils.bindOnTouchHold($('lifts'), ontouchHold, 750);
}

  // TODO -- move to utils
function getViewPortOffset( elementID ) {
  var e = $(elementID);
  var offset = {x:0, y:0};

  while (e) {
    offset.x += e.offsetLeft;
    offset.y += e.offsetTop;
    e = e.offsetParent;
  }

  var docElem = document.documentElement;

  if (docElem && ( docElem.scrollTop || docElem.scrollLeft) ) {
    offset.x -= docElem.scrollLeft;
    offset.y -= docElem.scrollTop;
  } 
  else if (document.body && (document.body.scrollTop || document.body.scrollLeft))
  {
    offset.x -= document.body.scrollLeft;
    offset.y -= document.body.scrollTop;
  }
  else if (window.pageXOffset || window.pageYOffset)
  {
    offset.x -= window.pageXOffset;
    offset.y -= window.pageYOffset;
  }

  return offset;
}

function toggleDrawer( name, openHeight, transY ) {
  var drawerName = name + "Drawer";
  var drawer = $(drawerName);
  var drawerArrow = $(drawerName+"Arrow");
  var overlay = $("drawer-overlay");
  var link = $(name + "Link");

  var currHeight = drawer.style.height;
  var isClosed = currHeight == '0px' || currHeight == '';

  // show or hide drawer
  drawer.style.height = isClosed ? openHeight : '0px';
  // hide or display arrow
  drawerArrow.style.opacity = isClosed ? 1 : 0;
 
  // Fade surrounding elements
  var elemsToFade = $getClasses( ["drawerButton", "wrapper"] );

  for(var i=0; i < elemsToFade.length; i++) {
    // Fade everything but the current drawerButton
    if ( elemsToFade[i].id != link.id ) {
      elemsToFade[i].style.opacity = isClosed ? 0.2 : 1;
    }
  }

  // Get the location of the drawer on the screen
  // don't perform a translate if the top of the drawer
  // will disappear off screen
  var offset = getViewPortOffset(drawerName);

  if (transY && offset.y > transY) { 
    var container = $("contentContainer");
    container.style.webkitTransform =  isClosed ? "translateY(-"+transY+"px)"
                                                : "translateY(0px)";
  }

  // show/hideoverlay folder
  overlay.style.display = isClosed ? "block" : "none" ;

  return false;
}

  function overlayClicked() { console.log("overlay clicked");
    closeDrawer(); closeDrawer = doNothing; }

  function toggleShortcutDrawer() { 
    closeDrawer = toggleShortcutDrawer;
    return toggleDrawer( 'shortcuts', '250px', '125'); }
  function toggleMacroWorkoutData() { 
    closeDrawer = toggleMacroWorkoutData;
    return toggleDrawer('macroHistory', '520px','250'); }

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
      // Something else is currntly being displayed.
      var otherPanel = $className(settings.liftPanel);
      toggleVisibility(otherPanel, false);
      settings.liftPanel = clazz; 
      toggleVisibility(panel, true);
    }
  }
   
  function handleKeyEvent(evt) {
    var keyCode = String.fromCharCode(evt.keyCode); 
    if ( keyCode == 'e' ) { toggle('estimates'); } 
    if ( keyCode == 'v' ) { toggle('volumeEstimate'); } 
    if ( keyCode == 's' ) { toggle('oneToTenSpread'); } 
    saveSettings();
  }

function ontouchHold(evt) {
//  console.log("inside on touch hold");
}

PPUtils.bind("load", window, init);
PPUtils.bind("keypress", document, handleKeyEvent);
