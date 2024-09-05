FROM denvazh/gatling

# Copy entrypoint script into the image
ADD entrypoint.sh /entrypoint.sh

# Set permissions for gatling.sh and other necessary directories
RUN chmod +x /opt/gatling/bin/gatling.sh \
    && mkdir -p /opt/gatling/user-files/simulations/results \
    && chmod -R 777 /opt/gatling/user-files/simulations/results

# Install necessary tools and clean up after installation
RUN apk add --update jq git bash curl \
    && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

# Copy the Gatling simulations into the appropriate folder
COPY simulations/ /opt/gatling/user-files/simulations/

# Set entrypoint to use the custom script
ENTRYPOINT ["bash", "/entrypoint.sh"]

# Run the container as root only where required
USER root
