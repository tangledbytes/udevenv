#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

ZSHPLUGINSCFGDIR=/home/$USERNAME/.zsh-plugins
ZSHPLUGINS=/home/$USERNAME/.zsh-plugins/plugins

function debuginfo() {
	echo "### DEBUG INFO ###"
	printenv
	echo "=================="
}

function init() {
	mkdir -p $ZSHPLUGINS
}

function setupUser() {
	useradd -m -s /bin/zsh ${USERNAME} && \
		usermod -aG sudo ${USERNAME} && \
		echo "${USERNAME}:${USERPASS}" | chpasswd
	echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
}

function setupZSH() {
	echo "Setting up ZSH"

	echo "Setting up local plugins"
	mv /setup/zsh/.zsh-plugins/** $ZSHPLUGINSCFGDIR
	echo "Completed setting up local plugins"

	echo "Setting up 3rd party plugins"
	mv /setup/zsh-plugins/** $ZSHPLUGINS
	echo "Completed setting up 3rd party plugins"

	echo "Setting up ZSH config"
	mv /setup/zsh/.zshrc /home/$USERNAME/.zshrc
	echo "Completed setting up ZSH config"

	echo "ZSH setup complete"
}

function setperms() {
	echo "Changing permissions"
	chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}
	find . -type f -exec chown -R ${USERNAME}:${USERNAME} {} \;
	echo "Permissions changed"
}

function cleanup() {
	rm -rf /setup
}

function finalize() {
	exec /sbin/init
}

debuginfo
init
setupUser
setupZSH
setperms
cleanup
finalize