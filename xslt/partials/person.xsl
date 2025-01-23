<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:template match="tei:person" name="person_detail">
        <xsl:variable name="entId" select="@xml:id"/>
        <xsl:variable name="entPointer" select="concat('#', $entId)"></xsl:variable>
        <table class="table entity-table">
            <tbody>
                
                <tr>
                    <th>
                        Geburtsdatum
                    </th>
                    <td>
                        <xsl:value-of select="./tei:birth/tei:date"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        Sterbedatum
                    </th>
                    <td>
                        <xsl:value-of select="./tei:death/tei:date"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        Beruf/Tätigkeit
                    </th>
                    <td>
                        <xsl:value-of select="normalize-space(string-join(.//tei:occupation//text(), ' '))"/>
                    </td>
                </tr>
                <tr>
                    <th>
                        Aufenthaltsorte
                    </th>
                    <td>
                        <xsl:for-each select=".//tei:residence">
                            <xsl:value-of select="./@type"/>:
                            <xsl:choose>
                                <xsl:when test="data(./@type) eq 'Geschäftsadresse'">
                                    <xsl:value-of select="./tei:placeName/text()"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <a href="{replace(./tei:placeName/@key, '#', '')||'.html'}">
                                        <xsl:value-of select="./tei:placeName/text()"/></a>
                                </xsl:otherwise>
                            </xsl:choose>
                            <br />
                        </xsl:for-each>
                    </td>
                </tr>
                <tr>
                    <th>
                        Firmenbeteiligungen
                    </th>
                    <td>
                        <xsl:for-each select=".//tei:affiliation">
                            <a href="{replace(./tei:orgName/@key, '#', '')||'.html'}">
                                <xsl:value-of select="./tei:orgName/text()"/></a><br />
                        </xsl:for-each>
                    </td>
                </tr>
                <tr>
                    <th>bibliographische Angaben</th>
                    <td><xsl:value-of select="normalize-space(string-join(.//tei:bibl//text(), ' '))"/></td>
                </tr>
                <tr>
                    <th>Familiäre Beziehungen</th>
                    <td>
                        <ul>
                            <xsl:for-each select="root()//tei:relation[@active=$entPointer or @passive=$entPointer]">
                                <xsl:variable name="relationParts" select="tokenize(@n, ' — ')"/>
                                <li>
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat(replace(@active, '#', ''), '.html')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$relationParts[1]"/> 
                                    </a>
                                    — <xsl:value-of select="$relationParts[2]"/> — 
                                    <a>
                                        <xsl:attribute name="href">
                                            <xsl:value-of select="concat(replace(@passive, '#', ''), '.html')"/>
                                        </xsl:attribute>
                                        <xsl:value-of select="$relationParts[3]"/> 
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th>potentielle Doublette von</th>
                    <td>
                        <ul>
                            <xsl:for-each select="tokenize(normalize-space(@sameAs), ' ')">
                                <xsl:variable name="curid">
                                    <xsl:value-of select="replace(data(.), '#', '')"/>
                                </xsl:variable>
                                <li>
                                    <a href="{$curid||'.html'}"><xsl:value-of select="$curid"/></a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th>
                        Erwähnt in
                    </th>
                    <td>
                        <ul>
                            <xsl:for-each select=".//tei:note[@type='mentions']">
                                <li>
                                    <a href="{replace(./@target, '.xml', '.html')}">
                                        <xsl:value-of select="./text()"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>