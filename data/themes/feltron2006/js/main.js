
  var cookieName = "feltron2006";
  var settings = new Object();
  settings.estimatesOn = false;

  function saveSettings() {
    var str = JSON.stringify(settings);
    PPUtils.setCookie(cookieName, str, 20*365);
  }

  function loadSettings() {
    var c = PPUtils.getCookie(cookieName);
    if (c != null) { 
      settings = JSON.parse(c);
      var estimates = $className('estimates');
      toggleVisibility(estimates, settings.estimatesOn); 
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

  function toggleShortcutDrawer() { return toggleDrawer( 'shortcutsDrawer', '175px'); }
  function toggleMacroWorkoutData() { return toggleDrawer('macroHistoryDrawer', '500px'); }

  function toggleVisibility(elements, visible) {
    if ( elements.length == 0 ) return;
    var opacity = visible == true ? 1 : 0;

    for (var i = 0; i < elements.length; i++ ) {
       elements[i].style.opacity = opacity
    }

  }

  function toggleEstimateVisibility() {
    var estimates = $className('estimates');

    settings.estimatesOn = !settings.estimatesOn;
    toggleVisibility(estimates, settings.estimatesOn); 
    saveSettings();
  }
   
  function handleKeyEvent(evt) {
    if ( String.fromCharCode(evt.keyCode) == 'e' ) {
      toggleEstimateVisibility();
     }
  }

  PPUtils.bind("load", window, init);
  PPUtils.bind("keypress", document, handleKeyEvent);
