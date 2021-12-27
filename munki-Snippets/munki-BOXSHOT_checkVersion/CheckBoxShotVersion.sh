#!/bin/sh

# adapted from : http://apple.stackexchange.com/questions/127561/script-to-check-software-version
# oem at oemden dot com for PR2i

## Goal want to remove version 4.8.2 to install 4.2.2 (avec licence)

ApplicationName="/Applications/Boxshot.app"
ApplicationVersionNumber="4.8.2"
echo $ApplicationName

#Check if Directory Exist
if [ ! -d $ApplicationName ]; then
    echo "$ApplicationName is not installed"
    exit 0
    # munki will then install correct Boxshot
fi
echo "$ApplicationName is installed"

# Check Version
VersionCheck=`plutil -p "${ApplicationName}/Contents/Info.plist" | grep "CFBundleShortVersionString.*$ApplicationVersionNumber"`
echo $VersionCheck
if [ ${#VersionCheck} != 0 ]; then
    echo "$ApplicationName $ApplicationVersionNumber is Installed"
    echo "Removing App"
   	rm -Rf "$ApplicationName"
    exit 0
fi
echo "$ApplicationName $ApplicationVersionNumber is NOT Installed"
exit 1
