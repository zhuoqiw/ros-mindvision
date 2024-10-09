# Build stage image
FROM ubuntu:latest AS build

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# Change workdir
WORKDIR /mindvision

# Copy install file from build context into image
COPY linuxSDK_V2.1.0.37.tar.gz install.tar.gz

# Copy cmake config files
COPY mindvisionConfig*.cmake /setup/opt/mindvision/

# Prepare install directories
RUN mkdir -p /setup/opt/mindvision/include /setup/opt/mindvision/lib /setup/etc/udev/rules.d

# Extract tar.gz
RUN tar -xzf install.tar.gz

# Copy header
RUN cp include/* /setup/opt/mindvision/include/

# Copy so
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    cp lib/x64/libMVSDK.so /setup/opt/mindvision/lib/; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    cp lib/arm64/libMVSDK.so /setup/opt/mindvision/lib/; \
    else exit 1; fi

# Copy rules
RUN cp *-mvusb.rules /setup/etc/udev/rules.d/

# Use busybox as container
FROM busybox:latest

# Copy setup
COPY --from=build /setup /setup/
