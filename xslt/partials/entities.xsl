<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    <xsl:import href="./person.xsl"/>
    
    <xsl:template match="tei:listPerson">
        <xsl:apply-templates/>
    </xsl:template>

    
    <xsl:template match="tei:person">
        <xsl:variable name="selfLink">
            <xsl:value-of select="concat(data(@xml:id), '.html')"/>
        </xsl:variable>
        <xsl:variable name="label">
            <xsl:value-of select="./tei:persName[1]/tei:surname[1]/text()"/>, <xsl:value-of select="./tei:persName[1]/tei:forename[1]/text()"/>
        </xsl:variable>
        <div class="modal modal-lg fade" id="{@xml:id}" data-bs-keyboard="true" tabindex="-1" aria-labelledby="{$label}" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h1 class="modal-title fs-5" id="staticBackdropLabel"><xsl:value-of select="$label"/></h1>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <xsl:call-template name="person_detail"/> 
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Schließen</button>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
        
</xsl:stylesheet>