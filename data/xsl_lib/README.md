
**xsltproc** does not support XSLT 2.0. Actually there is quite a lack of free XSLT 2.0 tools, most of them are commercial.

# /date #

EXSLT - Dates and Times 

This extension library was initially added so that the function date:date-time() could be used as a substitute for the built-in 2.0 function current-dateTime()

### Notes ###
The version downloaded was modified slightly. It contained spaces
in the namespace definition, which may be a build bug.  So

xmlns:date="http://exslt.org/dates and times"

was changed to 

xmlns:date="http://exslt.org/dates-and-times"

# References #
- http://stackoverflow.com/questions/1575111/can-an-xslt-insert-the-current-date
- http://www.exslt.org/date/index.html
