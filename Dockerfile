# Use a base image with JDK for Gatling
FROM adoptopenjdk:11-jre-hotspot

# Set the working directory inside the container
WORKDIR /opt/gatling

# Copy the Gatling distribution to the container
COPY gatling /opt/gatling

# Copy your simulation files (Scala simulations)
COPY src/test/scala /opt/gatling/user-files/simulations

# Copy your resource files (CSV, JSON files, etc.)
COPY src/test/resources /opt/gatling/user-files/resources

# Set environment variables for Gatling
ENV GATLING_HOME=/opt/gatling
ENV PATH=$PATH:/opt/gatling/bin

# Run Gatling with the simulation passed as an argument
ENTRYPOINT ["gatling.sh", "-s"]
