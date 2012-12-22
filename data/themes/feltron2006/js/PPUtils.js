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

if (typeof String.prototype.trimLeft !== "function") {
  String.prototype.trimLeft = function() {
    return this.replace(/^\s+/, "");
  };
}
if (typeof String.prototype.trimRight !== "function") {
  String.prototype.trimRight = function() {
    return this.replace(/\s+$/, "");
  };
}

if (typeof Array.prototype.map !== "function") {
  Array.prototype.map = function(callback, thisArg) {
    for (var i=0, n=this.length, a=[]; i<n; i++) {
      if (i in this) a[i] = callback.call(thisArg, this[i]);
    }
    return a;
  };
}

function PPUtils() {}

PPUtils.log = function ( output ) { if (window.console)  console.log(output); }

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

PPUtils.setCookie = function (name, value, days) {
  var expires = "";
  if (days > 0) {
    var date = new Date();
    date.setTime(date.getTime()+(days*24*60*60*1000));
    expires = "; expires="+date.toGMTString();
  }
  document.cookie = encodeURIComponent(name)+"="+
                    encodeURIComponent(value)+expires+"; path=/";
}

PPUtils.getCookie = function(name) {
  return PPUtils.getCookies()[name];
}

PPUtils.getCookies = function() {
  var c = document.cookie, v = 0, cookies = {};
  if (document.cookie.match(/^\s*\$Version=(?:"1"|1);\s*(.*)/)) {
    c = RegExp.$1;
    v = 1;
  }
  if (v === 0) {
    c.split(/[,;]/).map(function(cookie) {
      var parts = cookie.split(/=/, 2),
          name = decodeURIComponent(parts[0].trimLeft()),
          value = parts.length > 1 ? decodeURIComponent(parts[1].trimRight()) 
                                   : null;
      cookies[name] = value;
    });
  } else {
    c.match(/(?:^|\s+)([!#$%&'*+\-.0-9A-Z^`a-z|~]+)=([!#$%&'*+\-.0-9A-Z^`a-z|~]*|"(?:[\x20-\x7E\x80\xFF]|\\[\x00-\x7F])*")(?=\s*[,;]|$)/g).map(function($0, $1) {
      var name = $0,
          value = $1.charAt(0) === '"'
                    ? $1.substr(1, -1).replace(/\\(.)/g, "$1")
                    : $1;
          cookies[name] = value;
        });
    }
    return cookies;
}
