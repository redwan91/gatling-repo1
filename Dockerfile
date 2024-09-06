FROM openjdk:11-jre-slim

# Install required tools and download the correct Gatling bundle
RUN apt-get update && apt-get install -y curl unzip bash && \
    curl -fLo gatling.zip --retry 5 --retry-delay 5 https://repo1.maven.org/maven2/io/gatling/gatling-charts-highcharts-bundle/3.9.5/gatling-charts-highcharts-bundle-3.9.5-bundle.zip && \
    unzip gatling.zip -d /opt/ && \
    mv /opt/gatling-charts-highcharts-bundle-3.9.5 /opt/gatling && \
    rm gatling.zip || { echo "Gatling download failed"; exit 1; }

# Add custom entrypoint and scripts
COPY entrypoint.sh /entrypoint.sh
COPY run-gatling.sh /run-gatling.sh

# Copy the simulations and results folder
COPY simulations/ /opt/gatling/user-files/simulations/

# Set the necessary permissions
RUN chmod +x /run-gatling.sh

# Set entrypoint
ENTRYPOINT ["bash", "/entrypoint.sh"]
