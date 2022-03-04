FROM ruby:2.7.1-buster

RUN curl -sL "https://deb.nodesource.com/setup_14.x" | bash -

RUN apt --allow-releaseinfo-change update && \
    apt install -y --no-install-recommends \
      ca-certificates \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN npm install --global yarn

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR app

VOLUME /app/node_modules /app/log /app/tmp

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bundle", "exec", "unicorn", "-c", "config/unicorn.rb"]
