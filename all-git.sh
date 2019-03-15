#!/bin/bash
set -e
#------------------------------------------------  COLORS  ---------------------------------------------------------------------------
COLOR_RESET='\033[0m'
COLOR_GREEN='\033[1;32m'
COLOR_YELLOW='\033[1;33m'
COLOR_RED='\033[0;31m'
COLOR_BLUE='\033[1;34m'
#------------------------------------------------  VARIABLES  ------------------------------------------------------------------------
WORK_DIR="${HOME}"
NUM_DEFICES=5

dir_list="$( LANG=C; find "${WORK_DIR}" -type d -name '.git' -print 2>&1 | \
		grep -v 'Permission denied' | sed 's/\.git//' )"

MSG_OK='ok'
MSG_NEED_COMMIT='git commit -am "some commit"'
MSG_NEED_PUSH='need push to remote server'
MSG_NEED_ADD='git add .'
MSG_UNTRACKED_FILES='untracked files'
MSG_SEE_MORE='see more...'

STATUS_OK='nothing to commit, working'
STATUS_NEED_PUSH='use "git push" to publish your local commits'
STATUS_NEED_COMMIT='Changes not staged for commit:'
STATUS_NEED_ADD='git add'
STATUS_UNTRACKED_FILES='Untracked files:'
#------------------------------------------------  FUNCTIONS  ------------------------------------------------------------------------
function is_git_status(){
	[ -z "${1}" ] && ( echo "ERROR: ARG IS NOT EXIST IN is_git_status...") && exit 123
	[[ $(git status|grep -E "${1}") ]] && return 0 || return 1
}

function print_defis_after(){
    DEFICES_NUM=10
    MAX=$(for i in ${2};do echo $i;done|wc -L) #вычисляем максимальную длину строки в массиве
    MIN=$(echo $1|wc -c) #длина строки текущего элемента
    for i in $(seq 0 $(( $MAX+$DEFICES_NUM-$MIN )) );do VAR="$VAR-"; done
    echo $VAR
}
#------------------------------------------------  START  ----------------------------------------------------------------------------
for dir in ${dir_list}
do
	cd "${dir}"

	is_git_status "${STATUS_OK}" && \
    	OUTPUT_TEXT="${COLOR_GREEN}"${MSG_OK}"${COLOR_RESET}"

	is_git_status "${STATUS_NEED_PUSH}" && \
    	OUTPUT_TEXT="${COLOR_YELLOW}"${MSG_NEED_PUSH}"${COLOR_RESET}"

 	is_git_status "${STATUS_NEED_COMMIT}"  || is_git_status "${STATUS_NEED_ADD}" && \
    	OUTPUT_TEXT="${COLOR_RED}"${MSG_SEE_MORE}"${COLOR_RESET}"

	echo -e ${dir}$(print_defis_after "${dir}" "${dir_list}")$([ "${dir}" = "${WORK_DIR}" ] && echo '->' || echo '>') "${OUTPUT_TEXT}"
	unset OUTPUT_TEXT
done

exit "${?}"

#------------------------------------------------  END  ------------------------------------------------------------------------------
