<xsl:stylesheet version="1.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="head.xsl" />

<xsl:output method="html" indent="yes"/>

<xsl:template match="/">

  <!-- Specifies an HTML 5 document -->
  <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html></xsl:text>

  <html>
    <xsl:call-template name="htmlHeader">
      <xsl:with-param name="stylesheet">PPControl,style,zoom</xsl:with-param>
      <xsl:with-param name="javascript">d3.v3.min,PPControl,PPGraph,main,setupGraphs</xsl:with-param>
    </xsl:call-template>

    <body>
      <xsl:apply-templates/>
    </body>
  </html>
</xsl:template>

<xsl:template match="data">

 
  <div id="contentContainer" class="section present">

    <div class="wrapper assortedData">

       <div id="left_col">
         <ul id="left_data">
           <!-- Odd item entries go in left column -->
           <xsl:for-each select="item[position() mod 3 = 1] ">
           <li class="display">
             <div class="big_display">
               <div class="center"><xsl:apply-templates/></div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
       </div>

       <div id="middle_col">
         <ul id="middle_data">
           <!-- Even item entries go in right column -->
           <xsl:for-each select="item[position() mod 3 = 2] ">
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
           <xsl:for-each select="item[position() mod 3 = 0] ">
           <li class="display">
             <div class="big_display">
               <div class="center"><xsl:apply-templates/></div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
      </div>


    </div> <!-- end wrapper -->
  

    <div class="wrapper assortedData">

       <div id="col_one_lifts">
         <ul id="col_one_data_lifts">
           <xsl:for-each select="lifts/lift[position() mod 4 = 1] ">
             <xsl:variable name ="liftName" select="svgname"/>

           <li class="display">
             <div class="lift_display">
               <div class="center">
                 <div class="divide-line"></div>
                 <h2><span> <xsl:value-of select="name"/></span> </h2>

                 <div class="value"><span><xsl:value-of select="onerm"/></span></div>
                 <detail next_section="{$liftName}Detail"> 
                    <span class="mega-icon mega-icon-eye"></span>
                 </detail>
               </div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
       </div>

       <div id="col_two_lifts">
         <ul id="col_two_data_lifts">
           <xsl:for-each select="lifts/lift[position() mod 4 = 2] ">
             <xsl:variable name ="liftName" select="svgname"/>
           <li class="display">
             <div class="lift_display">
               <div class="center">
                 <div class="divide-line"></div>
                 <h2><span> <xsl:value-of select="name"/></span></h2>
                 <div class="value"><span><xsl:value-of select="onerm"/></span></div>
                 <detail next_section="{$liftName}Detail"> 
                 <span class="mega-icon mega-icon-eye"></span>
                 </detail>
               </div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
      </div>

       <div id="col__three_lifts">
         <ul id="col_three_data_lifts">
           <xsl:for-each select="lifts/lift[position() mod 4 = 3] ">
             <xsl:variable name ="liftName" select="svgname"/>
           <li class="display">
             <div class="lift_display">
               <div class="center">
                 <div class="divide-line"></div>
                 <h2><span> <xsl:value-of select="name"/></span></h2>
                 <div class="value"><span><xsl:value-of select="onerm"/></span></div>
                 <detail next_section="{$liftName}Detail"> 
                 <span class="mega-icon mega-icon-eye"></span>
                 </detail>
               </div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
      </div>



       <div id="col_four_lifts">
         <ul id="col_four_data_lifts">
           <xsl:for-each select="lifts/lift[position() mod 4 = 0] ">
             <xsl:variable name ="liftName" select="svgname"/>
           <li class="display">
             <div class="lift_display">
               <div class="center">
                 <div class="divide-line"></div>
                 <h2><span> <xsl:value-of select="name"/></span></h2>
                 <div class="value"><span><xsl:value-of select="onerm"/></span></div>
                 <detail next_section="{$liftName}Detail"> 
                 <span class="mega-icon mega-icon-eye"></span>
                 </detail>
               </div>
             </div>
           </li>
           </xsl:for-each>
         </ul>
      </div>

    </div> <!-- end wrapper -->
 


   </div> 

<!-- end contentContainer -->


   <xsl:for-each select="lifts/lift">

     <xsl:variable name="leftArrow"><span class="mega-icon mega-icon-arr-left"/></xsl:variable>
     <xsl:variable name="rightArrow"><span class="mega-icon mega-icon-arr-right"/></xsl:variable>
     <xsl:variable name ="liftName" select="svgname"/>

     <div id="{$liftName}Detail" class="section future liftDetail">
 

       <a onclick="zoomer.goBackInTime();return false" class="back">
         <span class="mega-icon mega-icon-chevron"/>
       </a>

       <div class="liftDetailInner">

         <div  style="position:relative">
           <div class="liftName"><xsl:value-of select="name"/> </div>
         </div>

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
           <p class="value"><xsl:value-of select="fiverm"/></p>
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



         <div id="d3Graph{$liftName}" class="liftGraph" />
       </div>

     </div> <!-- liftDetail -->

   </xsl:for-each>

</xsl:template>





 <xsl:template match="value">
   <div class="value"><span><xsl:apply-templates/></span></div>
 </xsl:template>

 <xsl:template match="svgname">
   <xsl:variable name ="idRoot" select="."/>
   <div id="{$idRoot}Graph" class="Graph" />
 </xsl:template>


 <xsl:template match="title">
   <div class="divide-line"></div>
   <h2><span><xsl:apply-templates/></span></h2>
 </xsl:template>


</xsl:stylesheet>
