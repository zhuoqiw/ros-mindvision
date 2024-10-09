# Build stage image
FROM debian:latest AS build

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# Copy install file from build context into image
COPY linuxSDK_V2.1.0.37.tar.gz install.tar.gz

RUN apt-get update && apt-get install -y libc6:arm64

# Prepare install directories
RUN mkdir -p /setup/usr/include /setup/lib /setup/etc/udev/rules.d

# Extract tar.gz
RUN tar -xzf install.tar.gz

# Copy header
RUN cp include/* /setup/usr/include/

# Copy so
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    cp lib/x64/libMVSDK.so /setup/lib/; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    cp lib/arm64/libMVSDK.so /setup/lib/; \
    else exit 1; fi

# Copy rules
RUN cp *-mvusb.rules /setup/etc/udev/rules.d/

# Use busybox as container
FROM busybox:latest

# Copy
COPY --from=build /setup /setup/

# Mount point for image users to install udev rules, etc.
VOLUME [ "/setup" ]

