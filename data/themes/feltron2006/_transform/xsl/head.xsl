<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns:str="http://exslt.org/strings" 
                extension-element-prefixes="str date"
>
<xsl:import href="../../../../xsl_lib/date/date.xsl" />
<xsl:import href="../../../../xsl_lib/str/str.xsl" />

<xsl:template name="htmlHeader">
  <xsl:param name="stylesheet"/>
  <xsl:param name="javascript"/>

  <xsl:variable name="vDoc" select="/"/>

  <head>

    <!-- prevent user from scaling webpage in iPhone -->
    <meta name="viewport" id="viewport" 
          content="width=device-width,initial-scale=1.0,user-scalable=no"/>

    <!-- prints out a title in the form: "Updated 10 Jan 2013" -->
    <title><xsl:value-of 
                select="concat('Updated: ', 
                date:format-date(date:date-time(), 'd MMM yyyy') )"/>
    </title>

    <link rel="apple-touch-icon" href="/images/touch-icon-iphone.png" />
    <link rel="apple-touch-icon" sizes="72x72" href="/images/touch-icon-ipad.png" />
    <link rel="apple-touch-icon" sizes="114x114" href="/images/touch-icon-iphone-retina.png" />
    <link rel="apple-touch-icon" sizes="144x144" href="/images/touch-icon-ipad-retina.png" />

    <xsl:for-each select="str:tokenize($stylesheet,',')">
       <xsl:variable name ="filename" select="."/>
       <Link rel="stylesheet" type="text/css" href="css/{$filename}"></Link>
    </xsl:for-each> 


    <xsl:for-each select="str:tokenize($javascript,',')">
       <xsl:variable name ="filename" select="."/>
       <script src="js/{$filename}.js" type="text/javascript"></script>
    </xsl:for-each> 

  </head>
</xsl:template>

</xsl:stylesheet>
