#!/bin/sh
__CURRENT_FILE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
__CURRENT_RUNNING_DIR="$( cd "$( dirname "." )" && pwd )"

# NOTE by default path is determined giving by the current running directory
__rel_to_abs_path() {
	local _rel_path="$1"
	local _abs_root_path="$2"
	local result

	if [ "$_abs_root_path" = "" ]; then
		_abs_root_path=$__CURRENT_RUNNING_DIR
	fi


	if [ "$(__is_abs $_abs_root_path)" = "FALSE" ]; then
		result="$_rel_path"
	else

		case $_rel_path in
			/*)
				# path is already absolute
				result="$_rel_path"
				;;
			*)
				# relative to a given absolute path
				if [ -d "$_abs_root_path/$_rel_path" ]; then
					# NOTE call to __rel_to_abs_path_alternative_3 is equivalent
					result="$(cd "$_abs_root_path/$_rel_path" && pwd -P)"
				else
					# TODO using this method if directory does not exist returned path is not real absolute (example : /tata/toto/../titi instead of /tata/titi)
					# TODO : we rely on pure bash version, because readlink -m option used in alternative2 do not exist on some system
					result=$(__rel_to_abs_path_alternative_1 "$_rel_path" "$_abs_root_path")
				fi
				;;
		esac
	fi
	echo $result | tr -s '/'
}



# NOTE : alternative : [ -z "${_path##/*}" ]
__is_abs() {
	local _path="$1"

	case $_path in
		/*)
			echo "TRUE"
			;;
		*)
			echo "FALSE"
			;;
	esac
}

# NOTE : http://stackoverflow.com/a/21951256
# NOTE : pure BASH : do not use readlink or cd or pwd command
# NOTE : paths do not have to exists
# NOTE : BUT do not follow symlink
__rel_to_abs_path_alternative_1(){
		local _rel_path=$1
		local _abs_root_path=$2

	  local thePath=$_abs_root_path/$_rel_path
	  echo "$thePath"|(
	  IFS=/
	  read -a parr
	  declare -a outp
	  for i in "${parr[@]}";do
	    case "$i" in
	    ''|.) continue ;;
	    ..)
	      len=${#outp[@]}
	      if ((len==0));then
	        continue
	      else
	        unset outp[$((len-1))]
	      fi
	      ;;
	    *)
	      len=${#outp[@]}
	      outp[$len]="$i"
	      ;;
	    esac
	  done
	  echo /"${outp[*]}"
	)
}