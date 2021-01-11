#!/bin/sh

# This script will generate a newsletter file to integrate to be integrated into tautulli newsletter


# the default template come from tautulli

# generate an XML catalog file with calibre filtered with criteria
#       calibredb catalog ctg.xml -v --search='date:>=2daysago' --library-path=/calibredb/books
# convert XML to json
#       cat ctg.xml | xq
# 


# NOTES -----------------------------------

#   catalog.json sample
# {
#   "calibredb": {
#     "record": [
#       {
#         "id": "162",
#         "uuid": "93191d36-1826-4b42-8478-8b272de8ff4e",
#         "size": "1927014",
#         "isbn": "9782917157046",
#         "identifiers": "amazon:B01A6X03EI,wd:Q3209796,isbn:9782917157046,google:O1BSCwAAQBAJ",
#         "title": {
#           "@sort": "Horde du Contrevent, La",
#           "#text": "La Horde du Contrevent"
#         },
#         "authors": {
#           "@sort": "Damasio, Alain",
#           "author": "Alain Damasio"
#         },
#         "timestamp": "2021-01-07T04:30:21+01:00",
#         "pubdate": "2004-01-01T00:00:00+01:00",
#         "comments": "<div>\n<p>« Imaginez une Terre poncée, avec en son centre une bande de cinq mille kilomètres de large et sur ses franges un miroir de glace à peine rayable, inhabité. Imaginez qu’un vent féroce en rince la surface. Que les villages qui s’y sont accrochés, avec leurs maisons en goutte d’eau, les chars à voile qui la strient, les airpailleurs debout en plein flot, tous résistent. Imaginez qu’en Extrême-Aval ait été formé un bloc d’élite d’une vingtaine d’enfants aptes à remonter au cran, rafale en gueule, leur vie durant, le vent jusqu’à sa source, à ce jour jamais atteinte : l’Extrême-Amont. Mon nom est Sov Strochnis, scribe. Mon nom est Caracole le troubadour et Oroshi Melicerte, aéromaître. Je m’appelle aussi Golgoth, traceur de la Horde, Arval l’éclaireur et parfois même Larco lorsque je braconne l’azur à la cage volante. Ensemble, nous formons la Horde du Contrevent. Il en a existé trente-trois en huit siècles, toutes infructueuses. Je vous parle au nom de la trente-quatrième : sans doute l’ultime. » **</p></div>",
#         "languages": "fra",
#         "cover": "/calibredb/books/Alain Damasio/La Horde du Contrevent (162)/cover.jpg",
#         "formats": {
#           "format": "/calibredb/books/Alain Damasio/La Horde du Contrevent (162)/La Horde du Contrevent - Alain Damasio.epub"
#         },
#         "library_name": "books"
#       },
#     ]
# }


# https://hub.docker.com/r/almir/webhook/
# https://github.com/almir/docker-webhook

# source_file="$1"
# target_file="$2"
# mode="$3"
# calibretools_path="$4"
# calibredb_path="$5"
# shift 5


python <<-EOF
import json
from mako.template import Template
from mako.lookup import TemplateLookup
#print(Template("hello ${data}!").render(data="world"))

 _hplookup = TemplateLookup(directories=["/config"], default_filters=['unicode', 'h'])

# https://stackabuse.com/reading-and-writing-json-to-a-file-in-python/
with open('/tmp/ctg.json') as json_file:
    data = json.load(json_file)

try:
    # https://github.com/Tautulli/Tautulli/blob/14b98a32e085d969f010f0249c3d2f660db50880/plexpy/newsletters.py#L477
    template = _hplookup.get_template("recently_added.html")
    print(template.render(calibredb=data))
except:
    print(mako.exceptions.html_error_template().render())
EOF
