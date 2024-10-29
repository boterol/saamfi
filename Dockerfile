FROM openjdk:11-jre-slim

# Install Maven
RUN apt-get update && \
    apt-get install -y maven && \
    rm -rf /var/lib/apt/lists/*

# Copy app source
COPY . /app

# Copy and install custom JAR
COPY libs/ojdbc6-11.2.0.3.jar /app/libs/ojdbc6-11.2.0.3.jar
RUN mvn install:install-file \
    -Dfile=/app/libs/ojdbc6-11.2.0.3.jar \
    -DgroupId=oracle \
    -DartifactId=ojdbc6 \
    -Dversion=11.2.0.3 \
    -Dpackaging=jar

# Compile and package the Spring Boot application
WORKDIR /app
RUN ./mvnw clean package -DskipTests

# Run the Spring Boot app
CMD ["java", "-jar", "/app/target/your-app.jar"]
