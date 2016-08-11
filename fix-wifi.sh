#!/bin/bash

#this script will disable WIFI power management to imporove overall wireless performance.  

#make sure the power management is off
iwconfig wlan0 power off


echo "options 8192cu rtw_power_mgnt=0 rtw_enusbss=0 rtw_ips_mode=1" >> /etc/modprobe.d/8192cu.conf

#take a backup 
cp /etc/rc.local /etc/rc.local.original

#this should be better:
#only look for the last occurence of exit 0
#however this should work well on a newly configured RPI with jessie
sed -i 's/exit 0/#exit 0/g' /etc/rc.local

echo " " >>/etc/rc.local
echo "sleep 10" >>/etc/rc.local
echo "iwconfig wlan0 power off" >>/etc/rc.local
echo " " >>/etc/rc.local
echo "exit 0 " >>/etc/rc.local

echo "[Unit]
Description=Turn of wlan power management
After=suspend.target

[Service]
Type=simple
ExecStartPre=/bin/sleep 10
ExecStart=/sbin/iwconfig wlan0 power off

[Install]
WantedBy=suspend.target" >> /etc/systemd/system/root-resume.service

systemctl enable root-resume

iwconfig

echo "You should rebood your system now" 
