#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ZSHPLUGINSCFGDIR=/home/$USERNAME/.zsh-plugins
ZSHPLUGINS=/home/$USERNAME/.zsh-plugins/plugins

function debuginfo() {
	echo "######### DEBUG INFO #########"
	printenv
	echo "=============================="
}

function init() {
	mount -t tmpfs -o exec tmpfs /tmp
}

function setupUser() {
	useradd -m -s /bin/zsh ${USERNAME} && \
		usermod -aG sudo ${USERNAME} && \
		echo "${USERNAME}:${USERPASS}" | chpasswd
	echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
}

function setupZSH() {
	echo "Setting up ZSH"
	sudo -i -u ${USERNAME} /bin/zsh <<EOF
		echo "Scaffolding ZSH config directories"
		mkdir -p $ZSHPLUGINS

		echo "Setting up local plugins"
		sudo mv /setup/zsh/.zsh-plugins/** $ZSHPLUGINSCFGDIR
		sudo find $ZSHPLUGINSCFGDIR -type f -exec chown -R ${USERNAME}:${USERNAME} {} \;
		echo "Completed setting up local plugins"

		echo "Setting up 3rd party plugins"
		sudo mv /setup/zsh-plugins/** $ZSHPLUGINS
		sudo find $ZSHPLUGINS -type f -exec chown -R ${USERNAME}:${USERNAME} {} \;
		echo "Completed setting up 3rd party plugins"

		echo "Setting up ZSH config"
		sudo mv /setup/zsh/.zshrc /home/$USERNAME/.zshrc
		sudo chown ${USERNAME}:${USERNAME} /home/$USERNAME/.zshrc
		echo "Completed setting up ZSH config"

		echo "ZSH setup complete"
EOF
}

function runUserRootScripts() {
	if [ ! -d "/setup/user-root-scripts" ]; then
		echo "No user root scripts found"
		return
	else
		echo "Running user root scripts"
		for file in /setup/user-root-scripts/*; do
			if [ -f "$file" ]; then
				echo "Running $file"
				chmod +x $file
				$file
			fi
		done
		echo "User root scripts complete"
	fi
}

function runUserScripts() {
	if [ ! -d "/setup/user-scripts" ]; then
		echo "No user scripts found"
		return
	else
		echo "Running user scripts"
		for file in /setup/user-scripts/*; do
			if [ -f "$file" ]; then
				echo "Running $file"
				chmod +x $file
				su -s /bin/bash -c "$file" $USERNAME
			fi
		done
		echo "User scripts complete"
	fi
}

function finalize() {
	exec /sbin/init
}

debuginfo
init
setupUser
setupZSH
runUserRootScripts
runUserScripts
finalize