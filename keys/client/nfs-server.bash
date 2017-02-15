yum install -y nfs-utils
read -p "Thu muc ban muon chia se:" folder
read -p "Ban muon chia se cho IP(1.1.1.1), Network(1.1.1.0/8), Tat ca(*):" ip
echo "$folder $ip(rw,no_root_squash)" >> /etc/exports
exportfs -a
/etc/rc.d/init.d/rpcbind start
/etc/rc.d/init.d/nfslock start
/etc/rc.d/init.d/nfs start
chkconfig rpcbind on
chkconfig nfslock on
chkconfig nfs on


##
client
{
	 yum -y install nfs-utils
	 /etc/rc.d/init.d/rpcbind start 
	 /etc/rc.d/init.d/rpcidmapd start 
	 /etc/rc.d/init.d/nfslock start
	 /etc/rc.d/init.d/netfs start 
chkconfig rpcbind on 
chkconfig rpcidmapd on 
chkconfig nfslock on 
chkconfig netfs on
read -p "Nhap dia chi server:" server
read -p "Thu muc ban duoc chia se:" folder
read -p "Thu muc ban muon mount:" mount
mount -t nfs $server:$folder $mount
echo "Luu y, khi khoi dong lai server phan vung mount se mat."
echo -n "Ban co muon them phan vung mount vao fstab (y/n)? "
read ans
if echo "$ans" | grep -iq "^y" ;then
	echo "$server:$folder	$mount	nfs 	defaults 0 0" >> /etc/fstab
	echo "Da ghi vao fstab."
else
    echo "Khong ghi vao fstab."
fi
}