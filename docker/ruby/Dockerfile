FROM ruby:2.5

ARG ts=0.0.15

RUN curl -sL "https://deb.nodesource.com/setup_10.x" | bash - && \
    curl -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

RUN echo -e "---\nBUNDLE_PATH: \"vendor/bundle\"" > /usr/local/bundle/config

ADD https://github.com/togostanza/ts/releases/download/v${ts}/ts_${ts}_linux_amd64.tar.gz /tmp/

RUN cd tmp && \
    tar xf ts_${ts}_linux_amd64.tar.gz && \
    mv ts_${ts}_linux_amd64/ts /usr/local/bin/ && \
    /usr/local/bin/ts version

ADD docker-entrypoint.sh /

WORKDIR app

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
