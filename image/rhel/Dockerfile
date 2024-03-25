FROM ubuntu:22.04

# Assign timezome
ENV TZ=Asia/Istanbul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Reguired Packages
RUN apt-get update
RUN apt-get install -y curl vim python3 python3-pip git libffi-dev libssl-dev supervisor openssh-server sshpass libpam-google-authenticator
RUN apt-get install -y ansible python3-jmespath
RUN ansible-galaxy collection install community.sap hpe.ilo
RUN pip3 install pyvim pyvmomi python-ilorest-library paramiko certifi python-hpilo

# Set root password for SSH access (change 'your_password' to your desired password)
RUN echo 'root:Murphy12!' | chpasswd
RUN sed -i 's/^#PermitRootLogin.*/PermitRootLogin\ yes/' /etc/ssh/sshd_config
RUN sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication\ yes/' /etc/ssh/sshd_config

# Prepare Ansible Persistent Volume
RUN mkdir -p /root/ansible
VOLUME /root/ansible

# Prepare Ansible Script Environment
COPY rhel.tar.gz /root
RUN tar -zxvf /root/rhel.tar.gz -C /root/ansible --strip-components=1
RUN rm -f /root/rhel.tar.gz

# Get Host IP Address
COPY host-ip.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Start SSH Service
RUN service ssh start

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22
CMD ["/usr/bin/supervisord"]
