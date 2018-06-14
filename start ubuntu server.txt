#Make DHCP reservation using mac address to get same ip all the time
ip a - will give mac address
sudo shutdown -r now
-------------------------------------------------
Setup SSH Access and disallow root to login remotely

sudo apt-get install openssh-server
vi  /etc/ssh/sshd_config
PermitRootLogin no

sudo systemctl restart ssh
systemctl status ssh

--------------------------------------------------
#Make prompt intersting using bashrcgenerator.com

vi ~/.bassrc

export PS1="\[$(tput bold)\]\[\033[38;5;2m\]\u@\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;0m\]:\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;4m\]\w\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;0m\]\\$\[$(tput sgr0)\]\[\033[38;5;15m\] \[$(tput sgr0)\]"

source ~/.bashrc

# may use tmux - virtaul terminal within terminal  (screen is older program to do the same)
# possibly store your tmux config on github

# wget URL - to download files
# scp and sftp to copy file from one machine to another

#socker stas - what ports are listening or connected
ss -ant  (a - all i.e. listening or connected, n - port , t - tcp socket)
------------------
Use a usb disk

#list all storage device on the system
sudo fdisk -l
ls /dev/sd* (see serail attached device - SATA/USB and partitions)

1. fdisk - create a partition
sudo fdisk /dev/sdb
m - info on fdisk
p - info about partion table
d - delete partition
g - label 'gpt' parttion table - allow more then 4 partition
n - create a new partition within partition table (specify first and last sector)
w - commit changes 

2. create a new ext4 file system 
sudo mkfs.ext4 /dev/sdb1

3. Mount - where to access 
sudo mkdir /mnt/storage
sudo mount /dev/sdb1 /mnt/storage
sudo chmod ugo+rw /mnt/storage   (we are only storing info and not running software on this drive so no need of execute permission)

4. Verify
touch /mnt/storage/test

---------------------------------
Make disk available even if system restarts

/etc/fstab --> look for disk and mount it
fs- storage device - /dev/sdb1 or UUID=
mount - where in fs it should exist
type - ext4
options - defaults
dump-0
pass-0

1. sudo blkid - give UUID
2. sudo umount /mnt/storage
3. sudo mount -a    (auto mount using fstab)
4. df -h


--------------------------------

Connect to Network Storage


1. To connect to storage device u need - username and password and IP address; make sure smb/cifs in turn on n/w storage device
2. mount n/w share is similar to mount a disk

3. sudo apt-get install cifs-utils
4. sudo mkdir /mnt/networkdisk
5. sudo mount -t cifs //ip_add/share_folder /mnt/networkdisk -o user=username,password=password
6. df -h
7. sudo /etc/fstab
//ip_add/share_folder /mnt/networkdisk cifs user=username,password=password   0 0

-----------------------------------------
Security 
-----------------------------------------
1.Remote access


2.Updates
#update software list
sudo apt-get update

#compare installed software with software list and install newer version
sudo apt-get upgrade

#auto install security update
sudo apt-get intall unattended-upgrades
sudo dpkg-reconfigure unattended-upgrades 
(ans yes to auto aownload, specify what packages - Debian-Security taged package from Debian distro)


3.Firewall - iptable / ufw

sudo ufw allow 22/tcp

#if enabling ufw - keep ports open for application
sudo ufw enable

sudo ufw staus
---------------------------------------------------

Local services
-----------------------------------------

1. SMB

#Keep shared files on storage disk
mkdir /mnt/storage/shared
chmod 777 /mnt/storage/shared

sudo apt-get install smba
sudo vi /etc/samba/smb.conf

[fileshare]
comment = Shared Files 
path = /mnt/storage/shared
read only = no
create mask = 0777
directoy mask = 0777

#test parameters
testparm

sudo systemctl restart smbd

# ensure user have access to fileshare
# samba uses different password to user login password to allow access to file share
# but a local user account need to exist for every user granted access to samba - but need to set up a sepearte pasword for each of them

#set up samba password
sudo smbpasswd -a local_user

#can create a user and create a password and smb password for it
sudo useradd user2
sudo passwd user2
sudo smbpasswd -a user2

sudo ufw allow 139/tcp
sudo ufw allow 445/tcp

connect to server = smb://ip/fileshare, in windows \\ip\fileshare

2. PLEX - Video streaming with apps for most devices, need to sign up for free account

Videos from the Blender Foundation


Big Buck Bunny  - https://peach.blender.org/download/


Sintel - https://durian.blender.org/download/


Elephants Dream - https://orange.blender.org/download/


Tears of Steel - https://mango.blender.org/download/

#create a location for all your media
wget http://ftp.nluug.nl/pub/graphics/blender/demo/movies/ToS/tears_of_steel_1080p.mov
ls -lh

mkdir /mnt/storage/media
mv @.m* /mnt/storage/media
ls /mnt/storage/media

# get plex - 
# add plex repo to list of repo where package manger will search and get key to use this repo   
# https://support.plex.tv/articles/235974187-enable-repository-updating-for-supported-linux-server-distributions/
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install plexmediaserver

sudo systemctl status plexmediaserver

sudo ufw allow 32400/tcp

ip:32400 -> Sign Up and login
Add library -> /mnt/storage/media,Can Add tag to media and can watch media bia browser or plex app
Setting -> Server -> Library -- can set frequency of update from disk to media lib on plex



3. NAMESERVICE
#alternative - host file on every machine
/etc/hosts   --- C:\windows\system32\frivers\etc\host
ip  name

#DNS


#DNSMASQ on sevrer- simplified DNS - use host file of this server and during DHCP tell client that DNS server in this server
sudo apt-get install dnsmasq
sudo vi /etc/hosts 
ip_add nameofserver  (note 1 host for 1 ip only)

#to route a request to many hosts (in a given domain)
sudo vi /etc/dnsmasq.conf
#address_directive:domain - here i am just giving 1 ip instead of domain
address=/double-click.net/192.168.0.2
sudo systemctl restart dnsmasq

sudo systemctl restart networking
sudo ufw allow 53/tcp

IN DCHP setings on router(which is acting as DHCP server) - set primary DNS to this serverip
Disable and enable network adapter

ping dnsservername
nslookup linkedin.com dnsservername


4. AD BLOCK
# https://debian-administration.org/article/535/Blocking_ad_servers_with_dnsmasq

5. SERVER SSTATUS via WEB

#it was available as PPA - personal package archive. Add software that is not avaialable from std repos
# Package manager get info from PPA repo on launchpad.net
# and add repo to software list
sudo apt-get install software-properties-common
sudo add-apt-repository ppa:cockpit-project/cockpit
sudo apt-get update

#install cockpit
sudo apt-get install cockpit

sudo systemctl enable cockpit
sudo ufw allow 9090/tcp


login with server credentials

6. DESKTOP ENV - connect remotely
Unity, Gnome, KDE, LXDE, Xfce

#Install xfce
sudo apt-get install xfce4 xfce4-goodies

#VNC application - can create graphical sessions (persitance sessions)
sudo apt-get install tightvncserver

vncserver - start vnc server
Password:  (max length 8 char) 
set View only password: no

#Inform server about desktop env 
sudo vi ~/.vnc/xstartup
startxfce4 & --> 3rd line

#specify resolution
sudo vi ~/.vncrc
$geometry = "1360X768"


vncserver -kill :1    - stop vnc server
vncserver   - start vnc server


sudo ufw allow 5901/tcp

Connect From client, connect to server - vnc://ip:5901

7. FILE BACKUP - OUTDATED INFO

# Other options Carbonite, Backblaze etc
# Crash plan 4.8.2 - allow free backups b/w computers on your network, backup to clould is paid service
# crash plan has visual interface
# I am connected to visual interface of my server

#extract tar file
tar -xf tar_file_name

./install.sh
where to store incoming backup data - /mnr/storage/backups

sudo ufw allow 4242/tcp

Access crashplan - desktop app

-----------------------------------------------------------------------

Accessing Resources Remotely
========================================================================

# Give server a name on internet 
# DynamicDNS - providers is NO-IP or DynDNS(7 day free trial)
# These companies provide Dynamic update client - software to monitor external IP and update DNS for subdomain, 
# we can instead install ddclient software package - that can be configured to talk to multiple DynamicDNS providers. Alternatively, some routers have built in function to update DynamicDNS providers

Sign up NO_IP choosing a subdomain (say aaa.ddns.net)
sudo apt-get install ddclient
Provider: other
Dynamic DNS Server: dynupdate.no-ip.com
Dynamic DNS update protocol : dyndns2
Username and password for DynamicDNS service
Network Interface used for dynamic DNS service: [leave blank]
FQDN: aaaa.ddns.net  

sudo vi /etc/ddclient.conf
use=web - ddclient will use webservice to resolve my external IP address

sudo vi /etc/default/ddclient
run_daemon="true"  - run on its own in background
run_ipup="fasle"

sudo systemctl restart ddclient
systemctl status ddclient


#Open Ports on Router - need router restart
Virtual server or port forwarding
22-> 22 on ip of server

--------------------------------------
# Remote SSH
Generate Key
Disbale PWD Auth

Public Key - put on all systems you want to access
Private Key - Keep secure and use to login

# generate key pair
ssh-keygen -t rsa

cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

#Move private key on desktop 
#on desktop, home directory run following command 
scp user@server:~/.ssh/id_rsa .



#On server
#Remove private key on server
# and disable password login, so only login using key
vi  /etc/ssh/sshd_config
PasswordAuthentication no

sudo systemctl restart ssh
systemctl status ssh

#On desktop 
ssh user@server -i keylocation

---------------------------------------
# Self - hosted File Syncing using nextcloud (PHP web app)
# Sync file between computer that have sync client installed
# use web interface to generate sharing links for files

# Can install using snap - packaging system, snap is distribution independent installer

sudo snap install nextcloud
sudo ufw allow 443/tcp
sudo nextcloud.enable-https self-signed



https://server
create admin user, login and  create normal users and logot
login as normal user

On desktop, next cloud client, connect to nextcloud server

To access it outside n/w, open port 80 or 443 on router and when configuring software use FQDN



























































































































































