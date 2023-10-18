FROM ruby:3.2

RUN curl -sL "https://deb.nodesource.com/setup_18.x" | bash -

RUN apt update && \
    apt install -y --no-install-recommends \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g npm

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /opt/togovar/app

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
