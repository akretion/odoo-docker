FROM ghcr.io/acsone/odoo-bedrock:12.0-py37-latest
MAINTAINER Akretion

# syntax = docker/dockerfile:1.4

# List from https://github.com/camptocamp/docker-odoo-project/blob/master/12.0/Dockerfile
ENV BUILD_PACKAGE \
    build-essential \
    gcc \
    python3.7-dev \
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
    #vim \
    po4a \
    libpq-dev \
    postgresql-client \
    libmupdf-dev \
    mupdf-tools \
    mupdf \
    expect

# recreate isolate env
RUN set -x \
  && rm -rf /odoo/bin \
  && python3.7 -m venv /env \
  && /env/bin/pip install -U pip wheel setuptools
ENV PATH=/env/bin:$PATH

# Install add-apt-repository command
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends software-properties-common

# Allow to use latest git in ubuntu 18.04
RUN add-apt-repository ppa:git-core/ppa

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGE

RUN pip install --force-reinstall pip "setuptools<58"

COPY 12.0/base_requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY 12.0/ak_requirements.txt /tmp/ak_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ak_requirements.txt

ENV ADDONS_PATH=/odoo/src/addons,/odoo/local-src,/odoo/links

COPY install/* /install/
RUN --mount=type=cache,target=/root/.cache /install/install_tool && rm /install/install_tool

COPY install/repos.yaml /root/.config/git-autoshare/repos.yml
COPY bin/* /usr/local/bin/


# customize entrypoint

ENTRYPOINT ["/usr/local/bin/ak-entrypoint.sh"]
CMD ["odoo"]
