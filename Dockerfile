ARG VARIANT=focal
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install --no-install-recommends wget software-properties-common build-essential ca-certificates python3-pip 

RUN KEYRING=/usr/share/keyrings/qgis-archive-keyring.gpg && \
    wget -O $KEYRING https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
    touch /etc/apt/sources.list.d/qgis.sources && \
    echo 'Types: deb deb-src' | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    echo 'URIs: https://qgis.org/ubuntugis' | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    echo 'Suites: 'lsb_release -c -s | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    echo 'Architectures: '$(dpkg --print-architecture) | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    echo 'Components: main' | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    echo 'Signed-By: '$KEYRING | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
    sudo apt update && \
    sudo apt upgrade -y && \
    sudo apt -y install qgis qgis-dev qgis-plugin-grass qgis-dev    

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pytest pytest-qgis pytest-cov pillow flake8 mypy pycodestyle yapf pb_tool pytest-qt 

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python
