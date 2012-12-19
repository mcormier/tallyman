"use strict";

function $(id){ return document.getElementById(id); }


function showElement( e ) { e.style.visibility = "visible"; }
function hideElement( e ) { e.style.visibility = "hidden"; }

function toggleElementVisibility( e ) { 
  if (e.style.visibility == "hidden") {
    showElement(e); 
  } else {
    hideElement(e);
  }
}

function PPUtils() {}

PPUtils.log = function ( output ) {
    if (window.console ) {
      console.log(output);
    }
}


PPUtils.bind = function(event, element, callback) {
  if ( typeof element.addEventListener != "undefined" ) {
    element.addEventListener(event, callback, false);
  } else if ( typeof element.attachEvent != "undefined" ) { // Supports IE < 9
    element.attachEvent(event, callback);
  }
}

PPUtils.getElementsByClassName=function(cn) {
  var allT=document.getElementsByTagName('*'), allCN=[], i=0, a;
  while(a=allT[i++]){
    a.className==cn?allCN[allCN.length]=a:null;
  }
  return allCN
}

function $className(className) { 
  if(!document.getElementsByClassName) {
    return PPUtils.getElementsByClassName(className);
  }
  return document.getElementsByClassName(className);
}
