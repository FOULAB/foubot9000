# Foubot9000™

## Installation

These instructions assume there already is a dedicated user for the display, and that this user has graphical autologin
setup.

0. Install runit, i3, urxvt/rxvt-unicode, and weechat.
    Urxvt must have the 256color mode enabled, like the Debian package.

1. As the foubot9000 user, run `install.py`.

2. In `~/foubot/bin/`, provide a wego binary patched for [broken functionality](https://github.com/schachmat/wego/pull/175)
    along with a build of [hwatch](https://github.com/blacknon/hwatch).

3. Generate an [OpenWeatherMap](https://openweathermap.org) API key.

4. Run wego once to generate the config, then edit `~/.wegorc` to set the `awm-api-key`, and set `location` to
    ```ini
    location=45.479600071690385,-73.5896074357722
    ```

## Development

```shell
# Spawn a windowed X server at "display" :1, with the same screen size as foubot9000
Xephyr -br -ac -noreset -screen 1280x1024 :1

# Run i3 on :1
DISPLAY=:1 i3
```
