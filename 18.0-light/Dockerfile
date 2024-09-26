FROM ghcr.io/acsone/odoo-bedrock:18.0-py312-noble-latest
ARG PYTHONBIN=python3.12
MAINTAINER Akretion

# syntax = docker/dockerfile:1.4

# List from https://github.com/camptocamp/docker-odoo-project/blob/master/16.0/Dockerfile
ENV BUILD_PACKAGE \
    build-essential \
    gcc \
    ${PYTHONBIN}-dev \
    libevent-dev \
    libfreetype6-dev \
    libxml2-dev \
    libxslt1-dev \
    libsasl2-dev \
    libldap2-dev \
    libssl-dev \
    libjpeg-dev \
    libpng-dev \
    zlib1g-dev \
    git \
# Additionnal dep from Ak
    po4a \
    libpq-dev \
    postgresql-client

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGE

COPY 18.0-light/base_requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY 18.0-light/ak_requirements.txt /tmp/ak_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ak_requirements.txt

CMD ["odoo"]
