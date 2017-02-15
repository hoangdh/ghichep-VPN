#!/bin/bash
list=$(cat ./list-user.txt)
i=1
for x in $list
	do
		sh ./vpn-client $x
		i=i+1
	done 
echo "$i users have been created by Scirpt"