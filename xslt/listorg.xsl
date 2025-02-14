<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>
    <xsl:import href="partials/org.xsl"/> 
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
                                    <p>Bei den hier gelisteten Firmen handelt es sich um alle identifizierten und nicht identifizierten Firmen/Handelshäuser/Kompanien, die im Merkantilprotokoll erwähnt
                                        werden. Die Spalte
                                        <strong>Beteiligte</strong> gibt Auskunft darüber, ob und
                                        wie viele <a href="listperson.html"
                                            title="Link zum Personenregister">Personen</a> zur jeweiligen
                                        Firma in Beziehung stehen.</p>
                                </div>
                                <div class="col-2"/>
                            </div>
                            <div class="text-center p-1">
                                <span id="counter1"/> von <span id="counter2"/>
                                Firmen
                            </div>
                            <table class="table" id="myTable">
                                <thead>
                                    <tr>
                                        <th scope="col" width="20" tabulator-headerSort="false" tabulator-download="false" tabulator-visible="false">itemId</th>
                                        <th scope="col" tabulator-formatter="html" tabulator-download="false" tabulator-headerFilter="input" tabulator-minWidth="250">Name</th>
                                        <th scope="col" tabulator-visible="false" tabulator-download="true"
                                            >Nachname_</th>
                                        <th scope="col" tabulator-headerFilter="input">Erwähnungen</th>
                                        <th scope="col" tabulator-headerFilter="input">Beteiligte</th>
                                        <th scope="col" tabulator-headerFilter="input">ID</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <xsl:for-each select=".//tei:org[./tei:noteGrp]">
                                        <xsl:variable name="id">
                                            <xsl:value-of select="data(@xml:id)"/>
                                        </xsl:variable>
                                        <tr>
                                            <td>
                                                <xsl:value-of select="concat($id, '.html')"/>
                                            </td>
                                            <td>
                                                <a href="{$id || '.html'}">
                                                    <xsl:value-of select=".//tei:orgName[1]/text()"/>
                                                </a>
                                            </td>
                                            <td>
                                                <xsl:value-of select=".//tei:orgName[1]/text()"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="count(.//tei:note[@type='mentions'])"/>
                                            </td>
                                            <td>
                                                <xsl:value-of select="count(.//tei:person)"/>
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
        <xsl:for-each select=".//tei:org">
            <xsl:variable name="filename" select="concat(./@xml:id, '.html')"/>
            <xsl:variable name="name" select="normalize-space(string-join(./tei:orgName[1]//text()))"></xsl:variable>
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
                                        <a href="listorg.html"><xsl:value-of select="$doc_title"/></a>
                                    </li>
                                </ol>
                            </nav>
                            <div class="container pt-5 pb-5">
                                <h1 class="text-center display-3 pb-3">
                                    <xsl:value-of select="$name"/>
                                </h1>
                                <xsl:call-template name="org_detail"/>  
                            </div>
                        </main>
                        <xsl:call-template name="html_footer"/>
                    </body>
                </html>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>