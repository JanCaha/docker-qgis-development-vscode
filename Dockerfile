ARG VARIANT=focal
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \ 
    apt-get -y install --no-install-recommends wget software-properties-common build-essential python3-pip && \
    wget -qO - https://qgis.org/downloads/qgis-2021.gpg.key | gpg --no-default-keyring --keyring gnupg-ring:/etc/apt/trusted.gpg.d/qgis-archive.gpg --import || true  && \
    chmod a+r /etc/apt/trusted.gpg.d/qgis-archive.gpg && \
    add-apt-repository "deb https://qgis.org/ubuntu `lsb_release -c -s` main" && \
    apt-get update && \
    apt-get install -y qgis qgis-plugin-grass saga && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pytest pytest-qgis pytest-cov pillow flake8 mypy pycodestyle yapf pb_tool pytest-qt pytest-xvfb

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python