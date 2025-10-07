FROM python:3.9-slim as builder
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends gcc g++ && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt
FROM python:3.9-slim
WORKDIR /app
RUN useradd -m -u 1000 appuser && mkdir -p /app/logs /app/artifacts && chown -R appuser:appuser /app
COPY --from=builder /root/.local /home/appuser/.local
COPY --chown=appuser:appuser . .
ENV PATH=/home/appuser/.local/bin:$PATH PYTHONUNBUFFERED=1 FLASK_APP=application.py PYTHONPATH=/app
EXPOSE 5000
USER appuser
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 CMD python -c "import requests; requests.get('http://localhost:5000/health'^)" || exit 1
CMD ["python", "application.py"]
