# Utilise une image officielle de Python comme image de base
FROM python:3.7.7

# Définit le répertoire de travail dans le conteneur
WORKDIR /app

# Copie le fichier requirements.txt dans le répertoire de travail du conteneur
COPY requirements.txt .

# Installe les dépendances Python spécifiées dans requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copie le reste des fichiers de l'application dans le répertoire de travail du conteneur
COPY . .

# Expose le port que l'application utilisera
EXPOSE 8000

# Définit la commande à exécuter au démarrage du conteneur
CMD ["python", "app.py"]