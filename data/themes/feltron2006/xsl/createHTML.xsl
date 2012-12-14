<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>

 <xsl:template match="data">
   <html>
     <head>
       <title></title>
       <Link rel="stylesheet" type="text/css" href="css/style.css" title="stylin"></Link>
     </head>
     <body>

     <div class="wrapper">

     <div id="left_col">
       <ul id="left_data">

     <!-- Odd item entries go in left column -->

     <xsl:for-each select="item[position() mod 2 = 1] ">
       <li class="display">
         <div class="big_display">
           <div class="top"></div> 
           <div class="center">
             <xsl:apply-templates/>
           </div>
           <div class="bottom"></div> 
         </div>
       </li>
     </xsl:for-each>
     </ul></div>

     <div id="right_col">
       <ul id="right_data">

     <!-- Even item entries go in right column -->

     <xsl:for-each select="item[position() mod 2 = 0] ">
       <li class="display">
         <div class="big_display">
           <div class="top"></div> 
           <div class="center">
             <xsl:apply-templates/>
           </div>
           <div class="bottom"></div> 
         </div>
       </li>
     </xsl:for-each>
     </ul></div>

     <!-- name, onerm, threerm, fiverm -->

     <div id="lifts" >
        <xsl:apply-templates select="lifts"/>
     </div>

     </div>

     </body>
   </html>
 </xsl:template>

 <xsl:template match="lifts">

     <xsl:for-each select="lift">
        <div>
          <div class="divide_line"></div>
          <div class="liftName"><xsl:value-of select="name"/> </div>
          <div class="liftValue"><p class="value"><xsl:value-of select="onerm"/></p><p class="vertText">1RM</p></div>
          <div class="liftValue"><p class="value"><xsl:value-of select="threerm"/></p><p class="vertText">3RM</p></div>
          <div class="liftValue"><p class="value"><xsl:value-of select="fiverm"/></p><p class="vertText">5RM</p></div>
        </div>
        <div class="clear"></div>
     </xsl:for-each>
 </xsl:template>


 <xsl:template match="value">
   <div class="value"><span><xsl:apply-templates/></span></div>
 </xsl:template>

 <xsl:template match="title">
   <div class="divide_line"></div>
   <h2><span><xsl:apply-templates/></span></h2>
 </xsl:template>


</xsl:stylesheet>
