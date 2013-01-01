
  var cookieName = "feltron2006";
  var settings = new Object();
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

  function init() { 
    loadSettings(); 
    elem = $('macroShow');    
    PPUtils.bind("click", elem, toggleMacroWorkoutData );

    elem = $('shortcuts');    
    PPUtils.bind("click", elem, toggleShortcutDrawer);
  }

  function toggleDrawer( drawerName, openHeight ) {
    drawer = $(drawerName);
    currHeight = drawer.style.height;
    drawer.style.height = currHeight == '0px' || currHeight == ''
                        ? openHeight : '0px';
    return false;
  }

  function toggleShortcutDrawer() { return toggleDrawer( 'shortcutsDrawer', '250px'); }
  function toggleMacroWorkoutData() { return toggleDrawer('macroHistoryDrawer', '500px'); }

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

  PPUtils.bind("load", window, init);
  PPUtils.bind("keypress", document, handleKeyEvent);
