#!/bin/bash
#$1 user
#$2 targetfolder
# oem at oemden dot com

## ================ VARS ==============
version="v0.7"
Script=`basename $0`
Folder="$2"
thefolder=`basename $Folder`
pathtofolder=`dirname $Folder`
User="$1"
ACLCommand="allow list,add_file,search,delete,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,writesecurity,chown,file_inherit,directory_inherit"
## ================ VARS ==============

## Cleanup
clear
echo "---------------------------------------------------"
echo " Adding ACL "
echo " $Script - Version=$version"
echo "  -> for user: \"$User\" "
echo "  -> on Folder \"$Folder\" "
echo "---------------------------------------------------"

## functions
function check_sudo {
	if [ `id -u` != 0 ] ; then
		echo "must be root - existing" && usage && exit 1
	fi
}

function usage {
	echo "---------------------------------------------------"
	echo " Use as follow:"
	echo
	echo " $Script \"User\" \"/Some/Path/to a Folder/you/want/to/Add/ACL/to\""
	echo
	echo " User can be a local or OpenDirectory User"
	echo "---------------------------------------------------"
}

function check_target_Folder() {
	if [[ ! -d "$Folder" ]] ; then
		FolderExist="0"
	else 
		FolderExist="1"
	fi
}

function check_user_exist_local {
	CheckUser=$(dscl . -list /Users | grep "$User" )
	if [[ -z "$CheckUser" ]] ; then
		UserExistLocal="0"
	else
		UserExistLocal="1"
	fi
}

function check_user_exist_od {
	CheckUser=$(dscl /LDAPv3/127.0.0.1 -list /Users | grep "$User" )
	if [[ -z "$CheckUser" ]] ; then
		UserExistOD="0"
	else
		UserExistOD="1"
	fi
}

function change_acl() {
	echo " - Adding ACL for \"$User\" on \"$Folder\"..."
	#chmod -R +a "$1 allow list,add_file,search,delete,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,writesecurity,chown,file_inherit,directory_inherit" "$2"
	chmod -R +a "$User $ACLCommand" "$Folder"
	echo " - - Done "
	ls -lhe `dirname $Folder` | grep "$Folder"
}

function do_it() {
	check_sudo
	check_user_exist_local #"$User"
	check_user_exist_od #"$User"
	check_target_Folder #"$Folder"

	##echo Checks
	if [[ "$FolderExist" == "0" ]] ; then
		echo " ! WARNING ! target folder : " && echo " \"$Folder\" does not exist"
	elif [[ "$FolderExist" == "1" ]] ; then
		echo " - Target Folder \"$Folder\" exist..." 
	fi
	echo "---------------------------------------------------"
	if [[ "$UserExistLocal" == "1" ]] || [[ "$UserExistOD" == "1" ]] ; then
		UserExist="1"
		echo " - User \"$User\" exist..." 
	else
		echo " ! WARNING ! user: " && echo " \"$User\" does not exist"
	fi

	##If we have a user and a folder then change ACL or quit
	echo "---------------------------------------------------"
	if [[ "$FolderExist" == "1" ]] && [[ "$UserExist" == "1" ]]; then
			change_acl #"$1" "$2"
			#change_acl #"$User" "$Folder"
	echo "---------------------------------------------------"
			echofolderACL #"$2"
	else
		echo && echo " Missing User or folder, existing now" && echo 
		usage
		exit 1
	fi
	echo "---------------------------------------------------"
}

function echofolderACL {
	ls -lhe "$pathtofolder" | grep -e "$thefolder" -e "$ACLCommand" | grep -e "$User" 
}

function echoCheck {
	echo "  -> for user: \"$User\" "
	echo "  -> on Folder \"$Folder\" "
	echo "  -> thefolder: \"$thefolder\" "
	echo "  -> pathtofolder \"$pathtofolder\" "
}

do_it #"$1" "$Folder"

exit 0

###TODOS
## What if localuser AND OD User exists ?
## Include Active Directory
## maybe move to optarg

### HISTORY
## v0.8 Added basic ACL Check aka ls -lhe of the folder only for User
## 		replacing all $1 $2 with variables
## v0.7 Added basic ACL Check aka ls -lhe of the folder
## v0.6 Cleaning
## v0.5 Added basic usage
## v0.4 If OD User or Local User then
## v0.3 Added user check (LDAP)
## v0.2 Added user check (local)
## v0.1	Added check folder exist
## v0 	simple chmod command hardcoded
