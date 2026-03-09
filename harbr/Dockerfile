# Build
FROM --platform=$BUILDPLATFORM debian:latest as build

ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:$PATH"
RUN apt-get update 
RUN apt-get install -y curl git wget unzip
RUN apt-get clean

RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
RUN flutter channel stable
RUN flutter upgrade

RUN mkdir /harbr/
COPY . /harbr/
WORKDIR /harbr/
RUN flutter build web

# Runtime
FROM --platform=$TARGETPLATFORM nginx:alpine
LABEL org.opencontainers.image.source="https://github.com/islamdiaa/harbr"
COPY --from=build /harbr/build/web /usr/share/nginx/html
