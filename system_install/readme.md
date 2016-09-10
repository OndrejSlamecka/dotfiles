Script to setup the user part of my Arch Linux installation. When
installing
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
  locally (e.g. pacaur, mpd).
