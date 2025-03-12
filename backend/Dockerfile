
# Build Stage
FROM maven:3.9.9-eclipse-temurin-17 AS builder
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# Run Stage
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

ARG OTEL_AGENT_VERSION=1.29.0
ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OTEL_AGENT_VERSION}/opentelemetry-javaagent.jar /otel-javaagent.jar
ENV JAVA_TOOL_OPTIONS="-javaagent:/otel-javaagent.jar"

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]