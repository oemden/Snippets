#!/bin/bash

# Rename ArtLantis Studio 5 pkg for silent install // No comment

# thx : http://stackoverflow.com/questions/2709458/bash-script-to-replace-spaces-in-file-names

## go to tmp folder
cd /tmp/ArtlantisStudio5
## rename pkg
for f in *\ *; do mv "$f" "${f// /}"; done
## install package
installer -pkg ./*.mpkg -tgt /

exit 0
