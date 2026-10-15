FROM node:14-buster

RUN sed -i \
      -e 's|http://deb.debian.org/debian-security|http://archive.debian.org/debian-security|g' \
      -e 's|http://security.debian.org/debian-security|http://archive.debian.org/debian-security|g' \
      -e 's|http://deb.debian.org/debian|http://archive.debian.org/debian|g' \
      /etc/apt/sources.list && \
    apt-get -o Acquire::Check-Valid-Until=false update && \
    apt-get install -y --no-install-recommends \
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
