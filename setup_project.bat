@echo off
REM Movie Recommendation System - Windows Project Generator
REM This script generates the complete project structure on Windows

echo ========================================
echo Movie Recommendation System Generator
echo ========================================
echo.

REM Set the target directory
set "PROJECT_DIR=C:\Users\salma\OneDrive\Desktop\Project\Movie"

REM Create main project directory
echo Creating project directory: %PROJECT_DIR%
if not exist "%PROJECT_DIR%" mkdir "%PROJECT_DIR%"
cd /d "%PROJECT_DIR%"

echo.
echo Creating directory structure...

REM Create all directories
mkdir artifacts 2>nul
mkdir data\raw 2>nul
mkdir data\processed 2>nul
mkdir logs 2>nul
mkdir notebook 2>nul
mkdir tests\unit 2>nul
mkdir tests\integration 2>nul
mkdir src\data 2>nul
mkdir src\models 2>nul
mkdir src\utils 2>nul
mkdir pipeline 2>nul
mkdir static\css 2>nul
mkdir static\js 2>nul
mkdir static\images 2>nul
mkdir config 2>nul
mkdir custom_jenkins 2>nul
mkdir utils 2>nul
mkdir templates 2>nul
mkdir .dvc 2>nul

echo [32mDirectory structure created successfully![0m
echo.

REM Create __init__.py files
echo Creating Python package files...
type nul > src\__init__.py
type nul > src\data\__init__.py
type nul > src\models\__init__.py
type nul > src\utils\__init__.py
type nul > pipeline\__init__.py
type nul > tests\__init__.py
type nul > tests\unit\__init__.py
type nul > tests\integration\__init__.py

REM Create .gitkeep files
type nul > data\raw\.gitkeep
type nul > data\processed\.gitkeep
type nul > logs\.gitkeep

echo [32m__init__.py files created![0m
echo.

REM Generate application.py
echo Creating application.py...
(
echo """
echo Movie Recommendation System - Flask Application
echo MLOps Implementation with DVC, Comet ML, and Kubernetes
echo """
echo.
echo from flask import Flask, render_template, request, jsonify
echo import pandas as pd
echo import numpy as np
echo import pickle
echo import logging
echo from pathlib import Path
echo import yaml
echo.
echo logging.basicConfig^(
echo     level=logging.INFO,
echo     format='%%(asctime^)s - %%(name^)s - %%(levelname^)s - %%(message^)s',
echo     handlers=[
echo         logging.FileHandler^('logs/application.log'^),
echo         logging.StreamHandler^(^)
echo     ]
echo ^)
echo logger = logging.getLogger^(__name__^)
echo.
echo app = Flask^(__name__^)
echo.
echo class MovieRecommender:
echo     def __init__^(self, config_path='config/config.yaml'^):
echo         self.config = self._load_config^(config_path^)
echo         self.model = None
echo         self.movies_data = None
echo         self.similarity_matrix = None
echo         self._load_artifacts^(^)
echo     
echo     def _load_config^(self, config_path^):
echo         try:
echo             with open^(config_path, 'r'^) as f:
echo                 return yaml.safe_load^(f^)
echo         except Exception as e:
echo             logger.error^(f"Error loading config: {e}"^)
echo             return {}
echo     
echo     def _load_artifacts^(self^):
echo         try:
echo             artifacts_path = Path^(self.config.get^('artifacts_path', 'artifacts'^)^)
echo             with open^(artifacts_path / 'movies_data.pkl', 'rb'^) as f:
echo                 self.movies_data = pickle.load^(f^)
echo             with open^(artifacts_path / 'similarity_matrix.pkl', 'rb'^) as f:
echo                 self.similarity_matrix = pickle.load^(f^)
echo             logger.info^("Artifacts loaded successfully"^)
echo         except Exception as e:
echo             logger.error^(f"Error loading artifacts: {e}"^)
echo             self._initialize_dummy_data^(^)
echo     
echo     def _initialize_dummy_data^(self^):
echo         logger.info^("Initializing with dummy data"^)
echo         self.movies_data = pd.DataFrame^({
echo             'movie_id': range^(100^),
echo             'title': [f'Movie {i}' for i in range^(100^)],
echo             'genres': [f'Genre{i%%5}^|Genre{^(i+1^)%%5}' for i in range^(100^)],
echo             'rating': np.random.uniform^(3, 5, 100^)
echo         }^)
echo         self.similarity_matrix = np.random.rand^(100, 100^)
echo     
echo     def get_recommendations^(self, movie_title, n_recommendations=10^):
echo         try:
echo             movie_idx = self.movies_data[self.movies_data['title'].str.lower^(^) == movie_title.lower^(^)].index
echo             if len^(movie_idx^) == 0:
echo                 return self._get_popular_movies^(n_recommendations^)
echo             movie_idx = movie_idx[0]
echo             sim_scores = list^(enumerate^(self.similarity_matrix[movie_idx]^)^)
echo             sim_scores = sorted^(sim_scores, key=lambda x: x[1], reverse=True^)
echo             sim_scores = sim_scores[1:n_recommendations+1]
echo             movie_indices = [i[0] for i in sim_scores]
echo             recommendations = self.movies_data.iloc[movie_indices][['title', 'genres', 'rating']].to_dict^('records'^)
echo             return recommendations
echo         except Exception as e:
echo             logger.error^(f"Error getting recommendations: {e}"^)
echo             return self._get_popular_movies^(n_recommendations^)
echo     
echo     def _get_popular_movies^(self, n=10^):
echo         return self.movies_data.nlargest^(n, 'rating'^)[['title', 'genres', 'rating']].to_dict^('records'^)
echo     
echo     def search_movies^(self, query, limit=10^):
echo         try:
echo             mask = self.movies_data['title'].str.contains^(query, case=False, na=False^)
echo             results = self.movies_data[mask].head^(limit^)[['title', 'genres', 'rating']].to_dict^('records'^)
echo             return results
echo         except Exception as e:
echo             logger.error^(f"Error searching movies: {e}"^)
echo             return []
echo.
echo recommender = MovieRecommender^(^)
echo.
echo @app.route^('/''^)
echo def home^(^):
echo     return render_template^('index.html'^)
echo.
echo @app.route^('/api/recommend', methods=['POST']^)
echo def recommend^(^):
echo     try:
echo         data = request.get_json^(^)
echo         movie_title = data.get^('movie_title', ''^)
echo         n_recommendations = data.get^('n_recommendations', 10^)
echo         if not movie_title:
echo             return jsonify^({'error': 'Movie title is required'}^), 400
echo         recommendations = recommender.get_recommendations^(movie_title, n_recommendations^)
echo         return jsonify^({'success': True, 'movie': movie_title, 'recommendations': recommendations}^)
echo     except Exception as e:
echo         logger.error^(f"Error in recommend endpoint: {e}"^)
echo         return jsonify^({'error': str^(e^)}^), 500
echo.
echo @app.route^('/api/search', methods=['GET']^)
echo def search^(^):
echo     try:
echo         query = request.args.get^('q', ''^)
echo         limit = int^(request.args.get^('limit', 10^)^)
echo         if not query:
echo             return jsonify^({'error': 'Query parameter is required'}^), 400
echo         results = recommender.search_movies^(query, limit^)
echo         return jsonify^({'success': True, 'query': query, 'results': results}^)
echo     except Exception as e:
echo         logger.error^(f"Error in search endpoint: {e}"^)
echo         return jsonify^({'error': str^(e^)}^), 500
echo.
echo @app.route^('/health'^)
echo def health^(^):
echo     return jsonify^({'status': 'healthy', 'service': 'movie-recommender', 'version': '1.0.0'}^)
echo.
echo if __name__ == '__main__':
echo     Path^('logs'^).mkdir^(exist_ok=True^)
echo     app.run^(host='0.0.0.0', port=5000, debug=False^)
) > application.py

echo [32mapplication.py created![0m
echo.

REM Generate requirements.txt
echo Creating requirements.txt...
(
echo Flask==2.3.3
echo flask-cors==4.0.0
echo gunicorn==21.2.0
echo pandas==2.0.3
echo numpy==1.24.3
echo scikit-learn==1.3.0
echo comet-ml==3.35.3
echo dvc==3.20.0
echo dvc-s3==3.0.1
echo PyYAML==6.0.1
echo python-dotenv==1.0.0
echo pytest==7.4.0
echo pytest-cov==4.1.0
echo pytest-mock==3.11.1
echo flake8==6.1.0
echo pylint==2.17.5
echo black==23.7.0
echo requests==2.31.0
echo python-dateutil==2.8.2
echo colorlog==6.7.0
echo Werkzeug==2.3.7
) > requirements.txt

echo [32mrequirements.txt created![0m
echo.

REM Generate Dockerfile
echo Creating Dockerfile...
(
echo FROM python:3.9-slim as builder
echo WORKDIR /build
echo RUN apt-get update ^&^& apt-get install -y --no-install-recommends gcc g++ ^&^& rm -rf /var/lib/apt/lists/*
echo COPY requirements.txt .
echo RUN pip install --no-cache-dir --user -r requirements.txt
echo FROM python:3.9-slim
echo WORKDIR /app
echo RUN useradd -m -u 1000 appuser ^&^& mkdir -p /app/logs /app/artifacts ^&^& chown -R appuser:appuser /app
echo COPY --from=builder /root/.local /home/appuser/.local
echo COPY --chown=appuser:appuser . .
echo ENV PATH=/home/appuser/.local/bin:$PATH PYTHONUNBUFFERED=1 FLASK_APP=application.py PYTHONPATH=/app
echo EXPOSE 5000
echo USER appuser
echo HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 CMD python -c "import requests; requests.get('http://localhost:5000/health'^)" ^|^| exit 1
echo CMD ["python", "application.py"]
) > Dockerfile

echo [32mDockerfile created![0m
echo.

REM Generate .gitignore
echo Creating .gitignore...
(
echo __pycache__/
echo *.py[cod]
echo *$py.class
echo *.so
echo .Python
echo env/
echo venv/
echo *.egg-info/
echo dist/
echo build/
echo *.egg
echo .vscode/
echo .idea/
echo *.swp
echo *.swo
echo .DS_Store
echo *.log
echo logs/
echo .pytest_cache/
echo .coverage
echo htmlcov/
echo .tox/
echo .dvc/tmp
echo .dvc/cache
echo .env
echo .env.local
echo artifacts/*.pkl
echo artifacts/*.json
echo artifacts/plots/
echo data/raw/*
echo data/processed/*
echo !data/raw/.gitkeep
echo !data/processed/.gitkeep
echo .ipynb_checkpoints/
echo *.ipynb
echo *.h5
echo *.pkl
echo *.joblib
echo *.model
echo Thumbs.db
) > .gitignore

echo [32m.gitignore created![0m
echo.

REM Generate config files
echo Creating configuration files...
(
echo app:
echo   name: movie-recommender
echo   version: 1.0.0
echo   debug: false
echo.
echo server:
echo   host: 0.0.0.0
echo   port: 5000
echo.
echo artifacts_path: artifacts/
echo.
echo logging:
echo   level: INFO
echo   format: '%%(asctime^)s - %%(name^)s - %%(levelname^)s - %%(message^)s'
) > config\config.yaml

(
echo data:
echo   input_path: 'data/movies.csv'
echo   test_size: 0.2
echo   random_state: 42
echo.
echo model:
echo   vectorizer: 'tfidf'
echo   max_features: 5000
echo   min_df: 2
echo   max_df: 0.8
echo.
echo output:
echo   artifacts_path: 'artifacts'
echo   model_name: 'movie_recommender'
echo.
echo comet:
echo   project_name: 'movie-recommender'
echo   workspace: 'your-workspace'
) > config\train_config.yaml

echo [32mConfiguration files created![0m
echo.

REM Generate .env.example
echo Creating .env.example...
(
echo COMET_API_KEY=your_comet_api_key_here
echo COMET_PROJECT_NAME=movie-recommender
echo COMET_WORKSPACE=your_workspace_here
echo.
echo AWS_ACCESS_KEY_ID=your_aws_access_key
echo AWS_SECRET_ACCESS_KEY=your_aws_secret_key
echo AWS_DEFAULT_REGION=us-east-1
echo.
echo FLASK_ENV=development
echo FLASK_DEBUG=1
echo FLASK_APP=application.py
echo.
echo LOG_LEVEL=INFO
echo MODEL_PATH=artifacts
) > .env.example

echo [32m.env.example created![0m
echo.

REM Generate HTML template
echo Creating web interface...
(
echo ^<!DOCTYPE html^>
echo ^<html lang="en"^>
echo ^<head^>
echo     ^<meta charset="UTF-8"^>
echo     ^<meta name="viewport" content="width=device-width, initial-scale=1.0"^>
echo     ^<title^>Movie Recommendation System^</title^>
echo     ^<style^>
echo         * { margin: 0; padding: 0; box-sizing: border-box; }
echo         body { font-family: 'Segoe UI', sans-serif; background: linear-gradient^(135deg, #667eea 0%%, #764ba2 100%%^); min-height: 100vh; padding: 20px; }
echo         .container { max-width: 1200px; margin: 0 auto; }
echo         .header { text-align: center; color: white; margin-bottom: 40px; padding: 30px 0; }
echo         .header h1 { font-size: 3em; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba^(0,0,0,0.3^); }
echo         .search-section { background: white; border-radius: 15px; padding: 40px; box-shadow: 0 10px 40px rgba^(0,0,0,0.2^); margin-bottom: 30px; }
echo         .search-input { flex: 1; padding: 15px 20px; font-size: 16px; border: 2px solid #e0e0e0; border-radius: 10px; width: 70%%; }
echo         .btn { padding: 15px 30px; font-size: 16px; font-weight: bold; border: none; border-radius: 10px; cursor: pointer; background: linear-gradient^(135deg, #667eea 0%%, #764ba2 100%%^); color: white; }
echo         .movie-card { background: white; border-radius: 15px; padding: 25px; margin: 10px; box-shadow: 0 5px 20px rgba^(0,0,0,0.1^); }
echo         #results { display: grid; grid-template-columns: repeat^(auto-fill, minmax^(300px, 1fr^)^); gap: 20px; }
echo     ^</style^>
echo ^</head^>
echo ^<body^>
echo     ^<div class="container"^>
echo         ^<div class="header"^>
echo             ^<h1^>🎬 Movie Recommender^</h1^>
echo             ^<p^>Powered by Machine Learning ^&^&^&^amp; MLOps^</p^>
echo         ^</div^>
echo         ^<div class="search-section"^>
echo             ^<h2^>Find Similar Movies^</h2^>
echo             ^<br^>
echo             ^<input type="text" id="movieInput" class="search-input" placeholder="Enter a movie title..."^>
echo             ^<button class="btn" onclick="getRecommendations^(^)"^>Get Recommendations^</button^>
echo         ^</div^>
echo         ^<div id="results"^>^</div^>
echo     ^</div^>
echo     ^<script^>
echo         async function getRecommendations^(^) {
echo             const title = document.getElementById^('movieInput'^).value;
echo             if ^(!title^) { alert^('Please enter a movie title'^); return; }
echo             const response = await fetch^('/api/recommend', { method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify^({movie_title: title, n_recommendations: 9}^) }^);
echo             const data = await response.json^(^);
echo             if ^(data.success^) displayResults^(data.recommendations^);
echo         }
echo         function displayResults^(movies^) {
echo             const html = movies.map^(m =^> `^<div class="movie-card"^>^<h3^>${m.title}^</h3^>^<p^>${m.genres}^</p^>^<p^>Rating: ${m.rating.toFixed^(1^)}^</p^>^</div^>`^).join^(''^);
echo             document.getElementById^('results'^).innerHTML = html;
echo         }
echo     ^</script^>
echo ^</body^>
echo ^</html^>
) > templates\index.html

echo [32mHTML template created![0m
echo.

REM Generate README
echo Creating README.md...
(
echo # 🎬 Movie Recommendation System
echo.
echo Production-ready Movie Recommendation System with MLOps practices.
echo.
echo ## Quick Start
echo.
echo ```bash
echo # Install dependencies
echo pip install -r requirements.txt
echo.
echo # Run application
echo python application.py
echo ```
echo.
echo Visit `http://localhost:5000`
echo.
echo ## Features
echo.
echo - Data Versioning with DVC
echo - Experiment Tracking with Comet ML
echo - CI/CD with Jenkins
echo - Docker containerization
echo - Kubernetes deployment
echo - Flask web interface
echo.
echo ## License
echo.
echo MIT License
) > README.md

echo [32mREADME.md created![0m
echo.

echo ========================================
echo [32mProject generation complete![0m
echo ========================================
echo.
echo Project location: %PROJECT_DIR%
echo.
echo [33mNext steps:[0m
echo 1. Copy .env.example to .env and update credentials
echo 2. Install Python dependencies: pip install -r requirements.txt
echo 3. Run application: python application.py
echo 4. Open browser: http://localhost:5000
echo.
echo [36mHappy coding! 🚀[0m
echo.
pause