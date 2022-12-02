ARG VARIANT=jammy
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN sudo gpg -k && \
    KEYRING=/usr/share/keyrings/qgis-archive-keyring.gpg && \
    wget -O $KEYRING https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
    FILE=/etc/apt/sources.list.d/ubuntugis-stable.sources && \
    echo 'Types: deb deb-src' | sudo tee -a $FILE && \
    echo 'URIs: https://qgis.org/ubuntugis' | sudo tee -a $FILE && \
    echo 'Suites: '$(lsb_release -c -s) | sudo tee -a $FILE && \
    echo 'Architectures: '$(dpkg --print-architecture) | sudo tee -a $FILE && \
    echo 'Components: main' | sudo tee -a $FILE && \
    echo 'Signed-By: '$KEYRING | sudo tee -a $FILE && \
    LASTSUPPORTED=focal && \
    KEYRING=/usr/share/keyrings/ubuntugis-archive-keyring.gpg && \
    sudo gpg --no-default-keyring --keyring $KEYRING --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160 && \
    FILE=/etc/apt/sources.list.d/ubuntugis-unstable.sources && \
    echo 'Types: deb deb-src' | sudo tee -a $FILE && \
    echo 'URIs: https://ppa.launchpadcontent.net/ubuntugis/ppa/ubuntu' | sudo tee -a $FILE && \
    echo 'Suites: '$LASTSUPPORTED | sudo tee -a $FILE && \
    echo 'Architectures: '$(dpkg --print-architecture) | sudo tee -a $FILE && \
    echo 'Components: main' | sudo tee -a $FILE && \
    echo 'Signed-By: '$KEYRING | sudo tee -a $FILE && \
    FILE=/etc/apt/sources.list.d/ubuntugis-unstable.sources && \
    echo 'Types: deb deb-src' | sudo tee -a $FILE && \
    echo 'URIs: https://ppa.launchpadcontent.net/ubuntugis/ubuntugis-unstable/ubuntu' | sudo tee -a $FILE && \
    echo 'Suites: '$(lsb_release -c -s) | sudo tee -a $FILE && \
    echo 'Architectures: '$(dpkg --print-architecture) | sudo tee -a $FILE && \
    echo 'Components: main' | sudo tee -a $FILE && \
    echo 'Signed-By: '$KEYRING | sudo tee -a $FILE

RUN export DEBIAN_FRONTEND=noninteractive && \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get update && \
    apt-get -y -q install --no-install-recommends wget software-properties-common build-essential ca-certificates python3-pip dialog apt-utils && \
    sudo apt update && \
    sudo apt upgrade -y -q && \
    sudo apt -y -q install qgis qgis-dev qgis-plugin-grass && \
    apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pytest pytest-qgis pytest-cov pillow flake8 mypy pycodestyle yapf pb_tool pytest-qt 

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python
