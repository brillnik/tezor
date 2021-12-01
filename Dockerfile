FROM node:16.13.0-slim
LABEL org.opencontainers.image.source https://github.com/settlemint/bpaas

WORKDIR /usecase

RUN apt update && \
  apt-get install -y nodejs build-essential jq python libcairo2-dev libpango1.0-dev libjpeg-dev libgif-dev librsvg2-dev && \
  rm -rf /var/lib/apt/lists/*

COPY ./package.json .
COPY yarn.lock .

COPY .yarnrc.yml .
COPY .yarn/plugins .yarn/plugins
COPY .yarn/releases .yarn/releases
RUN --mount=type=bind,target=/usecase/.yarn/cache,source=./.yarn/cache,rw \
  yarn workspaces focus

COPY ./ .
