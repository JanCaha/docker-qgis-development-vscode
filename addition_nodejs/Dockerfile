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

RUN set -eux ; \
    source ./settings/env.BASE