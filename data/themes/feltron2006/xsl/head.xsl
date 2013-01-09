<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings" 
                extension-element-prefixes="str date"
>

<xsl:template name="htmlHeader">
  <xsl:param name="stylesheet"/>
  <xsl:param name="javascript"/>

  <head>
    <title><xsl:value-of 
                select="concat('Updated: ', 
                date:format-date(date:date-time(), 'd MMM yyyy') )"/>
    </title>
    <Link rel="stylesheet" type="text/css" href="{$stylesheet}"></Link>


    <xsl:variable name="vDoc" select="/"/>
    <xsl:for-each select="str:tokenize($javascript,',')">
       <xsl:variable name ="filename" select="."/>
       <script src="{$filename}" type="text/javascript"></script>
    </xsl:for-each> 

  </head>
</xsl:template>

</xsl:stylesheet>
