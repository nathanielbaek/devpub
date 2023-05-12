#!/bin/bash

###########################################################
#                                                         #
#  Title: Klaytn Setup Script                             #
#  Author: Nathan baek                                    #
#  Date: May 11th, 2023                                   #
#  Description: kscn v1.10.2-0 , homi v1.10.2-0           #
#                                                         #
###########################################################

# Variable
[ -n "$KSCNV11020" ] || KSCNV11020="https://packages.klaytn.net/klaytn/v1.10.2/kscn-v1.10.2-0-linux-amd64.tar.gz"
[ -n "$HOMIV11020" ] || HOMIV11020="https://packages.klaytn.net/klaytn/v1.10.2/homi-v1.10.2-0-linux-amd64.tar.gz"
[ -n "$KGENV1910" ] || KGENV1910="https://packages.klaytn.net/klaytn/v1.9.1/kgen-v1.9.1-0-linux-amd64.tar.gz"
#[ -n "$PKG" ] || PKG="vim wget ntp fail2ban filebeat"
#[ -n "$NOFILE" ] || NOFILE="/etc/security/limits.d/nofile.conf"
#[ -n "$KERNEL" ] || KERNEL="/etc/sysctl.conf"
#[ -n "$MOTD" ] || MOTD="/etc/update-motd.d"
#[ -n "$BASHRC" ] || BASHRC="~/.bashrc"
#[ -z "No such file or directory"] && touch $NOFILE

# 항목 리스트 정의
options=(
"kscn-v1.10.2-0"
"homi-v1.10.2-0"
"kgen-v1.9.1-0")

# installation per version case
  pattern )
    ;;
esac
PS3="Select an option: "
select opt in "${options[@]}"; do
    case $opt in
        "Option 1")
            echo "You selected Option 1"
            curl -O $KSCNV11020
            # Option 1에 대한 작업 실행
            break
            ;;
        "Option 2")
            echo "You selected Option 2"
            curl -O $HOMIV11020
            # Option 2에 대한 작업 실행
            break
            ;;
        "Option 3")
            echo "You selected Option 3"
            curl -O $KGENV1910
            # Option 3에 대한 작업 실행
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done



# Check root authority
if [ "$(id -u)" != "0" ]; then
  echo "이 스크립트는 반드시 root 권한으로 실행하여야 합니다."
  echo "스크립트 실행을 취소합니다."
  exit 1
    else
      read -p "root 권한 확인되었습니다. 계속 진행하시겠습니까? (Y/N): " i
      if [[ "$i" =~ ^[Yy]$ ]]; then
        echo "스크립트를 실행합니다."
        # Set hostname
        echo "Enter SCN hostname:"
        read hostname
        hostnamectl set-hostname $hostname
        echo "   설정된 SCN 호스트명은 $hostname 입니다.   "

          # string import
              echo "export HISTTIMEFORMAT="%Y-%m-%d [%H:%M:%S]  "" | tee -a /etc/profile > /dev/null
              source /etc/profile
              touch $NOFILE
              echo "*   soft    nofile    65535" > $NOFILE
              echo "*   hard    nofile    65535" >> $NOFILE
          # kernel parameter
            chmod -x $MOTD/*
            cp -rp ./99-message $MOTD/99-message
            chmod +x $MOTD/99-message
                else
                  echo "스크립트 실행이 중지되었습니다. 다시 실행해주세요"
                    exit 1
                  fi
fi
echo "스크립트 실행이 완료되었습니다."
exit 0
