<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    

    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='"Wiener Merkantilprotokoll"'/>
        </xsl:variable>

    
        <html class="h-100">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="row p-2">
                        <div class="col">
                            <h1 class="text-center display-1 pt-5"><xsl:value-of select="$project_short_title"/></h1>
                            <h2 class="text-center display-4"><xsl:value-of select="$project_title"/></h2>
                            <div class="p-5">
                                <p>The FWF-funded project "Prosopographie der Wiener Kaufmannschaft 1725-1758" focuses on the systematic cataloguing of the first Viennese mercantile record (Wiener Stadt-und Landesarchiv, Bestand 2.3.2 - Merkantil- und Wechselgericht, 2.3.2.B6.1). This is a precursor to the commercial register and contains a complete list of merchants and their trading companies based in Vienna for the period from 1725 to 1758.</p>
                                <p>
                                    In the project led by Peter Rauscher (University of Vienna), the persons named in the mercantile record will be integrated into the database of the "Donauhandel" project and a digital edition of this important source for the economic history of Vienna and the Danube region will be produced. 
                                </p>
                                <div class="d-grid gap-2 pt-3">
                                    <a href="toc.html" class="btn btn-outline-secondary" type="button">Zum Protokoll</a>
                                    <a href="listperson.html" class="btn btn-outline-secondary" type="button">Zum Personenregister</a>
                                </div>
                            </div>
                        </div>
                        <div class="col">
                            <figure class="figure">
                                <img src="images/wstla__mkp.jpg" class="float-end img-fluid rounded"/>
                                <figcaption class="figure-caption text-end">Wiener Stadt- und Landesarchiv (WStLA), Bestand 2.3.2 - Merkantil- und Wechselgericht | 1725-1850-(1863) CC BY-NC-ND 4.0 WStLA</figcaption>
                            </figure>
                        </div>
                            
                    </div>
                        
                    
                </main>
                <xsl:call-template name="html_footer"/>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="tei:div//tei:head">
        <h2 id="{generate-id()}"><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p id="{generate-id()}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul id="{generate-id()}"><xsl:apply-templates/></ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li id="{generate-id()}"><xsl:apply-templates/></li>
    </xsl:template>
    <xsl:template match="tei:ref">
        <xsl:choose>
            <xsl:when test="starts-with(data(@target), 'http')">
                <a>
                    <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
                    <xsl:value-of select="."/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>