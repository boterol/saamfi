# Base image with Maven and JDK
FROM maven:3.8.1-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy project files into the container
COPY . .

# Copy the ojdbc JAR into the Docker container
COPY /tmp/ojdbc6-11.2.0.3.jar /app/libs/

# Install the ojdbc artifact in the local Maven repository
RUN mvn install:install-file -Dfile=/app/libs/ojdbc6-11.2.0.3.jar -DgroupId=oracle -DartifactId=ojdbc6 -Dversion=11.2.0.3 -Dpackaging=jar

# Build the application
RUN mvn clean install -DskipTests

# Runtime image
FROM openjdk:11-jre-slim

# Working directory
WORKDIR /app

# Copy the JAR built in the previous stage
COPY --from=build /app/target/your-app.jar .

# Expose port and run the app
EXPOSE 8080
CMD ["java", "-jar", "your-app.jar"]
