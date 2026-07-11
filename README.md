# dotfiles

---

# under construction

btrfs setup

```
# Format and create subvolumes
mkfs.btrfs -L arch /dev/nvme0n1p2
mount /dev/nvme0n1p2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@var_log
btrfs subvolume create /mnt/@swap
umount /mnt

# Mount everything
mount -o subvol=@,compress=zstd,noatime /dev/nvme0n1p2 /mnt
mkdir -p /mnt/{home,var/log,boot,swap}
mount -o subvol=@home,compress=zstd,noatime /dev/nvme0n1p2 /mnt/home
mount -o subvol=@var_log,compress=zstd,noatime /dev/nvme0n1p2 /mnt/var/log
mount -o subvol=@swap,compress=zstd,noatime /dev/nvme0n1p2 /mnt/swap
mount /dev/nvme0n1p1 /mnt/boot

# Create and activate the swap file (before pacstrap/chroot, while still in live ISO)
btrfs filesystem mkswapfile --size 16g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
```

pacstrap

```
pacstrap -K /mnt base linux linux-firmware linux-headers amd-ucode btrfs-progs nvidia-open nvidia-utils nvidia-prime networkmanager sof-firmware nano vim neovim base-devel nvidia-settings efibootmgr

```

loader.conf

```
default @saved
timeout 0
console-mode auto
editor no
```

arch.conf

```
title Arch Linux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rootflags=subvol=@ rw
```

packages
terminal productivity
`paru -S zsh zsh-autosuggestions zsh-syntax-highlighting git-delta eza bat ripgrep fzf fd`
