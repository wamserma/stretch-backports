# stretch-backports
convenience scripts to backport packages without official backports to Debian Stretch 

This repo is maintained on a "on-demand" basis.

Scripts are assumed to be run on Debian Stretch. Dockerization for other build platforms.

## Available backports:
+ opensc-0.19.0 OpenSC 0.19.0-1 from Debian Buster

## Build using Docker

The Docker images are intended for one-shot usage, so we do not make aggressive use of Docker's caching capabilities. Build time dependencies are reinstalled at every run by the build script. (If we fully dockerized this script, Docker would cache that step for us.)

Example use:
```
docker-compose build # required only once or after updates
docker-compose run -e HUID=`id -u` -e HGID=`id -g` opensc-0.19.0 # build the specified backport
```

In case there is only a single user on the system running the docker container, the user will likely have a UID and GID of 1000. In that case the IDs need not be passed to the container, as it will default to these values. One may also specify arbitrary other numerical IDs to define the owner of the resulting packages.

```
docker-compose run opensc-0.19.0 # build the specified backport
```

Cleaning up after Docker:
(always run the commands in the subshells without the `-q`options first for a preview)

```
# clean unused intermediate images
docker rmi $(docker images -a --filter=dangling=true -q)

# clean exited and done machines (be careful!)
docker rm $(docker ps --filter=status=exited --filter=status=created -q)
```

## Build behind proxy

If you are building behind a proxy, you may want to add the following line to the beginning of your `Dockerfile`, before doing any other apt operations:
```
RUN echo "Acquire::http::Proxy \"http://your.proxy:1234\";"
```
and add 
```
export http_proxy=http://your.proxy:1234
```
to the beginning of the build scripts in `scripts`.
