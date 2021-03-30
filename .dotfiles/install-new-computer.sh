#!/bin/bash

# See https://github.com/magnusviri/dotfiles for instructions
#
# Run this as admin but not root.
# Edit ~/.env first
#

set -u

WHICH_USER=`whoami`
UNAME="$(uname)"

echo "This script should be idempotent and can be run over and over"

if [ "$WHICH_USER" == "root" ]; then
	echo "You must be admin but not root to run this script"
	exit 1
fi

if [ "`id -Gn | grep -w admin`" = "" ]; then
	echo "You must be admin but not root to run this script"
	exit 1
fi

if [ ! -e "$HOME/.env" ]; then
	echo "Please create \"$HOME/.env\", see https://github.com/magnusviri/dotfiles for instructions."
	exit 1
fi
source "$HOME/.env"

if [ "$COMPUTER_TYPE" == "" ]; then
	echo "Please set COMPUTER_TYPE in ~/.env"
	exit 1
fi

if [ "$HARDWARE_TYPE" == "" ]; then
	echo "Please set HARDWARE_TYPE in ~/.env"
	exit 1
fi

if [ "$COMPUTER_NAME" == "" ]; then
	echo "Please set COMPUTER_NAME in ~/.env"
	exit 1
fi

echo "Authenticating with sudo."
sudo echo "I can sudo now"

##########################################################################################

# Create /usr/local/bin
if	 [ ! -e /usr/local/bin/ ]; then
	echo "mkdir -p /usr/local/bin/"
	sudo mkdir -p /usr/local/bin/
	sudo chown root:wheel /usr/local/bin/
	sudo chmod 755 /usr/local/bin/
fi

if [[ "$UNAME" == "Darwin" ]]; then

	echo "scutil --set ComputerName \"$COMPUTER_NAME\""
	scutil --set ComputerName "$COMPUTER_NAME"

	echo "scutil --set LocalHostName \"$COMPUTER_NAME\""
	scutil --set LocalHostName "$COMPUTER_NAME"

	# Download mak.py
	if [ ! -e /usr/local/bin/mak.py ]; then
		echo "Installing mak.py"
		echo "curl -o /usr/local/bin/mak.py https://raw.githubusercontent.com/magnusviri/mak.py/master/mak.py"
		sudo curl -o /usr/local/bin/mak.py https://raw.githubusercontent.com/magnusviri/mak.py/master/mak.py
		sudo chown root:wheel /usr/local/bin/mak.py
		sudo chmod 755 /usr/local/bin/mak.py
	fi

	# Download Brew
	if test ! $(which brew); then
		echo "Installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	fi

	if [[ "$COMPUTER_TYPE" == "WorkMac" ]]; then

		# Download nvm
		if [ ! -e "$HOME/.nvm" ]; then
			echo "Installing nvm"
			curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash
		fi

		# Download svg2icns
		if [ ! -e /usr/local/bin/svg2icns ]; then
			echo "Installing svg2icns"
			curl -o /usr/local/bin/svg2icns https://raw.githubusercontent.com/magnusviri/svg2icns/main/svg2icns
			chmod 755 /usr/local/bin/svg2icns
		fi

		echo "Running Homebrew"
		brew_formulae='
			tap "homebrew/bundle"
			tap "homebrew/cask"
			tap "homebrew/core"

			brew "asciinema"
			brew "bat"
			brew "catimg"
			brew "ffmpeg"
			brew "glances" # top, disk io, net, etc
			brew "htop"
			brew "httpie" # a user-friendly command-line HTTP client for the API era. https://httpie.org/
			brew "imagemagick"
			brew "lolcat"
			brew "lua"
			brew "mas"
			brew "micro"
			brew "neofetch" # system_profiler like
			brew "nnn" # File browser
			brew "prettier"
			brew "prettyping"
			brew "python3"
			brew "socat"
			brew "svg2png"
			brew "telnet"
			brew "tldr"
			brew "tmux"
			brew "webp"
			brew "wget"
			brew "whalebrew"
			brew "wumpus"
			brew "youtube-dl"
			brew "zsh"
# 			brew "autoconf" # for radmind
# 			brew "duti"
# 			brew "gifsicle" # Manipulate GIFs from terminal
# 			brew "gnu-typist" # Term typing tutor
# 			brew "jq" # like sed for JSON datahttps://stedolan.github.io/jq/
# 			brew "klavaro" # GUI typing tutor
# 			brew "librsvg"
# 			brew "mariadb"
# 			brew "midnight-commander" # Terminal Finder
# 			brew "packer"
# 			brew "speedtest-cli"
# 			brew "tesseract" #OCR software
# 			brew "tree" # displays directories as trees
			cask "arq"
			cask "bbedit"
			cask "brave-browser"
			cask "cord"
			cask "docker"
			cask "dropbox"
			cask "firefox"
			cask "go2shell"
			cask "grandperspective"
			cask "iterm2"
			cask "suspicious-package"
			cask "textadept"
			cask "vagrant"
			cask "virtualbox"
			cask "vlc"
			cask "wireshark"
			cask "xquartz"
			cask "zenmap"
			cask "zoom"
			mas "com.alice.mac.GetPlainText", id: 508368068
			mas "Numbers", id: 409203825
			mas "Slack", id: 803453959
			mas "The Unarchiver", id: 425424353
			mas "VOX", id: 461369673
			mas "Xcode", id: 497799835

# Work only
			cask "anaconda"
			brew "angular-cli"
			brew "ansible"
			brew "s3cmd"
			cask "microsoft-office"
			cask "microsoft-teams"
			cask "mountain-duck"
			cask "paragon-extfs"
			cask "vscodium"
			mas "1Password 7", id: 1333542190
			mas "Keynote", id: 409183694
			mas "Remote Desktop", id: 409907375

# Personal only
			brew "minetest"
			cask "blender"
			cask "freeorion"
			cask "musescore"
			mas "GarageBand", id: 682658836
		'
# If 10.15
#	cask "vmware-fusion"
# Box, Pacifist
#
# 	'Install Anaconda3' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Arduino' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install CoRD' => 								{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install GarageBand' => 						{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install iMovie' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Keynote' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Keyspan' => 							{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install LibreOffice' => 						{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install MeshLab' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Numbers' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Pages' => 								{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Sublime Text' => 						{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install VLC' => 								{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Xcode' => 								{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install XQuartz' => 							{'student'=>1, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install BoxDrive' => 							{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Dropbox' => 							{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Firefox' => 							{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install HP Printer Drivers' => 				{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Microsoft Office 2019' => 				{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install QuickTime 7' => 						{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Skype' => 								{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install TeamViewer' => 						{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install XMenu' => 								{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Zoom' => 								{'student'=>1, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Novabench' => 							{'student'=>1, 'staff'=>1, 'server'=>1, 'james'=>1},
# 	'Install BBEdit' => 							{'student'=>1, 'staff'=>1, 'server'=>1, 'james'=>1},
# 	'Install Carbon Copy Cloner' => 				{'student'=>1, 'staff'=>1, 'server'=>1, 'james'=>1},
#
# 	'Install iTerm2' => 							{'student'=>1, 'staff'=>1, 'server'=>1, 'james'=>1},
# 	'Install Radmind' => 							{'student'=>1, 'staff'=>1, 'server'=>1, 'james'=>1},
# 	'Install 1Password' => 	 						{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Adobe CC 2019' => 						{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Arq' => 								{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Microsoft Remote Desktop' => 			{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install Thunderbird' => 						{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install TNEFs Enough' => 						{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
# 	'Install VMware Fusion' => 						{'student'=>0, 'staff'=>1, 'server'=>0, 'james'=>1},
#
# ################################################################################################
# # James only
#
# 	'Install GrandPerspective' => 					{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Sassafras KeyConfigure K2 Admin' => 	{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install SoundFlower' => 						{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Suspicious Package' => 				{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install VirtualBox' => 						{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Wireshark' => 							{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# 	'Install Zenmap' => 							{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>1},
# #	'Install VMware Tools' => 						{'student'=>0, 'staff'=>0, 'server'=>0, 'james'=>0},

	fi
	if [[ "$COMPUTER_TYPE" == "WorkMacVM" ]]; then
		echo "Running Homebrew"
		brew_formulae='
			tap "homebrew/bundle"
			tap "homebrew/cask"
			tap "homebrew/core"

			brew "ansible"
			brew "micro"
			brew "python3"
			brew "s3cmd"
			brew "zsh"

			cask "brave-browser"
			cask "grandperspective"
		'
	fi

	if [[ "$COMPUTER_TYPE" == "PersonalMac" ]]; then
		echo "Running Homebrew"
		brew_formulae='
			tap "homebrew/bundle"
			tap "homebrew/cask"
			tap "homebrew/core"

			brew "python3"
			brew "webp"
			brew "wget"
			brew "wumpus"
			brew "youtube-dl"
			brew "zsh"
			cask "bbedit"
			cask "brave-browser"
			cask "docker"
			cask "dropbox"
			cask "firefox"
			cask "go2shell"
			cask "grandperspective"
			cask "iterm2"
			cask "suspicious-package"
			cask "textadept"
			cask "virtualbox"
			cask "vlc"
			cask "wireshark"
			cask "xquartz"
			cask "zenmap"
			cask "zoom"
			mas "com.alice.mac.GetPlainText", id: 508368068
			mas "Numbers", id: 409203825
			mas "Slack", id: 803453959
			mas "The Unarchiver", id: 425424353
			mas "VOX", id: 461369673
			mas "Xcode", id: 497799835
			mas "WiFi Explorer Lite", id: 1408727408

			brew "minetest"
# 			brew "freeciv"
# 			brew "pacman4console"
# 			brew "trader" # Old game
# 			brew "tty-solitaire"
			cask "blender"
			cask "freeorion"
# 			cask "mame"
# 			cask "milkytracker"
			cask "musescore"
# 			cask "nestopia"
# 			cask "openaudible"
# 			cask "scribus"
# 			cask "virtualc64"
			mas "GarageBand", id: 682658836
# 			mas "BlockheadsServer", id: 662633568
		'

# Audacity, ZeroBraneStudio, Deflemask, radmind & atari 800, other emulators, unknown-horizons

	fi

	echo "$brew_formulae" | brew bundle install --file=-
	brew cleanup
	brew doctor --verbose

	# Remove com.apple.quarantine
	echo "Removing com.apple.quarantine"
	IFS='|'
	quarantined=(
		"BBEdit.app"
		"Brave Browser.app"
		"CoRD.app"
		"Docker.app"
		"Dropbox.app"
		"Go2Shell.app"
		"GrandPerspective.app"
		"Inkscape.app"
		"MAME OS X.app"
		"MilkyTracker.app"
		"MuseScore 3.app"
		"Nestopia.app"
		"OpenAudible.app"
		"Remote Desktop.app"
		"Scribus.app"
		"Suspicious Package.app"
		"Textadept.app"
		"VLC.app"
		"VSCodium.app"
		"VirtualC64.app"
		"Wireshark.app"
		"iTerm.app"
	)
	for app in "${quarantined[@]}"; do :
		if [ -e "/Applications/$app" ]; then
		   xattr -cr "/Applications/$app"
		fi
	done

	# Add zsh to list of shells
	grep /usr/local/bin/zsh /etc/shells
	if [[ -e "/usr/local/bin/zsh" && "$?" == 1 ]]; then
		echo "Add zsh to list of shells"
		echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells
	fi

	# TextAdept
	if [ ! -e /usr/local/bin/textadept ]; then
		echo "Linking /usr/local/bin/textadept"
		cd /usr/local/bin/
		sudo ln -s /Applications/Textadept.app/Contents/MacOS/textadept-curses textadept
	fi

	# Download textart
	if [ ! -e /usr/local/bin/textart ]; then
		echo "Installing textart"
		sudo curl -o /usr/local/bin//textart https://raw.githubusercontent.com/magnusviri/textart/master/textart
		sudo chown root:wheel /usr/local/bin/textart
		sudo chmod 755 /usr/local/bin/textart
	fi

	sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

	echo
	echo "-------------------------------------------------"

	if [[ "$COMPUTER_TYPE" == "WorkMac" ]]; then
		echo
		echo "Remote Desktop grant non-admin rights, and remote desktop remote usage"
		echo "Install AnyConnect, Adobe CC, Office"
		echo
	fi

	echo "Set go2shell default to iTerm2 and ls -al to command."
	echo "Fix iTerm2's home, end, page up, page down, cmd-arrow keys."

elif [[ "$UNAME" == "Linux" ]]; then

	# Dropbox
	#https://www.dropbox.com/install-linux
	#cd ~ && wget -O - "https://www.dropbox.com/download?plat=lnx.x86" | tar xzf -

	#https://help.dropbox.com/installs-integrations/desktop/linux-commands
	#deb https://linux.dropbox.com/ubuntu xenial main >> /etc/apt/sources.list
	#sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 1C61A2656FB57B7E4DE0F4C1FC918B335044912E

	if [ ! -e /usr/local/bin [; then
		sudo mkdir -p /usr/local/bin
	fi

	if [ -e /bin/yum ]; then

		yum -y update && yum -y upgrade
		yum -y install open-vm-tools
		yum -y install git
		yum -y install tmux
		yum -y install rsync
		#yum -y install nano
		#yum -y install nftables

	elif [ -e /bin/apt ]; then

		sudo apt install tmux
		sudo apt install snapd
		sudo snap install brave
		sudo apt install curl
		sudo apt install apt-transport-https
		curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
		curl https://s3-us-west-2.amazonaws.com/brave-apt/keys.asc | sudo apt-key add -
		source /etc/os-release
		echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ $UBUNTU_CODENAME main" | sudo tee
		/etc/apt/sources.list.d/brave-browser-release-${UBUNTU_CODENAME}.list
		sudo apt update

	fi
fi

# https://docs.brew.sh/Adding-Software-to-Homebrew
# https://github.com/Homebrew/homebrew-core/blob/master/Formula/ansible.rb
# https://github.com/nicknisi/dotfiles/blob/master/Brewfile
# https://medium.com/better-programming/12-terminal-tips-and-tricks-using-macos-and-homebrew-4e89c2ccb2fb
#
# https://github.com/nicknisi/dotfiles/tree/master/zsh
# https://github.com/skwp/dotfiles/blob/master/tmux/tmux.conf
# https://github.com/ryanb/dotfiles/blob/master/oh-my-zsh/custom/plugins/rbates/bin/tagversions
# https://github.com/thoughtbot/dotfiles/blob/master/tmux.conf
# https://github.com/holman/dotfiles/blob/master/homebrew/install.sh
# https://github.com/holman/dotfiles/blob/master/zsh/config.zsh
# https://github.com/search?q=zsh+dotfiles&ref=commandbar
# https://scriptingosx.com/2019/07/moving-to-zsh-part-5-completions/
