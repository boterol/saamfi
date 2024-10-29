FROM maven:3.8.6-openjdk-11 AS build

# Set the working directory
WORKDIR /app

# Copy app source
COPY . .

# Make sure the mvnw script is executable
RUN chmod +x mvnw

# Copy and install custom JAR
COPY libs/ojdbc6-11.2.0.3.jar /app/libs/ojdbc6-11.2.0.3.jar
RUN mvn install:install-file \
    -Dfile=/app/libs/ojdbc6-11.2.0.3.jar \
    -DgroupId=oracle \
    -DartifactId=ojdbc6 \
    -Dversion=11.2.0.3 \
    -Dpackaging=jar

# Compile and package the Spring Boot application
RUN ./mvnw clean package -DskipTests -X


# Use a smaller image for the runtime
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/your-app.jar /app/your-app.jar

# Run the Spring Boot app
CMD ["java", "-jar", "/app/your-app.jar"]
