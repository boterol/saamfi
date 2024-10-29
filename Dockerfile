# Add this line to copy the JAR into the container
COPY C:/Users/luisb/OneDrive/Escritorio/ICESI/S8/devops/taller2/ojdbc6/ojdbc6/11.2.0.3/ojdbc6-11.2.0.3.jar /app/libs/ojdbc6-11.2.0.3.jar

# Install the JAR into Maven's local repository within the container
RUN mvn install:install-file -Dfile=/app/libs/ojdbc6-11.2.0.3.jar \
  -DgroupId=oracle \
  -DartifactId=ojdbc6 \
  -Dversion=11.2.0.3 \
  -Dpackaging=jar \
  -DgeneratePom=true
