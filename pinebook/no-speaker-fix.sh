#!/bin/bash

# Written by Peter Feerick, 2017
# Licensed under the GPL v3

# Fixes the issue with the currently shipped revision of the linux image on the
# Pinbook not haveing any sound. If it doesn't work, the asound.state file can
# be recovered from the /tmp directory.

if [ "$(id -u)" != "0" ]; then
        echo "This script must be executed as root. Exiting" >&2
        exit 1
fi

unpackNoSoundFix ()
{
	cd /var/lib/alsa && echo "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" | base64 -d | tar xzf -
} #unpackNoSoundFix

mv  /var/lib/alsa/asound.state /tmp

#download with curl was going to be original method of packaging fix
#curl -s https://raw.githubusercontent.com/pfeerick/pine64-scripts/master/pinebook/asound.state > /var/lib/alsa/asound.state

unpackNoSoundFix

alsactl restore

echo -e "\nTry your sound again now, there is no need to reboot your Pinebook.\n"
echo -e "If it works, you can delete the asound.state file which was backed up"
echo -e "to /tmp. Otherwise, you may want to restore that backup copy to "
echo -e "/var/lib/alsa/asound.state and run 'alsactl restore' to reapply it.\n"