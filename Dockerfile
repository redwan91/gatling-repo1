FROM denvazh/gatling

# Copy entrypoint script into the image
ADD entrypoint.sh /entrypoint.sh

# Copy the entire simulations folder (including src and results) into the image
COPY simulations/ /opt/gatling/user-files/simulations/


# Install necessary tools and clean up after installation
RUN apk add --update jq git bash curl \
    && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

# Set entrypoint to use the custom script
ENTRYPOINT ["bash", "/entrypoint.sh"]
