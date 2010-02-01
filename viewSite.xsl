<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>
    
   <xsl:include href="footer.xsl"/>
   <xsl:include href="headerback.xsl"/> 
   
   <!-- Local includes -->
   <xsl:include href="local/footer.xsl"/>
   <xsl:include href="local/headerback.xsl"/> 

 <!-- HEADER -->   
   <xsl:output method="xml" indent="yes"  doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" 
   doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
    <xsl:template match="/">
      <html>
       <head>
       <title><xsl:value-of select="cdash/title"/></title>
        <meta name="robots" content="noindex,nofollow" />
         <link rel="StyleSheet" type="text/css">
         <xsl:attribute name="href"><xsl:value-of select="cdash/cssfile"/></xsl:attribute>
         </link>   
       <xsl:comment><![CDATA[[if IE]>
       <script language="javascript" type="text/javascript" src="javascript/excanvas.js">
       </script>
       <![endif]]]></xsl:comment>
       <script language="javascript" type="text/javascript" src="javascript/jquery.js" charset="utf-8"></script> 
       <script language="javascript" type="text/javascript" src="javascript/jquery.flot.min.js" charset="utf-8"></script> 
       <script src="javascript/jquery.flot.selection.min.js" type="text/javascript" charset="utf-8"></script>
       <script language="javascript" type="text/javascript" src="javascript/jquery.flot.pie.js" charset="utf-8"></script>      
       </head>
       <body bgcolor="#ffffff">

<xsl:choose>         
<xsl:when test="/cdash/uselocaldirectory=1">
  <xsl:call-template name="headerback_local"/>
</xsl:when>
<xsl:otherwise>
  <xsl:call-template name="headerback"/>
</xsl:otherwise>
</xsl:choose>
     
<br/>

<!-- Site manager -->
<xsl:if test="cdash/user/sitemanager=1">
<a><xsl:attribute name="href">editSite.php?siteid=<xsl:value-of select="cdash/site/id"/></xsl:attribute>
<xsl:if test="cdash/user/siteclaimed=0">Are you maitaining this site? [claim this site]</xsl:if><xsl:if test="cdash/user/siteclaimed=1">[edit site description]</xsl:if></a>
<br/>
<br/>
</xsl:if>

<!-- Main -->         
<b>Processor Speed: </b><xsl:if test="string-length(cdash/site/processorclockfrequency)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processorclockfrequency"/><br/>   
<b>64 Bits: </b><xsl:if test="string-length(cdash/site/processoris64bits)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processoris64bits"/><br/>    
<b>Processor Vendor: </b><xsl:if test="string-length(cdash/site/processorvendor)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processorvendor"/><br/>    
<b>Processor Vendor ID: </b><xsl:if test="string-length(cdash/site/processorvendorid)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processorvendorid"/><br/>    
<b>Processor Family ID: </b><xsl:if test="string-length(cdash/site/processorfamilyid)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processorfamilyid"/><br/>    
<b>Processor Cache Size: </b><xsl:if test="string-length(cdash/site/processorcachesize)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/processorcachesize"/><br/>    
<b>Number of logical CPUs: </b><xsl:if test="string-length(cdash/site/numberlogicalcpus)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/numberlogicalcpus"/><br/>    
<b>Number of physical CPUs: </b><xsl:if test="string-length(cdash/site/numberphysicalcpus)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/numberphysicalcpus"/><br/>    
<b>Number of logical CPU per Physical CPUs: </b><xsl:if test="string-length(cdash/site/logicalprocessorsperphysical)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/logicalprocessorsperphysical"/><br/>   
<b>Total Virtual Memory: </b><xsl:if test="string-length(cdash/site/totalvirtualmemory)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/totalvirtualmemory"/><br/>    
<b>Total Physical Memory: </b><xsl:if test="string-length(cdash/site/totalphysicalmemory)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/totalphysicalmemory"/><br/>    
<b>Description: </b><xsl:if test="string-length(cdash/site/description)=0"> NA</xsl:if> <xsl:value-of select="cdash/site/description"/><br/>    
<br/>

<!-- Display the claimers -->
<xsl:if test="count(cdash/claimer)>0">
<b>Claimed by: </b>
<xsl:for-each select="cdash/claimer">
  <xsl:value-of select="firstname"/><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text><xsl:value-of select="lastname"/>
  <xsl:if test="email">
  <a>
  <xsl:attribute name="href">mailto:<xsl:value-of select="email"/></xsl:attribute>
  <img src="images/mail.png" border="0"/>
  </a>
  </xsl:if>
</xsl:for-each>
<br/><br/>
</xsl:if>

<!-- Display the map -->
<xsl:if test="string-length(cdash/site/ip)>0">  
  <b>IP address: </b><xsl:value-of select="cdash/site/ip"/><br/>
  <b>Map:</b><br/>
  <script type="text/javascript">
      <xsl:attribute name="src">http://maps.google.com/maps?file=api&amp;v=2&amp;key=<xsl:value-of select="cdash/dashboard/googlemapkey"/></xsl:attribute>
   </script>
    <xsl:text disable-output-escaping="yes">
    &lt;script type="text/javascript"&gt;
      // Creates a marker whose info window displays the letter corresponding
      // to the given index.
      function createMarker(point,title) 
        {     
        var marker = new GMarker(point);
        GEvent.addListener(marker, "click", function() 
          {
          marker.openInfoWindowHtml(title);
          });
        return marker;
      }

    function load() {
      if (GBrowserIsCompatible()) {
        var map = new GMap2(document.getElementById("map"));
    </xsl:text>
    <xsl:if test="string-length(cdash/site/latitude)>0">
        map.setCenter(new GLatLng(<xsl:value-of select="cdash/site/latitude"/>,<xsl:value-of select="cdash/site/longitude"/>),5);
        map.addControl(new GLargeMapControl());
        var point = new GLatLng(<xsl:value-of select="cdash/site/latitude"/>,<xsl:value-of select="cdash/site/longitude"/>);
        map.addOverlay(createMarker(point,'<xsl:value-of select="cdash/site/name"/>'));
    </xsl:if>
    <!-- if no geolocation found -->
    <xsl:if test="string-length(cdash/site/latitude)=0">
     map.setCenter(new GLatLng(0,0),1);
    </xsl:if>
    <xsl:text disable-output-escaping="yes">
      }
    }
    &lt;/script&gt;
    </xsl:text>
   <body onload="load()" onunload="GUnload()">
  <center><div id="map" style="width: 700px; height: 400px"></div></center>
  </body>
</xsl:if>
<br/>

<!-- Projects -->
<b>This site belongs to the following projects:</b><br/>
<xsl:for-each select="cdash/project">
<a>
<xsl:attribute name="href">index.php?project=<xsl:value-of select="name_encoded"/></xsl:attribute>
<xsl:value-of select="name"/>
</a>
(<xsl:value-of select="submittime"/>)<br/>
</xsl:for-each>
<br/>

<!-- Timing per project -->
<b>Time spent per project (computed from average data over one week):</b><br/><br/>

<center><div id="placeholder" style="width:850px;height:300px"></div></center>
<script id="source" language="javascript" type="text/javascript">
$(function () {
    $.plot($("#placeholder"), [
    
<xsl:for-each select="cdash/siteload/build">
 { label: "<xsl:value-of select="project"/> - <xsl:value-of select="name"/> (<xsl:value-of select="type"/>)",  data: <xsl:value-of select="time"/>},
</xsl:for-each>
 { label: "Non-CDash",  data: <xsl:value-of select="cdash/siteload/idle"/>}
  ], 
  {
   series: {
      pie: { 
        show: true,
        radius: 1,
        label: {
          show: true,
          radius: 3/4,
          formatter: function(label, series){
            return '<div style="font-size:8pt;text-align:center;padding:2px;color:white;">'+label+'<br/>'+Math.round(series.percent)+'%</div>';
          },
          background: { opacity: 0.5 }
        }
      }
    },
  })
});
</script>

<!-- FOOTER -->
<br/>

<xsl:choose>         
<xsl:when test="/cdash/uselocaldirectory=1">
  <xsl:call-template name="footer_local"/>
</xsl:when>
<xsl:otherwise>
  <xsl:call-template name="footer"/>
</xsl:otherwise>
</xsl:choose>

        </body>
      </html>
    </xsl:template>
</xsl:stylesheet>
