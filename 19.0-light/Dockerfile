FROM ghcr.io/acsone/odoo-bedrock:19.0-py313-noble-latest
ARG PYTHONBIN=python3.13
LABEL org.opencontainers.image.authors="Akretion"
# syntax = docker/dockerfile:1.4

# List from https://github.com/camptocamp/docker-odoo-project/blob/master/19.0/Dockerfile
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
    libcairo2-dev \
# Additionnal dep from Ak
    po4a \
    libpq-dev \
    postgresql-client

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGE

COPY 19.0-light/base_requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY 19.0-light/ak_requirements.txt /tmp/ak_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ak_requirements.txt

WORKDIR /odoo
CMD ["odoo"]
