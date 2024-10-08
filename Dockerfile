# Extract pylon
FROM ubuntu:latest AS base

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# Install file
ARG URL=https://www.mindvision.com.cn/wp-content/uploads/2023/08/linuxSDK_V2.1.0.37.tar.gz

# Prepare install directories
RUN mkdir -p /setup/usr/include /setup/lib /setup/etc/udev/rules.d

# Install dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Extract package to client
RUN wget -O temp.tar.gz ${URL} --no-check-certificate

RUN tar -xzf temp.tar.gz

RUN cp include/* /setup/usr/include/

RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    cp lib/x64/libMVSDK.so /setup/lib/; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    cp lib/arm64/libMVSDK.so /setup/lib/; \
    else exit 1; fi

RUN cp *-mvusb.rules /setup/etc/udev/rules.d/

# Use busybox as container
FROM busybox:latest

# Copy
COPY --from=base /setup /setup

# Mount point for image users to install udev rules, etc.
VOLUME [ "/setup" ]
