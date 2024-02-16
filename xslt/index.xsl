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
                            <h1 class="text-center display-1 pt-5">Das erste Wiener Merkantilprotokoll</h1>
                            <h2 class="text-center display-4">Digitale Edition</h2>
                            <div class="p-5">
                                <p>Das vom <a href="https://www.fwf.ac.at/forschungsradar/10.55776/P33980">FWF</a> geförderte Projekt "Prosopographie der Wiener Kaufmannschaft (1725–1758)" erschließt den ersten Band des Wiener Merkantilprotokolls (Wiener Stadt- und Landesarchiv, Bestand 2.3.2 – Merkantil- und Wechselgericht B6.1). Dieser Vorläufer des Handelsregisters (Firmenbuch) und enthält ein vollständiges Verzeichnis der Kaufleute bzw. Handelsunternehmen für den Zeitraum von 1725 bis 1758.</p>
                                <p>
                                    In dem von Peter Rauscher (Universität Wien) geleiteten Projekt werden die im Merkantilprotokoll genannten Personen und Firmen in die Datenbank des Projekts <a href="https://donauhandel.univie.ac.at/">Der Donauhandel</a> integriert und eine digitale Edition dieser wichtigen Quelle für die Wirtschaftsgeschichte Wiens erstellt.
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