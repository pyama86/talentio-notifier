FROM ruby:2.6.5
WORKDIR /talentio-notifier
ENV LANG C.UTF-8
RUN apt update -qqy && apt install -qqy python git python-yaml
RUN useradd talentio && chown talentio /talentio-notifier
USER talentio

RUN git clone https://github.com/emasaka/jpholidayp.git
RUN gem install talentio-notifier -v "0.3.5"
