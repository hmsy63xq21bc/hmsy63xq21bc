FROM ubuntu:latest

# update and install software
RUN export DEBIAN_FRONTEND=noninteractive  \
	&& apt-get update -qy \
	&& apt-get full-upgrade -qy \
	&& apt-get dist-upgrade -qy \
	&& apt-get install -qy \
        sudo dirmngr wget curl unzip tar git xz-utils apt-utils openssh-server build-essential software-properties-common iproute2 \
        openjdk-21-jdk openjdk-21-jre nano lsb-release ca-certificates apt-transport-https net-tools golang postgresql qbittorrent-nox

# Install vscode
ARG VSCODE_VERSION
ARG VSCODE_PWD

# Install node
ARG NODE_VERSION

# Install JDownloader
ARG JD_DEVICE_NAME
ARG JD_PASSWORD
ARG JD_EMAIL

# Install qBittorrent
ARG QB_USER
ARG QB_PWD

# install postgres
ARG PS_USER
ARG PS_PWD

# install tdl
ARG TDL_VERSION
ARG TDL_PASSWORD
ARG TDL_USER

# install filebrowser
ARG FB_VERSION
ARG FB_PWD
ARG FB_USER

# cleanup and fix
RUN apt-get autoremove --purge -qy \
	&& apt-get --fix-broken install \
	&& apt-get clean 

# user and groups
ARG USER
ARG PASSWORD

# Zrok remote
ARG ZROK_ARGIRONMENT
ARG ZROK_PACKAGE_VERSION

# ports
EXPOSE 22 10000 4444 12345 7777

# default command
ADD ENTRYPOINT.sh /ENTRYPOINT.sh
COPY tdl.sh /home/tdl.sh
RUN chmod +x ENTRYPOINT.sh
ENTRYPOINT ["/ENTRYPOINT.sh"]
WORKDIR /home/$USER
USER $USER
