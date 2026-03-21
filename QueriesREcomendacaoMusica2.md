# Análise de Recomendações Musicais - Queries Neo4j

## 📌 Sobre o Banco de Dados
Este documento contém 10 queries Cypher desenvolvidas para análise de comportamento musical e recomendação personalizada. As consultas exploram as interações dos usuários (escuta, curtidas, seguidores) com músicas, artistas e gêneros musicais.

### Estrutura do Banco de Dados

#### Nós e Propriedades
| Nó | Propriedades |
|-----|--------------|
| **User** | id, name, age, gender, city |
| **Artist** | id, name, type (Soloist/Band), countryOfOrigin, startYear |
| **Genre** | id, name, description, predominantEra, hexColor |
| **Song** |title ,track_popularity ,playlist_subgenre , playlist_name , playlist_id , mode , loudness , energy, danceability , album_release_date , danceability , acousticness |


#### Relacionamentos e Propriedades
| Relacionamento | Propriedades |
|----------------|--------------|
| **LISTENED** (User→Song) | timestamp, device, listeningDurationSec, liked, context |
| **LIKED** (User→Song) | timestamp, device |
| **FOLLOWS** (User→Artist) | startDate, notificationsActive |
| **COMPOSED** (Artist→Song) | participationType |
| **BELONGS_TO** (Song→Genre) | relevance |

---

## 📋 Índice das Queries
1. [Gêneros mais escutados por faixa etária](#query-1-gêneros-mais-escutados-por-faixa-etária)
2. [Gêneros mais curtidos pelos usuários](#query-2-gêneros-mais-curtidos-pelos-usuários)
3. [Artistas mais seguidos](#query-3-artistas-mais-seguidos)
4. [Músicas mais escutadas por contexto](#query-4-músicas-mais-escutadas-por-contexto)
5. [Artistas mais influentes (score combinado)](#query-5-artistas-mais-influentes-score-combinado)
6. [Recomendação de músicas baseada em curtidas](#query-6-recomendação-de-músicas-baseada-em-curtidas)
7. [Usuários com gostos similares](#query-7-usuários-com-gostos-similares)
8. [Usuários com gostos similares adaptação](#query-8-usuários-com-gostos-similares-adaptação)
9. [Usuários com gostos similares foco em gênero mais abrangente](#query-9-usuários-com-gostos-similares-foco-em-gênero-mais-abrangente)
10. [Análise de engajamento por dispositivo](#query-10-análise-de-engajamento-por-dispositivo)
11. [Músicas antigas com alta popularidade atual](#query-11-músicas-antigas-com-alta-popularidade-atual)
12. [Artistas em alta (últimos 30 dias)](#query-12-artistas-em-alta-últimos-30-dias)

---

## Query 1: Gêneros mais escutados por faixa etária
**Objetivo:** Identificar quais gêneros predominam em cada faixa etária para recomendar músicas apropriadas.

```//cypher

// Classificação por faixa etária: Jovens (18-25), Adultos (26-35), Adultos+ (36+)

MATCH (u:User)-[l:LISTENED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
WITH 
  CASE 
    WHEN u.age < 26 THEN 'Jovens (18-25)'
    WHEN u.age < 36 THEN 'Adultos (26-35)'
    ELSE 'Adultos+ (36+)'
  END AS faixaEtaria,
  g.name AS genero,
  COUNT(*) AS totalEscutas
WITH faixaEtaria, genero, totalEscutas
ORDER BY faixaEtaria, totalEscutas DESC
RETURN faixaEtaria, genero, totalEscutas;

```

💡 Recomendação: Utilize esta query para criar playlists segmentadas por idade. Por exemplo, se "Electropop" é predominante entre jovens, destaque este gênero na homepage para usuários de 18-25 anos. Se "Pop" domina entre adultos, personalize as recomendações de acordo.

Exemplo de resultado esperado:

|**faixaEtaria** |	**gênero** |  **totalEscutas** |	**percentualNaFaixa** |
|------------|---------|---------|---------|
|Jovens (18-25) |	Electropop	| 1.245	| 42,5%|
|Jovens (18-25)	| Dance Pop|	890	| 30,4%|
|Adultos (26-35) |	Pop	| 1.567	| 38,2%|


## Query 2: Gêneros mais curtidos pelos usuários

**Objetivo**: Descobrir quais gêneros geram mais engajamento positivo (curtidas).

``` //cypher

MATCH (u:User)-[:LIKED]->(s:Song)-[:BELONGS_TO]->(g:Genre)
RETURN g.name AS genero, 
       COUNT(*) AS totalCurtidas,
       COUNT(DISTINCT u) AS usuariosUnicos,
       ROUND(AVG(s.popularity), 2) AS popularidadeMedia
ORDER BY totalCurtidas DESC
LIMIT 5;
```

💡 Recomendação: Os gêneros mais curtidos devem receber destaque na seção "Recomendados para você" e em campanhas de marketing. Considere criar coleções especiais como "O melhor do [Gênero]" baseadas nestes resultados.

Exemplo de resultado esperado:

|**genero**	|**totalCurtidas**| **usuariosUnicos** | **popularidadeMedia**|
|:---|:----:|:----:|---:|
|Dance Pop	|3.245|	187	|78,5|
|Electropop	|2.890|	156	|82,3|
|Pop	|2.567|	203| 71,8|


## Query 3: Artistas mais seguidos

**Objetivo**: Identificar os artistas com maior base de fãs e engajamento.

``` //
//cypher
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
```

💡 Recomendação: Artistas mais seguidos devem receber prioridade em notificações sobre novos lançamentos. Use estes dados para negociações de parcerias e para posicionamento estratégico na plataforma.

Exemplo de resultado esperado:

| **Artista** | **Tipo** | **País** | **Total de Seguidores** | **Percentual de Notificações Ativas** | **Curtidas em Músicas** |
| :--- | :--- | :--- | :--- | :--- | :--- |
| Ed Sheeran | Soloist | United Kingdom | 156 | 87,5% | 892 |
| Dua Lipa | Soloist | United Kingdom | 142 | 91,2% | 1.245 |


## Query 4: Músicas mais escutadas por contexto

**Objetivo**: Entender o comportamento de consumo em diferentes contextos (Workout, Home, Commute, Party).

``` //
//cypher
MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN l.context AS contexto,
       s.title AS musica,
       s.popularity AS popularidade,
       COUNT(*) AS totalEscutas,
       ROUND(AVG(l.listeningDurationSec) / 60, 2) AS duracaoMediaMinutos,
       ROUND(100.0 * SUM(CASE WHEN l.liked THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxaCurtida
ORDER BY contexto, totalEscutas DESC;
```

💡 Recomendação: Crie playlists contextuais baseadas nestes dados, como "Músicas para Trabalhar", "Playlist Festa", "Relax em Casa" e "Trilha para o Treino". Isso aumenta o engajamento e o tempo de uso do app.

Exemplo de resultado esperado:

contexto	musica	popularidade	totalEscutas	duracaoMediaMinutos	taxaCurtida
Workout	"Don't Start Now"	97	342	3,2	78,5%
Party	"One Kiss"	85	289	3,8	82,1%


## Query 5: Artistas mais influentes (score combinado)

**Objetivo**: Calcular um score de influência combinando múltiplos fatores (escutas, curtidas, seguidores, popularidade).

``` //
//cypher

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

```

💡 Recomendação: Utilize este score para determinar quais artistas merecem destaque na página inicial, em newsletters e em campanhas de parceria. Artistas com alto score podem ser priorizados para features exclusivas.

Exemplo de resultado esperado:

| **Artista** | **Tipo** | **Total de Músicas** | **Popularidade Média** | **Ouvintes Únicos** | **Fãs que Curtem** | **Seguidores** | **Score de Influência** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Dua Lipa | Soloist | 12 | 86,5 | 1.245 | 892 | 142 | 98,3 |
| Ed Sheeran | Soloist | 15 | 82,3 | 1.189 | 845 | 156 | 96,7 |


## Query 6: Recomendação de músicas baseada em curtidas

**Objetivo**: Sugerir novas músicas para um usuário baseado nos gêneros que ele já curtiu.

``` //
//cypher

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
```

💡 Recomendação: Implemente este algoritmo na seção "Recomendados para você" do seu app. Combine com filtros de popularidade para garantir sugestões de qualidade que o usuário provavelmente ainda não conhece.

Exemplo de resultado esperado:

| **Música Sugerida** | **Gênero** | **Popularidade** | **Ano de Lançamento** | **Total Curtidas Outros Usuários** |
| :--- | :--- | :--- | :--- | :--- |
| "Levitating" | Dance Pop | 98 | 2020 | 245 |
| "Physical" | Dance Pop | 95 | 2020 | 198 |


## Query 7: Usuários com gostos similares

**Objetivo**: Encontrar usuários com padrões de curtidas semelhantes para recomendações sociais.

```
    //cypher

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
```


## Query 8: Usuários com gostos similares adaptação 

**Objetivo**:  Relacionamentos PERTENCE_A (Song -> Genre) Aqui está uma versão mais flexível que se adapta à realidade do seu banco: 

``` 
// cypher

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
```

## Query 9: Usuários com gostos similares foco em gênero mais abrangente

**Objetivo**:  Relacionamentos PERTENCE_A (Song -> Genre) 
```
// cypher 
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
```

💡 Recomendação: Use estes dados para criar features sociais como "Amigos com gostos parecidos" ou "Descobertas baseadas em usuários similares". As sugestões musicais podem ser apresentadas como "Pessoas como você também curtem...".

Exemplo de resultado esperado:

| **Usuário Similar** | **Idade** | **Cidade** | **Músicas em Comum** | **Sugestões Musicais** |
| :--- | :--- | :--- | :--- | :--- |
| Maria Santos | 28 | Rio de Janeiro | 7 | ["Don't Start Now", "Physical", "Levitating"] |
| Pedro Oliveira | 32 | Belo Horizonte | 5 | ["Break My Heart", "New Rules", "IDGAF"] |


## Query 10: Análise de engajamento por dispositivo

**Objetivo**: Identificar padrões de consumo e preferências por tipo de dispositivo.

```
   // cypher

MATCH (u:User)-[l:LISTENED]->(s:Song)
RETURN l.device AS dispositivo,
       COUNT(*) AS totalEscutas,
       COUNT(DISTINCT u) AS usuariosAtivos,
       ROUND(AVG(l.listeningDurationSec), 2) AS duracaoMediaSegundos,
       ROUND(AVG(s.durationSec), 2) AS duracaoMediaMusicas,
       ROUND(100.0 * SUM(CASE WHEN l.liked THEN 1 ELSE 0 END) / COUNT(*), 2) AS taxaCurtida,
       COLLECT(DISTINCT l.context)[0..3] AS contextosPopulares
ORDER BY totalEscutas DESC;
```

💡 Recomendação: Otimize a experiência do usuário por dispositivo. Se Mobile tem maior taxa de curtida, invista em UI/UX mobile-first. Se Desktop tem sessões mais longas, foque em features de descoberta e playlists estendidas.

Exemplo de resultado esperado:

| **Dispositivo** | **Total de Escutas** | **Usuários Ativos** | **Duração Média (Segundos)** | **Duração Média (Músicas)** | **Taxa de Curtida** | **Contextos Populares** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Mobile | 8.345 | 72 | 142,5 | 198,3 | 67,5% | ["Commute", "Workout", "Home"] |
| Desktop | 3.890 | 45 | 245,8 | 201,2 | 72,3% | ["Home", "Work"] |

## Query 11: Músicas antigas com alta popularidade atual

**Objetivo**: Encontrar músicas de anos anteriores que mantêm relevância e são frequentemente escutadas.

``` //
//cypher

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
```

💡 Recomendação: Crie uma playlist "Clássicos que nunca morrem" baseada nestas músicas. Use para campanhas de nostalgia e para engajar usuários mais velhos. Estas músicas têm alto potencial para playlists temáticas.

Exemplo de resultado esperado:

| **Música** | **Ano de Lançamento** | **Artista** | **Popularidade Atual** | **Escutas Recentes** | **Diversidade de Contextos** | **Contextos Onde Toca** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| "Wake Me Up" | 2013 | Avicii | 84 | 567 | 4 | ["Workout", "Party", "Home", "Commute"] |
| "Counting Stars" | 2013 | OneRepublic | 80 | 432 | 4 | ["Home", "Workout", "Commute"] |

## Query 12: Artistas em alta (últimos 30 dias)

**Objetivo**: Identificar artistas com crescimento significativo de ouvintes no período recente.

``` //
//cypher

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

```

💡 Recomendação: Destaque estes artistas em banners promocionais e na seção "Em alta" do aplicativo. Use para identificar tendências emergentes e negociar parcerias com artistas em crescimento.

Exemplo de resultado esperado:

| **Artista** | **Tipo** | **Ouvintes Últimos 30 Dias** | **Ouvintes Novos** | **Percentual de Crescimento** | **Média Diária de Escutas** | **Duração Média (Minutos)** |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| Billie Eilish | Soloist | 45 | 89 | 97,78% | 12,5 | 3,2 |
| Dua Lipa | Soloist | 156 | 245 | 57,05% | 18,3 | 3,5 |

## 📊 Resumo das Queries e Aplicações

| **#** | **Query** | **Foco Principal** | **Aplicação Prática** |
| :--- | :--- | :--- | :--- |
| 1 | Gênero por faixa etária | Segmentação demográfica | Playlists personalizadas por idade |
| 2 | Gêneros mais curtidos | Engajamento positivo | Destaques na homepage e campanhas |
| 3 | Artistas mais seguidos | Base de fãs | Notificações prioritárias e parcerias |
| 4 | Contexto de escuta | Comportamento situacional | Playlists contextuais |
| 5 | Score de influência | Ranking multi-fator | Posicionamento estratégico de artistas |
| 6 | Recomendação por curtidas | Personalização | Seção "Recomendados para você" |
| 7 | Usuários similares | Recomendação social | Features de descoberta social |
| 8 | Usuários similares | Recomendação social adaptada| Features de descoberta social |
| 9 | Usuários similares | Recomendação social gênero | Features de descoberta social |
| 10 | Análise por dispositivo | Otimização UX | Melhorias de interface por plataforma |
| 11 | Músicas antigas populares | Curadoria de catálogo | Playlist "Clássicos" e campanhas nostálgicas |
| 12 | Artistas em alta | Detecção de tendências | Seção "Em alta" e identificação de novos talentos |

## 🚀 Como Executar as Queries

**Identifique os IDs reais:** Substitua os placeholders como 'user_efd9d1d5-bdfc-46ae-9d10-96952e295232' pelos IDs existentes no seu banco.

**Ajuste períodos:** Modifique os intervalos de data conforme necessário (ex: P30D para 30 dias, P180D para 6 meses).

**Limites:** Ajuste o LIMIT para obter mais ou menos resultados.

## 🚀 Melhorias de Performace das Queries

**Performance:** Considere criar índices para as propriedades mais consultadas, especialmente User.id, Song.releaseYear e LISTENED.timestamp.

### Nota: 

**Todas as queries foram desenvolvidas considerando a estrutura do banco de dados. Execute-as em ordem para garantir a criação correta das análises e recomendações.**

