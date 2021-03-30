# This runs after .zshenv

# Prompt
# export PS1="%n@%m:%d@%*$ "
export PS1="%F{white}<%F{yellow}%n%F{white}@%F{green}%m%F{white}:%F{magenta}%~%F{white}|%F{cyan}%F{white}%F{cyan}%*%F{white}>%f "

source ~/.bash_profile

# History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000
setopt SHARE_HISTORY
# appeand to history
setopt APPEND_HISTORY
# append after every command
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# Silences "zsh: sure you want to delete all n files in /... [yn]?"
setopt rmstarsilent

# When typing a dir alone, it will auto cd to the dir.
setopt AUTO_CD

# Makes esc-del work right
WORDCHARS='~!#$%^&*(){}[]<>?.+;-'

########
# 3rd party

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true
test -e /usr/local/vic/autocomplete/zsh/vic-machine-darwin && source /usr/local/vic/autocomplete/zsh/vic-machine-darwin || true

########
# Adobe will never be my cloud storage...

test -e "${HOME}/Creative Cloud Files" && rm "${HOME}/Creative Cloud Files/Icon"* && rmdir "${HOME}/Creative Cloud Files" || true

########
# nnn

source ~/.dotfiles/quitcd.bash_zsh
alias 'nnn'='n'

########
# My customizations

#nvm use v14.15.1

alias 'ard'='echo sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -restart -agent'
alias 'extractAudio'='ffmpeg -i \!:1 -vn -acodec copy \!:2'
alias 'icns2png'='sips -s format png \!:1 --out \!:2'
alias 'npm6'='nvm use v14.15.1'

alias 'cat'='echo bat /bin/cat'
alias 'curl'='echo http /usr/bin/curl'
alias 'man'='echo tldr /usr/bin/man'
alias 'nano'='echo micro /usr/bin/nano'
alias 'pico'='echo micro /usr/bin/pico'
alias 'ping'='echo prettyping /sbin/ping'
alias 'top'='echo glances /usr/local/bin/htop /usr/bin/top'
alias 'reboot'='echo fdesetup authrestart /sbin/reboot'

# Laravel dev
#alias 'artisan'='docker-compose run --rm artisan'
#alias 'composer'='docker-compose run --rm composer'
#alias 'npm'='docker-compose run --rm npm'

alias

/bin/cat "${HOME}/.textart/"*
echo "\033[0m"

################################################################################
lolcat << EOF
asciinema ard catimg extractAudio icns2png lolcat neofetch nnn npm6 prettier
socat svg2png svg2icns tmux webp wget wumpus - 
EOF
