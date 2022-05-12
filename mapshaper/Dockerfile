FROM cahik/vscode-ubuntu-qgis-testing:v2

RUN apt-get update && \
    apt install -y nodejs npm && \
    npm install -g mapshaper

ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python