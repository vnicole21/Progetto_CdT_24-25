<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs">
    
    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    <xsl:key name="personById" match="tei:person" use="@xml:id"/>
    <xsl:key name="placeById" match="tei:place" use="@xml:id"/>
    <xsl:key name="orgById" match="tei:org" use="@xml:id"/>
    
    <!-- Template per copia tutti i nodi -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Template radice -->
    <xsl:template match="/">
        <xsl:apply-templates select="tei:TEI"/>
    </xsl:template>
    
    <!-- Template TEI principale -->
    <xsl:template match="tei:TEI">
        <html>
            <head>
                <meta charset="UTF-8"/>
                <title>La Rassegna Settimanale</title>
                <link rel="stylesheet" href="script/style.css"/>
                <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
                <script src="script/script.js"></script>
            </head>
            <body>
                
                <!-- NAVBAR -->
                <header>
                    <nav>
                        <div class="navbar">
                            <a class="nameproject" href="https://rassegnasettimanale.animi.it/">La Rassegna Settimanale</a>
                            <a href="#">Home</a>
                            <a href="#menu-articoli">Paragrafi</a>
                            <div class="dropdown">
                                <button class="dropbtn">Pagine</button>
                                <div class="dropdown-content">
                                    <xsl:for-each select="//tei:surface">
                                        <xsl:variable name="n" select="substring-after(@xml:id,'imgr')"/>
                                        <a href="#Pag{$n}">Pagina <xsl:value-of select="$n"/></a>
                                    </xsl:for-each>
                                </div>
                            </div>
                            <a href="#about">About</a>
                        </div>
                    </nav>
                </header>
                
                <!-- DESCRIZIONE DELLA FONTE -->
                <div class="desc">
                    
                    <!-- TITOLO RIVISTA -->
                    <h2>
                        <xsl:value-of select="//tei:titleStmt/tei:title[@type='main']"/>
                    </h2>
                    
                    <h3>
                        <xsl:value-of select="//tei:titleStmt/tei:title[@type='sub']"/>
                    </h3>
                    
                    <!-- FONDATORI -->
                    <p>
                        <strong>Fondatori:</strong>
                        
                        <xsl:for-each select="//tei:titleStmt/tei:respStmt[tei:resp='Fondatori:']/tei:persName">
                            
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@ref"/>
                                </xsl:attribute>
                                
                                <xsl:value-of select="."/>
                                
                            </a>
                            
                            <xsl:if test="position()!=last()">, </xsl:if>
                            
                        </xsl:for-each>
                    </p>
                    
                    <!-- EDIZIONE -->                    
                    <p>
                        <strong>Fonte originale:</strong>
                        
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="//tei:imprint/tei:publisher/@corresp"/>
                            </xsl:attribute>
                            <xsl:value-of select="//tei:imprint/tei:publisher"/>
                        </a>
                        
                        —
                        
                        <a>
                            <xsl:attribute name="href">
                                <xsl:value-of select="//tei:imprint/tei:pubPlace/@ref"/>
                            </xsl:attribute>
                            <xsl:value-of select="//tei:imprint/tei:pubPlace"/>
                        </a>
                        
                        ,
                        <xsl:value-of select="//tei:imprint/tei:date"/>
                    </p>
                    
                    
                    <!-- ESTENSIONE -->
                    <p>
                        <strong>Estensione:</strong>
                        Pagine
                        <xsl:value-of select="//tei:extent/tei:measure[@type='pages']"/>
                        —
                        Parole
                        <xsl:value-of select="//tei:extent/tei:measure[@type='words']"/>
                    </p>
                    
                    <!-- SERIE -->
                    <p>
                        <strong>Serie:</strong>
                        <xsl:value-of select="//tei:seriesStmt/tei:title"/>
                    </p>
                    
                    <p>
                        <strong>Codifica a cura di:</strong>
                        <xsl:value-of select="//tei:seriesStmt//tei:persName"/>
                    </p>
                    
                    <p>
                        Volume
                        <xsl:value-of select="//tei:biblScope[@unit='volume']"/>
                        —
                        Capitoli
                        <xsl:value-of select="//tei:biblScope[@unit='chapter']"/>
                    </p>
                    
                    <!-- DESCRIZIONE FISICA DEL MANOSCRITTO -->
                    <section>
                        <h2>Descrizione fisica</h2>
                        <p>
                            <strong>Supporto:</strong>
                            <xsl:value-of select="//tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support"/>
                        </p>
                        <p>
                            <strong>Condizione:</strong>
                            <xsl:value-of select="//tei:physDesc/tei:objectDesc/tei:supportDesc/tei:condition"/>
                        </p>
                        <p>
                            <strong>Layout:</strong>
                            <xsl:value-of select="//tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:layout"/>
                        </p>
                    </section>
                    
                    <!-- DESCRIZIONE CODIFICA -->
                    <div class="project-desc">
                        
                        <h2>Descrizione della Codifica</h2>
                        
                        <!-- PARAGRAFI tranne quelli con lista articoli -->
                        <xsl:for-each select="//tei:projectDesc/tei:p[not(tei:list)]">
                            <p>
                                <xsl:value-of select="normalize-space(.)"/>
                            </p>
                        </xsl:for-each>
                        
                        <!-- LISTA ARTICOLI -->
                        <ul>
                            <xsl:for-each-group 
                                select="//tei:projectDesc//tei:list/tei:item/tei:title" 
                                group-by="normalize-space(.)">
                                <li>
                                    <xsl:value-of select="current-grouping-key()"/>
                                </li>
                            </xsl:for-each-group>
                        </ul>
                        
                    </div>

                </div>
                
                <!-- BOTTONI ENTITÀ -->
                <div id="fenomeni">
                    <h2>Filtra entità</h2>
                    <div class="bottoni_fenomeni">
                        <button type="button" class="entity-btn" data-type="persone">Persone</button>
                        <button type="button" class="entity-btn" data-type="luoghi">Luoghi</button>
                        <button type="button" class="entity-btn" data-type="organizzazioni">Organizzazioni</button>
                    </div>
                </div>
                
                <!-- ELENCHI ENTITÀ -->
                <div id="elenchi-entita" style="display:none;">
                    <h2>Indici delle Entità per Articolo</h2>
                    <div class="articoli-indice-grid">
                    <xsl:for-each select="//tei:group/tei:text">
                        <div class="articolo-indice" data-articolo="{@xml:id}">
                            <h3><xsl:value-of select=".//tei:head[1]"/></h3>
                            <div style="display:flex; gap:30px; flex-wrap:wrap;">
                                <!-- PERSONE -->
                                <div class="entity-group persone" style="display:none;">
                                    <h4>Persone</h4>
                                    <ul>
                                        <xsl:for-each-group select=".//tei:persName[@ref]" group-by="replace(@ref, '^#', '')">
                                            <xsl:variable name="pid" select="current-grouping-key()"/>
                                            <xsl:variable name="p" select="key('personById',$pid)"/>
                                            <li>
                                                <a href="{if ($p and string-length(normalize-space($p/@corresp)) > 0) then $p/@corresp else '#'}" target="_blank" class="entity-link" data-ref="{$pid}">
                                                    <xsl:choose>
                                                        <xsl:when test="$p"><xsl:value-of select="$p/tei:persName"/></xsl:when>
                                                        <xsl:otherwise><xsl:value-of select="current-group()[1]"/></xsl:otherwise>
                                                    </xsl:choose>
                                                </a>
                                            </li>
                                        </xsl:for-each-group>
                                    </ul>
                                </div>
                                <!-- LUOGHI -->
                                <div class="entity-group luoghi" style="display:none;">
                                    <h4>Luoghi</h4>
                                    <ul>
                                        <xsl:for-each-group select=".//tei:placeName[@ref]" group-by="replace(@ref, '^#', '')">
                                            <xsl:variable name="plid" select="current-grouping-key()"/>
                                            <xsl:variable name="pl" select="key('placeById',$plid)"/>
                                            <li>
                                                <a href="{if ($pl and string-length(normalize-space($pl/@corresp)) > 0) then $pl/@corresp else '#'}" target="_blank" class="entity-link" data-ref="{$plid}">
                                                    <xsl:choose>
                                                        <xsl:when test="$pl"><xsl:value-of select="$pl/tei:placeName"/></xsl:when>
                                                        <xsl:otherwise><xsl:value-of select="current-group()[1]"/></xsl:otherwise>
                                                    </xsl:choose>
                                                </a>
                                            </li>
                                        </xsl:for-each-group>
                                    </ul>
                                </div>
                                <!-- ORGANIZZAZIONI -->
                                <div class="entity-group organizzazioni" style="display:none;">
                                    <h4>Organizzazioni</h4>
                                    <ul>
                                        <xsl:for-each-group select=".//tei:orgName[@ref]" group-by="replace(@ref, '^#', '')">
                                            <xsl:variable name="oid" select="current-grouping-key()"/>
                                            <xsl:variable name="org" select="key('orgById',$oid)"/>
                                            <li>
                                                <a href="{if ($org and string-length(normalize-space($org/@corresp)) > 0) then $org/@corresp else '#'}" target="_blank" class="entity-link" data-ref="{$oid}">
                                                    <xsl:choose>
                                                        <xsl:when test="$org"><xsl:value-of select="$org/tei:orgName"/></xsl:when>
                                                        <xsl:otherwise><xsl:value-of select="current-group()[1]"/></xsl:otherwise>
                                                    </xsl:choose>
                                                </a>
                                            </li>
                                        </xsl:for-each-group>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </xsl:for-each>
                    </div>
                </div>
                
                <!-- MENU PARAGRAFI -->
                <div id="menu-articoli">
                    <h2>Articoli e Paragrafi</h2>
                    <xsl:for-each select="//tei:group/tei:text">
                        <div class="articolo-block">
                            <h3 class="titolo-articolo"><xsl:value-of select=".//tei:head[1]"/></h3>
                            <ul class="lista-paragrafi">
                                <xsl:for-each select=".//tei:ab[@xml:id]">
                                    <li><a href="#{@xml:id}" onclick="evidenziaParagrafo('{@xml:id}')">Paragrafo <xsl:value-of select="position()"/></a></li>
                                </xsl:for-each>
                            </ul>
                        </div>
                    </xsl:for-each>
                </div>
                                
                <!-- FACSIMILI -->
                <div class="text">
                    <xsl:for-each select="//tei:surface">
                        <xsl:variable name="pageNum" select="substring-after(@xml:id,'imgr')"/>
                        <h2 id="Pag{$pageNum}">Pagina <xsl:value-of select="$pageNum"/></h2>
                        <div class="container">
                            <div class="box">
                                <div class="facsimile-wrapper">
                                    <img src="./pages/img{$pageNum}.png" class="facsimile"/>
                                    <div class="overlay">
                                        <xsl:apply-templates select="tei:zone"/>
                                    </div>
                                </div>
                            </div>
                            <div class="boxtext">
                                
                                <xsl:variable name="zones" select="tei:zone/@corresp"/>
                                
                                <xsl:for-each-group
                                    select="//tei:ab[concat('#',@xml:id) = $zones]"
                                    group-by="generate-id(ancestor::tei:div[1])">
                                    
                                    <xsl:variable name="articolo"
                                        select="current-group()[1]/ancestor::tei:div[1]"/>
                                    
                                    <!-- TITOLO DELL’ARTICOLO -->
                                    <xsl:apply-templates select="$articolo/tei:head"/>
                                    
                                    <!-- PARAGRAFI DI QUESTO ARTICOLO NELLA PAGINA -->
                                    <xsl:apply-templates select="current-group()"/>
                                    
                                    <!-- NOTE DELLO STESSO ARTICOLO -->
                                    <xsl:apply-templates
                                        select="//tei:note[
                                                concat('#',@xml:id) = $zones
                                                and ancestor::tei:div[1] is $articolo
                                            ]"/>
                                    
                                </xsl:for-each-group>
                                
                            </div>
                        </div>
                    </xsl:for-each>
                </div>
                            
                            <!-- FOOTER -->
                <div id="about">
                    <footer>                        
                        <!-- RESPONSABILITÀ -->
                        <div class="footer-block">
                            <h3>Responsabilità</h3>
                            <p>
                                <strong>Coordinamento:</strong>
                                <xsl:value-of select="//tei:editionStmt//tei:persName"/>
                            </p>
                            
                            <p>
                                <strong>Codifica del testo:</strong>
                                <xsl:value-of select="//tei:seriesStmt//tei:persName"/>
                            </p>
                        </div>
                        
                        <!-- DATI EDITORIALI -->
                        <div class="footer-block">
                            <h3>Dati editoriali</h3>
                            
                            <p>
                                <strong>Edizione digitale:</strong>
                                <xsl:value-of select="//tei:editionStmt/tei:edition"/>
                            </p>
                            
                            <p>
                                <strong>Ente:</strong>
                                <xsl:value-of select="//tei:publicationStmt/tei:publisher"/>
                                —
                                <xsl:value-of select="//tei:publicationStmt/tei:pubPlace"/>
                            </p>
                            
                            <p>
                                <strong>Anno:</strong>
                                <xsl:value-of select="//tei:publicationStmt/tei:date"/>
                            </p>
                            
                        </div>
                        
                        <!-- LICENZA -->
                        <div class="footer-block">
                            <h3>Licenza</h3>
                            
                            <p>
                                <xsl:value-of select="//tei:availability/tei:p"/>
                            </p>
                        </div>
                        
                        <!-- REPOSITORY -->
                        <div class="footer-block footer-link">
                            <p>
                                Repository progetto:
                                <a href="https://github.com/angelodel80/corsoCodifica" target="_blank">
                                    GitHub
                                </a>
                            </p>
                        </div>
                        
                    </footer>
                </div>
                
            </body>
        </html>
    </xsl:template>
    
    <!-- TEMPLATE PARAGRAFO + BYLINE -->
    <xsl:template match="tei:ab">
        <p id="{@xml:id}" class="paragrafo">
            <xsl:apply-templates/>
        </p>
        
        <!-- stampa byline solo se il paragrafo è marcato come fine -->
        <xsl:if test="@type='fine'">
            <xsl:apply-templates select="following-sibling::tei:byline[1]"/>
        </xsl:if>
    </xsl:template>
    
    <!-- TEMPLATE NOTE FACSIMILE -->
    <xsl:template match="tei:note">
        <p class="nota-testo">
            <xsl:attribute name="id">
                <xsl:choose>
                    <xsl:when test="@xml:id">
                        <xsl:value-of select="@xml:id"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="generate-id()"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <!-- TEMPLATE LINE BREAK -->
    <xsl:template match="tei:lb[@break='no']">
        
        <xsl:variable name="prev" select="normalize-space(preceding-sibling::text()[last()])"/>
        <xsl:variable name="next" select="normalize-space(following-sibling::text()[1])"/>
        
        <xsl:variable name="prev-clean"
            select="replace($prev,'[-–]\s*$','')"/>
        
        <span class="word-break" data-tooltip="{$prev-clean}{$next}">
            <br/>
        </span>
        
    </xsl:template>
    
    <!-- HI: corsivo -->
    <xsl:template match="tei:hi[@rend='italic']">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    
    <!-- unclear -->
    <xsl:template match="tei:unclear">
    <span class="unclear"
          data-tooltip="Lettura incerta">
        <xsl:apply-templates/>
    </span>
</xsl:template>


    <!-- ENTITÀ -->
    <xsl:template match="tei:persName | tei:placeName | tei:orgName">
        
        <xsl:variable name="id" select="substring-after(@ref,'#')"/>
        
        <xsl:variable name="url">
            <xsl:choose>
                <xsl:when test="self::tei:persName">
                    <xsl:value-of select="key('personById',$id)/@corresp"/>
                </xsl:when>
                <xsl:when test="self::tei:placeName">
                    <xsl:value-of select="key('placeById',$id)/@corresp"/>
                </xsl:when>
                <xsl:when test="self::tei:orgName">
                    <xsl:value-of select="key('orgById',$id)/@corresp"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$url and $url != 'NO INFO'">
                <a href="{$url}" target="_blank" class="{name()}" data-ref="{$id}">
                    <xsl:apply-templates/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <span class="{name()}" data-ref="{$id}">
                    <xsl:apply-templates/>
                </span>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
        
    <!-- QUOTE -->
    <xsl:template match="tei:quote">
        <span class="citazione">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- SAID -->
    <xsl:template match="tei:said">
        <span class="said">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- DATE -->
    <xsl:template match="tei:date">
        <span class="date">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- ADDNAME (epithet) -->
    <xsl:template match="tei:addName[@type='epithet']">
        <span class="epithet">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- FOREIGN -->
    <xsl:template match="tei:foreign">
        <span class="foreign">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- TITOLI OPERE -->
    <xsl:template match="tei:title">
        <span class="opere">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- CASA EDITRICE -->
    <xsl:template match="tei:publisher">
        <span class="casaeditrice">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- CHOICE -->
    <xsl:template match="tei:choice">
        <span class="choice-wrapper"> <!-- per choice ho inserito anche <seg> perché altrimenti mi dava errore -->
            
            <xsl:choose>
                
                <!-- ORIG/REG -->
                <xsl:when test="tei:seg/tei:orig and tei:seg/tei:reg">
                    <span class="orig" data-tooltip="{tei:seg/tei:reg}">
                        <xsl:apply-templates select="tei:seg/tei:orig"/>
                    </span>
                    <span class="reg">
                        <xsl:apply-templates select="tei:seg/tei:reg"/>
                    </span>
                </xsl:when>
                
                <!-- ABBR/EXPAN -->
                <xsl:when test="tei:seg/tei:abbr and tei:seg/tei:expan">
                    <span class="abbr" data-tooltip="{tei:seg/tei:expan}">
                        <xsl:apply-templates select="tei:seg/tei:abbr"/>
                    </span>
                    <span class="expan">
                        <xsl:apply-templates select="tei:seg/tei:expan"/>
                    </span>
                </xsl:when>
                
                <!-- FALLBACK -->
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
                
            </xsl:choose>
            
        </span>
    </xsl:template>
    
    <!-- IMMAGINI SURFACE -->
    <xsl:template match="tei:surface/tei:graphic">
        <img src="{@url}"/>
    </xsl:template>
    
    <!-- ZONE PER OVERLAY -->    
    <xsl:template match="tei:zone">
        <div class="zone-overlay" data-corresp="{substring-after(@corresp,'#')}"
             style="left:{@ulx}px; top:{@uly}px; width:{@lrx - @ulx}px; height:{@lry - @uly}px;"></div>
    </xsl:template>
    
    <xsl:template match="tei:head"><h2 class="titolo"><xsl:apply-templates/></h2></xsl:template>
    
    
    
</xsl:stylesheet>
