# mambo

## requirements

* bash
* git
* docker

NOTE : mambo will auto install docker-compose

## usage

* install
```
git clone
cd mambo
./mambo install
```

* launch

```
./mambo up
```

* stop all

```
./mambo down
```

## Configuration


### Environment variables

```
if you use bind mount as volumes define MAMBO_USER_ID and MAMBO_GROUP_ID which will defines the unix permissions off volumes files and folders
  MAMBO_USER_ID=1000 MAMBO_GROUP_ID=1000 ./mambo
if you want to specify a specific domain name use MAMBO_DOMAIN
   MAMBO_DOMAIN='.*' ./mambo
```


## Commands

* launch bundled docker-compose

```
./docker-compose <arg>
```



## Network configuration

* Mambo have two main endpoints `web` and `web_internal`
    * `web` entrypoint (port number defined by `MAMBO_PORT_MAIN`) is the main port to access to mambo - It is an entrypoint of traefik that allow access to organizr. You should allow its attached port to anybody in your router configuration.
    * `web_internal` entrypoint (port number defined by `MAMBO_PORT_INTERNAL`) is an internal port for mambo - It is an entrypoint of traefik that allow access to each services (so its bypass organizr) AND to traefik dashboard. You should protect its attached port in your router configuration according to your needs.

* TODO : As an alternative to block `web_internal` endpoint : manage iptables rule we can use this https://github.com/colinmollenhour/docker-confd-firewall

### Web acces points

* We have 3 ways to access a service
* The first is the main door
* The second is an access to services
* The last is a direct access to services for debug purposes

```
1. (host:web) traefik ==> Organizr2 ==> (host:web_internal) traefik ==> (host:docker_port_expose) Services (Ombi, Sabnzbd, ...)
2.                                  ==> (host:web_internal) traefik ==> (host:docker_port_expose) Services (Ombi, Sabnzbd, ...)
3.                                                                  ==> (host:docker_port_mapped) Services (Ombi, Sabnzbd, ...)
```

* Example with ombi

```
1.  TODO
2.  http://ombi.domain:MAMBO_PORT_INTERNAL ==> http://ombi:5000
3.  http://domin:8000 ==> http://ombi:5000
```

## Links

* MEDIA STACK on DOCKER with TRAEFIK https://gist.github.com/anonymous/66ff223656174fd39c76d6075d6535fd
* TRAEFIK GUIDES 
    * https://medium.com/@containeroo/traefik-2-0-docker-an-advanced-guide-d098b9e9be96
    * https://blog.eleven-labs.com/fr/utiliser-traefik-comme-reverse-proxy/
*  ORGANIZR2 and NGINX
    * translate this nginx to traefik: https://guydavis.github.io/2019/01/03/nginx_organizr_v2/