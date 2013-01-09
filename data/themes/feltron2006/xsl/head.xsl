<xsl:stylesheet version="1.0" 
                xmlns:date="http://exslt.org/dates-and-times"
                extension-element-prefixes="date"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- TODO use parameters for and javascript -->
<xsl:template name="htmlHeader">
  <xsl:param name="stylesheet"/>

  <head>
    <title><xsl:value-of 
                select="concat('Updated: ', 
                date:format-date(date:date-time(), 'd MMM yyyy') )"/>
    </title>
    <Link rel="stylesheet" type="text/css" href="{$stylesheet}"></Link>
    <script src="js/PPUtils.js" type="text/javascript"></script>
    <script src="js/main.js" type="text/javascript"></script>
  </head>
</xsl:template>

</xsl:stylesheet>
