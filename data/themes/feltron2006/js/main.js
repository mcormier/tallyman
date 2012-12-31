
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

  function toggleShortcutDrawer() {
    elem = $('shortcutsDrawer');
    height = elem.style.height;
    elem.style.height = height == '0px' || height == ''
                      ? '175px' : '0px';
    return false;
  }


  function toggleMacroWorkoutData() {
    elem = $('macroHistory');
    height = elem.style.height;
    elem.style.height = height == '0px' || height == ''
                      ? '500px' : '0px';
    return false;
  }

  function toggleVisibility(elements, visible) {
    if ( elements.length == 0 ) return;

    var count = 10;
    var e = elements;
    var delta = visible == true ? 0.1 : -0.1;
    var opacity = e[0].style.opacity <= 0 ? 0 : 0.9;

    var interval = window.setInterval( function()
    {
     count--;
     opacity = opacity + delta;

     for (var i = 0; i < e.length; i++ ) {
       e[i].style.opacity = opacity
     }

     if ( count == 0 ) {
       clearInterval(interval);
     }

    }, 30);


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
