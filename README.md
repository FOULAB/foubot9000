# Foubot9000™

## Installation

These instructions assume there already is a dedicated user for the display, and that this user has graphical autologin
setup.

0. Install runit, i3, urxvt/rxvt-unicode, and weechat. If provided by the distro, additionally install
    [hwatch](https://github.com/blacknon/hwatch).  
    Urxvt must have the 256color mode enabled, like the Debian package.

1. Ensure the user running foubot9000 has the required permissions to access the GPIO. On RPi OS, it's the`gpio` group.

2. As the foubot9000 user, run `install.py`.

3. In `~/foubot/bin/`, provide a wego binary patched for
    [broken functionality](https://github.com/schachmat/wego/pull/175), along with a build of hwatch if not already
    installed via package manager.

4. Generate an [OpenWeatherMap](https://openweathermap.org) API key.

5. Run wego once to generate the config, then edit `~/.wegorc` to set the `awm-api-key`, and set `location` to
    ```ini
    location=45.479600071690385,-73.5896074357722
    ```

### Building from-source components

#### Patched wego

These steps are required for as long as [the fix for wego](https://github.com/schachmat/wego/pull/175) isn't merged and
hasn't reached the packaged version on the target OS.

1. Clone the wego repo, and checkout the PR - OR -  apply the PR as a patch

2. With go installed on the system, run
    ```shell
    CGO_ENABLED=0 GOOS=linux GOARCH=arm GOARM=6 go build -o wego
    ```
    For another architecture than the original RPi1,
    [adjust `GOARCH` and `GOARM` accordingly](https://go.dev/doc/install/source#environment)

3. Check that the binary is properly built `file wego`. Output should contain the right architecture,
    and ` statically linked`.

#### hwatch

***These steps are only required if the target OS does not provide a package for hwatch.***

0. Identify the right rust target triple. For the RPi1, it's `arm-unknown-linux-musleabi`.  
    It's important to pick the target triple for the musl libc, as that is essentially required to statically build a
    rust program.

1. Install a rust toolchain for the target triple. This can be done a number of ways, but rustup is recommended.
    Using rustup, `rustup target add arm-unknown-linux-musleabi` shoudl be enough to install the toolchain.

2. Install the correct C crossbuilding toolchain. It must be for the right architecture and for the musl libc.  
    This is often packaged by distros, for example on Void Linux the correct one for a RPi1 is provided by the
    `cross-arm-linux-musleabi` package.

3. Clone the hwatch repository or download&extract the source tarball.

4. Build hwatch with cargo:
    ```shell
    RUSTFLAGS='-C linker=/usr/bin/arm-linux-musleabi-ld' cargo build --locked --release --target arm-unknown-linux-musleabi
    ```
    Where `--target` is the triple from step 0, and `linker=` is the `ld` binary provided by the cross toolchain.

4. The output binary should be located at `target/<triple>/release/hwatch`, and `file` output should contain the right
    architecture and the words `statically linked`.

## Development

```shell
# Spawn a windowed X server at "display" :1, with the same screen size as foubot9000
Xephyr -br -ac -noreset -screen 1280x1024 :1

# Run i3 on :1
DISPLAY=:1 i3
```
