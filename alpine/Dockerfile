# Derived from https://github.com/ellerbrock/docker-collection/blob/master/dockerfiles/alpine-neovim/Dockerfile
FROM alpine:edge

ARG SERVICE_USER
ARG SERVICE_HOME

ENV SERVICE_USER ${SERVICE_USER:-vim}
ENV SERVICE_HOME ${SERVICE_HOME:-/home/${SERVICE_USER}}

RUN \
  adduser -h ${SERVICE_HOME} -s /sbin/nologin -u 1000 -D ${SERVICE_USER}

RUN \
  apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    bash \
    py3-pynvim \
    fzf-neovim \
    py3-msgpack \
    dumb-init \
    neovim

USER    ${SERVICE_USER}
WORKDIR ${SERVICE_HOME}
VOLUME  ${SERVICE_HOME}

# ENTRYPOINT [ "/usr/bin/dumb-init", "--", "nvim" ]
ENTRYPOINT [ "/usr/bin/dumb-init", "--", "/bin/bash" ]
