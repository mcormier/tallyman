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

    <!-- prints out a title in the form: "Updated 10 Jan 2013" -->
    <title><xsl:value-of 
                select="concat('Updated: ', 
                date:format-date(date:date-time(), 'd MMM yyyy') )"/>
    </title>

    <xsl:for-each select="str:tokenize($stylesheet,',')">
       <xsl:variable name ="filename" select="."/>
       <Link rel="stylesheet" type="text/css" href="css/{$filename}.css"></Link>
    </xsl:for-each> 

    <xsl:for-each select="str:tokenize($javascript,',')">
       <xsl:variable name ="filename" select="."/>
       <script src="js/{$filename}.js" type="text/javascript"></script>
    </xsl:for-each>

    <!-- This will be picked up by all IE browsers until version 10.
         Version 11 renders SVG tags okay.
    -->
    <xsl:comment><![CDATA[[if IE]>
      <meta http-equiv="refresh" content="0;url=html/ieNotSupported.html"/>
    <![endif]]]></xsl:comment>

  </head>
</xsl:template>

</xsl:stylesheet>
