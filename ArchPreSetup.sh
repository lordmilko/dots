# to create the partitions programatically (rather than manually)
# we're going to simulate the manual input to fdisk
# The sed script strips off all the comments so that we can 
# document what we're doing in-line with the actual commands
# Note that a blank line (commented as "defualt" will send a empty
# line terminated with a newline to take the fdisk default.
sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | fdisk /dev/sda
  o # clear the in memory partition table
  n # new partition
  p # primary partition
  1 # partition number 1
    # default - start at beginning of disk 
  +512M # 512 MB boot parttion
  n # new partition
  p # primary partition
  2 # partion number 2
    # default, start immediately after preceding partition
  +27.5G # 27.5 GB data partition
  n  # new partition
  p # primary partition
  3 # partition number 3
    # default, start immediately after preceding partition
  +2G # 2 GB swap partition
  t # change partition type
  3 # partition number 3
  82 # swap partition
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

echo "Creating swap"
mkswap /dev/sda3
swapon /dev/sda3

echo "Formatting disks"
mkfs.ext4 /dev/sda1 -O \^64bit
mkfs.ext4 /dev/sda2 -O \^64bit

echo "Mounting disk"
mount /dev/sda2 /mnt

echo "Mounting boot"
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

echo "Installing arch"
pacstrap /mnt base

echo "Installing bootloader"
pacstrap /mnt syslinux
genfstab -p /mnt >> /mnt/etc/fstab

echo "Blacklisting drivers"
arch-chroot /mnt
echo "blacklist intel_rapl" >> /etc/modprobe.d/blacklist.conf

echo "Configuring bootloader"
mkinitcpio -p linux
syslinux-install_update -iam
sed -i "s/TIMEOUT 50/TIMEOUT 3/g" /boot/syslinux/syslinux.cfg
sed -i "s/APPEND root=\/dev\/sda3/APPEND root=\/dev\/sda2/g" /boot/syslinux/syslinux.cfg

echo "Please enter a password"
passwd

