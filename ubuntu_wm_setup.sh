#!/bin/bash

###########################################################
#                                                         #
#  Title: Ubuntu18.04 Setup Script                        #
#  Author: Nathan baek                                    #
#  Date: May 9th, 2023                                    #
#  Description: blockchain node                           #
#                                                         #
###########################################################

# Variable
es="http://elasticsearch:9200"
pkgtool="apt-get"
pkg="vim curl wget ntp ufw fail2ban logwatch filebeat openssl-server"
fw="ufw"

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
              alias vi="vim"
              alias name="#statement"

          # 필수 패키지 설치
              $pkgtool update
              $pkgtool upgrade -y
              $pkgtool install -y $pkg

          # Configure timezone
              timedatectl set-timezone Asia/Seoul
              #rdate -s 169.254.169.123

          # ntp start
              systemctl enable ntp
              systemctl start ntp

          # Profile string import
              echo 'export HISTTIMEFORMAT="%y-%m-%d %H:%M:%S"' | tee -a /etc/profile > /dev/null

          # Configure firewall
              $fw allow ssh # SSH
              $fw allow 80/tcp
              $fw allow 443/tcp
              $fw allow 3000/tcp
              $fw default deny incoming
              $fw default allow outgoing
              $fw default deny incoming
              $fw default allow outgoing
              $fw allow ssh
              $fw enable
              echo `$fw status`

          # fail2ban start
              systemctl enable fail2ban
              systemctl start fail2ban

          # input string for replace string in the file
              echo "Enter the string to search for:"
              read search_string
              echo "Enter the replacement string:"
              read replacement_string
              sed -i "s/$search_string/$replacement_string/g" filename.txt

          # filebeat Configure
              sed -i 's/#output.elasticsearch:/output.elasticsearch:/g' /etc/filebeat/filebeat.yml
              sed -i "s/#hosts: \[\"localhost:9200\"\]/hosts: \[\"$es\"\]/g" /etc/filebeat/filebeat.yml
              sed -i 's/#index: \"filebeat\"/index: \"system_logs\"/g' /etc/filebeat/filebeat.yml

          # filebeat - status!stop
              systemctl stop filebeat
              systemctl disable filebeat

          # Configure motd
              `echo "---------------------------------------------------------------"
              echo "               Prohibition of non-authorised use               "
              echo "---------------------------------------------------------------"
              echo "System Information:"
              echo "Hostname: $(hostname)"
              echo "Uptime: $(uptime | awk '{print $3,$4}' | sed 's/,//')"
              echo "Memory Usage: $(free | awk '/Mem/{printf("%.2f%"), $3/$2*100}')"
              echo "Disk Usage: $(df -h / | awk '/\//{print $(NF-1)}')"
              echo "---------------------------------------------------------------"` > /etc/motd
                else
                  echo "스크립트 실행이 중지되었습니다. 다시 실행해주세요"
                    exit 1
                  fi
fi
echo "스크립트 실행이 잘 완료되었습니다."
exit 0
