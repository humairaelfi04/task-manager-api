# Build Stage
FROM eclipse-temurin:17-jdk-alpine AS builder
WORKDIR /app

# Copy maven wrapper & pom.xml first for dependency caching
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:resolve -B

# Copy source code and build jar without tests (tests ran in CI stage)
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Runtime Stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Copy built jar artifact from builder
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
