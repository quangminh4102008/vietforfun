# GIAI ĐOẠN 1: BUILD ỨNG DỤNG
# Sử dụng một môi trường có sẵn Maven và Java (phiên bản 11) để build code
FROM maven:3.8-openjdk-11 AS build

# Tạo một thư mục làm việc tên là /app bên trong môi trường build
WORKDIR /app

# Sao chép file pom.xml vào trước để tận dụng cache của Docker
# Nếu file này không đổi, Docker sẽ không cần tải lại thư viện ở lần build sau
COPY pom.xml .
RUN mvn dependency:go-offline

# Sao chép toàn bộ mã nguồn của bạn vào môi trường build
COPY src ./src

# Chạy lệnh Maven để đóng gói dự án thành file .war
# Lệnh -DskipTests sẽ bỏ qua việc chạy kiểm thử để build nhanh hơn
RUN mvn clean package -DskipTests


# GIAI ĐOẠN 2: CHẠY ỨNG DỤNG
# Sử dụng một môi trường gọn nhẹ đã cài sẵn Tomcat 9 và Java 11
FROM tomcat:9-jdk11-corretto-al2

# Xóa sạch thư mục webapps mặc định của Tomcat để tránh chạy ứng dụng rác
RUN rm -rf /usr/local/tomcat/webapps/*

# Sao chép file .war đã được build ở Giai đoạn 1
# vào thư mục webapps của Tomcat.
# Đổi tên nó thành ROOT.war để ứng dụng chạy ngay tại địa chỉ gốc (ví dụ: my-app.com/)
# thay vì (my-app.com/ten-file-war/)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Cho môi trường bên ngoài biết rằng ứng dụng này chạy ở cổng 8080
EXPOSE 8080

# Lệnh sẽ được thực thi khi môi trường này khởi động (chính là lệnh khởi động Tomcat)
CMD ["catalina.sh", "run"]