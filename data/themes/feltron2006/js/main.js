"use strict";

var cookieName = "feltron2006";
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

// Assumes that the overlay has a fixed position 
// and height + width = 100%
function PPPopOver( ID, arrowID, overlayID ) {
  this.rootPane = $(ID);
  this.arrow    = $(arrowID);
  this.overlay  = $(overlayID);

  // Listen for overlay clicks 
  var me = this;
  new FastClick( document.querySelector("#"+overlayID));
  PPUtils.bind("click", this.overlay, function(){ me.hide(); } );

  // TODO -- magic number....
  this.touchOffset = 25;
  // default arrow position
  this.setArrowPosition("top");
}

PPPopOver.prototype.setArrowPosition = function(position) {
  if (this.arrowPosition == position) { return;}

  // Remove old position style
  this.arrow.removeClass(this.arrowPosition);
  this.arrowPosition = position;
  // Add new position style
  this.arrow.addClass(this.arrowPosition);
}

PPPopOver.prototype.setTouchCoords = function(xTouchPos, yTouchPos) {
  var width     = this.rootPane.offsetWidth;
  var height    = this.rootPane.offsetHeight;
  var winWidth  = window.innerWidth;
  var winHeight = window.innerHeight;

  var arrowPosition = "top";

  // Arrow on top is the default
  // Centre PopOver
  var x = xTouchPos - width/2;
  // Assuming top arrow.  Move the PopOver just below the finger
  var y = yTouchPos + this.touchOffset;

  // Check popover is fully displayed on window

  // Finger is really close to right side of window
  if ( x + width > winWidth ) {
    // Shift to the right
    x -= width/2 + this.touchOffset;
    // Centre PopOver
    y = yTouchPos - height/2;
    arrowPosition = "right";
  }

  // Finger is close to left side of window
  if ( x < 0 ) {
    x = xTouchPos + this.touchOffset;
    y = yTouchPos - width/2;
    arrowPosition = "left";
  }


  // Finger is too close to bottom of window
  if ( yTouchPos + this.touchOffset + height > winHeight ) {
    y  = yTouchPos - height - this.touchOffset;
    arrowPosition = "bottom";
  }

  this.setArrowPosition(arrowPosition);
  this.rootPane.style.top = y + "px";
  this.rootPane.style.left = x + "px";
}

PPPopOver.prototype.show = function() {
  this.overlay.style.display = "block";
  this.rootPane.style.display = "block";
  this.rootPane.removeClass("fadeout");
  this.rootPane.addClass("fadein");   
}

PPPopOver.prototype.hide = function() {
  this.overlay.style.display = "none";
  this.rootPane.addClass("fadeout");
  this.rootPane.removeClass("fadein");
}


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
  window.applicationCache.addEventListener('updateready', handleUpdateReady);


  loadSettings(); 

  if (PPUtils.isiPhone() ) { 
    bindLiftAlertSheet(); 
  } else {
    new FastClick( document.querySelector("#macroShowDiv"));
    new FastClick( document.querySelector("#drawer-overlay"));
    PPUtils.bind("click", $('macroHistoryLink'), toggleMacroWorkoutData );
    PPUtils.bind("click", $('shortcutsToggle'), toggleShortcutDrawer);
    PPUtils.bind("click", $('drawer-overlay'), overlayClicked);
  }

  if (PPUtils.isiPad() ) { 
    iPadPopover  = new PPPopOver("liftOptionsSheet", "popoverArrow",
                                 "popover-overlay");
    PPUtils.bindOnTouchHold($('lifts'), iPadOntouchHoldLifts, 500);
    bindIDArrayToClick( liftSheetIds, handleLiftPopOverSelection );

  }
}

function bindIDArrayToClick( idArray, callback) {
  for(var i=0; i < idArray.length; i++) {
    PPUtils.bind("click", $(idArray[i]), callback);
  }
}


function bindLiftAlertSheet() {
  PPUtils.bindOnTouchHold($('lifts'), ontouchHoldLifts, 500);
  bindIDArrayToClick( liftSheetIds, handleLiftSheetSelection);
  PPUtils.bind("click", $('cancelLiftSheet'), cancelLiftSheet);
  new FastClick( document.querySelector(".PPActionSheet"));
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

  // show/hide overlay folder
  overlay.style.display = isClosed ? "block" : "none" ;
}

  function overlayClicked() { closeDrawer(); closeDrawer = doNothing; }

  function popOverlayClicked() { iPadPopover.hide(); }

  function toggleShortcutDrawer() { 
    closeDrawer = toggleShortcutDrawer;
    toggleDrawer( 'shortcuts', '270px', '135'); }
  function toggleMacroWorkoutData() { 
    closeDrawer = toggleMacroWorkoutData;
    toggleDrawer('macroHistory', '520px','250'); }

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
    if ( keyCode == 'v' ) { toggle('volumeEstimate'); } 
    if ( keyCode == 's' ) { toggle('oneToTenSpread'); } 
    if ( keyCode == 'f' ) { toggleFullScreen(); } 
    saveSettings();
  }


function toggleFullScreen() {
  var element = document.documentElement;
  var requestMethod = element.requestFullScreen || 
                      element.webkitRequestFullScreen || 
                      element.mozRequestFullScreen || 
                      element.msRequestFullScreen;
  if (requestMethod) {
    requestMethod.call(element, Element.ALLOW_KEYBOARD_INPUT);
  }
}

function iPadOntouchHoldLifts(evt) {
  var yPos = evt.touches[0].clientY; 
  var xPos = evt.touches[0].clientX; 
  
  iPadPopover.setTouchCoords(xPos,yPos);
  iPadPopover.show();
  return;


  if ( yPos + popOverHeight > document.body.offsetWidth ) {
    yPos -= popOverHeight + touchOffset*2;
    popoverArrow.addClass("bottom");
  }

}

function ontouchHoldLifts(evt) {
  var sheet = $('liftOptionsSheet');
  var checkmarkSpan = checkSpanForLiftSheet(settings.liftPanel);

  checkmarkSpan.addClass("selected");

  if ( sheet.style.display == 'none' 
    || sheet.style.display == '' ) { sheet.style.display = 'block'; } 
  
  sheet.removeClass("slide-down");
  sheet.addClass("slide-up");
 }

function getLiftSheetOptionFrom(optionName) {
  // 'estimates' = 'liftSheetestimatesOpt'
  //  and
  // ''          = 'liftSheetnoneOpt'
  var option = "liftSheet" + (optionName == '' ? 'none' : optionName) 
                + "Opt";

  return $(option); 
}

function checkSpanForLiftSheet(optionName) {
  var option = getLiftSheetOptionFrom(optionName);
  return option.getElementsByClassName("checked")[0];
}

function handleLiftPopOverSelection(evt) {
  var option = evt.srcElement;
  iPadPopover.hide();
  // Change display after PopOver disappears
  setTimeout( function(){parseTouchOption(option);}, 500);
}

function handleLiftSheetSelection(evt) {
  // Switch checkmark before closing sheet
  var originalCheckMark = checkSpanForLiftSheet(settings.liftPanel);
  originalCheckMark.removeClass("selected");
  var option = evt.srcElement;
  option.childNodes[1].addClass("selected");

  closeLiftSheet();

  // Change display after sheet closes
  setTimeout( function(){parseTouchOption(option);}, 500);
}

// Used by iPhone.alertSheet and iPad.popOver for parsing
// a users selection.
function parseTouchOption(option) {
  var globalSetting = settings.liftPanel;
  if (settings.liftPanel == '') { globalSetting = 'none'; }

  // liftSheetestimatesOpt -> estimates
  var optionSetting = option.id.replace(/(liftSheet)|(Opt)/g,"") ;

  if (globalSetting != optionSetting) { 
    toggle(optionSetting); 
    saveSettings();
  }
}

function closeLiftSheet() {
  var sheet = $('liftOptionsSheet');
  sheet.removeClass("slide-up");
  sheet.addClass("slide-down");
}

// Function synonym
var cancelLiftSheet = closeLiftSheet;


PPUtils.bind("load", window, init);
PPUtils.bind("keypress", document, handleKeyEvent);

