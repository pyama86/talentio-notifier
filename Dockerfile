FROM ruby:latest
WORKDIR /talentio-notifier
ENV LANG C.UTF-8
RUN apt update -qqy && apt upgrade -qqy && \
  apt update -qqy && apt install -qqy wget && \
  wget https://github.com/knqyf263/holiday_jp-go/releases/download/v0.0.1/holiday_jp-go_0.0.1_linux_amd64.deb && \
  dpkg -i holiday_jp-go_0.0.1_linux_amd64.deb && \
  apt clean && rm -rf /var/lib/apt/lists/*
RUN useradd talentio && \
  chown talentio /talentio-notifier
USER talentio

RUN gem install talentio-notifier -v "0.3.6"
