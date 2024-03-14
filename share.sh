#!/bin/bash

 
read -p "Введите логин пользотвеля: " login 
read -sp "Введите пароль: "  password && echo


echo "Логин: $login"  
echo "Пароль: ******"  

#создает папку в /mnt/ с названием нужных нам папок
mkdir /mnt/RegistrAIDS
mkdir /mnt/share_adm


#создает ярлык для того чтобы у каждого пользотвалея он появлялся
#нужно указывать название вместо share_adm нужные Вам папки
echo " 
[Desktop Entry]
Name=share_adm
Type=Link
NoDisplay=false
Hidden=false
URL=/mnt/share_adm
"> share_adm.desktop
mv share_adm.desktop /usr/share/applications/flydesktop/


#создает ярлык для того чтобы у каждого пользотвалея он появлялся
#нужно указывать название вместо share_adm нужные Вам папки
echo " 
[Desktop Entry]
Name=RegistrAids
Type=Link
NoDisplay=false
Hidden=false
URL=/mnt/RegistrAIDS
"> RegistrAIDS.desktop
mv RegistrAIDS.desktop /usr/share/applications/flydesktop/


#под этой учеткой будет подкучатсья к общей папке
echo " 
username=$login
password=$password
"> /root/.smbuser
 
#запрет на определнные действия вsmbuser
chmod 400 /root/.smbuser

#создает файл монитролвания
#нужно указывать название вместо //172.20.53.217/RegistrAIDS и /mnt/RegistrAIDS нужные Вам папки
echo "//172.20.53.217/RegistrAIDS /mnt/RegistrAIDS cifs credentials=/root/.smbuser,rw,nosharesock,vers=1.0,soft,noperm 0 0" >> /etc/fstab
echo "//172.20.53.217/share_adm /mnt/share_adm cifs credentials=/root/.smbuser,rw,nosharesock,vers=1.0,soft,noperm 0 0" >> /etc/fstab

echo -e "\e[1;32m++++++++++++++++++ Настройка conky завершена++++++++++++++++++++++++\e[0m"

#монтирование
mount -a

 