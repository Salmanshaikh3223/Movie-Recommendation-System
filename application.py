"""
Movie Recommendation System - Flask Application
MLOps Implementation with DVC, Comet ML, and Kubernetes
"""

from flask import Flask, render_template, request, jsonify
import pandas as pd
import numpy as np
import pickle
import logging
from pathlib import Path
import yaml

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('logs/application.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

app = Flask(__name__)

class MovieRecommender:
    def __init__(self, config_path='config/config.yaml'):
        self.config = self._load_config(config_path)
        self.model = None
        self.movies_data = None
        self.similarity_matrix = None
        self._load_artifacts()
ECHO is off.
    def _load_config(self, config_path):
        try:
            with open(config_path, 'r') as f:
                return yaml.safe_load(f)
        except Exception as e:
            logger.error(f"Error loading config: {e}")
            return {}
ECHO is off.
    def _load_artifacts(self):
        try:
            artifacts_path = Path(self.config.get('artifacts_path', 'artifacts'))
            with open(artifacts_path / 'movies_data.pkl', 'rb') as f:
                self.movies_data = pickle.load(f)
            with open(artifacts_path / 'similarity_matrix.pkl', 'rb') as f:
                self.similarity_matrix = pickle.load(f)
            logger.info("Artifacts loaded successfully")
        except Exception as e:
            logger.error(f"Error loading artifacts: {e}")
            self._initialize_dummy_data()
ECHO is off.
    def _initialize_dummy_data(self):
        logger.info("Initializing with dummy data")
        self.movies_data = pd.DataFrame({
            'movie_id': range(100),
            'title': [f'Movie {i}' for i in range(100)],
            'genres': [f'Genre{i%5}|Genre{(i+1)%5}' for i in range(100)],
            'rating': np.random.uniform(3, 5, 100)
        })
        self.similarity_matrix = np.random.rand(100, 100)
ECHO is off.
    def get_recommendations(self, movie_title, n_recommendations=10):
        try:
            movie_idx = self.movies_data[self.movies_data['title'].str.lower() == movie_title.lower()].index
            if len(movie_idx) == 0:
                return self._get_popular_movies(n_recommendations)
            movie_idx = movie_idx[0]
            sim_scores = list(enumerate(self.similarity_matrix[movie_idx]))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
            sim_scores = sim_scores[1:n_recommendations+1]
            movie_indices = [i[0] for i in sim_scores]
            recommendations = self.movies_data.iloc[movie_indices][['title', 'genres', 'rating']].to_dict('records')
            return recommendations
        except Exception as e:
            logger.error(f"Error getting recommendations: {e}")
            return self._get_popular_movies(n_recommendations)
ECHO is off.
    def _get_popular_movies(self, n=10):
        return self.movies_data.nlargest(n, 'rating')[['title', 'genres', 'rating']].to_dict('records')
ECHO is off.
    def search_movies(self, query, limit=10):
        try:
            mask = self.movies_data['title'].str.contains(query, case=False, na=False)
            results = self.movies_data[mask].head(limit)[['title', 'genres', 'rating']].to_dict('records')
            return results
        except Exception as e:
            logger.error(f"Error searching movies: {e}")
            return []

recommender = MovieRecommender()

@app.route('/'')
def home():
    return render_template('index.html')

@app.route('/api/recommend', methods=['POST'])
def recommend():
    try:
        data = request.get_json()
        movie_title = data.get('movie_title', '')
        n_recommendations = data.get('n_recommendations', 10)
        if not movie_title:
            return jsonify({'error': 'Movie title is required'}), 400
        recommendations = recommender.get_recommendations(movie_title, n_recommendations)
        return jsonify({'success': True, 'movie': movie_title, 'recommendations': recommendations})
    except Exception as e:
        logger.error(f"Error in recommend endpoint: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/api/search', methods=['GET'])
def search():
    try:
        query = request.args.get('q', '')
        limit = int(request.args.get('limit', 10))
        if not query:
            return jsonify({'error': 'Query parameter is required'}), 400
        results = recommender.search_movies(query, limit)
        return jsonify({'success': True, 'query': query, 'results': results})
    except Exception as e:
        logger.error(f"Error in search endpoint: {e}")
        return jsonify({'error': str(e)}), 500

@app.route('/health')
def health():
    return jsonify({'status': 'healthy', 'service': 'movie-recommender', 'version': '1.0.0'})

if __name__ == '__main__':
    Path('logs').mkdir(exist_ok=True)
    app.run(host='0.0.0.0', port=5000, debug=False)
