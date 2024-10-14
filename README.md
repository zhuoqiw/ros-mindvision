# ros-mindvision

In order to use containerized mindvision, this specific image is to be utilized as two roles: for host and for container.

## For host

To fully use mindvision, udev rule infomation should be setup properly on host:

Follow these steps:

```bash
# run this image
docker run -d --name ros-mindvision zhuoqiw/ros-mindvision

# copy rules
sudo docker container cp ros-mindvision:/setup/etc/. /etc

# remove container
docker rm ros-mindvision

# reboot or
sudo udevadm control --reload-rules
```

## For container (multistage built image typically)

```Dockerfile
FROM zhuoqiw/ros-mindvision AS mindvision

FROM something-else

COPY --from=mindvision setup /
```
