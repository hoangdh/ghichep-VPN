#!/bin/bash

setup()
{
	info
	yum install epel-release -y
	yum install openvpn easy-rsa zip -y
}
configure()
{
	list_card
	mkdir -p /etc/openvpn/easy-rsa/keys
	cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
	cd /etc/openvpn/easy-rsa/
	cp openssl-1.0.0.cnf openssl.cnf
	#create_var
	source ./vars
	./clean-all
	echo Generating keys for server, please wait...
	./build-ca
	./build-key-server server
	./build-dh
	cd /etc/openvpn/easy-rsa/keys/
	cp dh2048.pem ca.crt server.crt server.key /etc/openvpn/
	#create file server.conf
cat > /etc/openvpn/server.conf << HOANG
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key  # This file should be kept secret
dh dh2048.pem
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
comp-lzo
user nobody
group nobody
persist-key
persist-tun
status openvpn-status.log
verb 3
HOANG
sed -i '7s/0/1/g' /etc/sysctl.conf

}
fw_conf()
{
iptables -F
# OpenVPN
#iptables -A INPUT -i $nic -m state --state NEW -p udp --dport 1194 -j ACCEPT
iptables -I INPUT -p udp --dport 1194 -j ACCEPT

# Allow TUN interface connections to OpenVPN server
iptables -A INPUT -i tun+ -j ACCEPT
 
# Allow TUN interface connections to be forwarded through other interfaces
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -o $nic -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -i $nic -o tun+ -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
 
# NAT the VPN client traffic to the internet
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o $nic -j MASQUERADE
service iptables save
service iptables restart
service openvpn start
chkconfig openvpn on

}
info()
{
	if [ $flag -eq 1 ]
	then
		echo "NIC: $nic IP: $ip"
	else
		echo "Welcome!"
	fi
}
list_card()
{
	echo "The NIC(s) avaliable on system: "
	ip a | grep "scope global" | awk '{print $7 ": " $2}' 
	read -p "Enter name NIC's: " nic
	tmp=$(ip a | grep "$nic" | awk '{print $2}'| tr "/" " " | awk '{print $1}')
	for x in $tmp
		do
			ip=$x
		done
	flag=1
}
clientkey()
{
	list_card
	info
	cd /etc/openvpn/easy-rsa/
	source ./vars
	echo Generating key for client...
	read -p "Enter name client:" name
	./build-key $name << H2



	








y
y
H2
	mkdir -p ~/client
	#ip=$(ip a | grep "scope global" | awk '{print $2}'| tr "/" " " | awk '{print $1}')
	# File client
	cd /etc/openvpn/easy-rsa/keys
cat > /etc/openvpn/easy-rsa/keys/$name.ovpn << HOANG
client
dev tun
proto udp
remote $ip 1194
resolv-retry infinite
nobind
persist-key
persist-tun
ca ca.crt
cert $name.crt
key $name.key
remote-cert-tls server
comp-lzo
verb 3
HOANG

zip ~/client/$name-client.zip ca.crt $name.key $name.crt $name.ovpn
#rm -rf $name.key $name.crt $name.ovpn
echo Client key has been created in ~/client/ 
}

echo "1. Setup OpenVPN"
echo "2. Create key client"
echo "3. Exit"

read -p "Please choose (1-3): " INPUT_STRING
	case $INPUT_STRING in 1)
		clear
		setup
		configure
		fw_conf
		break;;
	2)
		clear
		check=`rpm -qa openvpn`
		if [ $check != "" ]
		then
			clientkey
		else
			echo "OpenVPN hasn't installed."
			setup
			configure
			fw_conf
		fi
		break;;
	3)
		clear
		echo "Goodbye, Thanks for used!"
		break;;
	esac




