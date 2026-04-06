FROM maven:3.8.6-openjdk-11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
