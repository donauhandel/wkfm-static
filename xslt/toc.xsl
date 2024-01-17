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


    
        <html class="h-100">
    
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
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input">Titel</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input">erwähnte Personen</th>
                                    <th scope="col" tabulator-formatter="html" tabulator-headerFilter="input">Anzahl erwähtner Personen</th>
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
                                            <xsl:for-each select=".//tei:back//tei:person">
                                                <li>
                                                    <a href="{./@xml:id||'.html'}">
                                                        <xsl:value-of select="./tei:persName[1]/tei:surname[1]/text()"/>, <xsl:value-of select="./tei:persName[1]/tei:forename[1]/text()"/>
                                                    </a>
                                                </li>
                                            </xsl:for-each>
                                            </ul>
                                        </td>
                                        <td>
                                            <xsl:value-of select="count(.//tei:back//tei:person)"/>
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
    </xsl:template>
</xsl:stylesheet>