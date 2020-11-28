# Derived from https://github.com/ellerbrock/docker-collection/blob/master/dockerfiles/alpine-neovim/Dockerfile
FROM alpine:edge

ARG SERVICE_USER
ARG SERVICE_HOME

ENV SERVICE_USER ${SERVICE_USER:-vim}
ENV SERVICE_HOME ${SERVICE_HOME:-/home/${SERVICE_USER}}

RUN adduser --gecos "" -h ${SERVICE_HOME} -u 1000 -D ${SERVICE_USER}  
RUN \
  apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  bash \
  py3-pynvim \
  fzf-neovim \
  py3-msgpack \
  dumb-init \
  neovim \
  the_silver_searcher \
  git

RUN git clone https://github.com/app/nvim.git /home/${SERVICE_USER}/.config/nvim
RUN chown -R ${SERVICE_USER}:${SERVICE_USER} /home/${SERVICE_USER}
USER ${SERVICE_USER}
WORKDIR ${SERVICE_HOME}
SHELL ["/bin/bash", "-c"]
RUN nvim --headless +PlugInstall +qall 2> ${SERVICE_HOME}/error.log

CMD [ "/usr/bin/dumb-init", "--", "nvim" ]
