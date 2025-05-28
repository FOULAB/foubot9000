## foubot9k
- [x] useradd -mUG gpio foubot9k
- [x] apt install lightdm xorg
- [x] apt install runit --no-install-recommends
- [x] apt install i3-wm weechat runit xdotool rxvt-unicode
- [x] apt install git
    needed to pull f9k's repo
- [x] *(as foubot9k, in sudo -i)* install f9k configs
    - `git clone https://github.com/FOULAB/foubot9000.git git-foubot9000`
    - *followed instructions in repo*
- [x] lightdm's config
    In section `[Seat:*]`, add line `autologin-user=foubot9k`
- [x] systemctl set-default graphical.target; systemctl default



## foubot2
- [x] useradd -rG gpio foubot2
- [x] copying the binary over
- [x] adding the service file `/etc/systemd/system/foubot2.service`
- [x] binary renamed `foubot2` (also in service file)
- [x] service renamed `foubot2`
- [x] enable service

## groovesalad
- [x] install `mplayer`
- [x] move unit file `/etc/systemd/system/mplayer-groovesalad.service`
- [x] enable service
