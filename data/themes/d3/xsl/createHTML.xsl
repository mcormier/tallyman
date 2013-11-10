<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="head.xsl" />

<xsl:output method="html" indent="no"/>

<xsl:variable name="enableGraphs" select="/data/settings/enableGraphs" />

<xsl:template match="/">


  <!-- Specifies an HTML 5 document -->
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>

  <html manifest="cache.manifest">
    <xsl:call-template name="htmlHeader">
      <xsl:with-param name="stylesheet">style.css</xsl:with-param> 
      <xsl:with-param name="javascript">PPUtils,fastclick,main</xsl:with-param> 
    </xsl:call-template>

    <!--
       Applying an empty ontouchstart fixes iOS from ignoring 
       a:active style definitions.

       Reference: http://stackoverflow.com/questions/3885018/active-pseudo-class-doesnt-work-in-mobile-safari
    -->
    <body ontouchstart="">
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="data">

  <div class="imageloader"/>

  <div id="contentContainer" class="no-flick">

    <div class="wrapper assortedData fadeIn">

       <div id="left_col">
         <ul id="left_data">
           <!-- Odd item entries go in left column -->
           <xsl:for-each select="item[position() mod 2 = 1] ">
           <li class="display">
             <div class="big_display">
               <div class="center"><xsl:apply-templates/></div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
       </div>

       <div id="right_col">
         <ul id="right_data">
           <!-- Even item entries go in right column -->
           <xsl:for-each select="item[position() mod 2 = 0] ">
           <li class="display">
             <div class="big_display">
               <div class="center"><xsl:apply-templates/></div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
      </div>

    </div> <!-- end wrapper -->
  
    <div class="clear"/>
    <xsl:copy-of select="document('drawers.xml')/." />
    <div class="wrapper liftData fadeIn">
       <div id="lifts" ><xsl:apply-templates select="lifts"/></div>
    </div>

     <div class="clear"/>
   </div>

  <xsl:copy-of select="document('alertSheet.xml')/." />

  <div id="drawer-overlay"/>
  <div id="popover-overlay"/>

</xsl:template>

<xsl:template match="lifts">

  <xsl:variable name="leftArrow"><span class="mega-icon mega-icon-arr-left"/></xsl:variable>
  <xsl:variable name="rightArrow"><span class="mega-icon mega-icon-arr-right"/></xsl:variable>

  <xsl:for-each select="lift">
  <div class="1RM3RM5RM flip-container">
    <div class="divide-line"></div>

    <div  style="position:relative">
      <div class="liftName"><xsl:value-of select="name"/> </div>
      <xsl:if test="$enableGraphs='true'">
      <div class="toggler" onTouch="toggleFlip(this)" onClick="toggleFlip(this)" >
        <span class="mini-icon mini-icon-graph" ></span>  
      </div>
      </xsl:if>
    </div>


    <div class="flipper">

    <div class="front"> 


    <div class="liftValue 1RM">
      <p class="value"><xsl:value-of select="onerm"/></p>
      <p class="vertText">1RM</p>
      <xsl:if test="number(onerm) != 0">
      <!-- Estimate 3RM and 5RM to nearest 5 pounds -->
      <p class="estimates fadeIn">
        <span class="actual"><strong><xsl:value-of select="onerm"/></strong></span> 
        <xsl:copy-of select="$rightArrow"/>
        <xsl:value-of select="round(onerm * 0.9 div 5) * 5"/> 
        <xsl:copy-of select="$rightArrow"/>
        <xsl:value-of select="round(onerm * 0.86 div 5) * 5"/> 
      </p>
      <p class="volumeEstimate fadeIn">Volume: Warm up to and then do 
        <strong>6 sets of 3 reps at 
        <xsl:value-of select="round(onerm * 0.80 div 5) * 5"/></strong> with a 2 minute break in between each set.</p>

      <p class="oneToTenSpread fadeIn" >
        <span class="spreadValue"><strong><xsl:value-of select="onerm"/></strong><sup>1</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.95 div 5) * 5"/><sup>2</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.90 div 5) * 5"/><sup>3</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.88 div 5) * 5"/><sup>4</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.86 div 5) * 5"/><sup>5</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.83 div 5) * 5"/><sup>6</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.80 div 5) * 5"/><sup>7</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.78 div 5) * 5"/><sup>8</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.76 div 5) * 5"/><sup>9</sup></span>
        <span class="spreadValue"><xsl:value-of select="round(onerm * 0.75 div 5) * 5"/><sup>10</sup></span>
      </p>

      </xsl:if>
    </div>

    <div class="liftValue 3RM">
      <p class="value"><xsl:value-of select="threerm"/></p>
      <p class="vertText">3RM</p>
      <xsl:if test="number(threerm) != 0">
              <p class="estimates fadeIn">
                <!-- Estimate 1RM and 5RM to nearest 5 pounds -->
                <xsl:value-of select="round(threerm div 0.9 div 5) * 5"/> 
                <xsl:copy-of select="$leftArrow"/>
                <span class="actual"><strong><xsl:value-of select="threerm"/></strong></span> 
                <xsl:copy-of select="$rightArrow"/>
                <xsl:value-of select="round(threerm div 0.9 * 0.86 div 5) * 5"/> 
              </p>
            </xsl:if>
          </div>
          <div class="liftValue 5RM">
            <p class="value">
              <xsl:value-of select="fiverm"/>
            </p>
            <p class="vertText">5RM</p>

            <xsl:if test="number(fiverm) != 0">
              <p class="estimates fadeIn">
                <!-- Estimate 1RM and 3RM to nearest 5 pounds -->
                <xsl:value-of select="round(fiverm div 0.86 div 5) * 5"/>
                <xsl:copy-of select="$leftArrow"/>
                <xsl:value-of select="round(fiverm div 0.86 * 0.9 div 5) * 5"/>
                <xsl:copy-of select="$leftArrow"/>
                <span class="actual">
                  <strong><xsl:value-of select="fiverm"/></strong>
                </span>
              </p>
            </xsl:if>
 

          </div>

       </div>

      <xsl:if test="$enableGraphs='true'">
       <div class="back">
          <div class="repLegend"> 
            <div class="repLabel">1RM</div> 
            <div class="repLabel">3RM</div> 
            <div class="repLabel">5RM</div> 
          </div>

          <iframe width="250" height="260">
            <xsl:attribute name="src">svg/<xsl:value-of select="svgname"/>1RM.svg</xsl:attribute>
          </iframe>
          <iframe width="250" height="260">
            <xsl:attribute name="src">svg/<xsl:value-of select="svgname"/>3RM.svg</xsl:attribute>
          </iframe>
          <iframe width="250" height="260">
            <xsl:attribute name="src">svg/<xsl:value-of select="svgname"/>5RM.svg</xsl:attribute>
          </iframe>

       </div>
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
   <div class="divide-line"></div>
   <h2><span><xsl:apply-templates/></span></h2>
 </xsl:template>


</xsl:stylesheet>
