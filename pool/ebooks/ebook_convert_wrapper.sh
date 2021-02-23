#!/bin/bash

# This script is a wrapper around ebook-convert calibre tool
# it can be combined with calibre-web to empower calibre-web convert to kindle feature
# see https://github.com/janeczku/calibre-web/blob/a659f2e49d6413e2285a4473b44d380e09ac543f/cps/tasks/convert.py#L179

#   arg1 : ebook source file
#   arg2 : ebook target file
#   arg3 : mode
#           STANDARD : nothing special
#           ADD_CALIBREDB : add converted file to calibre db
#           METADATA_FROM_OPF : take metadata from metadata.opf file from same directory than ebook source file
#           ADD_CALIBREDB_AND_METADATA_FROM_OPF : combine two previous mode
#   arg4 : calibre binary tools folder with ebook-convert tool (i.e : /opt/calibre)
#   arg5 : folder path to calibredb database file (i.e: /books)
#   others args : arguments passed to calibre ebook convert tool 


# NOTE if this script is used from calibre-web 
#       * set "Path to Calibre E-Book Converter" to the path to this script
#       * set arg3 and following into "Calibre E-Book Converter Settings"




source_file="$1"
target_file="$2"
mode="$3"
calibretools_path="$4"
calibredb_path="$5"
shift 5


ebook_convert_tool_path="${calibretools_path}/ebook-convert"
calibredb_tool_path="${calibretools_path}/calibredb"

files_path="$(dirname "${source_file}")"
metadata_path="${files_path}/metadata.opf"

[ ! -f "${source_file}" ] && echo " ** ERROR [$0] : ${source_file} do not exist" && exit 1
[ ! -f "${ebook_convert_tool_path}" ] && echo " ** ERROR [$0] : ebook-convert tool ${ebook_convert_tool_path} do not exist" && exit 1


case $mode in
    ADD_CALIBREDB )
        [ ! -d "${calibredb_path}" ] && echo " ** ERROR [$0] : calibredb folder ${calibredb_path} do not exist" &&  exit 1
        [ ! -f "${calibredb_tool_path}" ] && echo " ** ERROR [$0] : calibredb tool ${calibredb_tool_path} do not exist" && exit 1

        echo "** Converting ebook"
        ${ebook_convert_tool_path} "${source_file}" "${target_file}" $@
        echo "** Done"

        # get book calibre id        
        book_id=$(dirname "${target_file}")
        book_id="${book_id%\)}"
        book_id="${book_id##*\(}"

        [ "${book_id}" = "" ] && echo " ** ERROR [$0] : can not find book id for ${source_file}" && exit 1

        if [ -f "${target_file}" ]; then
            echo "** Checking library"
            ${calibredb_tool_path} check_library --with-library="${calibredb_path}/"
            echo "** Done"

            echo "** Adding converted file to library"
            ${calibredb_tool_path} add_format --with-library="${calibredb_path}/" ${book_id} "${target_file}"
            error=$?
            if [ $error -ne 0 ]; then
                echo " ** ERROR [$0] : ERROR num $error -- error while adding file : ${target_file} to calibredb : ${calibredb_path}" 
                echo " ** ERROR [$0] : ${calibredb_tool_path} add_format --with-library="${calibredb_path}/" ${book_id} "${target_file}""
                exit 1
            fi
            echo "** Done"
        fi

        ;;

    METADATA_FROM_OPF )
        [ ! -f "${metadata_path}" ] && echo " ** ERROR [$0] : no metadata.opf file found here ${metadata_path}" && exit 1
        echo "** Converting ebook"
        ${ebook_convert_tool_path} "${source_file}" "${target_file}" --read-metadata-from-opf "${metadata_path}" $@
        echo "** Done"
        ;;
        
    ADD_CALIBREDB_AND_METADATA_FROM_OPF )
        [ ! -d "${calibredb_path}" ] && echo " ** ERROR [$0] : calibredb folder ${calibredb_path} do not exist" && exit 1
        [ ! -f "${calibredb_tool_path}" ] && echo " ** ERROR [$0] : calibredb tool ${calibredb_tool_path} do not exist" && exit 1
        [ ! -f "${metadata_path}" ] && echo " ** ERROR [$0] : no metadata.opf file found here ${metadata_path}" && exit 1

        echo "** Converting ebook"
        ${ebook_convert_tool_path} "${source_file}" "${target_file}" --read-metadata-from-opf "${metadata_path}" $@
        echo "** Done"
        
        # get book calibre id        
        book_id=$(dirname "${target_file}")
        book_id="${book_id%\)}"
        book_id="${book_id##*\(}"

        [ "${book_id}" = "" ] && echo " ** ERROR [$0] : can not find book id for ${source_file}" && exit 1

 
        if [ -f "${target_file}" ]; then
            echo "** Checking library"
            ${calibredb_tool_path} check_library --with-library="${calibredb_path}/"
            echo "** Done"

            echo "** Adding converted file to library"
            ${calibredb_tool_path} add_format --with-library="${calibredb_path}/" ${book_id} "${target_file}"
            error=$?
            if [ $error -ne 0 ]; then
                echo " ** ERROR [$0] : ERROR num $error -- error while adding file : ${target_file} to calibredb : ${calibredb_path}" 
                echo " ** ERROR [$0] : ${calibredb_tool_path} add_format --with-library="${calibredb_path}/" ${book_id} "${target_file}""
                exit 1
            fi
            echo "** Done"
        fi
        ;;


    STANDARD|* )
        echo "** Converting ebook"
        ${ebook_convert_tool_path} "${source_file}" "${target_file}" $@
        echo "** Done"
        ;;
esac



[ ! -f "${target_file}" ] && echo " ** ERROR [$0] : converted file ${target_file} do not exist" && exit 1

echo " ** INFO [$0] : ${source_file} converted to ${target_file} in mode $mode"

exit 0