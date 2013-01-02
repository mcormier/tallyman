<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" indent="yes"/>

<xsl:template match="data">

  <html>
     <head>
       <title>-</title>
       <Link rel="stylesheet" type="text/css" href="css/style.css" title="stylin"></Link>
       <script src="js/PPUtils.js" type="text/javascript"></script>
       <script src="js/main.js" type="text/javascript"></script>
     </head>

<body>

  <div id="shortcuts">

    <div class="featureRow">
      <div id="shortcutsToggle">
        <a href="#shortcutsInfo" id="showShortcuts">Keyboard shortcuts <span class="mega-icon mega-icon-keyboard drawer-toggle"></span></a>
      </div>
    </div>

    <div id="shortcutsDrawer" class="fullWidthWrapper shadow drawer">
      <div id="shortcutsContent">
        <h2>Keyboard Shortcuts</h2>
        <div class="divide_line"></div>
        <div class="columns threecols">
          <div class="column first">
            <h3>Lift shortcuts</h3>
            <dl class="keyboard-mappings">
              <dt>e</dt>
              <dd>Toggle estimates</dd>
            </dl>
            <dl class="keyboard-mappings">
              <dt>v</dt>
              <dd>Toggle volume recommendations</dd>
            </dl>
            <dl class="keyboard-mappings">
              <dt>s</dt>
              <dd>Toggle 1RM to 10RM spread</dd>
            </dl>
          </div>
        </div>
      </div>
    </div>

  </div> <!-- end shortcuts -->

  <div class="wrapper">

     <div id="left_col">
       <ul id="left_data">

     <!-- Odd item entries go in left column -->

     <xsl:for-each select="item[position() mod 2 = 1] ">
       <li class="display">
         <div class="big_display">
           <div class="center">
             <xsl:apply-templates/>
           </div>
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
           <div class="center">
             <xsl:apply-templates/>
           </div>
         </div>
       </li>
     </xsl:for-each>
     </ul></div>

    </div> <!-- end wrapper -->
    <div class="clear"></div>

<div id="macro">

  <div class="featureRow">
  <div id="macroShowDiv">
    <a href="#macroInfo" id="macroShow">
       <span class="mega-icon mega-icon-history lift-shortcuts"></span> Annual Workout  Data ...</a>
  </div>
  </div>

  <div id="macroHistoryDrawer" class="fullWidthWrapper shadow drawer">
   <div id="macroHistoryContent"></div>
  </div>
</div>


<div class="wrapper">
     <!-- name, onerm, threerm, fiverm -->

     <div id="lifts" >
        <xsl:apply-templates select="lifts"/>
     </div>

</div>

<div class="clear"></div>

     </body>
   </html>
</xsl:template>



<xsl:template match="lifts">

  <xsl:variable name="leftArrow"><span class="mega-icon mega-icon-arr-left"></span></xsl:variable>
  <xsl:variable name="rightArrow"><span class="mega-icon mega-icon-arr-right"></span></xsl:variable>

  <xsl:for-each select="lift">
  <div>
    <div class="divide_line"></div>
    <div class="liftName"><xsl:value-of select="name"/> </div>

    <div class="liftValue">
      <p class="value"><xsl:value-of select="onerm"/></p>
      <p class="vertText">1RM</p>
      <xsl:if test="number(onerm) != 0">
      <!-- Estimate 3RM and 5RM to nearest 5 pounds -->
      <p class="estimates fadeIn">
        <span class="actual"><xsl:value-of select="onerm"/></span> 
        <xsl:copy-of select="$rightArrow"/>
        <xsl:value-of select="round(onerm * 0.9 div 5) * 5"/> 
        <xsl:copy-of select="$rightArrow"/>
        <xsl:value-of select="round(onerm * 0.86 div 5) * 5"/> 
      </p>
      <p class="volumeEstimate fadeIn">Recommended volume training: 
        <strong>6 sets of 5 reps at 
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

    <div class="liftValue">
      <p class="value"><xsl:value-of select="threerm"/></p>
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
