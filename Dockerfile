FROM denvazh/gatling

ADD entrypoint.sh /entrypoint.sh
RUN apk add --update jq git bash curl     && rm -rf /var/cache/apk/*  # Clean-up to reduce image size

ENTRYPOINT ["bash", "/entrypoint.sh"]

COPY simulations/ /opt/gatling/user-files/simulations/
