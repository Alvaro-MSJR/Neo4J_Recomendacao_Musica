# Neo4J_Recomendacao_Musica
Criando um Algoritmo de Recomendação de Músicas Com Base Em Grafos

# 🎵 Projeto: Sistema de Recomendação Musical com Grafos Neo4j

[![Neo4j](https://img.shields.io/badge/Neo4j-008CC1?style=for-the-badge&logo=neo4j&logoColor=white)](https://neo4j.com/)
[![Cypher](https://img.shields.io/badge/Cypher-FFE047?style=for-the-badge&logo=neo4j&logoColor=black)](https://neo4j.com/developer/cypher/)
[![APOC](https://img.shields.io/badge/APOC-6DBE4E?style=for-the-badge&logo=neo4j&logoColor=white)](https://neo4j.com/labs/apoc/)
[![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)](https://www.python.org/)
[![Licença](https://img.shields.io/badge/Licença-MIT-green.svg)](LICENSE)

## 📋 Sobre o Projeto

Este repositório contém a implementação de um **sistema de recomendação de músicas** baseado em **banco de dados de grafos Neo4j**. O projeto foi desenvolvido como parte de um estudo avançado sobre modelagem de dados, algoritmos de grafos e técnicas de recomendação, aplicando conceitos de Ciência de Dados e Engenharia de Software.

O objetivo principal é demonstrar como as conexões inerentes a um grafo (usuários, músicas, artistas e gêneros) podem ser exploradas para gerar recomendações personalizadas e precisas, indo além das abordagens tradicionais baseadas em SQL.

## 👤 Autor

**Álvaro Monteiro**  
*Profissional em transição de carreira para Ciência de Dados e IA | Entusiasta de Grafos e Aprendizado de Máquina*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)]([LINK_DO_SEU_LINKEDIN])
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Alvaro-MSJR)

Este projeto reflete meu objetivo de unir minha experiência em sistemas (como CRM) com minha paixão por IA e Ciência de Dados, explorando o poder dos bancos de dados de grafos para resolver problemas complexos de recomendação.

## 🚀 Começando

Estas instruções permitirão que você obtenha uma cópia do projeto em operação na sua máquina local para fins de desenvolvimento e teste.

### Pré-requisitos

- **Neo4j Desktop** ou uma instância do **Neo4j Server** (versão 5.x ou superior)
- **Plugin APOC** instalado e habilitado
- **Plugin Graph Data Science (GDS)** instalado e habilitado (para algumas queries)
- (Opcional) Python 3.x com a biblioteca `neo4j` para executar scripts de carga de dados.

### Instalação e Configuração

1.  **Clone o repositório**
    ```bash
    git clone https://github.com/Alvaro-MSJR/[Neo4J_Recomendacao_Musica].git
    cd [Neo4J_Recomendacao_Musica]


2.  **Configurar o Banco de Dados**

Inicie o Neo4j e crie um novo banco de dados (ex: recomendacao-musical).

Abra o Neo4j Browser ou o console e execute os scripts na ordem indicada na seção Estrutura do Projeto.


3. 🧠 **Modelagem de Dados (Grafo)**

O modelo foi projetado para capturar a riqueza das interações musicais.

**Nós e Propriedades**
Usuario: id, nome, idade, sexo, cidade

Musica: id, titulo, anoLancamento, duracaoSeg, popularidade

Artista: id, nome, tipo ('Banda' ou 'Solista'), paisOrigem, anoInicio

Genero: id, nome, descricao, epocaPredominante, corHexadecimal

**Relacionamentos e Propriedades**
ESCUTOU (Usuario->Musica): dataHora, dispositivo, duracaoEscutaSeg, gostou, contexto

CURTIU (Usuario->Musica): dataHora, dispositivo

SEGUE (Usuario->Artista): dataInicio, notificacoesAtivas

COMPOS (Artista->Musica): tipoParticipacao

PERTENCE_A (Musica->Genero): relevancia

**Diagrama do Modelo**
https://./imagens/modelo_grafo.png

(Diagrama criado com Arrows.app)

⚙️ **Funcionalidades e Queries de Recomendação**
Foram implementadas 5 técnicas diferentes de recomendação, cada uma explorando uma característica distinta dos grafos.

**Similaridade (Baseada em Itens)**: Recomenda músicas dos mesmos gêneros das mais ouvidas pelo usuário.

**Comunidade (Baseada em Usuários)**: Usa o algoritmo de Louvain (GDS) para achar usuários com hábitos similares e recomendar o que eles curtem.

**Caminhos**: Recomenda artistas seguidos por usuários que também seguem os artistas que o usuário alvo segue.

**PageRank**: Identifica músicas "influentes" (alto PageRank) dentro de um subgrafo (ex: gênero preferido do usuário).

**Filtragem Demográfica**: Recomenda as músicas mais populares do gênero preferido por pessoas do mesmo perfil (idade/sexo).

Todas as queries estão disponíveis no arquivo 
/queries/02_recomendacoes.cypher.

🤖 **Inovação: Recomendação com APOC ML**
Como diferencial inovador, o projeto explora o uso do procedimento apoc.ml.classification para criar um modelo preditivo simples. O modelo é treinado com features extraídas do grafo (como idade do usuário, popularidade da música e ano de lançamento) para prever se um usuário irá curtir uma nova música.

O script de exemplo está em /queries/03_apoc_ml.cypher.

![Analise Técnica Comparativa](/imagens/analise.jpg). 


Conclusão: Não há uma técnica "melhor" universalmente. A escolha depende do contexto de negócio (ex: recomendar novidades vs. recomendar sucessos) e dos dados disponíveis. A combinação de técnicas (ensemble) pode gerar resultados superiores.

📈 Próximos Passos e Melhorias
Integração com API de Música: Conectar a uma API real (como Spotify) para obter dados de músicas e artistas reais.

Sistema de Feedback: Implementar um ciclo de feedback para avaliar a acurácia das recomendações (ex: se o usuário ouviu a música recomendada).

Modelo ML mais Robusto: Utilizar a biblioteca graphdatascience do Python para criar e treinar modelos de machine learning mais sofisticados (ex: GraphSAGE) diretamente no grafo.

Pipeline de Dados: Automatizar a carga e atualização dos dados com um pipeline ETL.

🤝 Contribuições
Contribuições são bem-vindas! Sinta-se à vontade para abrir uma issue ou um pull request.

📄 Licença
Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para detalhes.

✨ Agradecimentos
Agradeço à comunidade Neo4j e a todos os entusiastas de Ciência de Dados que compartilham conhecimento e tornam projetos como este possíveis.

[Fim do projeto]

Muito obrigado pela atenção!

Contato: https://github.com/Alvaro-MSJR