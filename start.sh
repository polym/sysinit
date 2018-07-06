set -ixe 
## Global VAR
pkgs="wget curl vim tmux git gcc g++ make automake autoconf patch libtool ntpdate ack-grep tcpdump python openssh-server"

### Apt Install
sed -i 's/archive.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list
apt-get update && apt-get install -y $pkgs

### System Config
unlink /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate -u -o3 time1.aliyun.com
mkdir -p /etc/cron.d && echo "0 * * * * (ntpdate -u -o3 time1.aliyun.com)" > /etc/cron.d/ntpdate
echo "nameserver 114.114.114.114" > /etc/resolv.conf

### Config it
cp -R etc/. $HOME

### Motd
rm -rf /etc/update-motd.d/* && cp bin/motd.py /etc/update-motd.d/50-sysinfo && chmod +x /etc/update-motd.d/50-sysinfo
sed -i -e 's|\(PrintLastLog\s*\)yes|\1no|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintLastLog\s*no\)|\1|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintLastLog\s*\)yes|\1no|' /etc/ssh/sshd_config
sed -i -e 's|\(PrintMotd\s*\)no|\1yes|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintMotd\s*yes\)|\1|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintMotd\s*\)no|\1yes|' /etc/ssh/sshd_config

### Install Golang From Source
mkdir -p $HOME/golang/3rdpkg \
    && cd $HOME/golang \
    && git clone https://github.com/golang/go.git go-src \
    && cp -R go-src go-1.4 && cp -R go-src go-1.9

export GOROOT=$HOME/golang/go
export GOROOT_BOOTSTRAP=$HOME/golang/go-1.4

ln -s $HOME/golang/go-1.4 $GOROOT
cd $GOROOT && git checkout go1.4.2 && cd src && CGO_ENABLED=0 ./make.bash
unlink $GOROOT

ln -s $HOME/golang/go-1.9 $GOROOT
cd $GOROOT && git checkout go1.9.5 && cd src && ./make.bash

. $HOME/.bashrc.user

### Install Vim Plugins
mkdir -p $HOME/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim \
    && vim -u $HOME/.vimrc.vundle +PluginInstall +qall

### Install Docker

### Install upx
go get github.com/polym/upx
