# TogoVar docker

## Configuration

### .env example

```bash
$ cat .env
# Docker compose settings
TOGOVAR_DOCKER_PORT=80
TOGOVAR_DOCKER_LOAD_BASE=/var/togovar/load
TOGOVAR_DOCKER_STORE_BASE=/var/togovar/data
TOGOVAR_DOCKER_PUBLIC_DIR=/var/www/public
TOGOVAR_DOCKER_JBROWSE_DATA=/var/www/jbrowse/data

# TogoVar application settings
TOGOVAR_ENDPOINT_SEARCH=http://togovar.biosciencedbc.jp/search
TOGOVAR_ENDPOINT_SPARQL=https://togovar.biosciencedbc.jp/sparql
TOGOVAR_ENDPOINT_STANZA=https://togovar.biosciencedbc.jp/stanza
TOGOVAR_ENDPOINT_SPARQLIST=https://togovar.biosciencedbc.jp/sparqlist
TOGOVAR_ENDPOINT_JBROWSE=https://togovar.biosciencedbc.jp/jbrowse

TOGOVAR_RDF_BASE_URI=http://togovar.biosciencedbc.jp
TOGOVAR_RDF_LOAD_DIR=/load

TOGOVAR_PUBLIC_DIR=/var/www/public

TOGOVAR_SECRET_KEY_BASE=changeme

# SPARQList settings
TOGOVAR_SPARQLIST_ADMIN_PASSWORD=changeme
```

## Run application

```
$ git submodule update --init --recursive
$ cd jbrowse && ./setup.sh && cd -
$ docker-compose build
$ docker-compose up -d
```
