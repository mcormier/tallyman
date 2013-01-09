<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- TODO use parameters for css and javascript -->
<xsl:template name="htmlHeader">
  <head>
    <title><xsl:value-of select="date:date-time()"/></title>
    <Link rel="stylesheet" type="text/css" href="css/style.css"></Link>
    <script src="js/PPUtils.js" type="text/javascript"></script>
    <script src="js/main.js" type="text/javascript"></script>
  </head>
</xsl:template>

</xsl:stylesheet>
