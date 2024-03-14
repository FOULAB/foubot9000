## xephyr
$ Xephyr -br -ac -noreset -screen 1280x1024 :1

## i3
$ DISPLAY=:1 i3

## weechat
$ DISPLAY=:1 urxvt -fn "xft:DejaVu Sans Mono:size=10" -b 8 -e weechat

## wego
$ DISPLAY=:1 urxvt -fn "xft:DejaVu Sans Mono:size=25" -b 8 -e hwatch -ctx -n 15 -- /code/fixstuff/wego/run.sh

## cmatrix
$ DISPLAY=:1 urxvt -fn "xft:DejaVu Sans Mono:size=10" -b 8 -e cmatrix

## xresources
$ xrdb -merge ~/.Xresources
