# Foubot9000™

## Installation

These instructions assume there already is a dedicated user for the display, and that this user has graphical autologin
setup.

0. Install required packages programs
    - **runit**
    - **awesomeWM** (just the window manager, avoid the metapackages/extras)
    - **polybar** (avoid the metapackages/extras)
    - **urxvt/rxvt-unicode**, must have the 256color mode enabled, like the Debian package.
    - **fonts-symbola**, for emoji
    - **weechat**
    - **wego** version 2.3 or above, [build from source](#wego) if not avaialble from the distro.
    - **[hwatch](https://github.com/blacknon/hwatch)**, [build from source](#hwatch) if not available from the distro.

1. Ensure the user running foubot9000 has the required permissions to access the GPIO. On RPi OS, it's the`gpio` group.

2. As the foubot9000 user, run `install.py`.
> [!CAUTION]
> Executing this on your computer outside of a chroot ***will* override your configs** for awesome, polybar,
> WeeChat, and Xresources.
> It *will* also pollute your home directory.

3. If wego and/or hwatch have been built from source, place the binaries in `~/foubot/bin/`.

4. Generate an [OpenWeatherMap](https://openweathermap.org) API key.

5. Run wego once to generate the config, then edit `~/.wegorc` to set the `awm-api-key`, and set `location` to
    ```ini
    location=45.479600071690385,-73.5896074357722
    ```

### Building from-source components

#### wego

***These steps are only required if the target OS does not provide a package for wego version 2.3 or above.***

1. Download & extract the source tarball from the latest release of [wego](https://github.com/schachmat/wego).

2. With go installed on the system, run
    ```shell
    CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o wego
    ```
    For another architecture than a 64bit RPi,
    [adjust `GOARCH` and `GOARM` accordingly](https://go.dev/doc/install/source#environment).

3. Check that the binary is properly built `file wego`. Output should contain the right architecture,
    and ` statically linked`.

#### hwatch

***These steps are only required if the target OS does not provide a package for hwatch.***

0. Identify the right rust target triple. For a 64bit RPi, it's `aarch64-unknown-linux-musl`.  
    It's important to pick the target triple for the musl libc, as that is essentially required to statically build a
    rust program.

1. Install a rust toolchain for the target triple. This can be done a number of ways, but rustup is recommended.
    Using rustup, `rustup target add aarch64-unknown-linux-musl` shoudl be enough to install the toolchain.

2. Install the correct C crossbuilding toolchain. It must be for the right architecture and for the musl libc.  
    This is often packaged by distros, for example on Void Linux the correct one for a 64bit RPi is provided by the
    `cross-aarch64-linux-musl` package.

3. Clone the [hwatch repository](https://github.com/blacknon/hwatch) or download&extract the source tarball.

4. Build hwatch with cargo:
    ```shell
    RUSTFLAGS='-C linker=/usr/bin/aarch64-linux-musl-ld' cargo build --locked --release --target aarch64-unknown-linux-musl
    ```
    Where `--target` is the triple from step 0, and `linker=` is the `ld` binary provided by the cross toolchain.

4. The output binary should be located at `target/<triple>/release/hwatch`, and `file` output should contain the right
    architecture and the words `statically linked`.

## Development

```shell
# Spawn a windowed X server at "display" :1, with the same screen size as foubot9000
Xephyr -br -ac -noreset -screen 1280x1024 -dpi 96 :1

# Run awesome on :1
DISPLAY=:1 dbus-run-session awesome
```
