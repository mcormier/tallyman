
**xsltproc** does not support XSLT 2.0. Actually there is quite a lack of free XSLT 2.0 tools, most of them are commercial.

# /date #

EXSLT - Dates and Times 

This extension library was initially added so that the function date:date-time() could be used as a substitute for the built-in 2.0 function current-dateTime()

### Changes ###
1. The version downloaded was modified slightly. It contained spaces
in the namespace definition, which may be a build bug.  So **xmlns:date="http://exslt.org/dates and times"** was changed to **xmlns:date="http://exslt.org/dates-and-times"**

2. The format-date() function depend on a couple of xsl files from the EXSTL Strings package.  They have been copied into the directory functions/format-date/ instead of including two libraries.

# References #
- http://stackoverflow.com/questions/1575111/can-an-xslt-insert-the-current-date
- http://www.exslt.org/date/index.html
- http://www.exslt.org/str/index.html
