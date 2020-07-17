FROM node:lts-buster

RUN npm install -g http-server

ARG ts=0.0.19

ADD https://github.com/togostanza/ts/releases/download/v${ts}/ts_${ts}_linux_amd64.tar.gz /tmp/

RUN cd tmp && \
    tar xvf ts_${ts}_linux_amd64.tar.gz && \
    mv -v ts_${ts}_linux_amd64/ts /usr/local/bin/ && \
    /usr/local/bin/ts version

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /stanza

VOLUME /stanza/dist

EXPOSE 8080

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["http-server", "-d", "false"]
