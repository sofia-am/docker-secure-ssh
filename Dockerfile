# Base image
FROM ubuntu:latest

# Copy the restricted-ssh-config file to the appropriate location
COPY restricted-ssh-config /etc/restricted-ssh-commands/config

# Copy the authorized_keys file to the appropriate location
COPY authorized_keys /root/.ssh/authorized_keys

# Set the RSC_VERBOSE environment variable in authorized_keys
RUN sed -i 's/command="RSC_VERBOSE=1/command="RSC_VERBOSE=1 \/usr\/lib\/restricted-ssh-commands/g' /root/.ssh/authorized_keys

# Include manpages
RUN sed -i 's:^path-exclude=/usr/share/man:#path-exclude=/usr/share/man:' /etc/dpkg/dpkg.cfg.d/excludes

# Install desired packages
RUN apt-get update && \
    apt-get install -y \
        openssh-server \
        net-tools \
        coreutils \
        iputils-ping \
        lm-sensors \
        man \
        manpages-posix \
        wireless-tools 
        #&& \
        #apt search manpages | more

# Create an SSH user
RUN useradd -rm -d /home/iot_user -s /bin/rbash -g root -G sudo -u 1001 iot_user
RUN echo 'iot_user:iot2023' | chpasswd

# Configure SSH
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN service ssh start
RUN mkdir /home/iot_user/bin
RUN chmod 755 /home/iot_user/bin
RUN echo "PATH=$HOME/bin" >> /home/iot_user/.bashrc
RUN echo "export PATH" >> /home/iot_user/.bashrc
RUN ln -s /bin/ls /home/iot_user/bin/
RUN ln -s /bin/sensors /home/iot_user/bin/
RUN ln -s /bin/cat /home/iot_user/bin/
RUN ln -s /sbin/ifconfig /home/iot_user/bin/
RUN ln -s /bin/ping /home/iot_user/bin/
RUN ln -s /bin/uptime /home/iot_user/bin/
RUN ln -s /bin/iwconfig /home/iot_user/bin/
RUN ln -s /bin/clear /home/iot_user/bin/

RUN chmod 444 /home/iot_user/.bashrc

EXPOSE 22

# Run ssh, -D: Do not detach and become daemon
CMD ["/usr/sbin/sshd","-D"]
