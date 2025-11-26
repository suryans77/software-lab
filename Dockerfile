FROM eclipse-temurin:21-jdk

# Set working directory
WORKDIR /app

# Copy the shaded JAR (built by Maven)
COPY target/todo-cli-app-1.0.jar app.jar

# Run the app
ENTRYPOINT ["java", "-jar", "app.jar"]