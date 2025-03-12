#!/bin/bash

# Remove previous build and then compile (Standard build)
./mvnw clean package

# Run
./mvnw spring-boot:run

# Fat JAR (Standalone executable)
./mvnw clean install

# 
./mvnw clean package -Pproduction

docker build --build-arg OTEL_AGENT_VERSION=$(mvn help:evaluate -Dexpression=otel.agent.version -q -DforceStdout) -t andrelapin/movie_app_backend .