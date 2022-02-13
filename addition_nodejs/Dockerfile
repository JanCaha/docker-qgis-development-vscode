FROM cahik/vscode-ubuntu-qgis-testing:v2 as builder

RUN apt-get update && \
    apt install -y nodejs npm && \
    npm install -g mapshaper

RUN apt-get clean autoclean && \
    apt-get autoremove --yes && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir pytest-xdist
# pytest-xvfb

FROM scratch 

COPY --from=builder / /

ENV HOME=/root
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PWD=/
ENV DEBIAN_FRONTEND=noninteractive
ENV QT_QPA_PLATFORM=offscreen
ENV XDG_RUNTIME_DIR=/tmp
ENV PYTHONPATH=/usr/share/qgis/python/plugins:/usr/share/qgis/python