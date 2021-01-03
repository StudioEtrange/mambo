#  TODO 

* [X] add forward auth to compose file static at each launch AND dynamic at each change ? use organizr2 api and traefik rest api provider

* [ ] lib transmission : generate encoded password for use in Authentification header

* [ ] allow api access to service without organizr auth https://github.com/htpcBeginner/docker-traefik/issues/27#issuecomment-743916338

* each plugin can work 
    * only on some specific services
    * may require app lib
    * may require stella
    * may require some var init in tango init or mambo init
    * TODO implement restriction system on plugin, which may work only if certains criteria are ok

* use ofelia to launch  __organizr2_init every X seconds : 
    ** make a plugin : 
        * declare a manual plugin on a ofelia itself ? ./tango --plugin ofelia%!organizr2 
        * dont know how to trigger plugin execution ? maybe do the same code than manual launch ./tango plugins exec organizr2
        
    TODO SOLUTION : 
        ** change __add_volume_pool_and_plugins_data_all (lib_tango) to mount tango and tango_app root in every services so plugins will have access to whole tango and mambo path : DONT know if we need this ! not sure at all !
        ** ONLY on plugin which need it and that are compatible : at the beginning of plugin do the same thing than in tango_init and manbo init. (WARN : it may not work, because stella is launched and some containers may not have all the requirement to launch stella)
        ** Merge tango_init and mambo init first lines (of mambo script) : bad idea

* nzbmedia : generate autoProcessMedia.cfg 


* description about the difference between a module, a plugin and a script (scripts_info, scripts_init, ...) are too complex

* scripts_info / scripts_init : transform into plugins ?

* plex : acces port to webtools (by default 33400)


* booksonic 
** API https://airsonic.github.io/docs/api/
** update library  : 

    SERVER='http://yourserverhere:4040'
    CLIENT='CLI'
    USERNAME='admin'
    PASSWORD='yourpasswordhere'
    curl "${SERVER}/rest/startScan?u=${USERNAME}&p=${PASSWORD}&v=1.15.0&c=${CLIENT}"



* emulator games web : webtropie with html&emularity OR retrojolt ?

* ombi bug cannot sync plex items https://github.com/tidusjar/Ombi/issues/3420

* organizr : sickbeard homepage widget : calendar bug

* why services listed in TANGO_ARTEFACT_SERVICES mount also artefact volume in TANGO_ARTEFACT_MOUNT_POINT (like sabnzbd)