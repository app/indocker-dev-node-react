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
  neovim

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

RUN locale-gen --purge ru_RU.UTF-8 en_US.UTF-8
RUN echo 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale

USER app

COPY .gitconfig /home/app/
COPY .bash_prompt /home/app/
COPY .bash_git /home/app/
RUN echo "alias ll='ls -la'" >> /home/app/.bashrc && \
  echo ". ~/.bash_prompt" >> /home/app/.bashrc && \
  echo ". ~/.bash_git" >> /home/app/.bashrc

RUN echo 'export LANG="en_US.UTF-8"\n' >> /home/app/.bashrc

RUN \
  git clone https://github.com/app/nvim.git /home/app/.config/nvim && \
  vim +UpdateRemotePlugins +PlugUpdate +qall

CMD ["/usr/bin/sleep"]
