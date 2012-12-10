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
     <table>
     <tr><th>Lift</th><th>1RM</th><th>3RM</th><th>5RM</th></tr>
     <tfoot><th>Lift</th><th>1RM</th><th>3RM</th><th>5RM</th></tfoot>
     <xsl:for-each select="lift">
       <tr>
         <xsl:if test="position() mod 2 = 0">
           <xsl:attribute name="class">even</xsl:attribute>
         </xsl:if>
         <xsl:if test="position() mod 2 = 1">
           <xsl:attribute name="class">odd</xsl:attribute>
         </xsl:if>
        <td><xsl:value-of select="name"/></td>
        <td><xsl:value-of select="onerm"/></td>
        <td><xsl:value-of select="threerm"/></td>
        <td><xsl:value-of select="fiverm"/></td>
       </tr> 
     </xsl:for-each>
     </table>
 </xsl:template>

 <xsl:template match="value">
   <div class="value"><span><xsl:apply-templates/></span></div>
 </xsl:template>

 <xsl:template match="title">
   <h2><span><xsl:apply-templates/></span></h2>
   <div class="divide_line"></div>
 </xsl:template>


</xsl:stylesheet>
