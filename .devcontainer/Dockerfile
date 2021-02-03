FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -yq curl file git unzip xz-utils zip && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /opt/flutter && \
    useradd -m flutter && \
    chown flutter:flutter /opt/flutter

USER flutter
WORKDIR /home/flutter

#ARG VERSION

#RUN git clone -b ${VERSION} https://github.com/flutter/flutter.git /opt/flutter
RUN git clone -b 1.25.0-8.3.pre https://github.com/flutter/flutter.git /opt/flutter
ENV PATH $PATH:/opt/flutter/bin

RUN flutter config --no-analytics --enable-web --no-enable-android --no-enable-ios && \
    flutter precache --web &&\
    flutter create --no-pub --platforms web dummy && \
    rm -rf dummy

COPY pubspec.yaml .

RUN flutter pub get
#     
