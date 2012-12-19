  function init() { }


  function toggleEstimateVisibility() {
    var estimates = $className('estimates');
    var count = 10;
    var opacity;
    var delta;

    if ( estimates[0].style.opacity == "" ) {
      opacity = 0.9;
    } else {
      opacity = estimates[0].style.opacity;
      if ( opacity < 0 ) { opacity = 0; } else { opacity = 0.9 }
    }
    if ( opacity == 0 ) { delta = 0.1; } else { delta = -0.1; }

    var interval = window.setInterval( function()
    {
     count--;
     opacity = opacity + delta;

     for (var i = 0; i < estimates.length; i++ ) {
       estimates[i].style.opacity = opacity
     }

     if ( count == 0 ) {
       clearInterval(interval);
     }

    }, 30);


  }
   


    function handleKeyEvent(evt) {
       if ( String.fromCharCode(evt.keyCode) == 'e' ) {
         toggleEstimateVisibility();
       }
    }

     PPUtils.bind("load", window, init);
     PPUtils.bind("keypress", document, handleKeyEvent);
