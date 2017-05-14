#!/bin/sh

# curl -O https://raw.githubusercontent.com/lordmilko/dots/master/ArchPreSetup1.sh
# chmod +x ArchPreSetup.sh

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
  +28160M # 27.5 GB data partition. Decimal point in GB doesn't work (maybe needs escaping?)
  n  # new partition
  p # primary partition
  3 # partition number 3
    # default, start immediately after preceding partition
    # 2 GB swap partition using remaining space. Explicitly specifying space doesn't work, due data partition being specified in MB
  t # change partition type
  3 # partition number 3
  82 # swap partition
  a # make a partition bootable
  1 # bootable partition is partition 1 -- /dev/sda1
  p # print the in-memory partition table
  w # write the partition table
  q # and we're done
EOF

echo "#################################################################"
echo "Creating swap"
mkswap /dev/sda3
swapon /dev/sda3

echo "#################################################################"
echo "Formatting disks"
mkfs.ext4 /dev/sda1 -O \^64bit
mkfs.ext4 /dev/sda2 -O \^64bit

echo "#################################################################"
echo "Mounting disk"
mount /dev/sda2 /mnt

echo "#################################################################"
echo "Mounting boot"
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

echo "#################################################################"
echo "Installing Base"
pacstrap /mnt base

echo "#################################################################"
echo "Installing Bootloader"
pacstrap /mnt syslinux
genfstab -p /mnt >> /mnt/etc/fstab

echo "Downloading Stage 2 Script"
curl -O https://raw.githubusercontent.com/lordmilko/dots/master/ArchPreSetup2.sh
curl -O https://raw.githubusercontent.com/lordmilko/dots/master/ArchPostSetup.sh

cp ./ArchPreSetup2.sh /mnt/root/ArchPreSetup2.sh
cp ./ArchPostSetup.sh /mnt/root/ArchPostSetup.sh
chmod +x /mnt/root/ArchPreSetup2.sh
chmod +x /mnt/root/ArchPostSetup.sh

echo "#################################################################"
echo "Entering new filesystem"
arch-chroot /mnt
