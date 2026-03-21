
// *****************************************************************
//     BLOCO 7
/*    Problema na carga estamos randomizando a massa para os arqtista e gêneros, para evitar que tenhamos músicas 
   sem gênero ou sem artista, o que prejudicaria a análise de recomendação posteriormente.
      Atualização randômica de playlist_genre para todas as músicas
*/
// *****************************************************************
MATCH (s:Song)
WITH s, toInteger(rand() * 7) AS seletor
SET s.playlist_genre = 
    CASE seletor
        WHEN 0 THEN 'Pop'
        WHEN 1 THEN 'Dance Pop'
        WHEN 2 THEN 'Electropop'
        WHEN 3 THEN 'Post-Teen Pop'
        WHEN 4 THEN 'Rock'
        WHEN 5 THEN 'New Age'
        ELSE 'Indie Poptimism'
    END;
// *****************************************************************
//     BLOCO 7
// Querys de analise de integridade e amostras de dados 
// Relacionamentos duplicados (mesma música ligada ao mesmo gênero mais de uma vez)
// *****************************************************************
MATCH (s:Song)-[r:BELONGS_TO]->(g:Genre)
WITH s, g, count(r) AS TotalRelacionamentos
WHERE TotalRelacionamentos > 1
RETURN SUM(TotalRelacionamentos - 1) AS Total_Geral_de_Duplicatas;

// Listar músicas com mais de um relacionamento BELONGS_TO para o mesmo gênero
MATCH (s:Song)-[r:BELONGS_TO]->(g:Genre)
WITH s, g, count(r) AS TotalRelacionamentos
WHERE TotalRelacionamentos > 1
RETURN 
    s.title AS Musica, 
    g.name AS Genero, 
    TotalRelacionamentos,
    (TotalRelacionamentos - 1) AS Setas_Excedentes
ORDER BY TotalRelacionamentos DESC;

//Para identificar se existem relacionamentos duplicados (ou seja, uma mesma música conectada ao mesmo gênero mais de uma vez), você pode usar uma query de agrupamento.
//No Neo4j, se você usou CREATE em vez de MERGE durante a carga, é muito comum que isso aconteça.
//Aqui estão as queries para diagnosticar e resolver:
//1. Identificar Músicas com Relacionamentos Duplicados
//Esta query agrupa por música e gênero e conta quantas conexões existem entre eles. Se o TotalConexoes for maior que 1, há duplicidade.
//Cypher
MATCH (s:Song)-[r:BELONGS_TO]->(g:Genre)
WITH s, g, count(r) AS TotalConexoes
WHERE TotalConexoes > 1
return s.title AS Musica, g.name AS Genero, TotalConexoes
ORDER BY TotalConexoes DESC;

//1. Contagem Total de Relacionamentos
//Esta query retorna o número total de conexões entre Músicas e Gêneros:
//Cypher
MATCH (:Song)-[r:BELONGS_TO]->(:Genre)
RETURN count(r) AS TotalRelacionamentos;

//4. Verificar Músicas "Órfãs" (Sem Gênero)
//Para saber quantas músicas não conseguiram se conectar a nenhum gênero (o que indica que o MATCH do Bloco 7 falhou para elas):
MATCH (s:Song)
WHERE NOT (s)-[:BELONGS_TO]->(:Genre)
RETURN count(s) AS MusicasSemGenero;



// *****************************************************************
// Auditoria de qualidade do bloco 8
// *****************************************************************
//Para garantir que sua base de dados está íntegra e sem "nós órfãos" (nós que deveriam estar conectados, mas ficaram isolados), preparei um conjunto de queries de auditoria.
//No seu modelo, um nó é considerado órfão se não possui os relacionamentos essenciais: COMPOSED, BELONGS_TO ou LISTENED.

//1. Músicas Órfãs (Sem Autor ou Sem Gênero)
//Esta é a verificação mais crítica, pois toda música no seu sistema deveria ter um artista e um gênero.
Cypher
MATCH (s:Song)
WHERE NOT (s)<-[:COMPOSED]-(:Artist) 
   OR NOT (s)-[:BELONGS_TO]->(:Genre)
RETURN 
    s.title AS Musica_Orfa,
    NOT (s)<-[:COMPOSED]-(:Artist) AS Sem_Artista,
    NOT (s)-[:BELONGS_TO]->(:Genre) AS Sem_Genero
LIMIT 20;

//2. Artistas "Fantasmagóricos" (Sem Músicas)
//Artistas que foram criados (seja no Bloco 3 ou via MERGE no Bloco 6), mas não possuem nenhuma música associada a eles no grafo.

Cypher
MATCH (a:Artist)
WHERE NOT (a)-[:COMPOSED]->(:Song)
RETURN a.name AS Artista_Sem_Obra, a.type AS Tipo
ORDER BY a.name;

//3. Gêneros Vazios
//Verifica se você criou algum gênero no Bloco 2 que não recebeu nenhuma música do CSV no Bloco 7 (provavelmente por erro de Case Sensitivity que corrigimos).

Cypher
MATCH (g:Genre)
WHERE NOT (:Song)-[:BELONGS_TO]->(g)
RETURN g.name AS Genero_Vazio, g.description AS Descricao;

//4. Usuários Inativos (Sem Histórico de Escuta)
//Verifica se o Bloco 8 falhou para algum usuário, deixando-o sem nenhuma música no histórico.

Cypher
MATCH (u:User)
WHERE NOT (u)-[:LISTENED]->(:Song)
RETURN u.name AS Usuario_Inativo, u.city AS Cidade;

//5. Auditoria Geral de Isolamento (Nós 100% Soltos)
//Esta query é a mais "pesada" e serve para encontrar qualquer nó que não tenha nenhum relacionamento de qualquer tipo. É o órfão absoluto.

Cypher
MATCH (n)
WHERE COUNT { (n)--() } = 0
RETURN labels(n) AS Tipo_No, count(n) AS Total_Isolados;

//Como interpretar os resultados?
//Muitas Músicas sem Artista: Provavelmente o MATCH do Bloco 6 falhou porque o nome do artista no CSV não era exatamente igual ao que você criou manualmente.
//Gêneros Vazios: Indica que a normalização de texto (Pop vs pop) no Bloco 7 precisa de ajuste.
//Usuários Inativos: Geralmente ocorre se o Bloco 8 não foi executado ou se houve erro no apoc.coll.randomItems.
//Dica: Se você encontrar muitos órfãos, o ideal é usar o comando MATCH (n) DETACH DELETE n e rodar os blocos corrigidos na sequência correta (1 ao 8).


///Para verificar duplicidade no Bloco 8, precisamos ajustar o tipo de relacionamento. No seu código, o Bloco 8 cria o relacionamento [:LISTENED] (usuário escuta música), enquanto o [:BELONGS_TO] pertence ao Bloco 7 (música pertence a gênero).
//Como o relacionamento [:LISTENED] possui propriedades como timestamp e device, uma duplicidade real seria o mesmo usuário ter escutado a mesma música múltiplas vezes de forma idêntica ou excessiva.
//Aqui está a query refatorada para auditar o Bloco 8:
//1. Verificar Duplicidade Direta (Usuário x Música)
//Esta query identifica se um usuário tem mais de um registro de "escuta" para a mesma música.
Cypher
MATCH (u:User)-[r:LISTENED]->(s:Song)
WITH u, s, count(r) AS TotalEscutas
WHERE TotalEscutas > 1
RETURN 
    u.name AS Usuario, 
    s.title AS Musica, 
    TotalEscutas,
    (TotalEscutas - 1) AS Registros_Duplicados
ORDER BY TotalEscutas DESC;


//2. Verificar Duplicidade por Propriedade (Timestamp)
//Se você quer saber se houve um erro de carga que criou a mesma escuta no mesmo exato momento:
Cypher
MATCH (u:User)-[r:LISTENED]->(s:Song)
WITH u, s, r.timestamp AS datahora, count(r) AS ocorrencias
WHERE ocorrencias > 1
RETURN u.name, s.title, datahora, ocorrencias;


//3. Resumo Geral de "Lixo" no Bloco 8
//Se você quer apenas um número para saber o quão "sujo" está o relacionamento de escuta:
Cypher
MATCH (u:User)-[r:LISTENED]->(s:Song)
WITH u, s, count(r) AS Total
WHERE Total > 1
RETURN SUM(Total - 1) AS Total_Geral_Duplicatas_Bloco8;

//Por que isso pode ter acontecido?
//Uso de CREATE: No seu código original do Bloco 8, você usou CREATE. Se você rodou o bloco duas vezes, ele duplicou tudo.
//Falta de Unique Constraint: O Neo4j não impede dois relacionamentos iguais entre os mesmos nós a menos que você use MERGE ou uma restrição de unicidade na relação (disponível apenas em versões Enterprise/específicas).
//Dica: Se o resultado da Query 1 for alto, recomendo deletar os relacionamentos LISTENED e rodar novamente usando a versão com MERGE que te sugeri anteriormente.


//Query de Limpeza: Deletar Músicas Órfãs
Cypher
MATCH (s:Song)
// Filtra músicas sem artista OU sem gênero
WHERE NOT (s)<-[:COMPOSED]-(:Artist) 
   OR NOT (s)-[:BELONGS_TO]->(:Genre)
// O DETACH garante que remova a música mesmo se houver outros relacionamentos
DETACH DELETE s;


