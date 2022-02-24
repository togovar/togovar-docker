# TogoVar docker

## Configuration

`.env`

Environment variables used by docker compose file

```
COMPOSE_PROJECT_NAME=dev # (optional) set to avoid conflicting volume names

NGINX_PORT=80

JBROWSE_VOLUMES_DATA=./data/jbrowse/data

VIRTUOSO_VOLUMES_LOAD=./data/virtuoso/load
VIRTUOSO_VOLUMES_DATABASE=./data/virtuoso/database
VIRTUOSO_VOLUMES_SETTINGS=./data/virtuoso/settings

ELASTICSEARCH_VOLUMES_01_DATA=./data/elasticsearch/01
ELASTICSEARCH_VOLUMES_02_DATA=./data/elasticsearch/02
ELASTICSEARCH_VOLUMES_03_DATA=./data/elasticsearch/03
ELASTICSEARCH_VOLUMES_04_DATA=./data/elasticsearch/04
ELASTICSEARCH_VOLUMES_05_DATA=./data/elasticsearch/05
ELASTICSEARCH_VOLUMES_SNAPSHOT=./data/elasticsearch/snapshot
```

## Initialize

```
$ ./bin/initialize
```

```
$ docker-compose run --rm virtuoso rdf convert -c /config/GRCh37.yml
```

## Run application

```
$ git submodule update --init --recursive
$ cd jbrowse && ./setup.sh && cd -
$ docker-compose build
$ docker-compose up -d
```

## Use kibana

```yaml
  kibana:
    image: docker.elastic.co/kibana/kibana:7.13.0
    environment:
      ELASTICSEARCH_HOSTS: http://elasticsearch01:9200
      I18N_LOCALE: ja-JP
    depends_on:
      - elasticsearch01
      - elasticsearch02
      - elasticsearch03
      - elasticsearch04
      - elasticsearch05
    <<: *logging
```
