FROM openjdk:11

# Install Maven using the official Maven repository
RUN apt-get update && \
    apt-get install -y wget && \
    wget -qO - https://archive.apache.org/dist/maven/binaries/apache-maven-3.6.3-bin.tar.gz | tar -xz -C /opt && \
    ln -s /opt/apache-maven-3.6.3/bin/mvn /usr/bin/mvn && \
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

# Set permissions for mvnw
RUN chmod +x /app/mvnw

# Compile and package the Spring Boot application
WORKDIR /app
RUN ./mvnw clean package -DskipTests

# Run the Spring Boot app
CMD ["java", "-jar", "/app/target/your-app.jar"]
