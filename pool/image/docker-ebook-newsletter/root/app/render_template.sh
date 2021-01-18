#!/bin/bash
# This script will generate render an html template with ebooks data

# NOTES -----------------------------------
# Generated calibredb catalog in json
# {
#   "calibredb": {
#     "record": [
#       {
#         "id": "162",
#         "uuid": "93191d36-8478-8b272de8ff4e-1826-4b42",
#         "size": "1927014",
#         "isbn": "00000000",
#         "identifiers": "amazon:00000000,wd:00000000,isbn:00000000,google:00000000",
#         "title": {
#           "@sort": "Title, The",
#           "#text": "The Title"
#         },
#         "authors": {
#           "@sort": "Doe, John",
#           "author": "John Doe"
#         },
#         "timestamp": "2021-01-07T04:30:21+01:00",
#         "pubdate": "2004-01-01T00:00:00+01:00",
#         "comments": "abstract text",
#         "languages": "fra",
#         "cover": "/calibredb/books/John Doe/The Title (162)/cover.jpg",
#         "formats": {
#           "format": "/calibredb/books/John Doe/The Title (162)/Title - John Doe.epub"
#         },
#         "library_name": "books"
#       },
#     ]
# }


# docker run -it -e PUID=$(id -u) -e PGID=$(id -g) -e DOCKER_MODS=studioetrange/calibre-mod:v5.9.0 --volume $HOME/testconfig:/config --volume $HOME/testnews:/newsletter --volume /mnt/NEON_EBOOKS/books:/calibredb/books i bash

# QUERY PARAMETERS -------------
# filter list by days old
DAYS_OLD_FILTER='date:>=10daysago'
# nb max of items (0:no limit)
LIMIT=0
# randomize order (1:random order)
RANDOM_ORDER=1
# generated title
TITLE='Recently Added Books'
# items name
ITEMS_NAME='book'
# template
TEMPLATE_FILE="tautulli_ebooks.html"
# calibredb
CALIBREDB_PATH='/calibredb/books'
# --------------------------------


# generated files
GENERATED_HTML_FILE="/newsletter/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.html"
GENERATED_XML_FILE="/newsletter/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.xml"
GENERATED_JSON_FILE="/newsletter/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.json"

# generate an xml list
calibredb catalog "${GENERATED_XML_FILE}" -v --search="${DAYS_OLD_FILTER}" --library-path="${CALIBREDB_PATH}"
[ ! -f "${GENERATED_XML_FILE}" ] && echo " ** WARN ${GENERATED_XML_FILE} file do not exist -  ${DAYS_OLD_FILTER} may have no matching books into $CALIBREDB_PATH" && exit
cat "${GENERATED_XML_FILE}" | xq -r . >${GENERATED_JSON_FILE}

# render template
python - "${TEMPLATE_FILE}" "${GENERATED_JSON_FILE}" "${GENERATED_HTML_FILE}" "${LIMIT}" "${RANDOM_ORDER}" "${TITLE}" "${ITEMS_NAME}" <<-EOF
import json
import sys
import random
from mako.template import Template
from mako.lookup import TemplateLookup
from mako.exceptions import html_error_template


template_file=sys.argv[1]
generated_json_file=sys.argv[2]
generated_html_file=sys.argv[3]
limit=int(sys.argv[4])
random_order=int(sys.argv[5])
title=sys.argv[6]
items_name=sys.argv[7]


hplookup = TemplateLookup(directories=["/config"], default_filters=['unicode', 'h'])

# https://stackabuse.com/reading-and-writing-json-to-a-file-in-python/
with open(generated_json_file) as json_file:
    data = json.load(json_file)

if random_order==1:
    calibredb=data['calibredb']
    if limit>0:
        if limit>len(calibredb['record']):
            limit=len(calibredb['record'])
        data['calibredb']['record']=random.sample(calibredb['record'],limit)
    else:
        data['calibredb']['record']=random.sample(calibredb['record'],len(calibredb['record']))
else:
    if limit>0:
        data['calibredb']['record']=data['calibredb']['record'][:limit]

try:
    # https://github.com/Tautulli/Tautulli/blob/14b98a32e085d969f010f0249c3d2f660db50880/plexpy/newsletters.py#L477
    template = hplookup.get_template(template_file)
    htmlcontent=template.render(data=data,title=title,items_name=items_name)
except:
    htmlcontent=str(html_error_template().render())

output = open(generated_html_file,"w")
output.write(htmlcontent)
output.close()
EOF
