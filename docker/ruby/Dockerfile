FROM ruby:2.7.1-buster

RUN curl -sL "https://deb.nodesource.com/setup_12.x" | bash - && \
    curl -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt update && \
    apt install -y --no-install-recommends nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR app

VOLUME /app/node_modules /app/log /app/tmp

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["unicorn", "-c", "config/unicorn.rb"]
