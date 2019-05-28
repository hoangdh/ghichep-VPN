# Ghi chép Tìm hiểu về VPN

## 1. VPN là gì?

**`VPN`** viết tắt của "**Virtual Private Network**", dùng để mở rộng một mạng, kết nối các máy tính của công ty hay tổ chức với nhau thông qua môi trường Internet.

## 2. Lợi ích và ưu điểm của VPN

- Tiết kiệm chi phí hơn so với thuê đường leased-line
- Đảm bảo an toàn thông tin với các phương pháp bảo mật
- Dễ dàng mở rộng mô hình, sẵn sàng kết nối với nhau thông qua Internet
- Hỗ trợ các giao thức mạng thông dụng nhất hiện nay như TCP/IP
- Giấu địa chỉ IP

## 3. Các công nghệ và giao thức VPN

### Đường hầm (Tunneling) và mã hóa

#### Tunneling

- Là một khái niệm quan trọng trong VPN, là đường kết nối ảo trên hệ thống mạng công cộng Internet
- Dữ liệu được truyền an toàn trên mạng và chỉ người gửi, người nhận có thể đọc được
- Đường hầm cung cấp một kết nối logic điểm đến điểm trên hệ thống mạng Internet hay trên các mạng công cộng khác khi không sử dụng, đường này được giải phóng

#### Mã hóa

- Là một phần không thể thiếu trong xây dựng và thiết kế mạng VPN vì sử dụng đường truyền công cộng Internet do vậy dữ liệu có thể bị bắt và xem thông tin.
- Nên sử dụng các thuật toán mã hóa phức tạp và chỉ có người gửi và người nhận có thể đọc được, tuy nhiên quy trình mã hóa mất khá nhiều thời gian và sẽ ảnh hưởng đến tốc độ truyền tải thông tin.
- Một kết nối VPN giữa hai điểm trên mạng công cộng là hình thức thiết lập một kết nối logic. Kết nối logic có thể được thiết lập trên Layer 2 hoặc Layer 3 của mô hình OSI và VPN được phân loại rộng rãi theo tiêu chuẩn này là Layer 2 VPNs và Layer 3 VPNs

### Công nghệ

#### Công nghệ Layer 2 VPNs

- Thực thi tại lớp 2 của mô hình tham chiếu OSI
- Các kết nối point-to-point được thiết lập gữa các site dựa trên một mạch ảo (virtual circuit), là một kết nối logic giữa 2 điểm trên 1 mạng và cũng có thể mở rộng thành nhiều điểm
- Một mạch ảo kết nối giữa 2 điểm đầu cuối (end-to-end) thường được gọi là mạch vĩnh cửu (Permanent Virtual Circuit - PVC)
- Mạng chuyển mạch (SVC - Switch Virtual Circuit) là một mạch ảo kết nối 2 điểm trên mạng (point-to-point), tuy nhiên SVC ít được sử dụng về sự phức tạp trong quá trình triển khai cũng như khắc phục lỗi. 
- ATM và Frame Relay là 2 công nghệ Layer 2 VPN phổ biến
- Hoạt động độc lập với các luồng dữ liệu của Layer 3
- Các mạng ATM và Frame Relay kết nối giữa các site có thể sử dụng các loại giao thức khác nhau như IP, IPX, AppleTalk,... Và có hỗ trợ QoS

#### Công nghệ Layer 3 VPNs

- Một kết nối giữa các site có thể được định nghĩa như là Layer 3 VPN, gồm các loại GRE, MPLS và IPSec.
- GRE và IPSec được sử dụng để thực hiện các kết nối point-to-point
- Công nghệ MPLS thực hiện các kết nối đa điểm (any-to-any)

##### GRE

- Generic Routing Encapsulation (GRE) được khởi xướng và phát triển bởi Cisco và sau đó được IETF xác nhận thành chuẩn RFC-1702.
- Dùng để khởi tạo các đường hầm và hỗ trợ nhiều giao thức khác nhau như IP, IPX,...
- GRE không có chức năng bảo mật cao cấp nhưng nó sử dụng cơ chế IPSec để bảo vệ gói tin
- Dữ liệu ở các site đầu GRE được đóng gói phần Header theo chuẩn của GRE
- Khi được kết nối, tất cả các site sẽ làm việc với nhau qua một tunnel
- Dữ liệu được bảo mật và chống lại các nguy cơ tấn công

##### MPLS

- Công nghệ này xây dựng các kết nối chuyển mạch nhãn (Label Switched Path) thông qua các router chuyển mạch nhãn (Label Switch Routte)
- Các gói tin được chuyển đi dựa vào nhãn - Lable ở gói tin
- MPLS sử dụng các giao thức TDP (Tag Distribution Protocol), LDP (Lable Distribution Protocol) hoặc RSVP (Reservation Protocol)

#### IPSec

- là một tập giao thức phát triển bởi IETF để thực thi dịch vụ bảo mật trên các mạng IP chuyển mạch gói
- Cho phép chứng thực, kiểm tra tính toàn vẹn dữ liệu, điều khiển truy cập và đảm bảo bí mật dữ liệu
- Thông tin được trao đổi giữa các site sẽ được mã hóa và kiểm tra, được triển khai trên cả hai loại VPN là Remote-access Client và site-to-site.

### Giao thức L2F

- Là giao thức Layer 2 được phát triển bởi Cisco.
- Được thiết kế cho phép tạo đường hầm giữa NAS và một thiết bị VPN Gateway để truyền các Frame
- Người sử dụng t ừ xa có thể kết nối đến NAS và truyền các Frame PPP từ Remote user đến VPN Gateway trong đường hầm được tạo

### Giao thức PPTP (Point-to-point Tunneling Protocol)

- Đây là giao thức được phát triển bởi Microsoft và cũng là giao thức phổ biến nhất
- Cung cấp một phần dịch vụ truy cập từ xa RAS (Remote Access Service)
- Như L2F, PPTP co phép tạo đường hầm từ phía người dùng (Mobile User) truy cập vào VNP Gateway/Concentator

### L2TP

- Là chuẩn giao thức do IETF đề xuất
- Nó được tích hợp hai điểm mạnh kết nối nhanh của PPTP và truy cập từ xa của L2F 
- Trong môi trường Remote Access L2TP cho phép khởi tạo đường hầm cho các frame và sử dụng giao thức PPP truyền dữ liệu trong đường hầm

### SSL

- Secure Socket Layer thực hiện bảo mật cho TCP session tại Layer 4 của mô hình OSI, và có thể dùng cho remote-access VPN (cũng như dùng để truy cập an toàn một web server thông qua HTTPS).

## 4. Các loại VPN

- **Remote-access VPN**: Một số người dùng ở xa có thể tạo một kết nối VPN từ PC của họ đến trụ sở công ty và làm việc bình thường như ở trong một mạng LAN. Sử dụng công nghệ IPSec hoặc SSL.

<img src="http://www.skullbox.net/vpns/pptp.gif" />


- **Site-to-site VPN**: Kết nối các chi nhánh của một công ty/tổ chức ở xa lại với nhau. Sử dụng công nghệ IPSec. 

<img src="http://www.skullbox.net/vpns/sitetosite.gif" />

- **Intranet-base**: Áp dụng cho công ty có nhiều chi nhánh ở xa muốn hợp nhất thành một mạng thống nhất.
- **Extranet-base**: Các công ty muốn làm việc chung với đối tác, hay đồng nghiệp; họ có thể xây dựng một mạng extranet để kết nối LAN với LAN cho phép chia sẻ công việc hay tài nguyên dữ liệu với nhau.
