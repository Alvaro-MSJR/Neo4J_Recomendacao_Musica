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


// ## Query 2: Gêneros mais curtidos pelos usuários
// **Objetivo**: Descobrir quais gêneros geram mais engajamento positivo (curtidas).
MATCH (u:User)-[:LIKED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
RETURN g.name AS genero, 
       COUNT(*) AS totalCurtidas,
       COUNT(DISTINCT u) AS usuariosUnicos,
       ROUND(AVG(s.popularity), 2) AS popularidadeMedia
ORDER BY totalCurtidas DESC
LIMIT 5;


//  ## Query 3: Artistas mais seguidos
//  **Objetivo**: Identificar os artistas com maior base de fãs e engajamento.
MATCH (u:User)-[f:FOLLOWS]->(a:Artist)
OPTIONAL MATCH (a)-[:COMPOSED]->(s:Song)<-[:LIKED]-(:User)
WITH a, COUNT(DISTINCT u) AS totalSeguidores, 
     COUNT(DISTINCT s) AS musicas,
     COUNT(DISTINCT s) AS totalCurtidas,
     AVG(CASE WHEN f.notificationsActive = true THEN 1.0 ELSE 0 END) * 100 AS percentualNotificacoesAtivas
RETURN a.name AS artista,
       a.type AS tipo,
       a.countryOfOrigin AS pais,
       totalSeguidores,
       ROUND(percentualNotificacoesAtivas, 2) AS percentualNotificacoesAtivas,
       totalCurtidas AS curtidasEmMusicas
ORDER BY totalSeguidores DESC
LIMIT 5;


// ## Query 4: Músicas mais escutadas por contexto
//  **Objetivo**: Entender o comportamento de consumo em diferentes contextos (Workout, Home, Commute, Party).
MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN l.context AS contexto,
       s.title AS musica,
       s.popularity AS popularidade,
       COUNT(*) AS totalEscutas,
       ROUND(AVG(l.listeningDurationSec) / 60, 2) AS duracaoMediaMinutos,
       ROUND(100.0 * SUM(CASE WHEN l.liked THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxaCurtida
ORDER BY contexto, totalEscutas DESC;



//  ## Query 5: Artistas mais influentes (score combinado)
//  **Objetivo**: Calcular um score de influência combinando múltiplos fatores (escutas, curtidas, seguidores, popularidade).

// Primeiro bloco: Calcular máximo de ouvintes para normalização
MATCH (:Artist)-[:COMPOSED]->(:Song)<-[:LISTENED]-(:User)
WITH COUNT(*) AS totalListeners
WITH totalListeners AS maxOuvintes

// Segundo bloco: Processar todos os artistas
MATCH (a:Artist)
OPTIONAL MATCH (a)-[:COMPOSED]->(s:Song)
WITH a, maxOuvintes, COLLECT(s) AS musicas

// Calcular total de músicas e popularidade média
WITH a, maxOuvintes, 
     SIZE(musicas) AS totalMusicas, 
     REDUCE(sum = 0.0, s IN musicas | sum + COALESCE(s.popularity, 0)) / 
       CASE WHEN SIZE(musicas) > 0 THEN SIZE(musicas) ELSE 1 END AS popularidadeMedia

// Contar ouvintes únicos
OPTIONAL MATCH (a)-[:COMPOSED]->(:Song)<-[:LISTENED]-(u:User)
WITH a, maxOuvintes, totalMusicas, popularidadeMedia, COUNT(DISTINCT u) AS ouvintesUnicos

// Contar fãs que curtiram
OPTIONAL MATCH (a)-[:COMPOSED]->(:Song)<-[:LIKED]-(u:User)
WITH a, maxOuvintes, totalMusicas, popularidadeMedia, ouvintesUnicos, COUNT(DISTINCT u) AS fasQueCurtem

// Contar seguidores
OPTIONAL MATCH (a)<-[:FOLLOWS]-(u:User)
WITH a, totalMusicas, popularidadeMedia, ouvintesUnicos, fasQueCurtem, COUNT(DISTINCT u) AS seguidores,
     maxOuvintes  // <--- IMPORTANTE: maxOuvintes precisa ser incluído aqui também

// Calcular score final e retornar
RETURN a.name AS artista,
       a.type AS tipo,
       totalMusicas,
       ROUND(popularidadeMedia, 2) AS popularidadeMedia,
       ouvintesUnicos,
       fasQueCurtem,
       seguidores,
       ROUND(
         (COALESCE(ouvintesUnicos, 0) * 0.3 + 
          COALESCE(fasQueCurtem, 0) * 0.4 + 
          COALESCE(seguidores, 0) * 0.2 + 
          COALESCE(popularidadeMedia, 0) * 0.1) / 
         CASE WHEN maxOuvintes > 0 THEN maxOuvintes ELSE 1 END * 100, 2
       ) AS scoreInfluencia
ORDER BY scoreInfluencia DESC
LIMIT 5;


//  ## Query 6: Recomendação de músicas baseada em curtidas
//  **Objetivo**: Sugerir novas músicas para um usuário baseado nos gêneros que ele já curtiu.
// Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID do usuário real

MATCH (u:User {id: 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232'})-[:LIKED]->(:Song)-[:BELONGS_TO]->(g:Genre)
WITH u, COLLECT(DISTINCT g) AS generosPreferidos

MATCH (recomendacao:Song)-[:BELONGS_TO]->(g:Genre)
WHERE g IN generosPreferidos
  AND NOT EXISTS((u)-[:LIKED]->(recomendacao))
  AND NOT EXISTS((u)-[:LISTENED {liked: false}]->(recomendacao))

OPTIONAL MATCH (recomendacao)<-[:LIKED]-(outros:User)
RETURN DISTINCT recomendacao.title AS musicaSugerida,
       g.name AS genero,
       recomendacao.popularity AS popularidade,
       recomendacao.releaseYear AS anoLancamento,
       COUNT(DISTINCT outros) AS totalCurtidasOutrosUsuarios
ORDER BY popularidade DESC, totalCurtidasOutrosUsuarios DESC
LIMIT 5;


//  ## Query 7: Usuários com gostos similares
//  **Objetivo**: Encontrar usuários com padrões de curtidas semelhantes para recomendações sociais.
// Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID do usuário real

MATCH (u1:User {id: 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232'})-[:LIKED]->(s:Song)
WITH u1, COLLECT(s) AS musicasUser1

MATCH (u2:User)-[:LIKED]->(s:Song)
WHERE u1 <> u2 AND s IN musicasUser1
WITH u1, u2, COUNT(s) AS musicasEmComum
WHERE musicasEmComum >= 3

MATCH (u2)-[:LIKED]->(s:Song)
WHERE NOT s IN musicasUser1
RETURN u2.name AS usuarioSimilar,
       u2.age AS idade,
       u2.city AS cidade,
       musicasEmComum,
       COLLECT(DISTINCT s.title)[0..3] AS sugestoesMusicais
ORDER BY musicasEmComum DESC
LIMIT 3;


//  ## Query 8: Usuários com gostos similares adaptação 
//  **Objetivo**:  Relacionamentos PERTENCE_A (Song -> Genre) Aqui está uma versão mais flexível que se adapta à realidade do seu banco: 
//Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID do usuário real

MATCH (u1:User )-[:LIKED]->(s:Song)
WITH u1, COLLECT(s) AS musicasUser1, COUNT(s) AS totalCurtidasUser1

// Encontrar usuários com pelo menos 1 música em comum (mais flexível)
MATCH (u2:User)-[:LIKED]->(s:Song)
WHERE u1 <> u2 AND s IN musicasUser1
WITH u1, u2, musicasUser1, totalCurtidasUser1, COUNT(s) AS musicasEmComum

// Calcular similaridade (percentual de overlap)
WITH u2, totalCurtidasUser1, musicasEmComum, musicasUser1,
     ROUND(100.0 * musicasEmComum / totalCurtidasUser1, 2) AS percentualSimilaridade

// Buscar músicas que u2 curte mas u1 não conhece
MATCH (u2)-[:LIKED]->(s:Song)
WHERE NOT s IN musicasUser1
WITH u2, totalCurtidasUser1, musicasEmComum, percentualSimilaridade, COLLECT(s.title) AS musicasSugeridas

// Retornar apenas se houver similaridade mínima (ajuste conforme necessário)
WHERE percentualSimilaridade >= 10 // Mínimo 10% de similaridade

RETURN u2.name AS usuarioSimilar,
       u2.age AS idade,
       u2.city AS cidade,
       musicasEmComum,
       totalCurtidasUser1,
       percentualSimilaridade,
       musicasSugeridas[0..5] AS sugestoesMusicais
ORDER BY percentualSimilaridade DESC, musicasEmComum DESC
LIMIT 10;


//  ## Query 9: Usuários com gostos similares foco em gênero mais abrangente
//  **Objetivo**:  Relacionamentos PERTENCE_A (Song -> Genre) 
// Substitua 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelo ID do usuário real

MATCH (u1:User)-[:LIKED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
WITH u1, COLLECT(DISTINCT g) AS generosUser1

// Encontrar usuários que curtem os mesmos gêneros
MATCH (u2:User)-[:LIKED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
WHERE u1 <> u2 AND g IN generosUser1
WITH u2, COUNT(DISTINCT g) AS generosEmComum
where generosEmComum > 1
ORDER BY generosEmComum DESC
LIMIT 10

RETURN u2.name AS usuarioSimilar,
       u2.age AS idade,
       u2.city AS cidade,
       generosEmComum
ORDER BY generosEmComum DESC;


//  ## Query 10: Análise de engajamento por dispositivo
//  **Objetivo**: Identificar padrões de consumo e preferências por tipo de dispositivo.

MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN l.device AS dispositivo,
       COUNT(*) AS totalEscutas,
       COUNT(DISTINCT u) AS usuariosAtivos,
       ROUND(AVG(l.listeningDurationSec), 2) AS duracaoMediaSegundos,
       ROUND(AVG(s.durationSec), 2) AS duracaoMediaMusicas,
       ROUND(100.0 * SUM(CASE WHEN l.liked THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxaCurtida,
       COLLECT(DISTINCT l.context)[0..3] AS contextosPopulares
ORDER BY totalEscutas DESC;


//  ## Query 11: Músicas antigas com alta popularidade atual
//  **Objetivo**: Encontrar músicas de anos anteriores que mantêm relevância e são frequentemente escutadas.

MATCH (s:Song)<-[l:LISTENED]-(u:User)
WHERE s.releaseYear < 2015
  AND l.timestamp > datetime() - duration('P180D') // últimos 6 meses
WITH s, COUNT(l) AS escutasRecentes, COLLECT(DISTINCT l.context) AS contextos

MATCH (s)<-[:COMPOSED]-(a:Artist)
RETURN s.title AS musica,
       s.releaseYear AS anoLancamento,
       a.name AS artista,
       s.popularity AS popularidadeAtual,
       escutasRecentes,
       SIZE(contextos) AS diversidadeContextos,
       contextos AS contextosOndeToca
ORDER BY (s.popularity * 0.4 + escutasRecentes * 0.6) DESC
LIMIT 5;


//  ## Query 12: Artistas em alta (últimos 30 dias)
//  **Objetivo**: Identificar artistas com crescimento significativo de ouvintes no período recente.

// Definir data limite
WITH datetime() - duration('P30D') AS dataLimite

// Artistas com escutas nos últimos 30 dias
MATCH (a:Artist)-[:COMPOSED]->(s:Song)<-[l:LISTENED]-(u:User)
WHERE l.timestamp > dataLimite
WITH a, dataLimite,
     COUNT(DISTINCT u) AS ouvintesRecentes,
     COUNT(l) AS escutasRecentes,
     AVG(l.listeningDurationSec) AS duracaoMedia

// Buscar escutas anteriores para comparação
OPTIONAL MATCH (a)-[:COMPOSED]->(s2:Song)<-[l2:LISTENED]-(u2:User)
WHERE l2.timestamp <= dataLimite
WITH a, ouvintesRecentes, escutasRecentes, duracaoMedia,dataLimite,
     COUNT(DISTINCT u2) AS ouvintesAnteriores,
     COUNT(l2) AS escutasAnteriores

// Calcular métricas finais
RETURN a.name AS artista,
       a.type AS tipo,
       ouvintesAnteriores AS ouvintesPeriodoAnterior,
       ouvintesRecentes AS ouvintesPeriodoAtual,
       CASE 
         WHEN ouvintesAnteriores > 0 
         THEN ROUND(100.0 * (ouvintesRecentes - ouvintesAnteriores) / ouvintesAnteriores, 2)
         ELSE 0.0
       END AS percentualCrescimento,
       ROUND(escutasRecentes / 30.0, 2) AS mediaDiariaEscutas,
       ROUND(COALESCE(duracaoMedia, 0) / 60, 2) AS duracaoMediaMinutos
ORDER BY percentualCrescimento DESC
LIMIT 5;