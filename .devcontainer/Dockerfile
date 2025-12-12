# syntax=docker/dockerfile:1.4
FROM mcr.microsoft.com/devcontainers/typescript-node:20-bullseye

# Install system dependencies in a single layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /workspaces/zgcp-dev-workspace

# Install global dependencies first
RUN npm install -g nodemon

# Create directories for package files
RUN mkdir -p ona-flix/frontend ona-flix/backend/catalog

# Copy package files for dependency caching
COPY ona-flix/frontend/package*.json ./ona-flix/frontend/
COPY ona-flix/backend/catalog/package*.json ./ona-flix/backend/catalog/

# Install dependencies using BuildKit cache
RUN --mount=type=cache,target=/root/.npm \
    cd ona-flix/frontend && npm ci --prefer-offline --no-audit --no-fund && \
    cd ../backend/catalog && npm ci --prefer-offline --no-audit --no-fund

# Copy the rest of the application
COPY ona-flix ./ona-flix

# Set the default user
USER node
