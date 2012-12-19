<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" indent="yes"/>

 <xsl:template match="data">
   <html>
     <head>
       <title></title>
       <Link rel="stylesheet" type="text/css" href="css/style.css" title="stylin"></Link>
       <script src="js/PPUtils.js" type="text/javascript"></script>
       <script src="js/main.js" type="text/javascript"></script>
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

     <xsl:variable name="leftArrow"><span class="arrow"> &#8592; </span></xsl:variable>
     <xsl:variable name="rightArrow"><span class="arrow"> &#8594; </span></xsl:variable>

     <xsl:for-each select="lift">
        <div>
          <div class="divide_line"></div>
          <div class="liftName"><xsl:value-of select="name"/> </div>

          <div class="liftValue">
            <p class="value">
              <xsl:value-of select="onerm"/> 
            </p>
            <p class="vertText">1RM</p>
            <xsl:if test="number(onerm) != 0">
              <!-- Estimate 3RM and 5RM to nearest 5 pounds -->
              <p class="estimates">
                <span class="actual">
                  <xsl:value-of select="onerm"/>
                </span> 
                <xsl:copy-of select="$rightArrow"/>
                <xsl:value-of select="round(onerm * 0.9 div 5) * 5"/> 
                <xsl:copy-of select="$rightArrow"/>
                <xsl:value-of select="round(onerm * 0.86 div 5) * 5"/> 
              </p>
            </xsl:if>
          </div>

          <div class="liftValue">
            <p class="value">
              <xsl:value-of select="threerm"/>
            </p>
            <p class="vertText">3RM</p>
            <xsl:if test="number(threerm) != 0">
              <p class="estimates">
                <!-- Estimate 1RM and 5RM to nearest 5 pounds -->
                <xsl:value-of select="round(threerm div 0.9 div 5) * 5"/> 
                <xsl:copy-of select="$leftArrow"/>
                <span class="actual">
                  <xsl:value-of select="threerm"/>
                </span> 
                <xsl:copy-of select="$rightArrow"/>
                <xsl:value-of select="round(threerm div 0.9 * 0.86 div 5) * 5"/> 
              </p>
            </xsl:if>
          </div>
          <div class="liftValue">
            <p class="value">
              <xsl:value-of select="fiverm"/>
            </p>
            <p class="vertText">5RM</p>

            <xsl:if test="number(fiverm) != 0">
              <p class="estimates">
                <!-- Estimate 1RM and 3RM to nearest 5 pounds -->
                <xsl:value-of select="round(fiverm div 0.86 div 5) * 5"/>
                <xsl:copy-of select="$leftArrow"/>
                <xsl:value-of select="round(fiverm div 0.86 * 0.9 div 5) * 5"/>
                <xsl:copy-of select="$leftArrow"/>
                <span class="actual">
                  <xsl:value-of select="fiverm"/>
                </span>
              </p>
            </xsl:if>
 

          </div>
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
