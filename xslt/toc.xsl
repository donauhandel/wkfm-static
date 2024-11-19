<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="xsl tei xs local">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="partials/html_navbar.xsl"/>
    <xsl:import href="partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>


    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Inhaltsverzeichnis'"/>


    
        <html class="h-100" lang="de">
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
            <xsl:call-template name="nav_bar"/>
                <main>
                    <div class="container pt-5 pb-5">
                        <h1 class="text-center display-3 pb-3">Inhaltsverzeichnis</h1>
                        <table class="table" id="myTable">
                            <thead>
                                <tr>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input" tabulator-minWidth="350">Titel</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input"  tabulator-minWidth="350">erwähnte Personen</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input">Anzahl erwähnter Personen</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input"  tabulator-minWidth="350">erwähnte Firmen</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input">Anzahl erwähnter Firmen</th>
                                </tr>
                            </thead>
                            <tbody>
                                <xsl:for-each
                                    select="collection('../data/editions?select=*.xml')//tei:TEI">
                                    <xsl:sort select="document-uri(/)"/>
                                    <xsl:variable name="full_path">
                                        <xsl:value-of select="document-uri(/)"/>
                                    </xsl:variable>
                                    <tr>
                                        <td>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:value-of
                                                        select="replace(tokenize($full_path, '/')[last()], '.xml', '.html')"
                                                    />
                                                </xsl:attribute>
                                            <xsl:value-of
                                                select=".//tei:titleStmt/tei:title[1]/text()"/>
                                            </a>
                                        </td>
                                        <td>
                                            <ul>
                                            <xsl:for-each select=".//tei:back/tei:listPerson//tei:person">
                                                <li>
                                                    <a href="{./@xml:id||'.html'}">
                                                        <xsl:value-of select="./tei:persName[1]/tei:surname[1]/text()"/>, <xsl:value-of select="./tei:persName[1]/tei:forename[1]/text()"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:back/tei:listPerson//tei:person)"/>
                                        </td>
                                        <td>
                                            <ul>
                                                <xsl:for-each select=".//tei:back/tei:listOrg//tei:org">
                                                    <li>
                                                        <a href="{./@xml:id||'.html'}">
                                                            <xsl:value-of select="./tei:orgName[1]/text()"/>
                                                        </a>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:back/tei:listOrg//tei:org)"/>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </tbody>
                        </table>
                        <xsl:call-template name="tabulator_dl_buttons"/>
                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <link href="https://unpkg.com/tabulator-tables@5.5.2/dist/css/tabulator.min.css" rel="stylesheet"></link>
                <link href="https://unpkg.com/tabulator-tables@5.5.0/dist/css/tabulator_bootstrap5.min.css" rel="stylesheet"></link>
                <script type="text/javascript" src="https://unpkg.com/tabulator-tables@5.5.2/dist/js/tabulator.min.js"></script>
                <script src="tabulator-js/config.js"></script>
                <script>
                    var table = new Tabulator("#myTable", config);
                    //trigger download of data.csv file
                    document.getElementById("download-csv").addEventListener("click", function(){
                    table.download("csv", "data.csv");
                    });
                    
                    //trigger download of data.json file
                    document.getElementById("download-json").addEventListener("click", function(){
                    table.download("json", "data.json");
                    });
                    
                    //trigger download of data.html file
                    document.getElementById("download-html").addEventListener("click", function(){
                    table.download("html", "data.html", {style:true});
                    });
                </script>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>