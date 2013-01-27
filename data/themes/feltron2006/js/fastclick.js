/**
 * FastClick: Set up handling of fast clicks
 *
 * See ./fastclick.md for full license and description.
 * 
 * @licence MIT License 
 * @copyright (c) 2011 Assanka Limited
 * @author Rowan Beentje <rowan@assanka.net>, 
 *         Matt Caruana Galizia <matt@assanka.net>
 *         Matthieu Cormier <mcormier@preenandprune.com>
 */

var FastClick = (function() {

	// Is touch handling is supported?
	var touchSupport = 'ontouchstart' in window;

	return function(layer) {
		if (!(layer instanceof HTMLElement)) {
			throw new TypeError('Layer must be instance of HTMLElement');
		}

		// Bind to events
		if (touchSupport) {
      PPUtils.bind('touchstart', layer, onTouchStart, true);
      PPUtils.bind('touchmove', layer, onTouchMove, true);
      PPUtils.bind('touchend', layer, onTouchEnd, true);
      PPUtils.bind('touchcancel', layer, onTouchCancel, true);
		}

    PPUtils.bind('click', layer, onClick, true);

		// If a handler is already declared in the element's 
    // onclick attribute, it will be fired before FastClick
		// Fix this by pulling out the user-defined handler 
		// function and adding it as listener.
		if (layer.onclick instanceof Function) {
      PPUtils.bind('click', layer, layer.onclick);
			layer.onclick = '';
		}

		// Define touch-handling variables
		var clickStart = { x:0, y:0, scroll:0 }, trackingClick = false;
	
		// On touch start, record the position and scroll offset.
		function onTouchStart(event) {
			trackingClick = true;
			clickStart.x = event.targetTouches[0].clientX;
			clickStart.y = event.targetTouches[0].clientY;
			clickStart.scroll = window.pageYOffset;
	
			return true;
		}
	
		// If the touch moves more than a small amount, cancel any derived clicks.
		function onTouchMove(event) {
			if (trackingClick) {
				if (Math.abs(event.targetTouches[0].clientX - clickStart.x) > 10 
         || Math.abs(event.targetTouches[0].clientY - clickStart.y) > 10) {
					trackingClick = false;
				}
			}
	
			return true;
		}
	
		// On touch end, determine whether to send a click event at once.
		function onTouchEnd(event) {
			var targetElement, clickEvent;
	
			// If the touch was cancelled (eg due to movement), 
      // or if the page has scrolled in the meantime, return.
			if ( !trackingClick || 
           Math.abs(window.pageYOffset - clickStart.scroll) > 5) {
				return true;
			}
	
			// Derive the element to click as a result of the touch.
			targetElement = document.elementFromPoint(clickStart.x, clickStart.y);
	
			//If the targeted node is a text node, target the parent instead.
			if (targetElement.nodeType === Node.TEXT_NODE) {
				targetElement = targetElement.parentNode;
			}
	
			// Unless the element is marked as only 
      // requiring a non-programmatic click, synthesise a click
			// event, with an extra attribute so it can be tracked.
			if ( !(targetElement.className.indexOf('clickevent') !== -1 
           && 
          targetElement.className.indexOf('touchandclickevent') === -1)) {
				clickEvent = document.createEvent('MouseEvents');
				clickEvent.initMouseEvent('click', true, true, window, 1, 0, 0, 
                                  clickStart.x, clickStart.y, false, 
                                  false, false, false, 0, null);
				clickEvent.forwardedTouchEvent = true;
				targetElement.dispatchEvent(clickEvent);
			}
	
			// Prevent the actual click from going though - unless the 
      // target node is marked as requiring real clicks or if 
      // it is a SELECT, in which case only non-programmatic 
      // clicks are permitted to open the options list and 
      // so the original event is required.
			if (!(targetElement instanceof HTMLSelectElement) &&
				targetElement.className.indexOf('clickevent') === -1) {
				event.preventDefault();
			} else {
				return false;
			}
		}

		function onTouchCancel(event) {
			trackingClick = false;
		}
	
		// On actual clicks, determine whether this is a 
    // touch-generated click, a click action occurring 
		// naturally after a delay after a touch (which needs 
    // to be cancelled to avoid duplication), or
		// an actual click which should be permitted.
		function onClick(event) {
			if (!window.event) {
				return true;
			}
	
			var allowClick = true;
			var targetElement;
			var forwardedTouchEvent = window.event.forwardedTouchEvent;
	
			// For devices with touch support, derive and check 
      // the target element to see whether the
			// click needs to be permitted; unless explicitly enabled, 
      // prevent non-touch click events
			// from triggering actions, to prevent ghost/doubleclicks.
			if (touchSupport) {
				targetElement = document.elementFromPoint(clickStart.x, 
                                                  clickStart.y);
				if (!targetElement ||  
					(!forwardedTouchEvent && 
           targetElement.className.indexOf('clickevent') == -1)) {
					allowClick = false;
				}
			}

			// If clicks are permitted, 
      // return true for the action to go through.
			if (allowClick) {
				return true;
			}
	
			// Otherwise cancel the event
			event.stopPropagation();
			event.preventDefault();

			// Prevent any user-added listeners declared on 
      // FastClick element from being fired.
			event.stopImmediatePropagation();

			return false;
		}
	}

})();
