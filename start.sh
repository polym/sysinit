#!/bin/bash
set -xe
ROOT=$(pwd)/$(dirname "${BASH_SOURCE}")
echo $ROOT
## Global VAR
pkgs="wget curl vim tmux git gcc g++ make automake autoconf patch libtool ntpdate ack-grep tcpdump python3 openssh-server unzip python3-pip jq locales cmake colordiff zsh ripgrep"

export DEBIAN_FRONTEND=noninteractive
export TZ=Etc/UTC

### Apt Install
if [ "$CI" != "true" ]; then
    # travis ci connect 163.com timeout
    sed -i 's/archive.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list
fi
apt-get update && apt-get install -y $pkgs

### System Config
unlink /etc/localtime && ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
if [ "$CI" != "true" ]; then
    ntpdate -u -o3 time1.aliyun.com
fi
mkdir -p /etc/cron.d && echo "0 * * * * root (/usr/sbin/ntpdate -u -o3 time1.aliyun.com)" > /etc/cron.d/ntpdate
echo "nameserver 223.5.5.5" > /etc/resolv.conf

export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8
dpkg-reconfigure locales

### Config it
if [ ! -f $HOME/.bashrc.user ]; then
    echo ". $HOME/.bashrc.user" >> $HOME/.bashrc \
        && echo ". $HOME/.zshrc.user" >> $HOME/.zshrc \
        && find ${ROOT}/etc/ -type f | xargs -i ln -s {} $HOME/
fi

### Motd
rm -rf /etc/update-motd.d/* && cp ${ROOT}/bin/motd.py /etc/update-motd.d/50-sysinfo && chmod +x /etc/update-motd.d/50-sysinfo
sed -i -e 's|\(PrintLastLog\s*\)yes|\1no|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintLastLog\s*no\)|\1|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintLastLog\s*\)yes|\1no|' /etc/ssh/sshd_config
sed -i -e 's|\(PrintMotd\s*\)no|\1yes|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintMotd\s*yes\)|\1|' /etc/ssh/sshd_config
sed -i -e 's|#\(PrintMotd\s*\)no|\1yes|' /etc/ssh/sshd_config

### SSH Client Config
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
echo "UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config
if [ ! -f /root/.ssh/id_rsa ]; then
    ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
fi

### Install Golang From Source
mkdir -p $HOME/golang/3rdpkg \
    && cd $HOME/golang \
    && wget http://collection.b0.upaiyun.com/softwares/go-src.tar.gz \
    && tar zxvf go-src.tar.gz && rm go-src.tar.gz && mv go go-src \
    && cp -R go-src go-1.4 && cp -R go-src go-1.17

export GOROOT=$HOME/golang/go
export GOROOT_BOOTSTRAP=$HOME/golang/go-1.4

## https://github.com/moovweb/gvm/issues/286
# apt install -y gcc-7
# CC="gcc-7 -Wimplicit-fallthrough=0 -Wno-error=shift-negative-value -Wno-shift-negative-value -Wno-stringop-truncation"

ln -s $HOME/golang/go-1.4 $GOROOT
cd $GOROOT && git checkout go1.4.3 && cd src && CGO_ENABLED=0 ./make.bash
unlink $GOROOT

ln -s $HOME/golang/go-1.17 $GOROOT
cd $GOROOT && git checkout go1.17.7 && cd src && ./make.bash

. $HOME/.bashrc.user

### Install Vim Plugins
mkdir -p $HOME/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim \
    && vim -u $HOME/.vimrc.vundle +PluginInstall +qall

### Install Docker

### Install upx
go install github.com/upyun/upx@v0.3.6

### Install https://github.com/wg/wrk
cd /tmp && git clone https://github.com/wg/wrk && cd wrk && make && mv wrk /usr/bin

### Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
