#!/bin/bash
# calculate and compare md5 checksums
# $1 is file - mandatory
# $2 is md5 to compare - optional
## oem@oemden.com © 2014
version="0.4" # simplified for ARD embeding 

#theFile="$1"
#theMasterChecksum="$2"
### Specific OfficeFix below
theFile="/Library/Preferences/com.microsoft.office.licensing.plist"
theMasterChecksum="bf70a2bca415facbeea4058d5cc24b36"
theFileName=`basename "$theFile"`

function doMd5 {
	openssl md5 "$1" | awk -F=' ' '{ print $2}'
}

function Check_plist {
	
	if [[ ! -f "$theFile" ]] ; then
		the_phrase="No licencing file"
		md5Result="NONE"
	fi

}

function compareMd5 {
	if [[ -f "$theFile" ]] ; then
		newMD5=`doMd5 "$theFile"`	
		if [ -n "$theMasterChecksum" ] ; then
			if [[ "$theMasterChecksum" == "$newMD5" ]] ; then
				#AS_item1
				#the_phrase="Checksums correct: $theMasterChecksum = $newMD5"
				the_phrase="	!Licencing NOT OK!:\n	$theMasterChecksum = $newMD5, \n	this is not Official plist\n"
				md5Result="BAD"
			else 
			#AS_item1
			#the_phrase="!WARNING! Checksums NOT correct: $theMasterChecksum vs $newMD5"
			the_phrase="!Licencing seems OK!\n	Checksums are different: $theMasterChecksum vs $newMD5"
			md5Result="GOOD"
			fi
		else
		#AS_item1
		the_phrase="$theFileName md5 Checksum is: $newMD5"
		md5Result="NEW"
		fi
	elif [[ ! -f "$theFile" ]] ; then
		the_phrase="No licencing file"
		md5Result="NONE"
	fi
	
}

function echoResult {
	compareMd5
	#AS_item1 the_phrase
	printf "$the_phrase"
	#AS_item2 the_result
	#echo "$md5Result"
	#AS_item3 the_md5
	echo "$newMD5"
	#AS_item4 the_filename
	echo "$theFileName"
}

## run it
echoResult
