#!/bin/bash

useradd -m -s /bin/bash $USER
usermod -append --groups sudo $USER
echo "$USER:$PASSWORD" | chpasswd
echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
chown -R $USER:$USER /home/$USER/.*

service ssh start

wget https://github.com/coder/code-server/releases/download/v$VSCODE_VERSION/code-server_${VSCODE_VERSION}_amd64.deb
dpkg -i code-server_${VSCODE_VERSION}_amd64.deb
rm -rf code-server_${VSCODE_VERSION}.deb
su - $USER -c "mkdir -p /home/$USER/.config/code-server"
su - $USER -c "touch /home/$USER/.config/code-server/config.yaml"
echo -e "bind-addr: 127.0.0.1:8080\nauth: password\npassword: $VSCODE_PWD\ncert: false" >> /home/$USER/.config/code-server/config.yaml
su - $USER -c "code-server --bind-addr 127.0.0.1:10000 >> vscode.log &"

# Install node
wget -O - https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash \
    && apt-get -y install nodejs

# Install qbittorrent
su - $USER -c "mkdir -p /home/$USER/.config/qBittorrent"
su - $USER -c "touch /home/$USER/.config/qBittorrent/qBittorrent.conf"
su - $USER -c cat > /home/$USER/.config/qBittorrent/qBittorrent.conf <<END 
[Preferences]
WebUI\Port=4444
WebUI\Username=$QB_USER
WebUI\Password_PBKDF2=$QB_PWD
END
su - $USER -c "qbittorrent-nox --webui-port=4444 >> qbittorrent.log &"

# install postgres
service postgresql start
#sudo su - postgres <<EOF
#psql -c "CREATE USER $PS_USER;"
#psql -c "ALTER USER shakugan WITH PASSWORD '$PS_PWD';"
#psql -c "CREATE DATABASE filebrowser;"
#psql -c "GRANT ALL PRIVILEGES ON DATABASE filebrowser TO $PS_USER;"
#EOF

# install tdl
wget https://github.com/sorenisanerd/gotty/releases/download/v1.5.0/gotty_v1.5.0_linux_amd64.tar.gz
tar -xf gotty_v1.5.0_linux_amd64.tar.gz && rm -rf gotty_v1.5.0_linux_amd64.tar.gz
chmod +x gotty && mv gotty /usr/local/bin/gotty
wget https://github.com/iyear/tdl/releases/download/v${TDL_VERSION}/tdl_Linux_64bit.tar.gz
mkdir tdl && tar -C tdl -xzf tdl_Linux_64bit.tar.gz && chmod +x tdl/tdl
mv tdl/tdl /usr/local/bin/tdl && rm -rf tdl tdl_Linux_64bit.tar.gz
su - $USER -c "mkdir tdl"
chmod ugo+rwx /home/tdl.sh
mv /home/tdl.sh /home/$USER/tdl/tdl.sh
chmod +x /home/$USER/tdl/tdl.sh
su - $USER -c "gotty --credential '${TDL_USER}:${TDL_PASSWORD}' -p 12345 --reconnect -w /home/$USER/tdl/tdl.sh >> tdl.log &"

# install filebrowser
wget https://github.com/filebrowser/filebrowser/releases/download/v${FB_VERSION}/linux-amd64-filebrowser.tar.gz
mkdir filebrowser && tar -C filebrowser -xzf linux-amd64-filebrowser.tar.gz
chmod +x filebrowser/filebrowser && mv filebrowser/filebrowser /usr/local/bin/filebrowser
rm -rf filebrowser linux-amd64-filebrowser.tar.gz
su - $USER -c "mkdir -p /home/$USER/Downloads"
su - $USER -c "filebrowser config init"
su - $USER -c "filebrowser users add $FB_USER $FB_PWD"
su - $USER -c "filebrowser -p 7777 -r /home/$USER/Downloads >> filebrowser.log &"

# Install zrok
curl -fSL "https://github.com/openziti/zrok/releases/download/v${ZROK_PACKAGE_VERSION}/zrok_${ZROK_PACKAGE_VERSION}_linux_amd64.tar.gz" -o zrok.tar.gz
mkdir zrok
tar -C zrok -xzf zrok.tar.gz
chmod +x zrok/zrok
mv zrok/zrok /usr/local/bin/zrok
rm -rf zrok zrok.tar.gz
su - $USER -c "zrok enable $ZROK_ENVIRONMENT"
su - $USER -c "zrok share private -b tcpTunnel 0.0.0.0:22 --headless & zrok share public localhost:10000 --headless & zrok share public localhost:4444 --headless & zrok share public localhost:12345 --headless & zrok share public localhost:7777 --headless >> zrok.log &"

# Install JDownloader
su - $USER -c "mkdir -p /home/$USER/jdownloader/cfg"
su - $USER -c 'curl -fSL "http://installer.jdownloader.org/JDownloader.jar" -o /home/$USER/jdownloader/JDownloader.jar'
su - $USER -c "java -jar /home/$USER/jdownloader/JDownloader.jar -norestart"
su - $USER -c cat > /home/$USER/jdownloader/cfg/org.jdownloader.api.myjdownloader.MyJDownloaderSettings.json <<END 
{\"devicename\" : \"$JD_DEVICE_NAME\", \"autoconnectenabledv2\" : true, \"password\" : \"$JD_PASSWORD\", \"email\" : \"$JD_EMAIL\"}
END
su - $USER -c "java -jar /home/$USER/jdownloader/JDownloader.jar -norestart >> /home/$USER/jdownloader.log "
