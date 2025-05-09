FROM ubuntu:latest

# Cập nhật và cài đặt các công cụ cần thiết
RUN apt-get update && apt-get install -y openssh-server sudo

# Tạo user và cấp quyền sudo
RUN useradd -ms /bin/bash ec2-user && echo "ec2-user:password" | chpasswd && adduser ec2-user sudo

# Cấu hình SSH
RUN mkdir /var/run/sshd
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

# Copy SSH key (tốt hơn dùng password)
COPY .ssh/id_rsa.pub /home/ec2-user/.ssh/authorized_keys
RUN chmod 600 /home/ec2-user/.ssh/authorized_keys && \
    chown ec2-user:ec2-user /home/ec2-user/.ssh/authorized_keys
# Mở cổng 22 để SSH
EXPOSE 22

# Khởi động SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
