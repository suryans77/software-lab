
FROM eclipse-temurin:21-jdk


# Create a non-root user (best practice & matches most lab expectations)
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Set working directory
WORKDIR /app

# Copy the fat JAR created by Maven Shade plugin
# → Your pom.xml must have <finalName>todo-app</finalName> inside the shade plugin
COPY target/todo-app.jar app.jar

# Change ownership to the non-root user
RUN chown appuser:appgroup app.jar

# Switch to non-root user
USER appuser

# Expose port (optional, since it's CLI, but good practice)
EXPOSE 8080

# Run the To-Do List CLI Application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]