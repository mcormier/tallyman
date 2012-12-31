
  var cookieName = "feltron2006";
  var settings = new Object();
  settings.estimatesOn = false;
  settings.volumeEstimatesOn = false;

  function saveSettings() {
    var str = JSON.stringify(settings);
    PPUtils.setCookie(cookieName, str, 20*365);
  }

  function loadSettings() {
    var c = PPUtils.getCookie(cookieName);
    if (c != null) { 
      settings = JSON.parse(c);
      var estimates = $className('estimates');
      var volumeEstimates = $className('volumeEstimate');
      toggleVisibility(estimates, settings.estimatesOn); 
      toggleVisibility(volumeEstimates, settings.volumeEstimatesOn); 
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

  function toggleShortcutDrawer() { return toggleDrawer( 'shortcutsDrawer', '200px'); }
  function toggleMacroWorkoutData() { return toggleDrawer('macroHistoryDrawer', '500px'); }

  function toggleVisibility(elements, visible) {
    if ( elements.length == 0 ) return;
    var opacity = visible == true ? 1 : 0;

    for (var i = 0; i < elements.length; i++ ) {
       elements[i].style.opacity = opacity
    }

  }



  function toggleEstimateVisibility() {
    if ( settings.volumeEstimatesOn ) { toggleVolumeVisibility(); }

    var estimates = $className('estimates');
    settings.estimatesOn = !settings.estimatesOn;
    toggleVisibility(estimates, settings.estimatesOn); 
    saveSettings();
  }

  function toggleVolumeVisibility() {
    if ( settings.estimatesOn ) { toggleEstimateVisibility(); }

    var volumeEstimates = $className('volumeEstimate');
    settings.volumeEstimatesOn = !settings.volumeEstimatesOn;
    toggleVisibility(volumeEstimates, settings.volumeEstimatesOn); 
    saveSettings();
  }
 
   
  function handleKeyEvent(evt) {
    var keyCode = String.fromCharCode(evt.keyCode); 

    if ( keyCode == 'e' ) { toggleEstimateVisibility(); } 
    if ( keyCode == 'v' ) { toggleVolumeVisibility(); } 
  }

  PPUtils.bind("load", window, init);
  PPUtils.bind("keypress", document, handleKeyEvent);
