#!/bin/bash

# curl -L https://raw.githubusercontent.com/magnusviri/dotfiles/master/.dotfiles/install.sh

set -u

# See https://github.com/magnusviri/dotfiles for instructions

echo -n "Current directory: "
pwd
echo "Please run this only from the main non-admin account directory"
sleep 5

WHICH_USER=`whoami`
uname="$(uname)"
non_admin_dir=`pwd`

if [[ "$uname" == "Darwin" ]]; then
	if [ ! -e "$non_admin_dir/.env" ]; then
		# First time
		echo "Please install Xcode tools when asked"
		git  --version
		git clone https://github.com/magnusviri/dotfiles.git
		echo ditto dotfiles .
		ditto dotfiles .
		echo rm -r dotfiles
		rm -r dotfiles
		echo cp .env.example .env
		cp .env.example .env
		echo nano .env
		echo "Please edit .env, then su to the admin user and rerun this script"
	else
		# Second time
		. $non_admin_dir/.env
		echo "Run these:"
		echo "cd /Users/$ADMIN_ACCOUNT"
		echo "ln -s $non_admin_dir/.env"
		echo "cd $non_admin_dir"
		echo "./.dotfiles/install-new-computer.sh"
		echo "cd /Users/$ADMIN_ACCOUNT"
		echo "$non_admin_dir/.dotfiles/install-new-home-dir.sh"
		echo "exit"
		echo "cd $non_admin_dir"
		echo "./.dotfiles/install-new-home-dir.sh"
	fi
# else
# 	if [[ "$uname" == "Linux" ]]; then
# 	fi
fi
