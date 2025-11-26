# Use official OpenJDK 21 image
FROM openjdk:21-jdk-slim

# Set working directory
WORKDIR /app

# Copy the shaded JAR (built by Maven)
COPY target/todo-app.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]