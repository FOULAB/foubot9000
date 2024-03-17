#!/bin/sh

# convennience so foubot9000 can find it's binaries easier
export PATH="$HOME/foubot/bin:$PATH"

# Sets theme and urxvt settings
xrdb -merge ~/.Xresources

# ...aaand that's a wrap!
exec runsvdir foubot/sv
