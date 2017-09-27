<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:dbx="http://phpdoc.org/xsl/functions"
    exclude-result-prefixes="dbx">
  <xsl:output indent="yes" method="html" />

  <xsl:template match="method/name">
    <h4 class="method {../@visibility}">
      <img src="{$root}images/icons/visibility_{../@visibility}.png" style="margin-right: 10px" alt="{@visibility}" title="{@visibility}"/>
      <xsl:value-of select="." />
    </h4>
  </xsl:template>

  <xsl:template match="function/name">

    <h3 class="function {../@visibility}">
      <img src="{$root}images/icons/visibility_{../@visibility}.png" style="margin-right: 10px" alt="{@visibility}" title="{@visibility}"/>
      <xsl:value-of select="." />
    </h3>
  </xsl:template>

    <xsl:template match="argument">
        <xsl:variable name="name" select="name"/>
        <tr>
            <th>
                <xsl:value-of select="$name"/>
            </th>
            <td>
                <xsl:if test="../docblock/tag[@name='param' and @variable=$name]/type">
                    <xsl:call-template name="implodeTypes">
                        <xsl:with-param name="items" select="../docblock/tag[@name='param' and @variable=$name]/type"/>
                    </xsl:call-template>
                </xsl:if>
            </td>
            <td>
                <em>
                    <xsl:value-of select="../docblock/tag[@name='param' and @variable=$name]/@description" disable-output-escaping="yes"/>
                </em>
            </td>
        </tr>
    </xsl:template>

  <xsl:template match="function|method">
    <a id="{../full_name}::{name}()" class="anchor" />

        <code class="title">
            <xsl:choose>
                <xsl:when test="@visibility='private'">
                    -<xsl:text> </xsl:text>
                </xsl:when>
                <xsl:when test="@visibility='protected'">
                    #<xsl:text> </xsl:text></xsl:when>
                <xsl:when test="@visibility='public'">
                    +<xsl:text> </xsl:text>
                </xsl:when>
            </xsl:choose>
            <span class="highlight"><xsl:value-of select="name" /></span>
            <span class="nb-faded-text">(<xsl:for-each select="argument"><xsl:if test="position() &gt; 1">, </xsl:if><xsl:variable name="variable_name" select="name" /><xsl:call-template name="implodeTypes"><xsl:with-param name="items" select="../docblock/tag[@name='param' and @variable=$variable_name]/type" /></xsl:call-template>&#160;<xsl:value-of select="$variable_name" /><xsl:if test="default != ''"> = <xsl:value-of select="default" disable-output-escaping="yes" /></xsl:if></xsl:for-each>)</span> : <xsl:if test="not(docblock/tag[@name='return'])">void</xsl:if><xsl:apply-templates select="docblock/tag[@name='return']" />
        </code>

        <div class="description">
            <xsl:if test="@static='true'">
                <span>static</span>
            </xsl:if>

            <xsl:if test="@final='true'">
                <span>final</span>
            </xsl:if>

            <xsl:if test="@abstract='true'">
                <span>abstract</span>
            </xsl:if>

            <xsl:if test="inherited_from">
                <span>inherited</span>
            </xsl:if>

            <p>
                <xsl:value-of select="docblock/description" disable-output-escaping="yes" />
            </p>

            <xsl:if test="inherited_from">
                <small class="inherited_from">Inherited from:
                    <xsl:if test="docblock/tag[@name='inherited_from']/@link">
                        <xsl:apply-templates select="docblock/tag[@name='inherited_from']/@link"/>
                    </xsl:if>

                    <xsl:if test="not(docblock/tag[@name='inherited_from']/@link)">
                        <xsl:value-of select="docblock/tag[@name='inherited_from']/@description" />
                    </xsl:if>
                </small>
            </xsl:if>
        </div>

        <div class="code-tabs">
            <xsl:apply-templates select="docblock/long-description"/>

            <xsl:if test="count(argument) > 0">
                <strong>Parameters</strong>
                <table>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="argument"/>
                </table>
            </xsl:if>

            <xsl:if test="docblock/tag[@name = 'return'] != '' and docblock/tag[@name = 'return']/@type != 'void'">
                <strong>Returns</strong>
                <table>
                    <thead>
                        <tr><th>Type</th><th>Description</th></tr>
                    </thead>
                    <tr>
                        <td>
                            <xsl:apply-templates select="docblock/tag[@name='return']"/>
                        </td>
                        <td>
                            <xsl:apply-templates select="docblock/tag[@name='return']/@description"/>
                        </td>
                    </tr>
                </table>
            </xsl:if>

            <xsl:if test="count(docblock/tag[@name = 'throws'])">
                <strong>Throws</strong>
                <table>
                    <thead>
                        <tr>
                            <th>Exception</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <xsl:apply-templates select="docblock/tag[@name='throws']"/>
                </table>
            </xsl:if>

            <xsl:call-template name="doctrine" />

            <xsl:if test="docblock/tag[@name != 'param' and @name != 'return' and @name !='inherited_from' and @name != 'throws']">
                <strong>Details</strong>
                <dl class="function-info">
                    <xsl:apply-templates select="docblock/tag[@name != 'param' and @name != 'return' and @name !='inherited_from' and @name != 'throws']">
                        <xsl:sort select="dbx:ucfirst(@name)"/>
                    </xsl:apply-templates>
                </dl>
            </xsl:if>
        </div>
<hr/>
  </xsl:template>

</xsl:stylesheet>