import pandas as pd

# Carregando o arquivo
df = pd.read_csv('./scripts/archive/spotify_songs.csv')

# Agrupando e removendo duplicidades com base nas colunas solicitadas
# Nota: Manteremos todas as colunas originais, mas eliminando linhas 
# onde a combinação de subgenre, genre e artist se repete.
df_cleaned = df.drop_duplicates(subset=['playlist_subgenre', 'playlist_genre', 'track_artist'])

# Salvando o resultado
df_cleaned.to_csv('./scripts/archive/spotify_songs_grouped.csv', index=False)