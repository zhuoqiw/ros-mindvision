# Build stage image
FROM ubuntu:latest AS build

# linux/amd64 or linux/arm64
ARG TARGETPLATFORM

# Prepare install directories
RUN mkdir -p install setup/opt/mindvision setup/etc/ld.so.conf.d setup/etc/udev/rules.d

# Copy install file from build context into image
COPY linuxSDK_V2.1.0.37.tar.gz install.tar.gz

# Copy cmake config files
COPY mindvisionConfig*.cmake setup/opt/mindvision/

# Extract tar.gz
RUN tar -xzf install.tar.gz -C install/

# Copy header
RUN mv install/include setup/opt/mindvision/include

# Copy so
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ]; then \
    mv install/lib/x64 setup/opt/mindvision/lib; \
    elif [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    mv install/lib/arm64 setup/opt/mindvision/lib; \
    else exit 1; fi

# Update ldconfig to client
RUN echo "/opt/mindvision/lib" >> setup/etc/ld.so.conf.d/mindvision.conf

# Copy rules
RUN cp *-mvusb.rules setup/etc/udev/rules.d/

# Use busybox as container
FROM busybox:latest

# Copy setup
COPY --from=build setup setup/
