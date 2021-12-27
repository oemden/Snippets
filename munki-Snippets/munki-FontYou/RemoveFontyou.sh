#!/bin/sh
## oem @ oemden dot com
## Remove FontYou.
Version="1.0"

## For Munki Pre-Uninstall Script.

########################## EDIT START ##########################
AD_DOMAIN="SP" # your company AD DOMAIN here.
########################## EDIT END #############################

LOGIN="$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')"
USER_HOMEDIR="$(/usr/bin/dscl . -read /Users/$LOGIN | grep 'NFSHomeDirectory:'  | awk '{print $2}')"
################################################################################################

## Prefix all paths with $TARGET
if [ "$3" == "/" ]; then
    TARGET=""
else
    TARGET="$3"
fi

## Unload daemon
launchctl unload -w "${USER_HOMEDIR}"/Library/LaunchAgents/com.fontyou.appRestarter.plist
launchctl remove -w "${USER_HOMEDIR}"/Library/LaunchAgents/com.fontyou.appRestarter.plist
rm -f "${USER_HOMEDIR}"/Library/LaunchAgents/com.fontyou.appRestarter.plist


## Quit the App. in case the daemon did not killed the App.
osascript -e 'quit app "Fontyou"'

#let Munki remove the App.

exit 0

