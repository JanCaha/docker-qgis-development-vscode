ARG VARIANT=jammy
FROM mcr.microsoft.com/vscode/devcontainers/base:${VARIANT}

RUN sudo gpg -k && \
    KEYRING=/usr/share/keyrings/qgis-archive-keyring.gpg && \
    wget -O $KEYRING https://download.qgis.org/downloads/qgis-archive-keyring.gpg && \
    touch /etc/apt/sources.list.d/qgis.sources && \
    echo -e 'Types: deb deb-src\n' \
        'URIs: https://qgis.org/ubuntugis\n' \
        'Suites: '$(lsb_release -c -s)'\n' \
        'Architectures: '$(dpkg --print-architecture)'\n' \
        'Components: main'
        'Signed-By: '$KEYRING | sudo tee -a /etc/apt/sources.list.d/qgis.sources && \
        LASTSUPPORTED=focal && \
        KEYRING=/usr/share/keyrings/ubuntugis-archive-keyring.gpg && \
        sudo gpg --no-default-keyring --keyring $KEYRING --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160 && \
    echo -e 'Types: deb deb-src\n' \
        'URIs: https://ppa.launchpadcontent.net/ubuntugis/ppa/ubuntu\n' \
        'Suites: '$LASTSUPPORTED'\n' \
        'Architectures: '$(dpkg --print-architecture)'\n' \
        'Components: main\n' \
        'Signed-By: '$KEYRING'\n' | sudo tee -a /etc/apt/sources.list.d/ubuntugis-stable.sources && \
    echo -e 'Types: deb deb-src\n' \ 
        'URIs:https://ppa.launchpadcontent.net/ubuntugis/ubuntugis-unstable/ubuntu\n' \
        'Suites: '$(lsb_release -c -s)'\n' \
        'Architectures: '$(dpkg --print-architecture)'\n' \
        'Components: main\n' \
        'Signed-By: '$KEYRING'\n' | sudo tee -a /etc/apt/sources.list.d/ubuntugis-unstable.sources

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
