FROM ruby:3.2.4

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bcftools \
      samtools \
      tabix && \
    rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
