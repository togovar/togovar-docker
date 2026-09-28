# TogoVar containers

## Compose files

| Environment | Docker Compose           | Additional override for rootless Podman |
|-------------|--------------------------|-----------------------------------------|
| Production  | `docker/compose.yml`     | `docker/compose.podman.yml`             |
| Staging     | `docker/compose.stg.yml` | `docker/compose.stg.podman.yml`         |

Production and staging are **independent configurations**. Select one row; do not combine `compose.yml` and
`compose.stg.yml`. Staging serves the frontend and stanzas from GitHub Pages, so it intentionally has no
`frontend-build` service.

Run the commands below from the repository root. Build contexts and repository mounts are relative to `docker/`, where
the first Compose file is located. Do not add `--project-directory .`: that would change their base directory. Existing
commands using that option must be updated when using these files. Use absolute data paths in `.env`; relative data
paths also resolve from `docker/`.

## Configuration

Create or update the repository-root `.env` with your deployment values:

```dotenv
COMPOSE_PROJECT_NAME=togovar_grch38
TOGOVAR_REFERENCE=GRCh38

NGINX_PORT=8080
PUBLIC_DIR=/absolute/path/to/public
JBROWSE_DATA=/absolute/path/to/jbrowse/data
HGVS2VCF_DATA=/absolute/path/to/hgvs2vcf
VIRTUOSO_DATA=/absolute/path/to/virtuoso/database
ELASTICSEARCH_01_DATA=/absolute/path/to/elasticsearch/01
ELASTICSEARCH_02_DATA=/absolute/path/to/elasticsearch/02
ELASTICSEARCH_03_DATA=/absolute/path/to/elasticsearch/03
ELASTICSEARCH_04_DATA=/absolute/path/to/elasticsearch/04
ELASTICSEARCH_05_DATA=/absolute/path/to/elasticsearch/05
ELASTICSEARCH_SNAPSHOT=/absolute/path/to/elasticsearch/snapshot

SECRET_KEY_BASE=<generate-a-secret>
SPARQLIST_ADMIN_PASSWORD=<choose-a-password>
SPARQL_PROXY_ADMIN_PASSWORD=<choose-a-password>

# Staging only: keep a stable secret of at least 32 characters.
KIBANA_ENCRYPTED_SAVED_OBJECTS_KEY=<generate-a-stable-encryption-key>
ELASTICSEARCH_PORT=9200
KIBANA_PORT=5601
```

The `${VAR:?}` variables are checked while parsing, even for inactive profiles. Set `HGVS2VCF_DATA` for both references,
and prepare its contents before enabling GRCh38; see [HGVS data preparation](docker/hgvs2vcf-cdot-lmdb/README.md). The
snapshot directory is now mounted on all five Elasticsearch nodes in both configurations, matching `path.repo`. Create
all data directories before starting.
`bin/initialize` covers only some of these directories and is not a data migration tool.

For a **new Elasticsearch cluster with empty data directories only**, temporarily add:

```dotenv
ELASTICSEARCH_INITIAL_MASTER_NODES=node01,node02,node03,node04,node05
```

After the cluster has formed, remove this variable and recreate the containers with the same Compose `up -d` command.
Leave it unset when reusing an existing cluster, including a migration from Docker. All nodes receive the same value;
the default empty list prevents accidental bootstrapping of a second cluster.
See [Elastic's cluster bootstrapping guidance](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/important-settings-configuration#initial_master_nodes).

Production URL defaults use `https://togovar.org`, while staging defaults use
`https://stg-togovar.org`. Existing `.env` values take precedence. Override
`TOGOVAR_FRONTEND_API_URL`, `TOGOVAR_ENDPOINT_SPARQL` and the other frontend endpoint variables when using a different
hostname.

## Docker Compose

Use Docker Compose v2 or a Compose Specification-compatible `docker-compose`. The common files contain no Podman-only
runtime options. The examples below use GRCh38. For GRCh37, set `TOGOVAR_REFERENCE=GRCh37` and omit `--profile GRCh38`.

```sh
git submodule update --init --recursive

# Production
docker compose --env-file .env --profile GRCh38 -f docker/compose.yml config --quiet
docker compose --env-file .env --profile GRCh38 -f docker/compose.yml build
docker compose --env-file .env --profile GRCh38 -f docker/compose.yml run --rm --no-deps app bundle install
docker compose --env-file .env --profile GRCh38 -f docker/compose.yml up -d

# Staging: use this file instead of docker/compose.yml for all commands above.
docker compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml config --quiet
docker compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml build
docker compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml run --rm --no-deps app bundle install
docker compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml up -d
```

With the standalone CLI, replace `docker compose` with `docker-compose`. The `app_bundle` named volume must contain the
backend gems; run `bundle install`
for a new volume and after Gemfile changes. Production builds the frontend before starting the app through
`service_completed_successfully`.

## Rootless Podman on Linux

Use a current Podman 5.x and `podman-compose` 1.5 or later. The overrides require support for `keep-id:uid=1000,gid=0`.
`podman compose` delegates to an external provider; select it explicitly so a different installed provider does not
silently change
behavior. [Podman Compose documentation](https://docs.podman.io/en/latest/markdown/podman-compose.1.html)

```sh
export PODMAN_COMPOSE_PROVIDER=podman-compose

# Production
podman compose --env-file .env --profile GRCh38 -f docker/compose.yml -f docker/compose.podman.yml config
podman compose --env-file .env --profile GRCh38 -f docker/compose.yml -f docker/compose.podman.yml build
podman compose --env-file .env --profile GRCh38 -f docker/compose.yml -f docker/compose.podman.yml run --rm --no-deps app bundle install
podman compose --env-file .env --profile GRCh38 -f docker/compose.yml -f docker/compose.podman.yml up -d

# Staging
podman compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml -f docker/compose.stg.podman.yml config
podman compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml -f docker/compose.stg.podman.yml build
podman compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml -f docker/compose.stg.podman.yml run --rm --no-deps app bundle install
podman compose --env-file .env --profile GRCh38 -f docker/compose.stg.yml -f docker/compose.stg.podman.yml up -d
```

`config` expands secrets from `.env`; keep its output private. The examples use GRCh38; omit `--profile GRCh38` for
GRCh37. Pass the profile explicitly: provider versions differ in whether they read `COMPOSE_PROFILES` from `.env`.
Always use the same pair of files for subsequent `logs`, `down`, and `run` commands. Docker Compose v2 can also be
selected as the provider by setting
`PODMAN_COMPOSE_PROVIDER` to the installed Compose executable's absolute path.

The Podman overrides make these changes:

- Use `k8s-file` logging with the same size limit. The common files omit `max-file`
  (Docker defaults to one file; Podman does not support that option).
- Add shared SELinux `:z` labels to mounts, including shared socket and frontend volumes. Starting containers can
  relabel these paths; use dedicated application directories, rather than system directories or an entire home
  directory.
- Map the invoking user to Elasticsearch's `1000:0`, disable automatic ownership changes, and disable memory locking
  with both inherited memlock limits set to zero. Elasticsearch data and snapshot directories must be writable by that
  host user.
- Name locally built images under `localhost/` and run containers outside a shared Podman pod so the Elasticsearch user
  namespace settings can apply per container.

These follow [Podman's runtime options](https://docs.podman.io/en/latest/markdown/podman-run.1.html). The other services
keep their image users; their bind mounts must also have appropriate read/write permissions. Existing Docker-owned data
may need an explicit ownership migration. The configuration does not recursively chown existing data.

Host preparation:

- Set `NGINX_PORT=8080` (or another permitted high port). An existing `.env` value of `80` still takes precedence;
  rootless low ports need host configuration or an external reverse proxy.
- Configure subordinate UID/GID ranges for the Podman user, and a host hard limit of at least 65535 open files
  (`ulimit -Hn`).
- Set the host `vm.max_map_count` to at least 1048576. Disable host swap when using the overrides, since Elasticsearch
  memory locking is disabled. Common Docker configuration instead enables memory locking and supplies unlimited memlock.
- Size the host for five Elasticsearch nodes: the unchanged default heap is 16 GiB per node, plus native memory and
  Virtuoso. Set `ELASTICSEARCH_JAVA_OPTS` explicitly for a smaller test deployment.

See [Elasticsearch container requirements](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-docker-prod).

Docker and Podman use separate image and named-volume stores. Rebuild the local images and reinstall backend gems;
migrate any required named-volume contents separately. Stop the Docker services before letting Podman open the same
database directories. Keep `COMPOSE_PROJECT_NAME` consistent for each deployment.

These overrides target **Linux rootless Podman**. Rootful execution and macOS Podman machine need their own UID mapping,
host/VM resource, and mount checks. Application readiness and a complete data migration must be verified on the target
host.
