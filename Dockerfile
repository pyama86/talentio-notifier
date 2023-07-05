FROM ruby:latest
WORKDIR /talentio-notifier
ENV LANG C.UTF-8
RUN apt update -qqy && apt upgrade -qqy && \
  apt update -qqy && apt install -qqy python3 git python3-yaml && \
  apt clean && rm -rf /var/lib/apt/lists/*
RUN useradd talentio && chown talentio /talentio-notifier && ln -sf /usr/bin/python3 /usr/bin/python
USER talentio

RUN git clone https://github.com/emasaka/jpholidayp.git
RUN gem install talentio-notifier -v "0.3.6"
