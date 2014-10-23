<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.music-encoding.org/ns/mei"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:m="http://www.music-encoding.org/ns/mei"
    xmlns:xl="http://www.w3.org/1999/xlink" 
    version="1.0" 
    exclude-result-prefixes="m xsl xl">

    <!--  
        Occasionally MerMEId appears to produce duplicate IDs. 
        These are renamed with this xsl.
        As of rev. 823, this check is also performed each time MerMEId saves a file.
        The xsl also fixes a couple of mistakes from earlier MerMEId versions.
        
        Oct. 2014
    -->
    
    
    <xsl:output indent="yes" xml:space="default" method="xml" encoding="UTF-8"
        omit-xml-declaration="yes"/>

    <xsl:strip-space elements="*"/>

    <xsl:template match="m:physLoc[m:ptr]">
        <!-- move misplaced ptr elements -->
        <physLoc>
            <xsl:apply-templates select="@*"/>
            <xsl:choose>
                <xsl:when test="m:ptr[@*[text()] or //text()]">
                    <!-- if the ptr element is not empty, put it in the repository element -->
                    <repository>
                        <xsl:apply-templates select="m:repository/@*"/>
                        <xsl:apply-templates select="m:repository/*"/>
                        <xsl:apply-templates select="m:ptr"/>
                    </repository>
                    <xsl:apply-templates select="*[name()!='ptr' and name()!='repository']"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- empty ptr element; just delete it -->
                    <xsl:apply-templates select="*[name()!='ptr']"/>
                </xsl:otherwise>
            </xsl:choose>
        </physLoc>
    </xsl:template>
    
    <!-- Change duplicate IDs -->
    <xsl:template match="*[@xml:id=preceding::*/@xml:id]">
        <xsl:variable name="duplicateID" select="@xml:id"/>
        <xsl:element name="{name()}">
            <xsl:apply-templates select="@*"/>
            <!-- Append a number to the ID according to its number of occurrence -->
            <xsl:attribute name="xml:id">
                <xsl:value-of select="concat($duplicateID,'_',count(preceding::*[@xml:id=$duplicateID]))"/>
            </xsl:attribute>
            <!-- To log changes: -->
            <!--<xsl:comment>Duplicate ID (<xsl:value-of select="$duplicateID"/>) changed</xsl:comment>-->
            <xsl:apply-templates select="node()"/>        
        </xsl:element>
    </xsl:template>
    
    
    <!-- Remove empty elements -->
    <xsl:template match="m:notesStmt[not(*)]"/>    
    <xsl:template match="m:eventList[not(*)]"/>    
    
    
    <!-- Remove misplaced empty geogName elements -->
    <xsl:template match="m:imprint/m:geogName[not(text())]"/>
    
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
