<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/entities.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>
    <xsl:variable name="facs-url">
        <xsl:value-of select="data(.//tei:pb[1]/@corresp)"/>
    </xsl:variable>

    <xsl:template match="/">

    
        <html class="h-100">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
                
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/openseadragon.min.js"/>
            </head>
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container pt-5 pb-5">

                        <div class="row">
                            <div class="col-md-2 col-lg-2 col-sm-12">
                                <xsl:if test="ends-with($prev,'.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$prev"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-left" title="zurück"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                            <div class="col-md-8 col-lg-8 col-sm-12">
                                <h1 class="text-center display-5">
                                    <xsl:value-of select="$doc_title"/>
                                </h1>
                                <h3 align="center">
                                    <a href="{$teiSource}">
                                        <i class="bi bi-download" title="TEI/XML"/>
                                    </a>
                                </h3>
                            </div>
                            <div class="col-md-2 col-lg-2 col-sm-12" style="text-align:right">
                                <xsl:if test="ends-with($next, '.html')">
                                    <h1>
                                        <a>
                                            <xsl:attribute name="href">
                                                <xsl:value-of select="$next"/>
                                            </xsl:attribute>
                                            <i class="bi bi-chevron-right" title="weiter"/>
                                        </a>
                                    </h1>
                                </xsl:if>
                            </div>
                        </div>
                        
                        <div class="row pt-5">
                            <div class="col-md">
                                <div style="width: 100%; height: 800px" id="osd_viewer"/>
                                <figcaption class="figure-caption text-center">Wiener Stadt- und Landesarchiv (WStLA), Bestand 2.3.2 - Merkantil- und Wechselgericht | 1725-1850-(1863) CC BY-NC-ND 4.0 WStLA </figcaption>
                            </div>
                            <div class="col-md">
                                <div class="transcript pb-5">
                                    <xsl:apply-templates select=".//tei:body"></xsl:apply-templates>
                                </div>
                                
                                <div class="footnotes pt-5">
                                    <xsl:for-each select=".//tei:body//tei:note[not(./tei:p)]">
                                        <div class="footnotes" id="{local:makeId(.)}">
                                            <xsl:element name="a">
                                                <xsl:attribute name="name">
                                                    <xsl:text>fn</xsl:text>
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </xsl:attribute>
                                                <a>
                                                    <xsl:attribute name="href">
                                                        <xsl:text>#fna_</xsl:text>
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </xsl:attribute>
                                                    <span style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                        <xsl:number level="any" format="1" count="tei:note"/>
                                                    </span>
                                                </a>
                                            </xsl:element>
                                            <xsl:apply-templates/>
                                        </div>
                                    </xsl:for-each>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer"/>                
                <script type="text/javascript">
                    var source = "<xsl:value-of select="concat($facs-url, '?format=iiif')"/>";
                    var viewer = OpenSeadragon({
                    id: "osd_viewer",
                    tileSources: {
                    type: 'image',
                    url: source
                    },
                    prefixUrl:"https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.1.0/images/",
                    });
                </script>
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="tei:hi[@style='superscript']">
        <sup><xsl:apply-templates/></sup>
    </xsl:template>
    
    <xsl:template match="tei:seg[starts-with(@type, 'orighead')]">
        <h4 style="text-align:center; padding-top:1em;"><xsl:apply-templates/></h4>
        <hr/>
    </xsl:template>
   
    
    <xsl:template match="tei:note">
        <xsl:for-each select=".">
            <xsl:variable name="runningNumber">
                <xsl:value-of select="position()"/>
            </xsl:variable>
            <a id="{'anchor_'||$runningNumber}" href="{'#note_'||$runningNumber}">
                <sup><xsl:value-of select="$runningNumber"/></sup>
            </a>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
