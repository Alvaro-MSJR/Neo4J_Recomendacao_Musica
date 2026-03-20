Match (n) DETACH DELETE n;

DROP CONSTRAINT unique_song IF EXISTS;
DROP CONSTRAINT unique_song_title IF EXISTS;
DROP CONSTRAINT song_composite_key IF EXISTS;

DROP CONSTRAINT unique_artist IF EXISTS;
DROP CONSTRAINT unique_artist_name IF EXISTS;
DROP CONSTRAINT artist_composite_key IF EXISTS;

DROP CONSTRAINT unique_genre IF EXISTS;
DROP CONSTRAINT unique_genre_name IF EXISTS;
DROP CONSTRAINT genre_composite_key IF EXISTS;

DROP CONSTRAINT unique_user IF EXISTS;
DROP CONSTRAINT unique_user_name IF EXISTS;
DROP CONSTRAINT user_composite_key IF EXISTS;

//BLOCO 1: Criação das Constraints (Índices de Unicidade)
//cypher
// Criar constraints para garantir unicidade e performance
CREATE CONSTRAINT unique_song IF NOT EXISTS FOR (s:Song) REQUIRE s.id IS UNIQUE;
CREATE CONSTRAINT unique_song_title IF NOT EXISTS FOR (s:Song) REQUIRE s.title IS UNIQUE;
CREATE CONSTRAINT song_composite_key IF NOT EXISTS
FOR (s:Song) REQUIRE (s.id, s.title) IS NODE KEY;

CREATE CONSTRAINT unique_artist IF NOT EXISTS FOR (a:Artist) REQUIRE a.id IS UNIQUE;
CREATE CONSTRAINT unique_artist_name IF NOT EXISTS FOR (a:Artist) REQUIRE a.name IS UNIQUE;
CREATE CONSTRAINT artist_composite_key IF NOT EXISTS
FOR (a:Artist) REQUIRE (a.id, a.name) IS NODE KEY;

CREATE CONSTRAINT unique_genre IF NOT EXISTS FOR (g:Genre) REQUIRE g.id IS UNIQUE;
CREATE CONSTRAINT unique_genre_name IF NOT EXISTS FOR (g:Genre) REQUIRE g.name IS UNIQUE;
CREATE CONSTRAINT genre_composite_key IF NOT EXISTS
FOR (g:Genre) REQUIRE (g.id, g.name) IS NODE KEY;

CREATE CONSTRAINT unique_user IF NOT EXISTS FOR (u:User) REQUIRE u.id IS UNIQUE;
CREATE CONSTRAINT unique_user_name IF NOT EXISTS FOR (u:User) REQUIRE u.name IS UNIQUE;
CREATE CONSTRAINT user_composite_key IF NOT EXISTS
FOR (u:User) REQUIRE (u.id, u.name) IS NODE KEY;

//BLOCO 2: Criação dos Gêneros Musicais
//cypher
// Criar gêneros com todas as propriedades necessárias
CREATE (g1:Genre {
    id: 'genre_001',
    name: 'Pop',
    description: 'Música pop contemporânea com foco em melodias cativantes e produção comercial',
    predominantEra: '2010s',
    hexColor: '#FF69B4'
})

CREATE (g2:Genre {
    id: 'genre_002',
    name: 'Dance Pop',
    description: 'Pop com batidas dançantes e elementos de música eletrônica',
    predominantEra: '2010s',
    hexColor: '#FF1493'
})

CREATE (g3:Genre {
    id: 'genre_003',
    name: 'Electropop',
    description: 'Pop fortemente influenciado por sintetizadores e produção eletrônica',
    predominantEra: '2010s',
    hexColor: '#9400D3'
})

CREATE (g4:Genre {
    id: 'genre_004',
    name: 'Post-Teen Pop',
    description: 'Pop voltado para jovens adultos com temáticas mais maduras',
    predominantEra: '2010s',
    hexColor: '#4B0082'
})

CREATE (g5:Genre {
    id: 'genre_005',
    name: 'Indie Poptimism',
    description: 'Fusão de indie rock com produção pop refinada',
    predominantEra: '2010s',
    hexColor: '#20B2AA'
});

//BLOCO 3: Criação dos Artistas
//cypher
// Criar artistas com todas as propriedades necessárias
CREATE (a1:Artist {
    id: 'artist_001',
    name: 'Ed Sheeran',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2004
})

CREATE (a2:Artist {
    id: 'artist_002',
    name: 'Maroon 5',
    type: 'Band',
    countryOfOrigin: 'USA',
    startYear: 1994
})

CREATE (a3:Artist {
    id: 'artist_003',
    name: 'Zara Larsson',
    type: 'Soloist',
    countryOfOrigin: 'Sweden',
    startYear: 2008
})

CREATE (a4:Artist {
    id: 'artist_004',
    name: 'The Chainsmokers',
    type: 'Band',
    countryOfOrigin: 'USA',
    startYear: 2012
})

CREATE (a5:Artist {
    id: 'artist_005',
    name: 'Lewis Capaldi',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2017
})

CREATE (a6:Artist {
    id: 'artist_006',
    name: 'Katy Perry',
    type: 'Soloist',
    countryOfOrigin: 'USA',
    startYear: 2001
})

CREATE (a7:Artist {
    id: 'artist_007',
    name: 'Sam Feldt',
    type: 'Soloist',
    countryOfOrigin: 'Netherlands',
    startYear: 2014
})

CREATE (a8:Artist {
    id: 'artist_008',
    name: 'Avicii',
    type: 'Soloist',
    countryOfOrigin: 'Sweden',
    startYear: 2006
})

CREATE (a9:Artist {
    id: 'artist_009',
    name: 'Shawn Mendes',
    type: 'Soloist',
    countryOfOrigin: 'Canada',
    startYear: 2013
})

CREATE (a10:Artist {
    id: 'artist_010',
    name: 'Ellie Goulding',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2009
})

CREATE (a11:Artist {
    id: 'artist_011',
    name: 'Loud Luxury',
    type: 'Band',
    countryOfOrigin: 'Canada',
    startYear: 2012
})

CREATE (a12:Artist {
    id: 'artist_012',
    name: 'Martin Garrix',
    type: 'Soloist',
    countryOfOrigin: 'Netherlands',
    startYear: 2012
})

CREATE (a13:Artist {
    id: 'artist_013',
    name: 'David Guetta',
    type: 'Soloist',
    countryOfOrigin: 'France',
    startYear: 1984
})

CREATE (a14:Artist {
    id: 'artist_014',
    name: 'Sam Smith',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2007
})

CREATE (a15:Artist {
    id: 'artist_015',
    name: 'Kygo',
    type: 'Soloist',
    countryOfOrigin: 'Norway',
    startYear: 2009
})

CREATE (a16:Artist {
    id: 'artist_016',
    name: 'Billie Eilish',
    type: 'Soloist',
    countryOfOrigin: 'USA',
    startYear: 2015
})

CREATE (a17:Artist {
    id: 'artist_017',
    name: 'Dua Lipa',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2013
})

CREATE (a18:Artist {
    id: 'artist_018',
    name: 'Calvin Harris',
    type: 'Soloist',
    countryOfOrigin: 'United Kingdom',
    startYear: 2002
});

//BLOCO 4: Criação dos Usuários (80 usuários)
//cypher
// Criar 80 usuários com nome composto, idade, sexo e cidade
UNWIND [
    {nome: 'João Silva', idade: 25, sexo: 'M', cidade: 'São Paulo'},
    {nome: 'Maria Santos', idade: 28, sexo: 'F', cidade: 'Rio de Janeiro'},
    {nome: 'Pedro Oliveira', idade: 32, sexo: 'M', cidade: 'Belo Horizonte'},
    {nome: 'Ana Souza', idade: 22, sexo: 'F', cidade: 'Salvador'},
    {nome: 'Lucas Pereira', idade: 29, sexo: 'M', cidade: 'Brasília'},
    {nome: 'Juliana Costa', idade: 26, sexo: 'F', cidade: 'Curitiba'},
    {nome: 'Marcos Rodrigues', idade: 35, sexo: 'M', cidade: 'Fortaleza'},
    {nome: 'Camila Almeida', idade: 24, sexo: 'F', cidade: 'Manaus'},
    {nome: 'Rafael Nascimento', idade: 31, sexo: 'M', cidade: 'Recife'},
    {nome: 'Beatriz Lima', idade: 27, sexo: 'F', cidade: 'Porto Alegre'},
    {nome: 'Gabriel Fernandes', idade: 23, sexo: 'M', cidade: 'Belém'},
    {nome: 'Larissa Gomes', idade: 29, sexo: 'F', cidade: 'Goiânia'},
    {nome: 'Felipe Martins', idade: 34, sexo: 'M', cidade: 'Guarulhos'},
    {nome: 'Mariana Ribeiro', idade: 26, sexo: 'F', cidade: 'Campinas'},
    {nome: 'Bruno Carvalho', idade: 30, sexo: 'M', cidade: 'São Luís'},
    {nome: 'Isabela Teixeira', idade: 25, sexo: 'F', cidade: 'Maceió'},
    {nome: 'Diego Cardoso', idade: 28, sexo: 'M', cidade: 'Duque de Caxias'},
    {nome: 'Letícia Dias', idade: 24, sexo: 'F', cidade: 'Natal'},
    {nome: 'Leonardo Barros', idade: 33, sexo: 'M', cidade: 'Teresina'},
    {nome: 'Vitória Mendes', idade: 22, sexo: 'F', cidade: 'Campo Grande'},
    {nome: 'Guilherme Rocha', idade: 27, sexo: 'M', cidade: 'Santo André'},
    {nome: 'Manuela Vieira', idade: 29, sexo: 'F', cidade: 'João Pessoa'},
    {nome: 'Enzo Araújo', idade: 21, sexo: 'M', cidade: 'Jaboatão dos Guararapes'},
    {nome: 'Valentina Castro', idade: 26, sexo: 'F', cidade: 'São José dos Pinhais'},
    {nome: 'Matheus Freitas', idade: 31, sexo: 'M', cidade: 'Contagem'},
    {nome: 'Helena Barbosa', idade: 28, sexo: 'F', cidade: 'Uberlândia'},
    {nome: 'Gustavo Moreira', idade: 32, sexo: 'M', cidade: 'Sorocaba'},
    {nome: 'Sophia Monteiro', idade: 24, sexo: 'F', cidade: 'Ribeirão Preto'},
    {nome: 'Arthur Lopes', idade: 27, sexo: 'M', cidade: 'Cuiabá'},
    {nome: 'Alice Cavalcanti', idade: 25, sexo: 'F', cidade: 'Aracaju'},
    {nome: 'Samuel Macedo', idade: 30, sexo: 'M', cidade: 'Feira de Santana'},
    {nome: 'Laura Peixoto', idade: 23, sexo: 'F', cidade: 'Londrina'},
    {nome: 'Vinicius Correia', idade: 29, sexo: 'M', cidade: 'Joinville'},
    {nome: 'Giovanna Andrade', idade: 26, sexo: 'F', cidade: 'Niterói'},
    {nome: 'Emanuel Fogaça', idade: 34, sexo: 'M', cidade: 'Belford Roxo'},
    {nome: 'Clara Tavares', idade: 22, sexo: 'F', cidade: 'Santos'},
    {nome: 'Breno Cunha', idade: 31, sexo: 'M', cidade: 'Ananindeua'},
    {nome: 'Eduarda Assunção', idade: 27, sexo: 'F', cidade: 'Campos dos Goytacazes'},
    {nome: 'Enrico Melo', idade: 25, sexo: 'M', cidade: 'São Gonçalo'},
    {nome: 'Isadora Viana', idade: 28, sexo: 'F', cidade: 'Caxias do Sul'},
    {nome: 'João Pedro Santana', idade: 24, sexo: 'M', cidade: 'Mauá'},
    {nome: 'Ana Clara Duarte', idade: 26, sexo: 'F', cidade: 'São José do Rio Preto'},
    {nome: 'Pedro Henrique Pires', idade: 29, sexo: 'M', cidade: 'Mogi das Cruzes'},
    {nome: 'Maria Eduarda Ramos', idade: 23, sexo: 'F', cidade: 'Betim'},
    {nome: 'Carlos Eduardo Aguiar', idade: 32, sexo: 'M', cidade: 'Diadema'},
    {nome: 'Ana Laura Fonseca', idade: 25, sexo: 'F', cidade: 'Jundiaí'},
    {nome: 'Luiz Fernando Amorim', idade: 30, sexo: 'M', cidade: 'Maringá'},
    {nome: 'Maria Cecília Bueno', idade: 27, sexo: 'F', cidade: 'Campina Grande'},
    {nome: 'José Antônio Siqueira', idade: 35, sexo: 'M', cidade: 'Piracicaba'},
    {nome: 'Ana Júlia Ferraz', idade: 24, sexo: 'F', cidade: 'Cariacica'},
    {nome: 'Luiz Felipe Padilha', idade: 28, sexo: 'M', cidade: 'Bauru'},
    {nome: 'Maria Luiza Nunes', idade: 26, sexo: 'F', cidade: 'Porto Velho'},
    {nome: 'João Gabriel Bittencourt', idade: 29, sexo: 'M', cidade: 'Canoas'},
    {nome: 'Ana Beatriz Prado', idade: 23, sexo: 'F', cidade: 'Ponta Grossa'},
    {nome: 'Pedro Lucas Muniz', idade: 31, sexo: 'M', cidade: 'Franca'},
    {nome: 'Maria Fernanda Serrano', idade: 25, sexo: 'F', cidade: 'Pelotas'},
    {nome: 'João Miguel Quadros', idade: 27, sexo: 'M', cidade: 'Cascavel'},
    {nome: 'Ana Luiza Vargas', idade: 24, sexo: 'F', cidade: 'Vitória da Conquista'},
    {nome: 'Luiz Gustavo Valente', idade: 33, sexo: 'M', cidade: 'Paulista'},
    {nome: 'Maria Vitória Simões', idade: 26, sexo: 'F', cidade: 'Rio Branco'},
    {nome: 'João Vitor Salgado', idade: 28, sexo: 'M', cidade: 'Blumenau'},
    {nome: 'Ana Elisa Bretas', idade: 25, sexo: 'F', cidade: 'Carapicuíba'},
    {nome: 'Pedro Augusto Azevedo', idade: 30, sexo: 'M', cidade: 'Olinda'},
    {nome: 'Maria Clara Sampaio', idade: 24, sexo: 'F', cidade: 'Anápolis'},
    {nome: 'João Guilherme Fontes', idade: 27, sexo: 'M', cidade: 'Santa Maria'},
    {nome: 'Ana Luísa Veras', idade: 26, sexo: 'F', cidade: 'Itaquaquecetuba'},
    {nome: 'Pedro Miguel Vilar', idade: 29, sexo: 'M', cidade: 'Taboão da Serra'},
    {nome: 'Maria Julia Manso', idade: 23, sexo: 'F', cidade: 'Cabo Frio'},
    {nome: 'João Felipe Seixas', idade: 31, sexo: 'M', cidade: 'Serra'},
    {nome: 'Ana Vitória Hermes', idade: 25, sexo: 'F', cidade: 'Sete Lagoas'},
    {nome: 'Luiz Otávio Gaia', idade: 28, sexo: 'M', cidade: 'Passo Fundo'},
    {nome: 'Maria Isabel Nogueira', idade: 26, sexo: 'F', cidade: 'Dourados'},
    {nome: 'João Lucas Braga', idade: 24, sexo: 'M', cidade: 'Criciúma'},
    {nome: 'Ana Laura Sá', idade: 27, sexo: 'F', cidade: 'Juazeiro do Norte'},
    {nome: 'Pedro Emílio Faria', idade: 30, sexo: 'M', cidade: 'Abaetetuba'},
    {nome: 'Maria Júlia Fontoura', idade: 25, sexo: 'F', cidade: 'Palhoça'},
    {nome: 'João Bernardo Lima', idade: 28, sexo: 'M', cidade: 'Bragança Paulista'},
    {nome: 'Ana Letícia Souza', idade: 26, sexo: 'F', cidade: 'Barreiras'},
    {nome: 'Luiz Henrique Silva', idade: 32, sexo: 'M', cidade: 'Pindamonhangaba'},
    {nome: 'Maria Alice Santos', idade: 24, sexo: 'F', cidade: 'Caçapava'}
] AS userData
CREATE (u:User {
    id: 'user_' + randomUUID(),
    name: userData.nome,
    age: userData.idade,
    gender: userData.sexo,
    city: userData.cidade
});

// VERSÃO DESCONTINUADA, POIS CARREGAVA MUSICAS DUPLICADAS E NÃO RESPEITAVA A NODE KEY (TITLE)
// somente ira funcionar se retirar a constraint de title 
//
//BLOCO 5: Criação das Músicas (baseado no CSV)
//   Extrair ano do release date e converter duração para segundos
//   Cypher
//   LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
//   WITH row
//   LIMIT 720
//   CREATE (s:Song {
//       id: 				'song_' + randomUUID() 									,
//       title: 				row.track_name											,
//       releaseYear: 		toInteger(split(row.track_album_release_date, '-')[0])	,
//       durationSec: 		toInteger(row.duration_ms) / 1000						,
//       popularity: 		toInteger(row.track_popularity)							,
//       playlist_name: 		row.playlist_name				,
//       playlist_genre : 	row.playlist_genre				,
//       track_artist : 		row.track_artist				,
//       album_name : 		row.album_name					,
//       album_release_date: row.track_album_release_date	,
//       playlist_id: 		row.playlist_id					,
//       playlist_subgenre:  row.playlist_subgenre			,	
//       danceability: 		row.danceability				,
//       energy: 			row.energy		    			,
//       loudness: 			row.loudness		    		,
//       mode: 				row.mode		        		,
//       speechiness: 		row.speechiness					,
//       acousticness: 		row.acousticness				,
//       track_popularity: 	toInteger(row.track_popularity)
//   });	

// BLOCO 5: Carga de Músicas com MERGE e tratamento de Node Key
//Cypher
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
WITH row
LIMIT 720

// 1. O MERGE busca apenas pelo título (único)
MERGE (s:Song { title: row.track_name })

// 2. O ON CREATE garante que as propriedades obrigatórias (Node Key) 
// sejam preenchidas no exato momento da criação do nó.
ON CREATE SET 
    s.id = 'song_' + randomUUID(),
    s.releaseYear 		 = toInteger(split(row.track_album_release_date, '-')[0]),
    s.durationSec 		 = toInteger(row.duration_ms) / 1000,
    s.popularity 		 = toInteger(row.track_popularity),
    s.playlist_name 	 = row.playlist_name,
    s.playlist_genre 	 = row.playlist_genre,
    s.track_artist 		 = row.track_artist,
    s.album_name 		 = row.album_name,
    s.album_release_date = row.track_album_release_date,
    s.playlist_id		 = row.playlist_id		,
    s.playlist_subgenre	 = row.playlist_subgenre,	
    s.danceability		 = row.danceability		,
    s.energy		     = row.energy		    ,
    s.loudness		     = row.loudness		    ,
    s.mode		         = row.mode		        ,
    s.speechiness		 = row.speechiness		,
    s.acousticness       = row.acousticness     ,
    s.track_popularity   = toInteger(row.track_popularity)
// 3. (Opcional) Caso queira atualizar a popularidade se a música já existir:
ON MATCH SET 
    s.popularity = toInteger(row.track_popularity);

//
//  DESCONTINUADO
//
//BLOCO 6: Relacionamentos COMPOS (Artist -> Song)
// Conectar artistas às músicas que eles compõem/performam
//Cypher
//  LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
//  WITH row
//  LIMIT 1600
//  MATCH (a:Artist {name: row.track_artist})
//  MATCH (s:Song {title: row.track_name})
//  WHERE s.releaseYear = toInteger(split(row.track_album_release_date, '-')[0])
//  CREATE (a)-[:COMPOSED {
//      participationType: CASE 
//          WHEN row.track_name CONTAINS 'Remix' THEN 'Remixer'
//          WHEN row.track_name CONTAINS 'feat' THEN 'Featured Artist'
//          ELSE 'Main Artist'
//      END
//  }]->(s);

// BLOCO 6: Relacionamentos COMPOSED (Refatorado)  (Artist -> Song)
// Conectar artistas às músicas que eles compõem/performam
//Cypher
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
WITH row
LIMIT 25000

// 1. Usamos MERGE para garantir que o artista exista (mesmo que não esteja no Bloco 3)
MERGE (a:Artist {name: row.track_artist})
ON CREATE SET a.id = 'artist_' + randomUUID(), a.type = 'Unknown'

WITH a, row

// 2. Buscamos a música (que já deve ter sido carregada no Bloco 5)
MATCH (s:Song {title: row.track_name})

WITH a, s, row

// 3. Criamos o relacionamento (usando MERGE para evitar duplicatas se rodar de novo)
MERGE (a)-[r:COMPOSED]->(s)
ON CREATE SET r.participationType = CASE 
        WHEN row.track_name CONTAINS 'Remix' THEN 'Remixer'
        WHEN row.track_name CONTAINS 'feat' THEN 'Featured Artist'
        ELSE 'Main Artist'
    END;

// 
//  DESCONTINUADO, POIS NÃO CARREGAVA CORRETAMENTE OS GENEROS, GERANDO DUPLICIDADE DE RELACIONAMENTO 
//
//BLOCO 7: Relacionamentos PERTENCE_A (Song -> Genre)
// Conectar músicas aos gêneros
// 
//Cypher
// LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
// WITH row
// LIMIT 1600
// MATCH (s:Song {title: row.track_name})
// OPTIONAL MATCH (g:Genre {name: 
//     CASE 
//         WHEN row.playlist_genre = 'pop' THEN 'Pop'
//         WHEN row.playlist_genre = 'dance pop' THEN 'Dance Pop'
//         WHEN row.playlist_genre = 'electropop' THEN 'Electropop'
//         WHEN row.playlist_genre = 'post-teen pop' THEN 'Post-Teen Pop'
//         ELSE 'Indie Poptimism'
//     END
// })
// WHERE g IS NOT NULL
// CREATE (s)-[:BELONGS_TO {
//     relevance: CASE 
//         WHEN toFloat(row.popularity) > 80 THEN 'High'
//         WHEN toFloat(row.popularity) > 60 THEN 'Medium'
//         ELSE 'Low'
//     END
// }]->(g);


// BLOCO 7: Relacionamentos PERTENCE_A (Song -> Genre) - SOLUÇÃO DEFINITIVA
// Conectar músicas aos gêneros
//Cypher
LOAD CSV WITH HEADERS FROM 'https://raw.githubusercontent.com/Alvaro-MSJR/Neo4J_Recomendacao_Musica/refs/heads/main/scripts/archive/spotify_songs.csv' AS row
WITH row
LIMIT 25000

// 1. Localiza a música criada no Bloco 5
MATCH (s:Song {title: row.track_name})

// 2. Normaliza o gênero do CSV para bater com o Bloco 2 (Case Sensitive fix)
WITH s, row,
    CASE 
        WHEN row.playlist_genre IS NULL OR row.playlist_genre = "" THEN 'Indie Poptimism'
        WHEN row.playlist_genre = 'pop' THEN 'Pop'
        WHEN row.playlist_genre = 'dance pop' THEN 'Dance Pop'
        WHEN row.playlist_genre = 'electropop' THEN 'Electropop'
        WHEN row.playlist_genre = 'post-teen pop' THEN 'Post-Teen Pop'
        WHEN row.playlist_genre = 'latin' THEN 'Pop' // Opcional: agrupar gêneros extras
        ELSE row.playlist_genre 
    END AS genreName

// 3. Busca o gênero (agora com o nome corrigido ex: 'Pop')
MATCH (g:Genre {name: genreName})

// 4. Cria o relacionamento garantindo unicidade
MERGE (s)-[r:BELONGS_TO]->(g)
ON CREATE SET r.relevance = 
    CASE 
        WHEN toInteger(row.track_popularity) > 80 THEN 'High'
        WHEN toInteger(row.track_popularity) > 60 THEN 'Medium'
        ELSE 'Low'
    END;

//BLOCO 8: Relacionamentos ESCUTOU (User -> Song)
//cypher
// Criar relacionamentos de escuta entre usuários e músicas
MATCH (u:User)
WITH COLLECT(u) AS users
MATCH (s:Song)
WITH users, COLLECT(s) AS songs
UNWIND users AS user
WITH user, songs, apoc.coll.randomItems(songs, 20) AS listenedSongs
UNWIND listenedSongs AS song
CREATE (user)-[:LISTENED {
    timestamp: datetime() - duration({days: toInteger(rand() * 30)}),
    device: CASE toInteger(rand() * 3)
        WHEN 0 THEN 'Mobile'
        WHEN 1 THEN 'Desktop'
        ELSE 'Tablet'
    END,
    listeningDurationSec: toInteger(rand() * song.durationSec),
    liked: rand() > 0.4,
    context: CASE toInteger(rand() * 3)
        WHEN 0 THEN 'Home'
        WHEN 1 THEN 'Commute'
        WHEN 2 THEN 'Workout'
        ELSE 'Party'
    END
}]->(song);

//BLOCO 9: Relacionamentos CURTIU (User -> Song)
//cypher
// Criar relacionamentos de curtida (30% das músicas escutadas são curtidas)
MATCH (u:User)-[l:LISTENED]->(s:Song)
WHERE l.liked = true
WITH u, s, l.timestamp AS listenTime, l.device AS device
LIMIT 1600
CREATE (u)-[:LIKED {
    timestamp: listenTime + duration({minutes: toInteger(rand() * 60)}),
    device: device
}]->(s);

//BLOCO 10: Relacionamentos SEGUE (User -> Artist)
//cypher
// Criar relacionamentos de seguir artistas
MATCH (u:User)
WITH COLLECT(u) AS users
MATCH (a:Artist)
WITH users, COLLECT(a) AS artists
UNWIND users AS user
WITH user, artists, apoc.coll.randomItems(artists, toInteger(rand() * 8) + 3) AS followedArtists
UNWIND followedArtists AS artist
CREATE (user)-[:FOLLOWS {
    startDate: date() - duration({months: toInteger(rand() * 12)}),
    notificationsActive: rand() > 0.3
}]->(artist);



//BLOCO 11: Verificação de Integridade
//cypher
// Verificar todos os nós e suas propriedades
MATCH (u:User) RETURN 'Usuários: ' + COUNT(u) AS Tipo, COLLECT(u.name)[0..3] AS Amostra
UNION ALL
MATCH (a:Artist) RETURN 'Artistas: ' + COUNT(a) AS Tipo, COLLECT(a.name)[0..3] AS Amostra
UNION ALL
MATCH (g:Genre) RETURN 'Gêneros: ' + COUNT(g) AS Tipo, COLLECT(g.name)[0..3] AS Amostra
UNION ALL
MATCH (s:Song) RETURN 'Músicas: ' + COUNT(s) AS Tipo, COLLECT(s.title)[0..3] AS Amostra;


// Verificar todos os relacionamentos e suas propriedades
MATCH ()-[r:LISTENED]->() RETURN 'Escutas: ' + COUNT(r) AS Relacionamento, COUNT(r) AS Quantidade
UNION ALL
MATCH ()-[r:LIKED]->() RETURN 'Curtidas: ' + COUNT(r) AS Relacionamento, COUNT(r) AS Quantidade
UNION ALL
MATCH ()-[r:FOLLOWS]->() RETURN 'Seguidores: ' + COUNT(r) AS Relacionamento, COUNT(r) AS Quantidade
UNION ALL
MATCH ()-[r:COMPOSED]->() RETURN 'Composições: ' + COUNT(r) AS Relacionamento, COUNT(r) AS Quantidade
UNION ALL
MATCH ()-[r:BELONGS_TO]->() RETURN 'Pertences a gênero: ' + COUNT(r) AS Relacionamento, COUNT(r) AS Quantidade;



// Resumo do Banco Refatorado:
// 
// Nós e Propriedades:
// 
// User: id, name, age, gender, city (80 usuários)
// Artist: id, name, type, countryOfOrigin, startYear (18 artistas)
// Genre: id, name, description, predominantEra, hexColor (5 gêneros)
// Song: id, title, releaseYear, durationSec, popularity (500 músicas)
// 
// Relacionamentos e Propriedades:
// 
// LISTENED: timestamp, device, listeningDurationSec, liked, context (~1600 relações)
// LIKED: timestamp, device (~800 relações)
// FOLLOWS: startDate, notificationsActive (~500 relações)
// COMPOSED: participationType (500 relações)
// BELONGS_TO: relevance (500 relações)
// 
//   Todas as propriedades foram traduzidas para inglês conforme solicitado e 
// cada nó/relacionamento possui exatamente as propriedades especificadas!