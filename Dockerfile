# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package

# Stage 2: Create a minimal JRE image and copy the JAR file
FROM openjdk:17-jdk-alpine
WORKDIR /app
COPY --from=build /app/target/minsait-0.0.1-SNAPSHOT.jar ./app.jar

# Specify the default command to run on startup
CMD ["java", "-jar", "app.jar"]
