FROM ruby:3.2.4

ENV NODE_MAJOR=18

RUN apt update && \
    apt install -y --no-install-recommends \
      ca-certificates \
      curl \
      gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt update && \
    apt install -y --no-install-recommends \
      nodejs && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g npm

COPY docker-entrypoint.sh /usr/local/bin/

WORKDIR /opt/togovar/app

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["start"]
