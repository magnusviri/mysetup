#!/bin/bash

set -u

# See https://github.com/magnusviri/dotfiles for instructions

WHICH_USER=`whoami`
uname="$(uname)"

if [[ "$uname" == "Darwin" ]]; then

	if [ ! -e "$HOME/.env" ]; then
		echo "Please install Xcode tools when asked"
		git
		git clone https://github.com/magnusviri/dotfiles.git
		mv dotfiles .* * .
		rmdir dotfiles
		cp .env.example .env
		nano .env
	fi

	echo "Please su to the admin user and rerun this script"
	echo "cd /Users/<admin>"
	echo "ln -s ../<non admin>/.env"
	echo "cd /Users/<non admin>"
	echo "./.dotfiles/install-new-computer.sh"
	echo "cd /Users/<admin>"
	echo "../<non-admin>/.dotfiles/install-new-home-dir.sh"
	echo "exit"
	echo "cd /Users/<non admin>"
	echo "./.dotfiles/install-new-home-dir.sh"

elif [[ "$uname" == "Linux" ]]; then

fi
