<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">


    <xsl:template match="tei:org" name="org_detail">
        <table class="table entity-table">
            <tbody>

                <tr>
                    <th> Name </th>
                    <td>
                        <xsl:value-of select="./tei:orgName"/>
                    </td>
                </tr>
                <tr>
                    <th>Beteiligte Personen</th>
                    <td>
                        <ul>
                            <xsl:for-each select=".//tei:persName">
                                <li>
                                    <a href="{replace(@key, '#', '')||'.html'}">
                                        <xsl:value-of select="./text()"/>
                                    </a>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <th>Erwähnt in</th>
                    <td>
                        <ul>
                            <xsl:for-each select=".//tei:note[@type = 'mentions']">
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
