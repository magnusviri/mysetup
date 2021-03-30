# Dotfiles

Scripts to setup my new computers. I go through new computers so often (and VM's too) I'm really tired of doing it over and over. I've been meaning to do this forever. It's finally time.

## Install/Update

https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line

Brand new Mac

- Install OS
- Create admin account
- Create non-admin account
- Login as non-admin account
- Run this

	curl -L https://raw.githubusercontent.com/magnusviri/dotfiles/master/.dotfiles/install.sh | bash

- Install Xcode when asked
- Edit stuff
- Do this when prompted

	su <admin>
	./.dotfiles/install.sh

- Restart the computer.

## I should probably...

- Update the Linux stuff.