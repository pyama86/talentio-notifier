FROM ruby:latest
WORKDIR /talentio-notifier
ENV LANG C.UTF-8
RUN apt update -qqy && apt install -qqy python git python-yaml
RUN git clone https://github.com/emasaka/jpholidayp.git
RUN gem install talentio-notifier
