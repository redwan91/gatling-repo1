FROM denvazh/gatling

# Copy entrypoint script into the image
ADD entrypoint.sh /entrypoint.sh

# Copy the entire simulations folder (including src and results) into the image
COPY simulations/ /opt/gatling/user-files/simulations/

# Ensure the results folder has the correct permissions
RUN chmod -R 777 /opt/gatling/user-files/simulations/results

# Install necessary tools and clean up after installation
RUN apk add --update jq git bash curl \
    && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

# Set entrypoint to use the custom script
ENTRYPOINT ["bash", "/entrypoint.sh"]

# Run the container as root only where required
USER root