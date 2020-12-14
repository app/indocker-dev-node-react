FROM debian:sid
MAINTAINER Andrey Paskal <andrey@paskal.email>
ARG VCS_REF
ARG VCS_VERSION
ARG DEBIAN_FRONTEND=noninteractive

ENV USER app
ENV USER_HOME /home/${USER}

RUN \
  apt-get update -q --fix-missing && \
  apt-get -y upgrade && \
  apt-get -y install --no-install-recommends \
  apt-utils

RUN \
  apt-get -y install --no-install-recommends \
  bash-completion \
  unzip \
  bzip2 \
  inetutils-ping \
  ca-certificates \
  curl \
  file \
  grep \
  gzip \
  locales \
  rsyslog \
  dumb-init \
  sudo \
  git \
  neovim \
  tmux \
  jq \
  tree

# nodejs dependencies
RUN \
  apt-get -y install --no-install-recommends \
  software-properties-common \
  gnupg \
  gcc g++ make

# neovim plugins dependencies
RUN \
  apt-get -y install --no-install-recommends \
  python3-pip \
  silversearcher-ag \
  bsdmainutils

RUN curl -sL https://deb.nodesource.com/setup_14.x | sudo bash - && \
  apt-get install -y nodejs

RUN pip install pynvim
RUN adduser --quiet --disabled-password --gecos "" ${USER}
RUN echo "${USER} ALL=NOPASSWD: ALL" >>  /etc/sudoers

RUN export LANGUAGE="en_US.UTF-8" && export LANG="en_US.UTF-8" && export LC_ALL="en_US.UTF-8" && \
  echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US.UTF-8"\nLC_ALL="en_US.UTF-8"\n' > /etc/default/locale && \
  sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen

COPY .gitconfig ${USER_HOME}
COPY .bash_prompt ${USER_HOME}
COPY .bash_git ${USER_HOME}
COPY .tmux.conf ${USER_HOME}
COPY .tmux_statusline ${USER_HOME}
RUN echo "alias ll='ls -l'" >> ${USER_HOME}/.bashrc && \
  echo "alias la='ls -la'" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_prompt" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_git" >> ${USER_HOME}/.bashrc && \
  echo ". ~/.bash_locale" >> ${USER_HOME}/.bashrc && \
  sed -i '1iexport TERM=tmux-256color' ${USER_HOME}/.bashrc

RUN echo 'export LANG="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
  echo 'export LC_ALL="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale && \
  echo 'export LANGUAGE="en_US.UTF-8"' >> ${USER_HOME}/.bash_locale

RUN git clone https://github.com/app/nvim.git ${USER_HOME}/.config/nvim

RUN chown -R ${USER}:${USER} ${USER_HOME}
SHELL ["/bin/bash", "-c"]
USER root
RUN npm -g install tern
USER ${USER}
WORKDIR ${USER_HOME}
RUN nvim --headless +PlugInstall +qall 2> ${USER_HOME}/error.log
RUN [ -f ~/.fzf.bash ] && source ~/.fzf.bash

CMD [ "/usr/bin/dumb-init", "--", "/bin/bash" ]
