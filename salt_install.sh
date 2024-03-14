

#Устанвока для миньона

#!/bin/bash
mkdir /opt/salt && cd /opt/salt

wget https://repo.saltproject.io/salt/py3/debian/11/arm64/SALT-PROJECT-GPG-PUBKEY-2023.gpg

echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/11/arm64/latest bullseye main" | sudo tee /etc/apt/sources.list.d/salt.list

sudo apt-get install salt-minion -y

sudo ufw allow proto tcp from any to any port 4505,4506

echo 172.20.0.175 salt >> /etc/hosts

S1="#master_finger: ''"
S2="master_finger: 'fb:be:72:a1:dc:e0:d4:11:7a:aa:34:70:3e:c6:d2:d5:b9:c0:ce:e3:a9:b8:16:af:3d:25:6a:c0:71:19:44:97'"
sed -i "s/${S1}/${S2}/g" /etc/salt/minion 

/etc/init.d/salt-minion restart



#Устанвока для мастера
#!/bin/bash
mkdir /opt/salt && cd /opt/salt

wget https://repo.saltproject.io/salt/py3/debian/11/arm64/SALT-PROJECT-GPG-PUBKEY-2023.gpg

echo "deb [signed-by=/etc/apt/keyrings/salt-archive-keyring-2023.gpg arch=amd64] https://repo.saltproject.io/salt/py3/debian/11/arm64/latest bullseye main" | sudo tee /etc/apt/sources.list.d/salt.list

sudo apt -y install salt-api salt-cloud salt-master salt-ssh salt-syndic

sudo ufw allow proto tcp from any to any port 4505,4506


S1="##interface: 0.0.0.0"
S2="interface: 172.20.0.175"
sed -i "s/${S1}/${S2}/g" /etc/salt/minion 

/etc/init.d/salt-master restart

#Выведите на экран главный ключ, который необходим для подключения управляемых узлов и Скопируйте содержимое строки master.pub прямо из консоли
salt-key -F master 

mkdir -p /srv/{salt,pillar}

echo 'file_roots:
base:
- /srv/salt
- /srv/formulas

pillar_roots:
base:
- /srv/pillar
'>> etc/salt/master