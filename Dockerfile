# Extract pylon
FROM ubuntu:latest AS build

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# Install file
ARG URL=https://www.mindvision.com.cn/wp-content/uploads/2023/08/linuxSDK_V2.1.0.37.tar.gz

# Prepare install directories
RUN mkdir -p /setup/usr/include /setup/lib /setup/etc/udev/rules.d

RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*
  
RUN curl -o temp.tar.gz ${URL}
RUN touch test
RUN cp test abc

# Install dependencies
#RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
#    && apt-get -y install --no-install-recommends \
#    wget \
#    && rm -rf /var/lib/apt/lists/*

# Extract package to client
#RUN wget -O temp.tar.gz ${URL} --no-check-certificate

# Extract tar.gz
#RUN tar -xzf temp.tar.gz

# Copy header
# RUN mv include/* /setup/usr/include/

# Copy so
#RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
#    mv lib/x64/libMVSDK.so /setup/lib/; \
#    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
#    mv lib/arm64/libMVSDK.so /setup/lib/; \
#    else exit 1; fi

# Copy rules
#RUN cp 88-mvusb.rules /setup/etc/udev/rules.d/88-mvusb.rules

# Use busybox as container
FROM busybox:latest

# Copy
COPY --from=build 88-mvusb.rules /setup/

# Mount point for image users to install udev rules, etc.
VOLUME [ "/setup" ]

