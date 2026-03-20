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