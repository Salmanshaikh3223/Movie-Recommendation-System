
# 🎬 Movie Recommendation System

A production-ready **Movie Recommendation System** built with comprehensive **MLOps practices**. This project demonstrates end-to-end machine learning pipeline implementation with data versioning, experiment tracking, CI/CD automation, containerization, and Kubernetes deployment.

![Python](https://img.shields.io/badge/Python-3.9+-blue.svg)
![Flask](https://img.shields.io/badge/Flask-2.3.3-green.svg)
![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Ready-blue.svg)
![License](https://img.shields.io/badge/License-MIT-yellow.svg)

## 🚀 Features

- **🔄 Data Versioning**: DVC (Data Version Control) for tracking datasets and model artifacts
- **🧪 Experiment Tracking**: Integrated with Comet ML for comprehensive experiment management
- **📊 Model Training**: Modular, configurable training pipeline with TF-IDF and cosine similarity
- **🔁 CI/CD Automation**: Jenkins pipelines for continuous integration and deployment
- **🐳 Containerization**: Docker containers ensuring environment consistency
- **☸️ Kubernetes Deployment**: Scalable orchestration with auto-scaling capabilities
- **🌐 Web Interface**: Flask-powered responsive frontend for recommendations
- **📈 Monitoring**: Built-in health checks and logging

## 📁 Project Structure

```
movie-recommender/
├── .dvc/                     # DVC configuration and cache
├── .github/                  # GitHub Actions workflows (optional)
├── artifacts/                # Model artifacts and outputs
│   ├── vectorizer.pkl
│   ├── similarity_matrix.pkl
│   ├── movies_data.pkl
│   └── metrics.json
├── config/                   # Configuration files
│   ├── config.yaml          # Application config
│   ├── train_config.yaml    # Training config
│   └── comet_config.yaml    # Comet ML config
├── custom_jenkins/          # Custom Jenkins scripts
│   ├── setup.sh
│   └── deploy.sh
├── data/                    # Dataset directory
│   ├── raw/                # Raw data
│   └── processed/          # Processed data
├── logs/                   # Application logs
├── notebook/               # Jupyter notebooks
│   ├── EDA.ipynb
│   └── model_experiments.ipynb
├── pipeline/               # ML pipeline scripts
│   ├── __init__.py
│   ├── train_pipeline.py
│   ├── prepare_data.py
│   ├── evaluate_model.py
│   └── validate_model.py
├── src/                    # Source code
│   ├── __init__.py
│   ├── data/              # Data processing
│   ├── models/            # Model definitions
│   └── utils/             # Utility functions
├── static/                # Static web assets
│   ├── css/
│   ├── js/
│   └── images/
├── templates/             # Flask HTML templates
│   └── index.html
├── tests/                 # Test suite
│   ├── unit/
│   ├── integration/
│   └── conftest.py
├── utils/                 # Utility scripts
│   ├── data_loader.py
│   └── logger.py
├── .dvcignore            # DVC ignore patterns
├── .gitignore            # Git ignore patterns
├── .dockerignore         # Docker ignore patterns
├── application.py        # Flask application entry point
├── Dockerfile            # Container definition
├── Jenkinsfile           # CI/CD pipeline definition
├── deployment.yaml       # Kubernetes manifests
├── dvc.yaml              # DVC pipeline definition
├── params.yaml           # Pipeline parameters
├── requirements.txt      # Python dependencies
├── setup.py              # Package setup
├── tox.ini              # Tox configuration
└── README.md            # This file
```

## 🛠️ Prerequisites

- Python 3.9+
- Docker
- Kubernetes cluster (for deployment)
- Jenkins (for CI/CD)
- AWS S3 or similar storage (for DVC)
- Comet ML account (for experiment tracking)

## 📥 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/movie-recommender.git
cd movie-recommender
```

### 2. Create Virtual Environment

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

### 4. Setup DVC

```bash
# Initialize DVC (if not already initialized)
dvc init

# Configure remote storage (S3 example)
dvc remote add -d s3storage s3://your-bucket/movie-recommender/
dvc remote modify s3storage region us-east-1

# Pull data and artifacts
dvc pull
```

### 5. Configure Environment Variables

Create a `.env` file:

```bash
# Comet ML
COMET_API_KEY=your_comet_api_key
COMET_PROJECT_NAME=movie-recommender
COMET_WORKSPACE=your_workspace

# AWS (for DVC)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key

# Flask
FLASK_ENV=development
FLASK_DEBUG=1
```

## 🚀 Quick Start

### Run Locally

```bash
# Train the model
python pipeline/train_pipeline.py --config config/train_config.yaml

# Start the Flask application
python application.py
```

Visit `http://localhost:5000` in your browser.

### Run with Docker

```bash
# Build the image
docker build -t movie-recommender:latest .

# Run the container
docker run -p 5000:5000 \
  -e COMET_API_KEY=your_api_key \
  -v $(pwd)/artifacts:/app/artifacts \
  movie-recommender:latest
```

### Run with Docker Compose

```bash
# Create docker-compose.yml
docker-compose up -d
```

## 📊 Training Pipeline

### Manual Training

```bash
# Run complete pipeline
dvc repro

# Or run individual stages
python pipeline/prepare_data.py
python pipeline/train_pipeline.py
python pipeline/evaluate_model.py
```

### Pipeline Configuration

Edit `params.yaml` to adjust parameters:

```yaml
model:
  max_features: 5000
  min_df: 2
  max_df: 0.8

training:
  n_recommendations: 10
```

### Experiment Tracking with Comet ML

All training runs are automatically logged to Comet ML:
- Hyperparameters
- Metrics (similarity scores, evaluation metrics)
- Model artifacts
- Training visualizations
- System metrics

Access your experiments at: `https://www.comet.ml/your-workspace/movie-recommender`

## 🔄 CI/CD Pipeline

### Jenkins Setup

1. **Install Jenkins** and required plugins:
   - Docker Pipeline
   - Kubernetes CLI
   - Git

2. **Create Jenkins Pipeline**:
   - New Item → Pipeline
   - Configure SCM: Point to your Git repository
   - Pipeline script from SCM: Use Jenkinsfile

3. **Configure Credentials**:
   ```bash
   # Add credentials in Jenkins
   - comet-api-key: Comet ML API key
   - kubernetes-config: Kubeconfig file
   - docker-registry: Registry credentials
   ```

4. **Trigger Build**:
   - Manually or via webhook
   - Automatic on push to main/develop branches

### Pipeline Stages

The Jenkins pipeline includes:

1. **Checkout**: Clone repository
2. **Setup Environment**: Install dependencies
3. **Linting & Code Quality**: flake8, pylint, black
4. **Unit Tests**: pytest with coverage
5. **Pull Data with DVC**: Sync datasets
6. **Train Model**: Execute training pipeline
7. **Model Validation**: Validate model performance
8. **Version Artifacts**: Track with DVC
9. **Build Docker Image**: Create container
10. **Security Scan**: Vulnerability scanning
11. **Push to Registry**: Upload image
12. **Deploy to Staging/Production**: Kubernetes deployment
13. **Integration Tests**: E2E testing

## ☸️ Kubernetes Deployment

### Prerequisites

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Configure kubectl to connect to your cluster
kubectl config use-context your-cluster-context
```

### Deploy to Kubernetes

```bash
# Create namespace
kubectl create namespace movie-recommender

# Create secrets
kubectl create secret generic movie-recommender-secrets \
  --from-literal=comet-api-key=YOUR_COMET_API_KEY \
  -n movie-recommender

# Apply configurations
kubectl apply -f deployment.yaml

# Check deployment status
kubectl get pods -n movie-recommender
kubectl get services -n movie-recommender

# View logs
kubectl logs -f deployment/movie-recommender -n movie-recommender
```

### Access the Application

```bash
# Get external IP (LoadBalancer)
kubectl get service movie-recommender-service -n movie-recommender

# Port forward for local testing
kubectl port-forward service/movie-recommender-service 8080:80 -n movie-recommender
```

### Scaling

```bash
# Manual scaling
kubectl scale deployment movie-recommender --replicas=5 -n movie-recommender

# Auto-scaling is configured via HorizontalPodAutoscaler in deployment.yaml
# Scales between 3-10 replicas based on CPU/Memory usage
```

### Update Deployment

```bash
# Rolling update with new image
kubectl set image deployment/movie-recommender \
  movie-recommender=your-registry.io/movie-recommender:v2.0 \
  -n movie-recommender

# Check rollout status
kubectl rollout status deployment/movie-recommender -n movie-recommender

# Rollback if needed
kubectl rollout undo deployment/movie-recommender -n movie-recommender
```

## 📊 Data Versioning with DVC

### Track New Data

```bash
# Add new dataset
dvc add data/movies.csv

# Commit DVC files
git add data/movies.csv.dvc .gitignore
git commit -m "Add new movie dataset"

# Push to remote storage
dvc push
```

### Switch Between Versions

```bash
# Checkout specific version
git checkout v1.0
dvc checkout

# Return to latest
git checkout main
dvc checkout
```

### Reproduce Pipeline

```bash
# Run entire pipeline
dvc repro

# Force re-run specific stage
dvc repro -f train_model
```

## 🧪 Testing

### Run Tests

```bash
# All tests
pytest

# With coverage
pytest --cov=src --cov=pipeline --cov-report=html

# Specific test file
pytest tests/unit/test_recommender.py

# Integration tests only
pytest tests/integration/
```

### Test Structure

```python
# tests/unit/test_recommender.py
def test_get_recommendations():
    recommender = MovieRecommender()
    results = recommender.get_recommendations("The Matrix", n=10)
    assert len(results) == 10
    assert all('title' in r for r in results)
```

## 📈 Monitoring & Logging

### Application Logs

```bash
# Local
tail -f logs/application.log

# Kubernetes
kubectl logs -f deployment/movie-recommender -n movie-recommender

# Stream logs from all pods
kubectl logs -f -l app=movie-recommender -n movie-recommender
```

### Health Checks

```bash
# Local
curl http://localhost:5000/health

# Kubernetes
kubectl get pods -n movie-recommender
# Pods show "Running" with passing liveness/readiness probes
```

### Metrics

Access Comet ML dashboard for:
- Model performance metrics
- Training time trends
- Resource utilization
- Experiment comparisons

## 🔧 Configuration

### Application Configuration (`config/config.yaml`)

```yaml
app:
  name: movie-recommender
  version: 1.0.0
  debug: false

server:
  host: 0.0.0.0
  port: 5000

artifacts:
  path: artifacts/
  model_name: movie_recommender

logging:
  level: INFO
  format: '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
```

### Training Configuration (`config/train_config.yaml`)

```yaml
data:
  input_path: data/movies.csv
  test_size: 0.2
  random_state: 42

model:
  vectorizer: tfidf
  max_features: 5000
  min_df: 2
  max_df: 0.8

output:
  artifacts_path: artifacts
  model_name: movie_recommender

comet:
  project_name: movie-recommender
  workspace: your-workspace
```

## 🎯 API Endpoints

### Health Check
```bash
GET /health
```

### Search Movies
```bash
GET /api/search?q=matrix&limit=10
```

Response:
```json
{
  "success": true,
  "query": "matrix",
  "results": [
    {
      "title": "The Matrix",
      "genres": "Action|Sci-Fi",
      "rating": 8.7
    }
  ]
}
```

### Get Recommendations
```bash
POST /api/recommend
Content-Type: application/json

{
  "movie_title": "The Matrix",
  "n_recommendations": 10
}
```

Response:
```json
{
  "success": true,
  "movie": "The Matrix",
  "recommendations": [
    {
      "title": "The Matrix Reloaded",
      "genres": "Action|Sci-Fi",
      "rating": 7.2
    }
  ]
}
```

## 🔐 Security

- Non-root user in Docker container
- Kubernetes NetworkPolicy for pod isolation
- Secret management for sensitive data
- Vulnerability scanning with Trivy
- HTTPS/TLS encryption (configure in Ingress)

## 🚀 Performance Optimization

- **Caching**: Implement Redis for recommendation caching
- **Load Balancing**: Kubernetes service with multiple replicas
- **Auto-scaling**: HPA based on CPU/Memory metrics
- **CDN**: Use CDN for static assets
- **Database**: Use PostgreSQL for production data storage

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

### Code Style

```bash
# Format code
black src/ pipeline/

# Lint
flake8 src/ pipeline/
pylint src/ pipeline/
```

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Dataset: [MovieLens](https://grouplens.org/datasets/movielens/) or [TMDb](https://www.themoviedb.org/)
- Inspired by production ML systems best practices
- Built with modern MLOps tools and frameworks

## 📧 Contact

Your Name - [@yourtwitter](https://twitter.com/yourtwitter) - email@example.com

Project Link: [https://github.com/yourusername/movie-recommender](https://github.com/yourusername/movie-recommender)

## 🗺️ Roadmap

- [ ] Add collaborative filtering
- [ ] Implement A/B testing framework
- [ ] Add real-time recommendations
- [ ] Integrate with streaming data
- [ ] Add multi-language support
- [ ] Implement user authentication
- [ ] Add rating prediction
- [ ] Create mobile app
- [ ] Add recommendation explanations
- [ ] Implement active learning

## 📚 Additional Resources

- [DVC Documentation](https://dvc.org/doc)
- [Comet ML Documentation](https://www.comet.ml/docs/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Flask Documentation](https://flask.palletsprojects.com/)

---

**Star ⭐ this repository if you find it helpful!**
