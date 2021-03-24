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
# NOTES -----
# in hooks.json definition
# we filter HTTP request with a trigger rule to launch this script only the request ask for at least text/html
# Because the navigator could relaunch subsequent HTTP GET request to retrieve images (even if the image is not inside generated html response)
# with this trigger we avoid this script to be called twice !
#   "trigger-rule":
#   {
#     "match":
#     {
#       "type": "regex",
#       "regex": ".*text/html.*",
#       "parameter":
#       {
#         "source": "header",
#         "name": "Accept"
#       }
#     }
#   }


# QUERY PARAMETERS -------------
# calibredb
CALIBREDB_PATH="${1:-/calibredb/books}"
# template_file
TEMPLATE_FILE="${2:-tautulli_ebooks.html}"
# items_name
ITEMS_NAME="${3:-book}"
# title
TITLE="${4:-Recently Added Books}"
# limit: nb max of items (0:no limit)
LIMIT="${5:-0}"
# random_order: randomize order (1:random order) - by the default order is by decreasing added date
RANDOM_ORDER="${6:-0}"
# days_old_filter: filter list by days old (0: no filter)
DAYS_OLD_FILTER="${7:-0}"
[ ! "$DAYS_OLD_FILTER" = "0" ] && DAYS_OLD_FILTER="date:>=${DAYS_OLD_FILTER}daysago"
# url - link to books main page
URL="${8:-}"
# debug (1:active debug)
DEBUG="${9:-0}"

# --------------------------------
if [ "$DEBUG" = "1" ]; then
    echo "<!-- ARGS_BEBIN"
    echo $CALIBREDB_PATH
    echo $TEMPLATE_FILE
    echo $ITEMS_NAME
    echo $TITLE
    echo $LIMIT
    echo $RANDOM_ORDER
    echo $DAYS_OLD_FILTER
    echo $URL
    echo $DEBUG
    echo "ARGS_END -->"
fi


# generated files
GENERATED_HTML_FILE="/config/output/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.html"
GENERATED_XML_FILE="/config/output/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.xml"
GENERATED_JSON_FILE="/config/output/${ITEMS_NAME}_$(date +"%s_%N")_${RANDOM}${RANDOM}.json"


# copy calibre files to avoid access files problems like database lock or samba mounted files problem
tmp="$(mktemp --directory)"
cp "${CALIBREDB_PATH}"/metadata* "${tmp}/"

# ie : /calibredb/books -> books
database_name="$(basename ${CALIBREDB_PATH})"

# generate an xml list
calibredb catalog "${GENERATED_XML_FILE}" -v --search="${DAYS_OLD_FILTER}" --library-path="${tmp}" 1>/dev/null
[ ! -f "${GENERATED_XML_FILE}" ] && echo " ** WARN ${GENERATED_XML_FILE} file do not exist -  ${DAYS_OLD_FILTER} may have no matching books into $CALIBREDB_PATH" && exit
cat "${GENERATED_XML_FILE}" | xq -r 'if .calibredb!=null then . else .calibredb="" end'>${GENERATED_JSON_FILE}

# replace tmp folder reference
#cat "${GENERATED_JSON_FILE}" | jq --arg tmp "$tmp" --arg CALIBREDB_PATH "$CALIBREDB_PATH" --arg database_name "$database_name" -r 'if (.calibredb|type != "string") then (.calibredb["record"]) | .[].library_name=$database_name | .[].cover |= sub($tmp;$CALIBREDB_PATH) else . end' | sponge "${GENERATED_JSON_FILE}"
cat "${GENERATED_JSON_FILE}" | jq --arg tmp "$tmp" --arg CALIBREDB_PATH "$CALIBREDB_PATH" --arg database_name "$database_name" -r 'if (.calibredb|type != "string") then .calibredb["record"][].library_name=$database_name | .calibredb["record"][].cover |= sub($tmp;$CALIBREDB_PATH) else . end' | sponge "${GENERATED_JSON_FILE}"


# render template
python - "${TEMPLATE_FILE}" "${GENERATED_JSON_FILE}" "${GENERATED_HTML_FILE}" "${LIMIT}" "${RANDOM_ORDER}" "${TITLE}" "${ITEMS_NAME}" "${URL}" "${DEBUG}" <<-EOF
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
url=sys.argv[8]
debug=int(sys.argv[9])


hplookup = TemplateLookup(directories=["/config/templates"], default_filters=['unicode', 'h'])

# https://stackabuse.com/reading-and-writing-json-to-a-file-in-python/
with open(generated_json_file) as json_file:
    data = json.load(json_file)

if not 'calibredb' in data:
    data={'calibredb': {}}
if not isinstance(data['calibredb'],dict):
    data={'calibredb': {}}
if not 'record' in data['calibredb']:
    data['calibredb']={'record': []}
else:
    if random_order==1:
        #calibredb=data['calibredb']
        if limit>0:
            if limit>len(data['calibredb']['record']):
                limit=len(data['calibredb']['record'])
            data['calibredb']['record']=random.sample(data['calibredb']['record'],limit)
        else:
            data['calibredb']['record']=random.sample(data['calibredb']['record'],len(data['calibredb']['record']))
    else:
        # reverse books order because calibredb catalog order it by default with ascending order
        # which match the ascending added date, but we want the opposite
        data['calibredb']['record'].reverse()
        if limit>0:
            data['calibredb']['record']=data['calibredb']['record'][:limit]

try:
    # https://github.com/Tautulli/Tautulli/blob/14b98a32e085d969f010f0249c3d2f660db50880/plexpy/newsletters.py#L477
    template = hplookup.get_template(template_file)
    htmlcontent=template.render(data=data,title=title,items_name=items_name,url=url)
except:
    htmlcontent=html_error_template().render().decode("utf-8")

if debug==1:
    output = open(generated_html_file,"w")
    output.write(htmlcontent)
    output.close()

print(htmlcontent)

EOF

if [ "$DEBUG" = "0" ]; then
    rm -f "${GENERATED_HTML_FILE}" 2>/dev/null
    rm -f "${GENERATED_XML_FILE}" 2>/dev/null
    rm -f "${GENERATED_JSON_FILE}" 2>/dev/null
    # remove database copied files
    rm -Rf "${tmp}" 2>/dev/null
fi

