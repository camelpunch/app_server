<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet 
  version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  >

  <xsl:output 
    method="xml" 
    indent="yes"
    encoding="UTF-8"
    />

  <xsl:param name="name"/>

  <!-- copy all by default -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- remove existing update element -->
  <xsl:template match="atom:updated"/>

  <!-- remove existing self links -->
  <xsl:template match="atom:link">
    <xsl:choose>
      <xsl:when test="@rel = 'self'"/>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="atom:entry">
    <atom:entry>
      <atom:updated><xsl:value-of select="current-dateTime()"/></atom:updated>
      <atom:link rel="self" href="{$name}"/>
      <xsl:apply-templates/>
    </atom:entry>
  </xsl:template>

</xsl:stylesheet>

