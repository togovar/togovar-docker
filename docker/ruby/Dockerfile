FROM ruby:2.7.1-buster

RUN curl -sL "https://deb.nodesource.com/setup_14.x" | bash -

RUN apt --allow-releaseinfo-change update && \
    apt install -y --no-install-recommends \
      ca-certificates \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN npm update -g npm

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /opt/togovar/app

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
