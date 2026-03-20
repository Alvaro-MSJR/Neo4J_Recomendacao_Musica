# Queries de Recomendação Musical - Neo4j

## 📌 Sobre o Banco de Dados
Este documento contém 10 queries Cypher para análise de comportamento musical e recomendações personalizadas, baseadas nas interações dos usuários (escuta, curtidas, seguidores) com músicas, artistas e gêneros.

---

## Query 1: Gêneros mais escutados por faixa etária
**Objetivo:** Identificar quais gêneros predominam em cada faixa etária para recomendar músicas apropriadas.

```cypher
// Faixa etária: Jovens (18-25), Adultos (26-35), Adultos+ (36+)
MATCH (u:User)-[l:LISTENED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
RETURN 
  CASE 
    WHEN u.age < 26 THEN 'Jovens (18-25)'
    WHEN u.age < 36 THEN 'Adultos (26-35)'
    ELSE 'Adultos+ (36+)'
  END AS faixaEtaria,
  g.name AS genero,
  COUNT(*) AS totalEscutas
ORDER BY faixaEtaria, totalEscutas DESC;
```

💡 Recomendação: Use este resultado para criar playlists segmentadas por idade. Exemplo: Se "Electropop" é predominante entre jovens, destaque esse gênero na homepage para usuários dessa faixa.

## Query 2: Gêneros mais curtidos pelos usuários

**Objetivo**: Descobrir quais gêneros geram mais engajamento positivo.

``` // cypher
MATCH (u:User)-[:LIKED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
RETURN g.name AS genero, COUNT(*) AS totalCurtidas
ORDER BY totalCurtidas DESC
LIMIT 5;
```

💡 Recomendação: Os gêneros mais curtidos devem ter destaque na seção "Recomendados para você" e em campanhas de email marketing.

## Query 3: Artistas mais seguidos pelos usuários

**Objetivo**: Identificar os artistas com maior base de fãs.

``` //cypher
MATCH (u:User)-[f:FOLLOWS]->(a:Artist)
RETURN a.name AS artista, 
       a.type AS tipo,
       COUNT(u) AS totalSeguidores,
       AVG(CASE WHEN f.notificationsActive = true THEN 1 ELSE 0 END) * 100 AS percentualNotificacoesAtivas
ORDER BY totalSeguidores DESC
LIMIT 5;
```

💡 Recomendação: Artistas mais seguidos devem receber prioridade em notificações sobre novos lançamentos e shows.

## Query 4: Músicas mais escutadas (com contexto)

**Objetivo**: Entender onde as músicas são mais consumidas.

``` //cypher
MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN s.title AS musica, 
       s.popularity AS popularidade,
       l.context AS contexto,
       COUNT(*) AS totalEscutas
ORDER BY totalEscutas DESC
LIMIT 10;
```

💡 Recomendação: Crie playlists contextuais baseadas nesses dados, como "Melhores para Workout" ou "Trilha para o Trabalho".

## Query 5: Artistas mais influentes (baseado em múltiplos fatores)

**Objetivo**: Calcular um score de influência combinando escutas, curtidas e seguidores.

``` //cypher
MATCH (a:Artist)
OPTIONAL MATCH (a)-[:COMPOSED]->(s:Song)<-[:LISTENED]-(u:User)
WITH a, COUNT(DISTINCT u) AS totalOuvintes
OPTIONAL MATCH (a)-[:COMPOSED]->(s:Song)<-[:LIKED]-(u:User)
WITH a, totalOuvintes, COUNT(DISTINCT u) AS totalFas
OPTIONAL MATCH (a)<-[:FOLLOWS]-(u:User)
RETURN a.name AS artista,
       totalOuvintes AS ouvintesUnicos,
       totalFas AS fasQueCurtem,
       COUNT(DISTINCT u) AS seguidores,
       (totalOuvintes * 0.3 + totalFas * 0.5 + COUNT(DISTINCT u) * 0.2) AS scoreInfluencia
ORDER BY scoreInfluencia DESC
LIMIT 5;
```

💡 Recomendação: Use este score para determinar quais artistas merecem destaque na página inicial e em campanhas de parceria.

## Query 6: Recomendação de músicas baseada em curtidas anteriores

**Objetivo**: Sugerir músicas de gêneros que o usuário já curtiu.

``` //cypher
// Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID real
MATCH (u:User {id: 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232'})-[:LIKED]->(:Song)-[:BELONGS_TO]->(g:Genre)
MATCH (recomendacao:Song)-[:BELONGS_TO]->(g)
WHERE NOT EXISTS((u)-[:LIKED]->(recomendacao))
RETURN DISTINCT recomendacao.title AS sugestao, 
       g.name AS genero,
       recomendacao.popularity AS popularidade
ORDER BY recomendacao.popularity DESC
LIMIT 5;
```

💡 Recomendação: Implemente este algoritmo na seção "Recomendados para você" do seu app.

## Query 7: Usuários com gostos similares (para recomendações sociais)

**Objetivo**: Encontrar usuários que curtirem músicas parecidas.

``` //cypher
// Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID real
MATCH (u1:User {id: 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232'})-[:LIKED]->(s:Song)<-[:LIKED]-(u2:User)
WHERE u1 <> u2
RETURN u2.name AS usuarioSimilar, 
       COUNT(s) AS musicasEmComum
ORDER BY musicasEmComum DESC
LIMIT 3;
```

💡 Recomendação: Use esses dados para criar features sociais como "Compartilhado por amigos" ou "Descobertas da semana baseadas em usuários similares".

## Query 8: Análise de engajamento por dispositivo

**Objetivo**: Identificar padrões de consumo por tipo de dispositivo.

``` //cypher
MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN l.device AS dispositivo,
       COUNT(*) AS totalEscutas,
       AVG(l.listeningDurationSec) AS duracaoMediaSegundos,
       AVG(CASE WHEN l.liked = true THEN 1 ELSE 0 END) * 100 AS percentualCurtidas
ORDER BY totalEscutas DESC;
```

💡 Recomendação: Otimize a experiência do usuário por dispositivo. Se Mobile tem mais curtidas, invista em UI/UX mobile-first.

## Query 9: Músicas antigas que ainda fazem sucesso
**Objetivo**: Encontrar músicas de anos anteriores com alta popularidade atual.

``` //cypher
MATCH (s:Song)<-[l:LISTENED]-()
WHERE s.releaseYear < 2015
RETURN s.title AS musica,
       s.releaseYear AS anoLancamento,
       s.popularity AS popularidadeAtual,
       COUNT(l) AS escutasRecentes
ORDER BY s.popularity DESC, escutasRecentes DESC
LIMIT 5;
```

💡 Recomendação: Crie uma playlist "Clássicos que nunca morrem" baseada nessas músicas.

## Query 10: Artistas em alta (baseado em escutas recentes)

**Objetivo**: Identificar artistas com crescimento no número de escutas nos últimos 30 dias.

``` //cypher
WITH datetime() - duration('P30D') AS dataLimite
MATCH (a:Artist)-[:COMPOSED]->(s:Song)<-[l:LISTENED]-(u:User)
WHERE l.timestamp > dataLimite
RETURN a.name AS artista,
       COUNT(DISTINCT u) AS ouvintesUltimos30Dias,
       COUNT(l) AS totalEscutasPeriodo
ORDER BY ouvintesUltimos30Dias DESC
LIMIT 5;
```

💡 Recomendação: Destaque esses artistas em banners promocionais e na seção "Em alta" do aplicativo.

### 📊 Resumo das Queries
|  Query	| Foco				| Aplicação
| :---        |    :----:   |          ---: |
|1	|Gênero por faixa etária	|	Playlists segmentadas
|2	|Gêneros mais curtidos		|	Destaques na homepage
|3	|Artistas mais seguidos		|	Notificações prioritárias
|4	|Contexto de escuta			|	Playlists contextuais
|5	|Score de influência		|	Parcerias com artistas
|6	|Recomendação por curtidas	|	Seção "Recomendados"
|7	|Usuários similares			|	Features sociais
|8	|Análise por dispositivo	|	Otimização UX
|9	|Músicas antigas populares	|	Playlist "Clássicos"
|10	|Artistas em alta			|	Seção "Em alta"

#### Nota: 
**__Substitua os IDs de exemplo (user_efd9d1d5...) pelos IDs reais do seu banco de dados ao executar as queries que requerem um usuário específico.__**

**Este arquivo markdown contém 10 queries úteis, todas focadas em gerar insights para recomendações musicais.**

**Cada query tem um propósito claro e uma sugestão de aplicação prática!**