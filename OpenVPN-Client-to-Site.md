## Cấu hình Client-to-Site

### I. Cài đặt và cấu hình OpenVPN trên CentOS 6

#### 1. Cài đặt

Cài đặt `epel-release` để cập nhật thêm repo

```
yum install -y epel-release
```

http://prntscr.com/bj0bzm

Cài đặt OpenVPN và Easy-RSA

```
yum install -y openvpn easy-rsa
```

http://prntscr.com/bj0cqk

#### 2. Cấu hình OpenVPN

##### 1. Cấu hình server

Tạo thư mục chứa key

```
mkdir -p /etc/openvpn/easy-rsa/keys
```

Copy bộ tạo key về thư mục cài đặt

```
cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa/
```

Copy file cấu hình OpenSSL

```
cd /etc/openvpn/easy-rsa/
cp openssl-1.0.0.cnf openssl.cnf
```

Sửa thông tin cần thiết khi tạo key

```
vi /etc/openvpn/easy-rsa/vars
```

http://prntscr.com/bj0fno

Sau đó lưu lại và chạy lệnh:

```
cd /etc/openvpn/easy-rsa/
source ./vars
./clean-all
```

http://prntscr.com/bj0hcc

Tạo CA:

```
./build-ca
```
Sửa các thông tin nếu cần thiết. Mặc định, bấm Enter.

http://prntscr.com/bj0i7d

Tạo key cho Server

```
./build-key-server server
```

Khi tạo key cho server, hệ thống sẽ hỏi challange password, password này sẽ được sử dụng mỗi khi tạo key cấp cho client. Tuy nhiên chúng ta có thể bỏ trống trường này và optional company name.

http://prntscr.com/bj0jta

Tạo DH (Một dạng mã hóa)

```
./build-dh
```

http://prntscr.com/bj0lcv

Thời gian tạo key này khá lâu vì lúc trước ta chọn mã hóa 2048 bit.

Copy các file key vừa tạo vào thư mục cài đặt

```
cd /etc/openvpn/easy-rsa/keys/
cp dh2048.pem ca.crt server.crt server.key /etc/openvpn/
```

http://prntscr.com/bj0pou

Tạo file cấu hình cho server

```
vi /etc/openvpn/server.conf
```

```
port 1194
proto udp
dev tun
ca ca.crt
cert server.crt
key server.key 
dh dh2048.pem
server 10.8.0.0 255.255.255.0 # Dải IP cấp cho Client
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp" # Tất cả các traffic của client đều qua VPN
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
comp-lzo
user nobody
group nobody
persist-key
persist-tun
status openvpn-status.log
verb 3 # Mức độ cảnh báo ghi vào log
```