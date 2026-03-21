# pip install python-dotenv

import os
from dotenv import load_dotenv

# Carrega as variáveis do arquivo .env para o ambiente do Python
load_dotenv()

# Agora você pode pegar sua chave com segurança
GEMINI_KEY = os.getenv("GEMINI_API_KEY")

print(f"Chave carregada com sucesso: {GEMINI_KEY[:5]}...") # Mostra só o início por segurança