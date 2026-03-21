

// Primeira solução.... Nao implementada, pois funciona com uma instalação de Noe4jDesktop.

// 1. Localizar o Usuário e a Música no Grafo
MATCH (u:User {name: "José Antônio Siqueira"})
MATCH (m:Song {title: "Beautiful People (feat. Khalid) - Jack Wins Remix"})
MATCH (a:Artist)-[:COMPOSED]->(m)

// 2. Preparar o contexto para a IA usando suas novas propriedades
WITH u, m, a,
     "O usuário " + u.name + " (Idade: " + u.age + ", Cidade: " + u.city + ") " +
     "está ouvindo a música '" + m.title + "' do artista " + a.name + ". " +
     "Dados técnicos da música: Popularidade " + m.track_popularity + ", Energia " + m.energy + ", Dançabilidade " + m.danceability + ". " +
     "Baseado nisso, gere uma recomendação personalizada." AS meu_prompt

// 3. Chamada para a API do DeepSeek (Free Tier)
CALL apoc.load.jsonParams(
  "https://api.deepseek.com/chat/completions",
  {
    Authorization: "Bearer sk-cdac30c1c9084bc4846bb8a59519236c",
    `Content-Type`: "application/json"
  },
  apoc.convert.toJson({
    model: "deepseek-chat",
    messages: [
      {role: "system", content: "Você é um sistema de recomendação musical especializado em análise de grafos e perfis demográficos."},
      {role: "user", content: meu_prompt}
    ],
    temperature: 0.3
  })
) YIELD value

// 4. Retornar a análise e criar o relacionamento se o score for alto (exemplo lógico)
RETURN 
    u.name AS Usuario,
    m.title AS Musica,
    value.choices[0].message.content AS Analise_IA


    // Segunda solução.... Nao implementada, pois funciona com uma instalação de Noe4jDesktop.

    // 1. Localizar Usuário e Música
MATCH (u:User {name: "José Antônio Siqueira"})
MATCH (m:Song {title: "Beautiful People (feat. Khalid) - Jack Wins Remix"})
MATCH (a:Artist)-[:COMPOSED]->(m)

// 2. Preparar o Prompt
WITH u, m, a,
     "O usuário " + u.name + " (Idade: " + u.age + ") ouve '" + m.title + 
     "' de " + a.name + ". Popularidade: " + m.track_popularity + 
     ". Ele vai gostar?" AS meu_prompt

// 3. Chamada usando apoc.http.post (Padrão para APIs REST)
CALL apoc.http.post(
  "https://api.deepseek.com/chat/completions",
  {
    Authorization: "Bearer sk-cdac30c1c9084bc4846bb8a59519236c",
    `Content-Type`: "application/json"
  },
  apoc.convert.toJson({
    model: "deepseek-chat",
    messages: [
      {role: "system", content: "Você é um recomendador musical."},
      {role: "user", content: meu_prompt}
    ]
  })
) YIELD value

// 4. Retornar Resultado
RETURN m.title AS Musica, value.choices[0].message.content AS Sugestao