
FROM openjdk:11-jre-slim

# Install required tools and Gatling
RUN apt-get update && apt-get install -y curl unzip bash \
    && curl -o gatling.zip https://repo1.maven.org/maven2/io/gatling/gatling-charts-highcharts-bundle/3.7.2/gatling-charts-highcharts-bundle-3.7.2-bundle.zip \
    && unzip gatling.zip -d /opt/ \
    && mv /opt/gatling-charts-highcharts-bundle-3.7.2 /opt/gatling \
    && rm gatling.zip

# Add custom entrypoint and scripts
COPY entrypoint.sh /entrypoint.sh
COPY run-gatling.sh /run-gatling.sh

# Copy the simulations and results folder
COPY simulations/ /opt/gatling/user-files/simulations/

# Set the necessary permissions
RUN chmod +x /run-gatling.sh

# Set entrypoint
ENTRYPOINT ["bash", "/entrypoint.sh"]
