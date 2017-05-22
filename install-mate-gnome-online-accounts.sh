#!/bin/bash
# Installs and configures the GNOME Control Centre on Ubuntu Mate to
# give access to the Online Services module
#
# GPL v3 licensed
# Written 2017 Peter Feerick

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

echo -en "GNOME Online Accounts installer\n\n"

echo -ne "Refreshing software update repositories ... "
apt-get update >/dev/null 2>&1
echo -ne "done!\n"

echo -ne "Installing GNOME Online Accounts and dependencies ... "
apt-get -f -y install gnome-control-center gnome-online-accounts >/dev/null 2>&1
echo -ne "done!\n"

echo -ne "Adding menu entry to Applications -> System Tools ... "
mkdir -p ~/.local/share/applications/
cp /usr/share/applications/gnome-control-center.desktop ~/.local/share/applications/
sed -i '/^OnlyShowIn/d' ~/.local/share/applications/gnome-control-center.desktop
sed -i 's/^Exec.*/Exec=env XDG_CURRENT_DESKTOP=GNOME gnome-control-center --overview/' ~/.local/share/applications/gnome-control-center.desktop
sed -i 's/^Name=Settings/Name=GNOME Control Center/' ~/.local/share/applications/gnome-control-center.desktop
echo -ne "done!\n"

echo -ne "\nYou can now launch the GNOME Control Center from Applications -> System Tools.\n"
echo -ne "This will give you access to all the settings modules, including Online Accounts.\n\n"

read -t 10 -p "Do you want to open the Online Accounts module now (y/n)?" choice

case "$choice" in
  y|Y ) echo -ne "\nOpening GNOME Online Accounts module... " && \
        exec=env XDG_CURRENT_DESKTOP=GNOME gnome-control-center online-accounts >/dev/null 2>&1 && \
        echo -ne "All done!\n";;
  n|N ) exit 0;;
  *) echo -ne "\n\nInvalid input or timeout... Exiting!\n"
esac
