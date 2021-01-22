
# [studioetrange/nzbtomedia](https://github.com/studioetrange/docker-nzbtomedia)

[nzbToMedia](https://github.com/clinton-hall/nzbToMedia) provides an efficient way to handle postprocessing for CouchPotatoServer and SickBeard (and its forks) when using one of the popular NZB download clients like SABnzbd and NZBGet.

This image will contains at launch a specific or latest version of nzbToMedia. 

It is based on linuxserver/baseimage-ubuntu:bionic

&nbsp;
## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest |  |

&nbsp;
## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  sabnzbd:
    image: studioetrange/nzbtomedia
    container_name: nzbtomedia
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
    volumes:
      - /path/to/nzbtomedia:/app
```

### docker cli

```
docker run \
  --name=nzbtomedia \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -v <path to data>:/app \
  studioetrange/nzbtomedia
```

&nbsp;
## Parameters

| Parameter | Function |
| :----: | --- |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e VERSION=12.1.08` | nzbtomedia tag version #optional default is 'master' |
| `-e ERASE=1` | will remove existing install from /app/VERSION #optional |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /app` | Local path for nzbtomedia files. nzbtomediafiles will be isntalled in /app/VERSION |

&nbsp;
## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.


&nbsp;
## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/studioetrange/docker-nzbtomedia.git
cd docker-nzbtomedia
docker build \
  --no-cache \
  --pull \
  -t studioetrange/docker-nzbtomedia:latest .
```

