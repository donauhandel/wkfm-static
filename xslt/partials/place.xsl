<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">

    <xsl:template match="tei:place" name="place_detail">
        <table class="table entity-table">
            <tbody>
                <tr>
                    <th>
                        Ortsname
                    </th>
                    <td>
                        <xsl:value-of select="./tei:placeName[1]/text()"/>
                    </td>
                </tr>
                
                <tr>
                    <th>
                        Geonames ID
                    </th>
                    <td>
                        <a href="{./tei:idno[@subtype='geonames']}" target="_blank">
                            <xsl:value-of select="./tei:idno[@subtype='geonames']"/>
                        </a>
                    </td>
                </tr>
                
                
                <tr>
                    <th>
                        GND ID
                    </th>
                    <td>
                        <a href="{./tei:idno[@subtype='gnd']}" target="_blank">
                            <xsl:value-of select="./tei:idno[@subtype='gnd']"/>
                        </a>
                    </td>
                </tr>
                <tr>
                    <th>
                        Bibliographische Angaben
                    </th>
                    <td>
                       
                            <xsl:for-each select=".//tei:bibl">
                                <xsl:value-of select="./text()"/><br />
                            </xsl:for-each>
                        
                        
                    </td>
                </tr>
                
                <tr>
                    <th>
                        Breitengrad
                    </th>
                    <td>
                        <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1], '\s')[1]"/>
                    </td>
                </tr>
                
               
                <tr>
                    <th>
                        Längengrad
                    </th>
                    <td>
                        <xsl:value-of select="tokenize(./tei:location[1]/tei:geo[1], '\s')[2]"/>
                    </td>
                </tr>
                
                
            </tbody>
        </table>
    </xsl:template>
</xsl:stylesheet>
