FROM node:lts-buster

RUN apt update && \
    apt install -y --no-install-recommends \
      build-essential \
      libpng-dev \
      zlib1g-dev \
      libgd-dev \
      samtools \
      tabix && \
    rm -rf /var/lib/apt/lists/*

RUN npm install -g http-server

WORKDIR /var/www

ARG branch=togovar

RUN git clone "https://github.com/togovar/jbrowse.git" -b "${branch}" . && \
    ./setup.sh && \
    rm .htaccess

ADD http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64/bedGraphToBigWig /usr/local/bin/bedGraphToBigWig

CMD ["http-server", "-d", "false"]

EXPOSE 8080
