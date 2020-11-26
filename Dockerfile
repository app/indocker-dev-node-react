FROM debian:sid
MAINTAINER Andrey Paskal <andrey@paskal.email>
ARG VCS_REF
ARG VCS_VERSION
ARG DEBIAN_FRONTEND=noninteractive

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
  sudo \
  git \
  neovim \
  tmux

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
RUN adduser --quiet --disabled-password --gecos "" app
RUN echo "app ALL=NOPASSWD: ALL" >>  /etc/sudoers

RUN export LANGUAGE="en_US.UTF-8" && export LANG="en_US.UTF-8" && export LC_ALL="en_US.UTF-8" && \
  echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US.UTF-8"\nLC_ALL="en_US.UTF-8"\n' > /etc/default/locale && \
  sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
  locale-gen

USER app

COPY .gitconfig /home/app/
COPY .bash_prompt /home/app/
COPY .bash_git /home/app/
COPY .tmux.conf /home/app/
COPY .tmux_statusline /home/app/
RUN echo "alias ll='ls -l'" >> /home/app/.bashrc && \
  echo "alias la='ls -la'" >> /home/app/.bashrc && \
  echo ". ~/.bash_prompt" >> /home/app/.bashrc && \
  echo ". ~/.bash_git" >> /home/app/.bashrc && \
  echo ". ~/.bash_locale" >> /home/app/.bashrc && \
  sed -i '1iexport TERM=xterm-256color' /home/app/.bashrc

RUN echo 'export LANG="en_US.UTF-8"' >> /home/app/.bash_locale && \
  echo 'export LC_ALL="en_US.UTF-8"' >> /home/app/.bash_locale && \
  echo 'export LANGUAGE="en_US.UTF-8"' >> /home/app/.bash_locale

RUN \
  git clone https://github.com/app/nvim.git /home/app/.config/nvim && \
  vim +UpdateRemotePlugins +PlugUpdate +qall

CMD ["/usr/bin/sleep"]
