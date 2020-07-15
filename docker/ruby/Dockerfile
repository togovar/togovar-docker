FROM ruby:2.7.1-buster

ARG ts=0.0.19

RUN curl -sL "https://deb.nodesource.com/setup_12.x" | bash - && \
    curl -sS "https://dl.yarnpkg.com/debian/pubkey.gpg" | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y nodejs yarn && \
    rm -rf /var/lib/apt/lists/*

RUN gem install bundler

ADD https://github.com/togostanza/ts/releases/download/v${ts}/ts_${ts}_linux_amd64.tar.gz /tmp/

RUN cd tmp && \
    tar xf ts_${ts}_linux_amd64.tar.gz && \
    mv ts_${ts}_linux_amd64/ts /usr/local/bin/ && \
    /usr/local/bin/ts version

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /

WORKDIR app

EXPOSE 8080

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]
