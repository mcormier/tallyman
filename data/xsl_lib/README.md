
**xsltproc** does not support XSLT 2.0. Actually there is quite a lack of free XSLT 2.0 tools, most of them are commercial.

These libraries from EXSLT help bridge the xsl 1.0 to 2.0 gap. These libraries were downloaded and modifed slightly as their are some small errors in the libraries. (i.e. case sensitive namespace definition mistakes that probably won't occur in Windows but will under Unix)

# /str - EXSLT - STRINGS #

Downloaded from: http://www.exslt.org/str/index.html

Added so that a string of the form "param1,param2" could be passed to a parameter and iterated through as an array.

### Changes ###

1. A namespace was defined incorrectly as **xmlns:str="http://exslt.org/Strings"** instead of **xmlns:str="http://exslt.org/strings"** for the file **str/str.xsl**

# /date - EXSLT - Dates and Times #

Downloaded from: http://www.exslt.org/date/index.html

This extension library was initially added so that the function date:date-time() could be used as a substitute for the built-in 2.0 function current-dateTime()

### Changes ###
1. The version downloaded was modified slightly. It contained spaces
in the namespace definition, which may be a build bug.  So **xmlns:date="http://exslt.org/dates and times"** was changed to **xmlns:date="http://exslt.org/dates-and-times"**

2. The **format-date()** function depends on a couple of xsl files from **str** package. **date.format-date.function.xsl** depends on **str.padding.function.xsl** and **date.format-date.template.xsl** depends on **str.padding.template.xsl**. Inconsistently, format-date.function expected it's dependency in it's directory while format-date.template referenced ../../../str/functions/padding.  format-date.function has been changed to reference the str function also. 

# References #
- http://stackoverflow.com/questions/1575111/can-an-xslt-insert-the-current-date
- http://www.exslt.org/date/index.html
- http://www.exslt.org/str/index.html
