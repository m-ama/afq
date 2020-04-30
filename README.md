![Docker Pulls](https://img.shields.io/docker/pulls/dmri/afq)
![Docker Stars](https://img.shields.io/docker/stars/dmri/afq)


## dmri/afq

Docker build context for the AFQ pipeline.

## Install
Issue the following command in CLI to pull the latest AFQ pipeline compatible with Docker.

```
docker pull dmri/afq
```

## Run
AFQ container may be called with

```
docker run -it --rm \
    -v [SOURCE PATH]:[DESTINATION PATH]
    dmr/afq [PATH TO dt6.mat]
```
