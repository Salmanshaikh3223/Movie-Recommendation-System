🎥 Movie Recommendation System with MLOps

This project implements an end-to-end Movie Recommendation System, integrating essential MLOps practices. It covers data versioning, model training, experiment tracking, CI/CD automation, containerization, and deployment with Kubernetes — ensuring reproducibility, scalability, and maintainability.

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

🚀 Features

* Data Versioning: Track datasets and model artifacts using DVC
* Model Training: Modular scripts for configurable and reproducible training workflows
* Experiment Tracking: Integrated with Comet ML for metrics, visualizations, and comparisons
* CI/CD Pipeline: Automated with Jenkins for continuous integration and deployment
* Containerization: Docker ensures consistency across environments
* Deployment: Kubernetes manifests for scalable orchestration
* Web Interface: Flask-powered frontend for real-time movie recommendations
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

📁 Project Structure

>├── .dvc/                 # DVC configuration files     
>├── artifacts/            # Stored artifacts like models and datasets   
>├── build/lib/            # Build outputs    
>├── config/               # YAML configs for training, DVC, Comet, etc.    
>├── custom_jenkins/       # Jenkins pipeline scripts  
>├── logs/                 # Application and training logs  
>├── notebook/             # Jupyter notebooks for EDA & experiments  
>├── pipeline/             # ML pipeline scripts  
>├── src/                  # Core source code  
>├── static/               # Web static files (CSS, JS, Images)  
>├── templates/            # Flask HTML templates  
>├── utils/                # Helper functions  
>├── .dvcignore            # Ignore patterns for DVC  
>├── .gitignore            # Ignore patterns for Git  
>├── Dockerfile            # Container specification  
>├── Jenkinsfile           # CI/CD configuration  
>├── application.py        # Flask entrypoint  
>├── deployment.yaml       # Kubernetes deployment config  
>├── requirements.txt      # Python dependencies  
>├── setup.py              # Project setup config  
>├── tester.py             # Test runner script  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

🛠️ Getting Started

Prerequisites
*Python 3.8+
*Git
*Docker
*DVC
*Jenkins
*Kubernetes
*Comet ML account

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Installation

*git clone https://github.com/YOUR_USERNAME/Movie_Recommendation_MLOps.git
*cd Movie_Recommendation_System

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

🔧 Setup Instructions

Create a virtual environment

>python -m venv venv
>source venv/bin/activate    # On Windows: venv\Scripts\activate

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Install dependencies

>pip install -r requirements.txt


Initialize and Pull Data using DVC
>dvc init
>dvc pull

Run the Flask App
>docker build -t movie-recommender .
>docker run -p 5000:5000 movie-recommender

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

📊 Experiment Tracking with Comet ML

Use Comet ML to:

* Track training and validation metrics  
* Compare experiment runs  
* Visualize model performance and hyperparameters  
* Manage versioned artifacts  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

💡 Comet ML logging is automatically enabled during training if your API key is configured in .env.

⚙️ CI/CD Pipeline

The project uses Jenkins for continuous integration and deployment.

- Jenkins Pipeline Stages  
- Code testing and linting  
- Model training and versioning  
- Docker image build and push  
- Application deployment to Kubernetes  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
🧪 Testing

Run unit and integration tests locally:

>python tester.py

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
🤝 Contributing

Contributions are welcome!

  1. Fork the repository  
  2. Create a feature branch (feature/your-feature)  
  3. Commit your changes  
  4. Push to the branch  
  5. Open a Pull Request  
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
📜 License

This project is open-source under the MIT License.
