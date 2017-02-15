#!/bin/bash

setup()
{
	yum install epel-release -y
	yum install openvpn easy-rsa zip -y
}
configure()
{
	mkdir -p /etc/openvpn/easy-rsa/keys
	cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
	cd /etc/openvpn/easy-rsa/
	cp openssl-1.0.0.cnf openssl.cnf
	create_var
	source ./vars
	./clean-all
	echo Generating keys for server, please wait...
	./build-ca
	./build-key-server server
	./build-dh
	cd /etc/openvpn/easy-rsa/keys/
	cp dh2048.pem ca.crt server.crt server.key /etc/openvpn/
}
create_var()
{
rm -rf /etc/openvpn/easy-rsa/vars
	read -p "Enter your country[VN]:" country
	read -p "Enter your province:" province
	read -p "Enter yur province:" province
	read -p "Enter yur province:" province
	read -p "Enter your city:" city
	read -p "Enter your organzination:" org
	read -p "Enter your email:" email
	read -p "Enter your Organzination Unit:" ou
	read -p "Enter your keyname:" keyname
cat > /etc/openvpn/easy-rsa/vars << HOANG
export EASY_RSA="`pwd`"
export OPENSSL="openssl"
export PKCS11TOOL="pkcs11-tool"
export GREP="grep"
export KEY_CONFIG=`$EASY_RSA/whichopensslcnf $EASY_RSA`
export KEY_DIR="$EASY_RSA/keys"
# Issue rm -rf warning
echo NOTE: If you run ./clean-all, I will be doing a rm -rf on $KEY_DIR
# PKCS11 fixes
export PKCS11_MODULE_PATH="dummy"
export PKCS11_PIN="dummy"
export KEY_SIZE=2048
export CA_EXPIRE=3650
export KEY_EXPIRE=3650
export KEY_COUNTRY="$country"
export KEY_PROVINCE="$province"
export KEY_CITY="$city"
export KEY_ORG="$org"
export KEY_EMAIL="$email"
export KEY_OU="$ou"
export KEY_NAME="$keyname"


HOANG
}
clientkey()
{

	cd /etc/openvpn/easy-rsa/
	source ./vars
	echo Generating key for client...
	read -p "Enter name client:" name
	read -p "Enter your server IP: " ip
	./build-key $name
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
echo Client key has been created in ~/client/ 
ls -l ~/client/
}
setup
configure
clientkey




###########
#Update
#!/bin/bash

# setup()
# {
	# yum install epel-release
	# yum install openvpn easy-rsa zip
# }
# configure()
# {
	# mkdir -p /etc/openvpn/easy-rsa/keys
	# cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
	# cd /etc/openvpn/easy-rsa/
	# cp openssl-1.0.0.cnf openssl.cnf
	#create_var
	# source ./vars_hoang
	# ./clean-all
	# echo Generating keys for server, please wait...
	# ./build-ca
	# ./build-key-server server
	# ./build-dh
	# cd /etc/openvpn/easy-rsa/keys/
	# cp dh2048.pem ca.crt server.crt server.key /etc/openvpn/
# }
# create_var()
# {
	# read -p "Enter your country[VN]:" country
	# sed -i 's/US/$country/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your province:" province
	# sed -i 's/CA/$province/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your city:" city
	# sed -i 's/SanFrancisco/$city/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your organzination:" org
	# sed -i 's/Fort-Funston/$org/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your email:" email
	# sed -i 's/me@myhost.mydomain/$email/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your Organzination Unit:" ou
	# sed -i 's/MyOrganizationalUnit/$ou/g' /etc/openvpn/easy-rsa/vars
	# read -p "Enter your keyname:" keyname
	# sed -i 's/EasyRSA"/$keyname/g' /etc/openvpn/easy-rsa/vars
# }
# clientkey()
# {

	# cd /etc/openvpn/easy-rsa/
	# create_var
	# source ./vars
	# echo Generating key for client...
	# read -p "Enter name client:" name
	# read -p "Enter your server IP: " ip
	# ./build-key $name
	# mkdir -p ~/client
	# #ip=$(ip a | grep "scope global" | awk '{print $2}'| tr "/" " " | awk '{print $1}')
	# # File client
	# cd /etc/openvpn/easy-rsa/keys
# cat > /etc/openvpn/easy-rsa/keys/$name.ovpn << HOANG
# client
# dev tun
# proto udp
# remote $ip 1194
# resolv-retry infinite
# nobind
# persist-key
# persist-tun
# ca ca.crt
# cert $name.crt
# key $name.key
# remote-cert-tls server
# comp-lzo
# verb 3
# HOANG

# zip ~/client/$name-client.zip ca.crt $name.key $name.crt $name.ovpn
# echo Client key has been created in ~/client/ 
# }

# clientkey