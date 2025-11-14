# Stage 1: Build/Install dependencies
FROM python:3.9-slim as builder
WORKDIR /app
RUN pip install --upgrade pip
COPY requirements.txt .
# Build wheels for dependencies for a smaller final image
RUN pip wheel --no-cache-dir --wheel-dir=/app/wheels -r requirements.txt

# Stage 2: Final image
FROM python:3.9-slim
WORKDIR /app

# Copy the built wheels from the builder stage
COPY --from=builder /app/wheels /app/wheels
COPY requirements.txt .
COPY app.py .

# Install dependencies from the local wheels
RUN pip install --no-cache-dir --find-links=/app/wheels -r requirements.txt

# Make port 5000 available
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py

# Run flask
CMD ["flask", "run", "--host=0.0.0.0"]
