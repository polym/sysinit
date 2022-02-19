FROM ubuntu:20.04

ADD . /sysinit

ENV CI=true

RUN /sysinit/start.sh
