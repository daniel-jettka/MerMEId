<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet     
    xmlns="http://www.music-encoding.org/ns/mei" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xl="http://www.w3.org/1999/xlink" 
    xmlns:m="http://www.music-encoding.org/ns/mei" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="m xsl"
    version="2.0">
    
    <xsl:template match="@*|*">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="m:work|m:expression|m:source|m:item|m:event|m:change|m:ensemble|m:performer|m:castItem">
        <xsl:variable name="element_name" select="local-name()"/>
        <xsl:element name="{$element_name}">
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">
                    <xsl:call-template name="id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
        
    <xsl:template match="t:bibl">
        <xsl:variable name="element_name" select="local-name()"/>
        <xsl:element name="{$element_name}" namespace="http://www.tei-c.org/ns/1.0"> 
            <xsl:if test="not(@xml:id)">
                <xsl:attribute name="xml:id">
                    <xsl:call-template name="id"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template name="id">
        <xsl:variable name="generated_id" select="generate-id()"/>
        <xsl:variable name="no_of_nodes" select="count(//*)"/>
        <xsl:variable name="milliseconds" select="translate(string(seconds-from-time(current-time())),'.','')"/>
        <xsl:value-of select="concat(local-name(),'_',$no_of_nodes,$milliseconds,$generated_id)"/>
    </xsl:template>
    
</xsl:stylesheet>
