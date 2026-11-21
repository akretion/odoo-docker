FROM ghcr.io/acsone/odoo-bedrock:19.0-py313-noble-latest
ARG PYTHONBIN=python3.13
LABEL org.opencontainers.image.authors="Akretion"
# syntax = docker/dockerfile:1.4

# List from https://github.com/camptocamp/docker-odoo-project/blob/master/19.0/Dockerfile
ENV BUILD_PACKAGE="\
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
    postgresql-client"

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGE

COPY 19.0-light/base_requirements.txt /tmp/base_requirements.txt
RUN pip install --no-cache-dir -r /tmp/base_requirements.txt

COPY 19.0-light/ak_requirements.txt /tmp/ak_requirements.txt
RUN pip install --no-cache-dir -r /tmp/ak_requirements.txt

# /home/odoo is created at runtime by the entrypoint (useradd -m)
# so shell config goes in /etc and history in the data volume
COPY install/odoo_shell_history.py /tmp/odoo_shell_history.py
COPY install/odoo_completion.bash /etc/bash_completion.d/odoo
RUN mkdir -p /data/odoo/history \
    && SITE=$(python -c "import sysconfig; print(sysconfig.get_path('purelib'))") \
    && mv /tmp/odoo_shell_history.py "$SITE/" \
    && echo "import odoo_shell_history" > "$SITE/odoo_shell_history.pth" \
    && echo "[ -f /etc/bash_completion.d/odoo ] && . /etc/bash_completion.d/odoo" >> /etc/bash.bashrc
ENV PYTHON_HISTORY=/data/odoo/history/python_history \
    IPYTHONDIR=/data/odoo/history/ipython \
    HISTFILE=/data/odoo/history/bash_history

WORKDIR /odoo
CMD ["odoo"]
