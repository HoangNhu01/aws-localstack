# LocalStack Terraform Project

Dự án này sử dụng [LocalStack](https://localstack.cloud/) để giả lập các dịch vụ AWS và [Terraform](https://www.terraform.io/) để quản lý cơ sở hạ tầng dưới dạng mã (IaC).

## Cấu trúc dự án

- **`.localstack/`**: Thư mục chứa dữ liệu và tạm thời của LocalStack.
- **`ec2/`**: Thư mục chứa các tệp SSH và Dockerfile giả lập EC2.
- **`terraform/`**: Thư mục chứa mã Terraform để triển khai cơ sở hạ tầng.
- **`volume/`**: Thư mục chứa dữ liệu được ánh xạ từ container LocalStack.

## Yêu cầu hệ thống

- [Docker](https://www.docker.com/) và [Docker Compose](https://docs.docker.com/compose/) đã được cài đặt.
- [Terraform](https://www.terraform.io/downloads.html) đã được cài đặt.
- Quyền truy cập vào terminal.

![AWS Network](https://miro.medium.com/v2/resize:fit:720/format:webp/0*kA5ZBZAUAZ37dJtW)
## Hướng dẫn chạy

### 1. Khởi động LocalStack

1. Mở terminal và di chuyển đến thư mục gốc của dự án.

2. Chạy lệnh sau để khởi động LocalStack:

   ```powershell
   docker-compose up -d
   ```

3. Kiểm tra container LocalStack đã chạy thành công:
   ```powershell
    docker ps   
   ```
- Truy cập giao diện [LocalStack] qua URL: http://localhost:4566.

4. Di chuyển đến thư mục terraform:

   ```powershell
   cd terraform
   ```

5. Chạy lệnh sau để khởi tạo Terraform:

   ```powershell
   terraform init
   ```

6. Chạy lệnh để kiểm tra kế hoạch triển khai:

   ```powershell
   terraform plan
   ```

6. Chạy lệnh để triển khai cơ sở hạ tầng:

   ```powershell
   terraform apply -auto-approve
   ```

## Tài liệu tham khảo

- [LocalStack Documentation](https://docs.localstack.cloud/)
- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [AWS CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)



