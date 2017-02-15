#!/bin/bash
# Script to add a user to Linux system
adduser()
{
yum install -y perl 2&> /dev/null
if [ $(id -u) -eq 0 ]; then
	#read -p "Enter username : " username
	username=$1
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"  >> /opt/user-add-error.txt
	else		
		#read -s -p "Enter password : " password
		password=`head -c 500 /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 15 | head -n 1`
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		[ $? -eq 0 ] &&	echo -e "$username\t$password" >> /opt/list-user.txt ||
		echo -e "\nFailed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
}

if [ -f list.txt ]; then 
	tmp=$(cat list.txt)
	 for x in $tmp
		do
			adduser $x
		done 
else
	clear
	echo -e "Error: Can't find file list.txt! \nPlease, list user in list.txt."
	exit 1	
fi

cat /opt/list-user.txt

