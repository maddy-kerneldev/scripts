#!/bin/sh
# SPDX-License-Identifier: GPL-2.0
#
# Madhavan Srinivasan, IBM Corp 2022
#
# Usage: $ ./check_asm-offset.sh <arch>
#
# Example: ./check_asm-offset.sh powerpc
#
# Search for each macro defined in asm-offset.s in the ./arch/<arch> sourc path
# for usage of the macro. If not used, print the macro name.
#
# Prerequisites:
#
# Script expect <arch> folder to have asm-offset.s file. If not it will return with message

usage() { echo "Usage: $0 <arch folder name>"}

#Check for parameter
if [-z "$1"]; then
	usage
	exit
fi

out=`ls -1 ./arch/ | grep -w $1`
if [ -z $out ]
then
	echo "Invalid <arch> parameter"
	usage
	exit
fi

cd ./arch/$1/
out=`find . -name asm-offsets.s`
if [ -z $out ]
then
	echo "asm-offset.s is missing"
	echo "Genarate it and then run the script again"
	exit
fi

while IFS= read -r line;
do 
	if [[ $line == .ascii* ]]
	then
		macro=$( cut -d' ' -f 1 <<< `cut -d'>' -f 2 <<< $line` );
		if grep -qnr $macro --exclude="asm-offsets.*";
		then
			continue
		else
			echo $macro
		fi
	fi
done < $out 
