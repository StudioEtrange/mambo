
# [studioetrange/ebooks-list](https://github.com/studioetrange/docker-ebooks-list)

ebooks-list is a web engine that can render different templates written for python [Mako](https://www.makotemplates.org).
It can use calibredb catalog feature to extract a list, filterd with arguments and send generated html through HTTP.

This render engine was developped mainly for [Mambo media stack](https://github.com/StudioEtrange/mambo) and can be used to inject some ebooks newsletter into  [Tautulli](https://github.com/Tautulli/Tautulli) generated newsletter or with other newsletter system.

Docker base image : lsiobase/ubuntu
Template engine : [Mako](https://www.makotemplates.org)
Web engine : https://github.com/adnanh/webhook


&nbsp;
## Version Tags

This image provides various versions that are available via tags. `latest` tag usually provides the latest stable version. Others are considered under development and caution must be exercised when using them.

| Tag | Description |
| :----: | --- |
| latest |  |

&nbsp;
## Docker Image usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  sabnzbd:
    image: studioetrange/ebooks-list
    container_name: ebooks-list
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 
    volumes:
      - <path to data>:/config
      - <path to ebook calibredb folder>:/calibredb/books
    ports:
      - 9000:9000
    restart: unless-stopped
```

### docker cli

```
docker run \
  -d \
  --name=ebooks-list \
  -p 9000:9000 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 \
  -v <path to data>:/config \
  -v <path to ebook calibredb folder>:/calibredb/books \
  studioetrange/ebooks-list
```

&nbsp;
### Parameters


| Parameter | Function |
| :----: | --- |
| `-p 9000` | HTTP port for web engine |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London. |
| `-v /config` | Where to store config files, templates and generated files. |
| `-v /calibredb` | Root from where Where your calibredb folder should me mounted. |

&nbsp;
### Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

&nbsp;
### User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

&nbsp;
## Render engine usage


### Requesting render engine

The render engine is requested through an HTTP request reacheable at `http://localhost:port/hooks/render` and by using query parameters

| Parameter | Function | Default |
| :----: | --- | --- |
| `calibredb` | A calibre db folder path (that might be located in /calibredb) | /calibredb/books |
| `template_file` | An html Mako template file that must be in /config/templates | tautulli_ebooks.html |
| `items_name` | A word to describe item in template (book, comic, manga,...) | book |
| `title` | A title that can be used in template | Recently Added Books |
| `limit` | Limit generated list size (0:no limit) | 0 |
| `random_order` | Randomize generated list order, by default the order is by decreasing added date (1:random order) | 0 |
| `days_old_filter` | Max nb of days that item have been added to catalog to filter catalog list. 0: unlimited | 0 |
| `url` | URL to books homepage | <empty> |
| `debug` | Generated files will be kept in /config/output. (1:active debug) | 0 |


Requesting a rendering
  * browe to `http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=myitem&title=foo%20bar&days_old_filter=20&random_order=0&debug=1&limit=4`
  * launch `curl -H "Accept: text/html" http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=myitem&title=foo%20bar&days_old_filter=20&random_order=0&debug=1&limit=4`
  * launch `wget --header="Accept: text/html" http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=myitem&title=foo%20bar&days_old_filter=20&random_order=0&debug=1&limit=4`

### Templates

Parameters are used by the rendering engine which will use the specified template_file to generate a response. If you need additional information into your template, your env var passed to the container at launch.


### Sample for integration with Tautulli newsletter system

There is an embedded template wchich can be integrated with [tautulli newsletter template](https://github.com/Tautulli/Tautulli/blob/7489bc8d981d395d8a712dd5b548a856934fe130/data/interfaces/newsletters/recently_added.html) : 
  * `tautulli_ebooks.html` : html template to be inserted into [tautulli newsletter template](https://github.com/Tautulli/Tautulli/blob/7489bc8d981d395d8a712dd5b548a856934fe130/data/interfaces/newsletters/recently_added.html)
  * recently_added.html : the default [tautulli newsletter template](https://github.com/Tautulli/Tautulli/blob/7489bc8d981d395d8a712dd5b548a856934fe130/data/interfaces/newsletters/recently_added.html) tweaked with ebooks-list

It needs two env var  
  * `URL_CALIBREDB_FOR_COVER` point to calibredb folder exposed with HTTP to access cover files (dont forget to use .htaccess to authorize only images files access through HTTP)



```
docker run \
  -d \
  --name=ebooks-list \
  -p 9000:9000 \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 \
  -e 'URL_CALIBREDB_FOR_COVER=https://web/cover' \
  -v <path to data>:/config \
  -v <path to ebook calibredb folder>:/calibredb/books \
  studioetrange/ebooks-list
```

To integrate it, we will inject a section into [Tautulli](https://github.com/Tautulli/Tautulli) newsletter which will call ebooks-list. 


* Edit [default tautulli template](https://github.com/Tautulli/Tautulli/blob/a8adad7dbb1b992d0b51067b6ccdfc64f64a2950/data/interfaces/newsletters/recently_added.html) to add a python call to ebooks-list before recently added movies section and saved it in a file named `recently_added.html`
  ```
  <%
  import urllib.request
  rendered_html=urllib.request.urlopen('http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=book&title=Last%20added%20books&days_old_filter=20&random_order=0&debug=0&limit=10')
  print(rendered_html.read())
  %>

  % if recently_added.get('movie'):
  ...
  ```
* Configure [Tautulli](https://github.com/Tautulli/Tautulli) to use this `recently_added.html` as newsletter template : see [FAQ](https://github.com/Tautulli/Tautulli-Wiki/wiki/Frequently-Asked-Questions#newsletter-custom-template)



* To add a `Recently added books` since 7 days section use : `http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=book&title=Recently%20added%20books&days_old_filter=7`
* To add a `10 Last added books` section use : `http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=book&title=10%20Last%20added%20books&limit=10`
* To add a `Recently added random books` with a link to books homepage section use : `http://localhost:9000/hooks/render?calibredb=/calibredb/books&template_file=tautulli_ebooks.html&items_name=book&title=Recently%20added%20random%20books&limit=10&random_order=1&days_old_filter=7&url=https%3A%2F%2Fdomain.org%2F%23Books`

&nbsp;
## Docker Mods
[![Docker Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=transmission&query=%24.mods%5B%27transmission%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=transmission "view available mods for this container.") [![Docker Universal Mods](https://img.shields.io/badge/dynamic/yaml?color=94398d&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=universal&query=%24.mods%5B%27universal%27%5D.mod_count&url=https%3A%2F%2Fraw.githubusercontent.com%2Flinuxserver%2Fdocker-mods%2Fmaster%2Fmod-list.yml)](https://mods.linuxserver.io/?mod=universal "view available universal mods.")

ebooks-list use a [Docker Mod](https://github.com/linuxserver/docker-mods) to inject a calibre version with [calibre-mod](https://github.com/studioetrange/docker-calibre-mod).




&nbsp;
## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:
```
git clone https://github.com/studioetrange/docker-ebooks-list.git
cd docker-ebooks-list
docker build \
  --no-cache \
  --pull \
  -t studioetrange/ebooks-list:latest .
```

## License

[![License](https://img.shields.io/github/license/Tautulli/Tautulli?style=flat-square)](https://github.com/Tautulli/Tautulli/blob/master/LICENSE)

This is free software under the GPL v3 open source license. Feel free to do with it what you wish, but any modification must be open sourced. A copy of the license is included.