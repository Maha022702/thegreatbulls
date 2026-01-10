# Dockerfile for Kite AWS Collector
FROM python:3.10-slim as base

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install in stages to avoid timeouts
COPY requirements.txt .

# Install lightweight packages first
RUN pip install --no-cache-dir --timeout=300 \
    kiteconnect \
    opensearch-py \
    requests-aws4auth \
    boto3 \
    pandas

# Install heavier ML packages with CPU-only torch for smaller size
RUN pip install --no-cache-dir --timeout=600 \
    torch --index-url https://download.pytorch.org/whl/cpu

RUN pip install --no-cache-dir --timeout=600 \
    sentence-transformers \
    langchain \
    langchain-community \
    langchain-aws

# Clean up caches to reduce image size
RUN rm -rf /root/.cache/pip && \
    find /usr/local -name "*.pyc" -delete && \
    find /usr/local -name "__pycache__" -type d -exec rm -rf {} + || true

# Final stage with minimal image
FROM python:3.10-slim

WORKDIR /app

# Copy installed packages from base stage
COPY --from=base /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=base /usr/local/bin /usr/local/bin

COPY kite_integration.py .

# Set environment variables (override with --env-file or -e)
ENV AWS_REGION=us-east-1
ENV KITE_API_KEY=""
ENV KITE_API_SECRET=""
ENV OPENSEARCH_ENDPOINT=""
ENV BEDROCK_MODEL_ID="anthropic.claude-v2"

CMD ["python", "kite_integration.py"]