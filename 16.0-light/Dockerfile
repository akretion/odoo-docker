# python 3.10 is the default used in acsone
FROM ghcr.io/acsone/odoo-bedrock:16.0-py310-latest
ARG PYTHONBIN=python3.10
LABEL org.opencontainers.image.authors="Akretion"

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
    expect \
    postgresql-client

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGE

# Install tooling for running test and coverage
ENV PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin
RUN --mount=type=cache,target=/root/.cache\
    python3 -m pip install pipx &&\
    pipx install manifestoo &&\
    pipx install coverage

COPY 16.0/base_requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY 16.0-light/ak_requirements.txt /tmp/ak_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ak_requirements.txt

# customize entrypoint
COPY bin/ak-entrypoint-light.sh /usr/local/bin/ak-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/ak-entrypoint.sh"]

CMD ["odoo"]
