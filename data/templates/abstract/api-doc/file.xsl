<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dbx="http://phpdoc.org/xsl/functions"
    exclude-result-prefixes="dbx">
  <xsl:output indent="yes" method="html" />

  <xsl:template match="file">

      <a name="top" class="anchor"/>
      <xsl:if test="docblock/description|docblock/long-description">
          <div id="file-description">
              <xsl:apply-templates select="docblock/description"/>
              <xsl:apply-templates select="docblock/long-description"/>
          </div>
      </xsl:if>

      <xsl:if test="count(docblock/tag) > 0">
      <dl class="file-info">
          <xsl:apply-templates select="docblock/tag">
            <xsl:sort select="dbx:ucfirst(@name)" />
          </xsl:apply-templates>
      </dl>
      </xsl:if>

    <xsl:if test="count(constant) > 0">
    <a name="constants" class="anchor" />
    <h2>Constants</h2>
    <div>
      <xsl:apply-templates select="constant"/>
    </div>
    </xsl:if>

    <xsl:if test="count(function) > 0">
    <a name="functions" class="anchor" />
    <h2>Functions</h2>
    <div>
      <xsl:apply-templates select="function">
        <xsl:sort select="name" />
      </xsl:apply-templates>
    </div>
    </xsl:if>

    <xsl:if test="count(class) > 0">
    <a name="classes" class="anchor" />
    <xsl:apply-templates select="class">
      <xsl:sort select="name" />
    </xsl:apply-templates>
    </xsl:if>

    <xsl:if test="count(interface) > 0">
    <a name="interfaces" class="anchor" />
    <xsl:apply-templates select="interface">
      <xsl:sort select="name" />
    </xsl:apply-templates>
    </xsl:if>

  </xsl:template>

</xsl:stylesheet>