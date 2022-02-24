FROM openlink/virtuoso-opensource-7:7.2

RUN apt --allow-releaseinfo-change update && \
    apt install -y ruby && \
    rm -rf /var/lib/apt/lists/*

COPY --from=togovar/vcf2rdf /usr/local/bin/vcf2rdf /usr/local/bin/vcf2rdf
COPY bin/rdf /usr/local/bin/rdf

RUN chmod +x /usr/local/bin/rdf
