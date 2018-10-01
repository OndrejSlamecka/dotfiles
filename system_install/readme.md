Installing
----------

When installing the operating system
([guide](https://wiki.archlinux.org/index.php/installation_guide)) run
this script after `chroot`-ing and skip the rest of the steps in the guide
**except boot loader**, don't forget to install it!

    # How to run
    export username=ondra
    export hostname=ondra-
    pacman -S openssh
    curl -O https://raw.githubusercontent.com/OndrejSlamecka/dotfiles/master/system_install/install.sh
    sh install.sh

The script downloads and runs two files:

* `base.sh` sets basic information, manages users and groups and installs programs,
* `user.sh` installs and configures software which should be installed
  locally (e.g. trizen, mpd).


If the system is running in VirtualBox then

* On the host run this command to synchronize clock more often (default is 20 min which is too much). `VBoxManage guestproperty set <vm name> "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold" 1000`.
* `stack setup` may fail for not big enough `tmp`, then do `mount -o remount,size=2G,noatime /tmp`.


Updating
--------

For updating the installation use the commands below.

    pacman -Syu
    trizen -Syu --aur
    stack upgrade
    nvim +"call dein#update()"
    pacman -Rns $(pacman -Qtdq) # remove orphans

