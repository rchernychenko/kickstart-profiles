### THIS FILE WAS GENERATED BY PUPPET ###

# Command Section
install
url --url http://mirror.centos.org/centos/7/os/x86_64
lang en_US.UTF-8
keyboard us
cmdline
network --onboot yes --device eth0 --bootproto dhcp --hostname kickstarted.example.com
rootpw --plaintext changeme
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --enforcing
timezone --utc Etc/UTC
bootloader --location=mbr --driveorder=sda --append="crashkernel=auto rhgb quiet"
reboot

# Package Repositories
repo --name base --baseurl http://mirror.centos.org/centos/7/os/x86_64

# Partition Configuration
zerombr 
clearpart --all --drives=sda --initlabel
part /boot --fstype=ext4 --size=500
part pv.2 --grow --size=200
volgroup VolGroup00 --pesize=4096 pv.2
logvol /home --fstype=ext4 --name=lv_home --vgname=VolGroup00 --size=80000
logvol / --fstype=ext4 --name=lv_root --vgname=VolGroup00 --size=12000
logvol swap --name=lv_swap --vgname=VolGroup00 --size=4096

# Packages Section
%packages
@core
ntpdate
ntp
wget
screen
git
openssh-clients
open-vm-tools
man
mlocate
bind-utils
traceroute
mailx
-iwl5000-firmware
-ivtv-firmware
-xorg-x11-drv-ati-firmware
-iwl4965-firmware
-iwl3945-firmware
-iwl5150-firmware
-iwl6050-firmware
-iwl6000g2a-firmware
-iwl6000-firmware
-iwl100-firmware
-aic94xx-firmware
-iwl1000-firmware
-alsa-tools-firmware
-iwl3160-firmware
-iwl6000g2b-firmware
-iwl2030-firmware
-iwl2000-firmware
-linux-firmware
-alsa-firmware
-iwl7265-firmware
-iwl105-firmware
-iwl135-firmware
-iwl7260-firmware
%end

%post --log /root/ks-post.log
########## BEGIN: community_kickstarts/install_puppet.erb
rpm -ivh https://yum.puppetlabs.com/el/7/PC1/x86_64/puppetlabs-release-pc1-1.0.0-1.el7.noarch.rpm
yum -y install puppet
yum -y update

########## END: community_kickstarts/install_puppet.erb
########## BEGIN: profile/kickstart/clear_firewall.erb
# Flush the firewall rules out and disable firewalld
systemctl disable firewalld
systemctl stop firewalld
yum -y install iptables-services
systemctl start iptables
systemctl enable iptables
iptables -F
iptables -X
/usr/libexec/iptables/iptables.init save
systemctl restart iptables

########## END: profile/kickstart/clear_firewall.erb
%end