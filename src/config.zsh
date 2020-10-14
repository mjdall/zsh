#!/usr/bin/env zsh
# ~~~~~~~~~~~~~~~~~~~

# Get standard distribution info
. /etc/os-release

# conda setup
. /anaconda/etc/profile.d/conda.sh

# ~~~~~~~~~~~~~~~~~~
# Antigen Setup

_ANTIGEN_INSTALL_DIR=""$HOME"/.antigen/"
export _ANTIGEN_INSTALL_DIR
mkdir -p "$_ANTIGEN_INSTALL_DIR"
ANTI_FILE="$_ANTIGEN_INSTALL_DIR/antigen.zsh"

if [ ! -f "$ANTI_FILE" ]; then
	curl -L git.io/antigen >"$ANTI_FILE"
fi

AZ_AUTOCOMPLETES=""$HOME"/.az_auto_completion"
if [ ! -f "$AZ_AUTOCOMPLETES" ]; then
	curl -L https://raw.githubusercontent.com/Azure/azure-cli/dev/az.completion > "$AZ_AUTOCOMPLETES"
	echo -e "#\!/usr/bin/env bash\n\n$(cat "$AZ_AUTOCOMPLETES")" > "$AZ_AUTOCOMPLETES"
fi

source "$ANTI_FILE"

pip list | grep "radian" &> /dev/null
if [ $? -ne 0 ]; then
	pip install radian
fi

RADIAN_PROFILE=""$HOME"/.radian_profile"
if [ ! -f "$RADIAN_PROFILE" ]; then
	# settings for Radian as VSCode R console
	echo "options(radian.color_scheme = \"monokai\")" > "$RADIAN_PROFILE"
	echo "options(radian.auto_match = FALSE)" >> "$RADIAN_PROFILE"
	echo "options(radian.auto_indentation = FALSE)" >> "$RADIAN_PROFILE"
fi

# ~~~~~~~~~~~~~~~~~~
# Antigen Config

antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle z
antigen bundle docker-compose
antigen bundle docker

antigen bundle djui/alias-tips
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle webyneter/docker-aliases.git
antigen bundle zsh-users/zsh-completions
antigen bundle chrissicool/zsh-256color
antigen bundle esc/conda-zsh-completion

# Load the theme.
antigen theme af-magic #denysdovhan/spaceship-prompt

# Tell Antigen that you're done.
antigen apply

# ~~~~~~~~~~~~~~~~~~~
# Vars

source "$(dirname $0)/vars.env"

# ~~~~~~~~~~~~~~~~~~~~
# Alias

# Easy jump into a container
alias boop="docker run --rm -it"
alias r="radian"
alias watch-logs="dmesg -THw"

# Project Init
alias projinit="mkdir -p script && touch LICENSE README.md CONTRIBUTING.md script/test script/bootstrap"

# vim > nano
alias nano="echo 'stop being bad, use vim to edit: '"

# Update
alias up="_ apt update;_ apt -y full-upgrade;_ apt -y autoremove"

# todo: figure out this error with complete cmd
alias auto_az="source "$AZ_AUTOCOMPLETES""

alias install-theme="mkdir -p ~/.themes \
&& wget -O /tmp/flat-gtk.zip https://github.com/daniruiz/flat-remix-gtk/archive/master.zip \
&& wget -O /tmp/flat-gnome.zip https://github.com/daniruiz/Super-Flat-Remix-GNOME-theme/archive/master.zip \
&& wget -O /tmp/mono.zip https://download.jetbrains.com/fonts/JetBrainsMono-1.0.2.zip \
&& unzip /tmp/flat-gtk.zip -d /tmp/ \
&& unzip /tmp/flat-gnome.zip -d /tmp/ \
&& unzip /tmp/mono.zip -d $HOME/.fonts \
&& cp -r /tmp/flat-remix-gtk-master/Flat-Remix-* ~/.themes \
&& cp -r /tmp/flat-remix-gnome-master/Flat-Remix-* ~/.themes \
&& _ add-apt-repository -y ppa:numix/ppa \
&& _ apt update -y && _ apt-get install -y papirus-icon-theme \
&& gsettings set org.gnome.desktop.wm.preferences theme 'Flat-Remix-Dark' \
&& gsettings set org.gnome.desktop.interface icon-theme 'Papirus' \
&& gsettings set org.gnome.desktop.interface gtk-theme 'Flat-Remix-GTK-Yellow-Dark' \
&& gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrains Mono 10' \
&& gsettings set org.gnome.desktop.interface document-font-name 'JetBrains Mono 10' \
&& gsettings set org.gnome.desktop.interface font-name 'JetBrains Mono 10' \
&& gsettings set org.gnome.shell.extensions.dash-to-dock autohide false \
&& gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false \
&& gsettings set org.gnome.shell.extensions.dash-to-dock intellihide false"

alias install-gitkraken="_ apt-get update -y && _ apt-get -y install python gconf2 gconf-service && \
wget -O /tmp/gitkraken.deb https://release.gitkraken.com/linux/gitkraken-amd64.deb && \
_ dpkg -i /tmp/gitkraken.deb"

# Probs update this frequently
# https://www.jetbrains.com/toolbox/download/download-thanks.html?platform=linux
alias install-jetbrains="wget -O /tmp/jet.tar.gz https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.18.7455.tar.gz && \
tar -xzf /tmp/jet.tar.gz -C /tmp && \
_ mv /tmp/jetbrains-toolbox-*/jetbrains-toolbox /usr/local/bin/"

alias install-megasync="_ apt-get update -y && \
_ apt-get install -y libc-ares2 libcrypto++6 libmediainfo0v5 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5svg5 libqt5widgets5 libzen0v5 && \
wget -O /tmp/megasync.deb https://mega.nz/linux/MEGAsync/x${NAME}_${VERSION_ID}/amd64/megasync-x${NAME}_${VERSION_ID}_amd64.deb && \
_ dpkg -i /tmp/megasync.deb"

alias install-notable="wget -O /tmp/note.deb https://github.com/notable/notable/releases/download/v1.8.2/notable_1.8.2_amd64.deb && \
_ dpkg -i /tmp/note.deb"

# Personal Prefs
alias install-tyler="\
_ apt update \
&& _ apt install -y \
	vim \
	ubuntu-desktop \
	keepassx \
	gnome-tweak-tool \
	clusterssh \
	network-manager-openvpn \
	chrome-gnome-shell \
	network-manager-openvpn-gnome \
&& _ snap install --classic code \
&& _ snap install --classic slack \
&& _ snap install --classic go \
&& _ snap install --classic kubectl \
&& _ snap install discord \
&& _ snap install spotify \
&& _ snap install hexchat \
&& install-theme \
&& install-jetbrains \
&& install-notable"
