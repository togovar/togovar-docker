FROM node:lts-alpine

RUN npm install -g http-server

ARG SAMTOOLS_VERSION=1.12

RUN apk add --no-cache \
      curl-dev \
      bzip2-dev \
      libressl-dev \
      musl-dev \
      perl \
      xz-dev \
      zlib-dev && \
    apk add --no-cache --virtual build-dependencies \
      automake \
      curl \
      gcc \
      make && \
    cd /tmp && \
    curl -L -o samtools-${SAMTOOLS_VERSION}.tar.bz2 https://github.com/samtools/samtools/releases/download/${SAMTOOLS_VERSION}/samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    tar xvf samtools-${SAMTOOLS_VERSION}.tar.bz2  && \
    cd samtools-${SAMTOOLS_VERSION} && \
    ./configure --without-curses && \
    make && \
    make install && \
    cd htslib-${SAMTOOLS_VERSION} && \
    ./configure && \
    make && \
    make install && \
    cd /tmp && \
    rm -f samtools-${SAMTOOLS_VERSION}.tar.bz2 && \
    rm -rf samtools-${SAMTOOLS_VERSION} && \
    apk del build-dependencies

WORKDIR /var/www

ARG branch=togovar

RUN apk add --no-cache \
      bash git && \
    git clone "https://github.com/togovar/jbrowse.git" -b "${branch}" . && \
    ./setup.sh && \
    rm .htaccess && \
    apk del git

ADD http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig /usr/local/bin/bedGraphToBigWig

EXPOSE 8080

CMD ["/usr/local/bin/http-server", "-d", "false"]
