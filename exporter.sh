#!/bin/bash

docker_compose_exporter() {
	local GREEN='\033[0;32m'
	local RED='\033[0;31m'
	local LIGHT_BLUE='\033[1;34m'
	local ORANGE='\033[0;33m'
	local NO_COLOR='\033[0m'
	local LIGHT_GRAY='\033[0;37m'
	local CYAN='\033[0;36m'

	local images
	local images_arr=()
	local formatted_images
	local pid
	for img in $(docker-compose config | awk '{if ($1 == "image:") print $2;}'); do
  		images="$images $img"
		images_arr+=("$img")

		if [ -n "$(docker images -q $img)" ]; then
			formatted_images="$formatted_images - ${ORANGE}$img${NO_COLOR} [${GREEN}Found${NO_COLOR}]\n"
		else
			formatted_images="$formatted_images - ${ORANGE}$img${NO_COLOR} [${RED}Not Found${NO_COLOR}]\n"
		fi
	done
	
	printf "Images list: \n$formatted_images\n";


	# check images existence on local machine. if not, pull it.
	for img in ${images_arr[@]}; do
		if [[ -z "$(docker images -q $img)" ]]; then
			# in case image not found
			docker pull $img 1>/dev/null & pid=$!

			local j=0
			local spin='-\|/'
			while kill -0 $pid 2>/dev/null
			do
				j=$(( (j+1) %4 ))
				printf "\r > Run docker pull ${CYAN}%s${NO_COLOR} ... ${spin:$j:1} " $img;
				sleep .1
			done
			printf "\r > Run docker pull ${CYAN}%s${NO_COLOR} ... ${GREEN}Done${NO_COLOR}\n" $img;
		fi
	done

	echo
	
	docker save $(echo $images) -o $1 2>/dev/null & pid=$!

	local i=0
	local spin='-\|/'
	while kill -0 $pid 2>/dev/null
	do
		i=$(( (i+1) %4 ))
		printf "\rExporting images to ${CYAN}%s${NO_COLOR} ... ${spin:$i:1} " $1;
		sleep .1
	done
	printf "\rExporting images to ${CYAN}%s${NO_COLOR} ... ${GREEN}Done${NO_COLOR}\n" $1;

	echo -e "Images successfully saved in ${CYAN}$1${NO_COLOR}";
	echo -e "\nTo load them run ${LIGHT_BLUE}'docker load < $1'${NO_COLOR}";
}

if [ -z "$1" ]
then
	echo "Store file name is not exist"
	exit 1
else
	docker_compose_exporter $1;
fi

