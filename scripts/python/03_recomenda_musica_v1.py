""" 
*************************************************************
 Configuracao do ambiente para execucao do codigo pyton
*************************************************************
 
1) Crie um ambiente virtual (opcional, mas recomendado):
python -m venv venv

2) instale as dependências necessárias: 
 pip install neo4j openai

3) Execute o script:
 docker run \
    --name neo4j-estudo \
    -p 7474:7474 -p 7687:7687 \
    -d \
    --env NEO4J_AUTH=neo4j/sua_senha_aqui \
    neo4j:latest
4) Certifique-se de que o Neo4j está rodando e que as credenciais estão corretas no script.

5) Execute o script Python para obter a recomendação musical.

 ## Codigo para ChatGPT e DeepSeek
"""

# *******************************************************************
# Script para recomendar música usando Google Gemini e Neo4j
# *******************************************************************

import os
from google import genai
from neo4j import GraphDatabase
from dotenv import load_dotenv

# 1. Carregar configurações
load_dotenv()
# O .strip() remove espaços em branco acidentais no início ou fim da chave
GEMINI_KEY = os.getenv("GEMINI_API_KEY", "").strip()
print(f"/n  Chave carregada com sucesso: {GEMINI_KEY[:5]}.../n") # Mostra só o início por segurança
NEO4J_URI = "neo4j+ssc://d4be3182.databases.neo4j.io"
NEO4J_AUTH = ("d4be3182", "__smER-uoD6nl-zh8zIfpf1esKT13_scU7wBCaHNWpQ")

# 2. Configurar o Cliente Novo (SDK v2)
client = genai.Client(api_key=GEMINI_KEY)

def obter_recomendacao():
    driver = GraphDatabase.driver(NEO4J_URI, auth=NEO4J_AUTH)
    
    try:
        with driver.session() as session:
            # Busca os dados no Neo4j
            result = session.run("""
                MATCH (u:User {name: "José Antônio Siqueira"})
			    MATCH (m:Song {title: "Beautiful People (feat. Khalid) - Jack Wins Remix"})	
                MATCH (a:Artist)-[:COMPOSED]->(m)
                RETURN u.age as age, m.title as title, a.name as artist, 
                       m.track_popularity as pop, m.energy as energy
            """)
            
            dados = result.single()
            if not dados:
                print(f"/n ⚠️ Dados não encontrados no Neo4j. Verifique os nomes dos nós.")
                return

            prompt = (f"/n O usuário de {dados['age']} anos ouve '{dados['title']}' de {dados['artist']}. "
                      f"Popularidade: {dados['pop']}, Energia: {dados['energy']}. "
                      "Ele vai gostar? Responda em uma frase curta.")

            # 3. Chamada para o modelo gemini-2.5-flash-lite
            response = client.models.generate_content(
                model="gemini-2.5-flash-lite",
                contents=prompt
            )
            
            print(f"/n ✅ Chave validada: {GEMINI_KEY[:5]}...")
            print(f"/n --- RECOMENDAÇÃO: {dados['title']} ---")
            print(response.text)

    except Exception as e:
        if "API_KEY_INVALID" in str(e):
            print("❌ ERRO: Sua chave do Gemini é inválida. Verifique o arquivo .env")
        else:
            print(f"❌ Erro: {e}")
    finally:
        driver.close()

if __name__ == "__main__":
    obter_recomendacao()