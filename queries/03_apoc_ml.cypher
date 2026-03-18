// Exemplo conceitual do uso do APOC ML
// ... (trecho do script)
CALL apoc.ml.predict(modelo, {idade: u.idade, popularidadeMusica: m.popularidade}) 
YIELD score
RETURN m.titulo, score ORDER BY score DESC;
