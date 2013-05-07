#  FastClick: Set up handling of fast clicks #

On touch WebKit (eg Android, iPhone) onclick events are usually delayed by ~300ms to ensure that they are clicks rather than other interactions such as double-tap to zoom.
 
To work around this, add a document listener which converts touches to clicks on a global basis, excluding scrolls and gestures.  The default click events are then cancelled to prevent double-clicks.

This function automatically adapts if no action is required (eg if touch events are not supported), and also handles functionality such as preventing actions in the page while the section selector is displaying.

One alternative is to use ontouchend events for everything, but that prevents non-touch interaction, and requires checks everywhere to ensure that a touch wasn't a scroll/swipe/etc.

# License #

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The below copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

MIT License (http://www.opensource.org/licenses/mit-license.php)

# Modifications #

This version of fastclick has been modified to rely on convenience methods defined in PPUtils.js

# Authors #
- Rowan Beentje <rowan@assanka.net> 
- Matt Caruana Galizia <matt@assanka.net>
- Mathieu Cormier <mcormier@preenandprune.com>

