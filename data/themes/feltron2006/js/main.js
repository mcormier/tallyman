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

function handleUpdateReady(e) {
  var appCache = window.applicationCache;
  appCache.swapCache();
  if ( confirm('New version available. Load?') ) {
    window.location.reload();
  }
}

function init() { 
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

}

function bindLiftAlertSheet() {
  PPUtils.bindOnTouchHold($('lifts'), ontouchHoldLifts, 750);
  PPUtils.bind("click", $('liftSheetestimatesOpt'), handleLiftSheetSelection);
  PPUtils.bind("click", $('liftSheetoneToTenSpreadOpt'), handleLiftSheetSelection);
  PPUtils.bind("click", $('liftSheetvolumeEstimateOpt'), handleLiftSheetSelection);
  PPUtils.bind("click", $('liftSheetnoneOpt'), handleLiftSheetSelection);
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

  function toggleShortcutDrawer() { 
    closeDrawer = toggleShortcutDrawer;
    toggleDrawer( 'shortcuts', '250px', '125'); }
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
    saveSettings();
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

function handleLiftSheetSelection(evt) {
  //Switch checkmark before closing sheet
  var originalCheckMark = checkSpanForLiftSheet(settings.liftPanel);
  originalCheckMark.removeClass("selected");
  var option = evt.srcElement;
  option.childNodes[1].addClass("selected");


  //Change display after sheet closes
  setTimeout( function() {
      var globalSetting = settings.liftPanel;
      if (settings.liftPanel == '') { globalSetting = 'none'; }

      // liftSheetestimatesOpt -> estimates
      var optionSetting = option.id.replace(/(liftSheet)|(Opt)/g,"") ;
   
      if ( globalSetting != optionSetting) {
        toggle(optionSetting);
      }
    }, 500);

  closeLiftSheet();
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
