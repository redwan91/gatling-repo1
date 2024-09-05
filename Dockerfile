FROM denvazh/gatling

# Copy entrypoint script into the image
ADD entrypoint.sh /entrypoint.sh

# Install necessary tools and clean up after installation
RUN apk add --update jq git bash curl \
    && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

# Create the Gatling results directory with correct permissions
RUN mkdir -p /opt/gatling/results && chmod -R 777 /opt/gatling/results

# Copy the Gatling simulations into the appropriate folder
COPY simulations/ /opt/gatling/user-files/simulations/

# Set entrypoint to use the custom script
ENTRYPOINT ["bash", "/entrypoint.sh"]

# Use root user to ensure proper permissions
USER root
