list=`cat list.txt`

for x in $list
do
	userdel $x
done 