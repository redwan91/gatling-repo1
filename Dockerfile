FROM denvazh/gatling

# Copy entrypoint script into the image
ADD entrypoint.sh /entrypoint.sh

# Set permissions for gatling.sh and other necessary directories
RUN  mkdir -p /opt/gatling/user-files/simulations/results
    

# Install necessary tools and clean up after installation
RUN apk add --update jq git bash curl \
    && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

# Copy the Gatling simulations into the appropriate folder
COPY simulations/ /opt/gatling/user-files/simulations/

# Set entrypoint to use the custom script
ENTRYPOINT ["bash", "/entrypoint.sh"]


