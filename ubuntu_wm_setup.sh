#!/bin/bash

###########################################################
#                                                         #
#  Title: Ubuntu20 LTS Setup Script                       #
#  Author: Nathan baek                                    #
#  Date: May 11th, 2023                                   #
#  Description: blockchain node                           #
#                                                         #
###########################################################

# Variable
[ -n "$ES" ] || ES="http://elasticsearch:9200"
[ -n "$PKGTOOL" ] || PKGTOOL="apt-get"
[ -n "$PKG" ] || PKG="vim curl wget ntp ufw fail2ban logwatch filebeat openssl-server"
[ -n "$NOFILE" ] || NOFILE="/etc/limits.d/-nofile.conf"
[ -n "$KERNEL" ] || KERNEL="/etc/sysctl.conf"
[ -n "$MOTD" ] || MOTD="/etc/update-motd.d"
#[ -z "No such file or directory"] && touch $NOFILE

# Check root authority
if [ "$(id -u)" != "0" ]; then
  echo "이 스크립트는 반드시 root계정으로 실행하여야 합니다."
  echo "스크립트 실행을 취소합니다."
  exit 1
    else
      read -p "root 권한확인되었습니다. 계속진행하시겠습니까? (Y/N): " i
      if [[ "$i" =~ ^[Yy]$ ]]; then
        echo "스크립트를 실행합니다."
        # Set hostname
        echo "Enter hostname:"
        read hostname
        hostnamectl set-hostname $hostname
        echo "설정된 호스트명은 $hostname 입니다."
        # Command alias
        `alias vi="vim"`
        # 필수 패키지 설치
        $PKGTOOL update
              $PKGTOOL upgrade -y
              $PKGTOOL install -y $PKG
          # Configure timezone
              timedatectl set-timezone Asia/Seoul
              #rdate -s 169.254.169.123
          # ntp start
              systemctl enable ntp
              systemctl start ntp
          # string import
              echo 'export HISTTIMEFORMAT="%y-%m-%d %H:%M:%S"' | tee -a /etc/profile > /dev/null
              `source /etc/profile`
              touch $NOFILE
              echo "*   soft    nofile    65535" > $NOFILE
              echo "*   hard    nofile    65535" >> $NOFILE
          # kernel parameter
          echo "net.ipv4.ip_local_port_range = 1024 65535" >> $KERNEL
          echo "fs.file-max = 65535" >> $KERNEL
          echo "net.core.somaxconn = 8192" >> $KERNEL
          echo "net.core.netdev_max_backlog = 1800000" >> $KERNEL
          echo "net.core.rmem_default= 253952" >> $KERNEL
          echo "net.core.wmem_default= 253952" >> $KERNEL
          echo "net.core.rmem_max= 16777216" >> $KERNEL
          echo "net.core.wmem_max= 16777216" >> $KERNEL
          echo "vm.swappiness = 1" >> $KERNEL
          `sysctl -p`
          # Configure firewall
              #ufw allow 10022/tcp # SSH
              #ufw allow 80/tcp
              #ufw allow 443/tcp
              #ufw allow 3000/tcp
              #ufw default deny incoming
              #ufw default allow outgoing
              #ufw default deny incoming
              #ufw default allow outgoing
              #ufw allow ssh
              #ufw enable
              #echo `ufw status`
          # fail2ban start
              #systemctl enable fail2ban
              #systemctl start fail2ban
          # input string for replace string in the file
              #echo "Enter the string to search for:"
              #read search_string
              #echo "Enter the replacement string:"
              #read replacement_string
              #sed -i "s/$search_string/$replacement_string/g" filename.txt
          # filebeat Configure
              #sed -i 's/#output.elasticsearch:/output.elasticsearch:/g' /etc/filebeat/filebeat.yml
              #sed -i "s/#hosts: \[\"localhost:9200\"\]/hosts: \[\"$ES\"\]/g" /etc/filebeat/filebeat.yml
              #sed -i 's/#index: \"filebeat\"/index: \"system_logs\"/g' /etc/filebeat/filebeat.yml
          # filebeat - status!stop
              #systemctl stop filebeat
              #systemctl disable filebeat
          # Configure motd
            `chmod -x $MOTD/*`
            `cp -rp ./99-message $MOTD/99-message`
            `chmod +x $MOTD/99-message`
                else
                  echo "스크립트 실행이 중지되었습니다. 다시 실행해주세요"
                    exit 1
                  fi
fi
echo "스크립트 실행이 완료되었습니다."
exit 0
