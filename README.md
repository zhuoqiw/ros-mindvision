# ros-mindvision

In order to use containerized mindvision, this specific image is to be utilized as two roles: for host and container.

## For host

To fully use mindvision, udev rule infomation should be setup properly on host:

These may be accomplished via a mount point '/setup', follow these steps:

```bash
# run this image once so the setup volume (via mount point) persists
docker run --rm -v ros-mindvision-setup:/setup zhuoqiw/ros-mindvsion

# follow interactive instruction
sudo sh /var/lib/docker/volumes/ros-pylon-setup/_data/opt/pylon/share/pylon/setup-usb.sh

# in case to save a little bit tiny disk usage
docker volume rm ros-pylon-setup

# or reboot
sudo udevadm control --reload-rules
```

## For container (multistage built image typically)

Three pieces of information should be setup properly on container:

1. Copy the runtime package from /setup/opt/pylon to container's /opt/pylon
1. Setup PYLON_ROOT to enable easy examples
1. Copy ldconfig from /setup/etc/ld.so.conf.d/pylon.conf to container's /etc/ld.so.conf.d/pylon.conf and run ldconfig

```Dockerfile
FROM zhuoqiw/ros-pylon AS pylon

FROM something-else

COPY --from=pylon /setup /
ENV PYLON_ROOT=/opt/pylon
RUN ldconfig
```
