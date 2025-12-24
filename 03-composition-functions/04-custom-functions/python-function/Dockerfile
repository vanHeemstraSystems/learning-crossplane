# Dockerfile for Python Composition Function

FROM python:3.11-slim

WORKDIR /function

# Copy requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy function code
COPY function.py .

# Set entrypoint
ENTRYPOINT ["python", "function.py"]
