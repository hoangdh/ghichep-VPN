sendmail()
{
for i in {1..100}
do
	#echo "Đã gửi $i email.!"
#	s=`date | md5sum | awk {'print $1'}`
#	sleep 1
	#s="Thư số $i"
	echo "Xin chào, đây là script spam mail." | mail -s "Email $i" $1
	if [ $? -eq 0 ]; then
	echo "Đã gửi email số $i.!"
	else	
	echo "Lỗi!"
	fi
	sleep 1
	#clear
done
}
	if [ -z $1 ];
	then 
		read -p "Nhập Email muốn spam: " EMAIL
		sendmail $EMAIL	
	# elif [ $1 -eq "-h" ];
	# then
		# echo -e "Xin chào!\n Sử dụng script như sau:\nmail anyone@example.com\nChúc bạn sử dụng vui vẻ!\nBạn phải cài đặt Postfix Relay hoặc sSMTP để gửi."
	else
		sendmail $1
	fi


