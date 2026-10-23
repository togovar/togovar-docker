FROM node:26

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      git \
      perl \
      libpng-dev \
      zlib1g-dev \
      libgd-dev \
      samtools \
      tabix && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g http-server yarn@1.22.22 && \
    npm cache clean --force

WORKDIR /var/www

ARG branch=togovar

RUN git clone --depth 1 --branch "${branch}" https://github.com/togovar/jbrowse.git . && \
    mkdir -p node_modules/.bin && \
    ln -s "$(command -v yarn)" node_modules/.bin/yarn && \
    NODE_OPTIONS=--openssl-legacy-provider DISABLE_V8_COMPILE_CACHE=1 YARN_IGNORE_SCRIPTS=true ./setup.sh && \
    rm -f .htaccess

EXPOSE 8080

CMD ["http-server", "-a", "0.0.0.0", "-p", "8080", "-d", "false"]
