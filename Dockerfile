# Adapted from https://github.com/dbsystel/postgresql-partman-container/blob/main/Dockerfile

ARG POSTGRESQL_VERSION="17.4"
FROM postgres:$POSTGRESQL_VERSION

RUN apt-get update
RUN apt-get -y install wget gcc make cmake build-essential coreutils postgresql-server-dev-17 libpq-dev git

## installing partman
WORKDIR /tmp
ARG PARTMAN_CHECKSUM="462464d83389ef20256b982960646a1572341c0beb09eeff32b4a69f04e31b76"

RUN wget "https://github.com/pgpartman/pg_partman/archive/refs/tags/v5.2.4.tar.gz" \
    && echo "${PARTMAN_CHECKSUM} v5.2.4.tar.gz" | sha256sum --check
RUN tar -zxf v5.2.4.tar.gz

WORKDIR /tmp/pg_partman-5.2.4
RUN make install
RUN cd ../ && rm -rf pg_partman-* v5.2.4.tar.gz
