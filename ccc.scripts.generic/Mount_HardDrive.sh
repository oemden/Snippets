#!/bin/bash

## v 0.2 © oem at oemden dot com

########### IMPORTANT #################
## NOTE : No Space in the Name.
## I know it sucks... but I'm too lazy to search for a solution.
##
## If you REALLY want to have a Space in the Name you'll have to edit the line
## diskID=`diskutil list | grep "$1" | awk '{print $6}'` in the function below.
## if you have 1 space in the name  change $6 with $7; 
## if you have two spaces in the name change $6 with $8 and so on.
########### IMPORTANT #################

## Replace your (Backup) HardDrive Name here.
#
Drive="Boo"

## ------------------------------------------
#### Don't edit below unless you've read above
## and/or you know what you're doing
## ------------------------------------------

## to allow argument (just in case for testing fro example)
if [[ -n "$1" ]] ; then
	Drive="$1"
fi
echo "HardDriveName is : $Drive"

function get_diskID {
	# "{$1}" = Disc name
	diskID=`diskutil list | grep "$1" | awk '{print $6}'`
}

function mount_BackupDiscs {
	# "{$1}" = DiskID
	get_diskID "$1"
	echo "$diskID"
	/usr/sbin/diskutil mount "$diskID" > /dev/null
}

## mount the disc
mount_BackupDiscs "$Drive"

exit 0