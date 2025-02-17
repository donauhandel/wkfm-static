<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    

    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="partials/place.xsl"/>
    
    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
        </xsl:variable>
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
        <html  class="h-100">
            
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <main>
                    <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item">
                                <a href="index.html">Merkantilprotokoll</a>
                            </li>
                            <li class="breadcrumb-item active" aria-current="page"><xsl:value-of select="$doc_title"/></li>
                        </ol>
                    </nav>
                    <div class="container pt-5 pb-5">
                        <h1 class="text-center display-3 pb-3">
                            <xsl:value-of select="$doc_title"/>
                        </h1>
                        <div class="row">
                            <div class="col-2"/>
                            <div class="col-8">
                                <p>Bei den hier gelisteten Orten handelt es sich um Bezugsorte diverser Art der im Personenregister verzeichneter Orte. Anders als bei vergleichbaren Editionsprojekten stehen diese Orte aber in keinem direkten Bezug zu der hier präsentierten Quelle.</p>
                            </div>
                            <div class="col-2"/>
                        </div>
                        
                        
                        <div id="map"/>
                        <div class="text-center p-1">
                            <span id="counter1"/> von <span id="counter2"/>
                            Orte
                        </div>
                        <table class="table" id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-formatter="html"  tabulator-headerFilter="input" tabulator-minWidth="350" tabulator-download="false">Ortsname</th>
                                    <th scope="col" tabulator-visible="false">Ortsname_</th>
                                    <th scope="col" tabulator-headerFilter="input">Verbundene Personen</th>
                                    <th scope="col" tabulator-headerFilter="input">Lat</th>
                                    <th scope="col" tabulator-headerFilter="input">Long</th>
                                    <th scope="col" tabulator-headerFilter="input">ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each select=".//tei:place">
                                    <xsl:variable name="id">
                                        <xsl:value-of select="data(@xml:id)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of select="concat($id, '.html')"/>
                                                </xsl:attribute>
                                                <xsl:value-of select="./tei:placeName[1]/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <xsl:value-of select="./tei:placeName[1]/text()"/>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:note[@type='related'])"/>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location[1]/tei:geo[1]">
                                                    <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[1]"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:choose>
                                                <xsl:when test="./tei:location[1]/tei:geo[1]">
                                                    <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[last()]"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                        <td>
                                            <xsl:value-of select="$id"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <xsl:call-template name="tabulator_js"/>
            </body>
        </html>
        <xsl:for-each select=".//tei:place[@xml:id]">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:placeName[1]//text()))"></xsl:variable>
            <xsl:result-document href="{$filename}">
                <html  class="h-100">
                    <head>
                        <xsl:call-template name="html_head">
                            <xsl:with-param name="html_title" select="$name"></xsl:with-param>
                        </xsl:call-template>
                    </head>

                    <body class="d-flex flex-column h-100">
                        <xsl:call-template name="nav_bar"/>
                        <main>
                            <nav style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb" class="ps-5 p-3">
                                <ol class="breadcrumb">
                                    <li class="breadcrumb-item">
                                        <a href="index.html">Merkantilprotokoll</a>
                                    </li>
                                    <li class="breadcrumb-item">
                                        <a href="listplace.html"><xsl:value-of select="$doc_title"/></a>
                                    </li>
                                </ol>
                            </nav>
                            <div class="container pt-5 pb-5">
                                <h1 class="text-center display-3 pb-3">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:if test="./tei:location/tei:geo">
                                    <div id="map_detail"/>
                                </xsl:if>
                                <xsl:call-template name="place_detail"/>
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                        <xsl:if test="./tei:location/tei:geo">
                            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
                                integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
                                crossorigin=""/>
                            <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
                                integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
                                crossorigin=""></script>
                            <script>
                                var lat = <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[1]"/>;
                                var long = <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1]/text(), ' ')[last()]"/>;
                                $("#map_detail").css("height", "500px");
                                var map = L.map('map_detail').setView([Number(lat), Number(long)], 13);
                                L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
                                maxZoom: 19,
                                attribution: '&amp;copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
                                }).addTo(map);
                                var marker = L.marker([Number(lat), Number(long)]).addTo(map);
                            </script>
                        </xsl:if>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>