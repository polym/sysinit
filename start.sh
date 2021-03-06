#!/bin/bash
set -xe
ROOT=$(pwd)/$(dirname "${BASH_SOURCE}")
echo $ROOT
## Global VAR
pkgs="wget curl vim tmux git gcc g++ make automake autoconf patch libtool ntpdate ack-grep tcpdump python openssh-server unzip python-pip jq locales cmake colordiff"

### Apt Install
if [ "$CI" != "true" ]; then
    # travis ci connect 163.com timeout
    sed -i 's/archive.ubuntu.com/mirrors.163.com/' /etc/apt/sources.list
fi
apt-get update && apt-get install -y $pkgs

### GIT Editor
#git config --global core.editor vim

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
echo ". $HOME/.bashrc.user" >> $HOME/.bashrc && find ${ROOT}/etc/ -type f | xargs -i ln -s {} $HOME/

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
    && tar zxvf go-src.tar.gz && rm go-src.tar.gz \
    && cp -R go-src go-1.4 && cp -R go-src go-1.12

export GOROOT=$HOME/golang/go
export GOROOT_BOOTSTRAP=$HOME/golang/go-1.4

## https://github.com/moovweb/gvm/issues/286
GCC_VERSION=$(gcc -dumpversion)
if [[ "$GCC_VERSION" > "7" || "$GCC_VERSION" == "7" ]]; then
    CC="gcc -Wimplicit-fallthrough=0 -Wno-error=shift-negative-value -Wno-shift-negative-value"
else
    CC="gcc"
fi

ln -s $HOME/golang/go-1.4 $GOROOT
cd $GOROOT && git checkout go1.4.2 && cd src && CC=$CC CGO_ENABLED=0 ./make.bash
unlink $GOROOT

ln -s $HOME/golang/go-1.12 $GOROOT
cd $GOROOT && git checkout go1.12.9 && cd src && ./make.bash

. $HOME/.bashrc.user

### Install Vim Plugins
mkdir -p $HOME/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim \
    && vim -u $HOME/.vimrc.vundle +PluginInstall +qall

### Install Docker

### Install upx
go get github.com/polym/upx

### Install https://github.com/wg/wrk
cd /tmp && git clone https://github.com/wg/wrk && cd wrk && make && mv wrk /usr/bin
