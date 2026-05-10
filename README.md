<h1 align=center>hyprland-shell</h1>

https://github.com/user-attachments/assets/0840f496-575c-4ca6-83a8-87bb01a85c5f

## Components

-   Widgets: [`Quickshell`](https://quickshell.outfoxxed.me)
-   Window manager: [`Hyprland`](https://hyprland.org)

## Installation

### Arch linux

Follow the [manual installation](#manual-installation) section below.

### Manual installation

Dependencies:

-   [`caelestia-cli`](https://github.com/caelestia-dots/cli)
-   [`quickshell-git`](https://quickshell.outfoxxed.me) - this has to be the git version, not the latest tagged version
-   [`ddcutil`](https://github.com/rockowitz/ddcutil)
-   [`brightnessctl`](https://github.com/Hummer12007/brightnessctl)
-   [`app2unit`](https://github.com/Vladimir-csp/app2unit)
-   [`libcava`](https://github.com/LukashonakV/cava)
-   [`networkmanager`](https://networkmanager.dev)
-   [`lm-sensors`](https://github.com/lm-sensors/lm-sensors)
-   [`fish`](https://github.com/fish-shell/fish-shell)
-   [`aubio`](https://github.com/aubio/aubio)
-   [`libpipewire`](https://pipewire.org)
-   `glibc`
-   `qt6-declarative`
-   `gcc-libs`
-   [`material-symbols`](https://fonts.google.com/icons)
-   [`caskaydia-cove-nerd`](https://www.nerdfonts.com/font-downloads)
-   [`swappy`](https://github.com/jtheoof/swappy)
-   [`libqalculate`](https://github.com/Qalculate/libqalculate)
-   [`bash`](https://www.gnu.org/software/bash)
-   `qt6-base`

Build dependencies:

-   [`cmake`](https://cmake.org)
-   [`ninja`](https://github.com/ninja-build/ninja)

**Arch Linux install commands:**

```sh
# Official repos
sudo pacman -S ddcutil brightnessctl networkmanager lm_sensors fish aubio \
               pipewire qt6-base qt6-declarative swappy libqalculate bash \
               cmake ninja gcc-libs \
               material-symbols-font ttf-cascadia-code-nerd

# AUR (requires yay or paru)
yay -S quickshell-git app2unit libcava caelestia-cli
```

To install the shell, clone this repo anywhere and build with `cmake`:

```sh
git clone https://github.com/<your-username>/hyprland-shell.git
cd hyprland-shell
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DVERSION=1.0.0
cmake --build build
sudo cmake --install build
```

This installs the shell config to `/etc/xdg/quickshell/hyprlandsh/` and libraries to `/usr/lib/hyprlandsh/`.

> [!TIP]
> You can customise the installation location via the `cmake` flags `INSTALL_LIBDIR`, `INSTALL_QMLDIR` and
> `INSTALL_QSCONFDIR` for the libraries (the beat detector), QML plugin and Quickshell config directories
> respectively. If changing the library directory, remember to set the `HYPRLANDSH_LIB_DIR` environment
> variable to the custom directory when launching the shell.
>
> e.g. installing to `~/.config/quickshell/hyprlandsh` for easy local changes:
>
> ```sh
> mkdir -p ~/.config/quickshell/hyprlandsh
> cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DVERSION=1.0.0 -DINSTALL_QSCONFDIR=~/.config/quickshell/hyprlandsh
> cmake --build build
> sudo cmake --install build
> sudo chown -R $USER ~/.config/quickshell/hyprlandsh
> ```

## Usage

The shell can be started via `qs -c hyprlandsh`. To autostart on login, add the following to your Hyprland config:

```conf
exec-once = qs -c hyprlandsh
```

### Shortcuts/IPC

All keybinds are accessible via Hyprland [global shortcuts](https://wiki.hyprland.org/Configuring/Binds/#dbus-global-shortcuts).

All IPC commands can be accessed via `caelestia shell ...`. For example

```sh
caelestia shell mpris getActive trackTitle
```

The list of IPC commands can be shown via `caelestia shell -s`:

```
$ caelestia shell -s
target drawers
  function toggle(drawer: string): void
  function list(): string
target notifs
  function clear(): void
target lock
  function lock(): void
  function unlock(): void
  function isLocked(): bool
target mpris
  function playPause(): void
  function getActive(prop: string): string
  function next(): void
  function stop(): void
  function play(): void
  function list(): string
  function pause(): void
  function previous(): void
target picker
  function openFreeze(): void
  function open(): void
target wallpaper
  function set(path: string): void
  function get(): string
  function list(): string
```

### PFP/Wallpapers

The profile picture for the dashboard is read from the file `~/.face`, so to set
it you can copy your image to there or set it via the dashboard.

The wallpapers for the wallpaper switcher are read from `~/Pictures/Wallpapers`
by default. To change it, change the wallpapers path in `~/.config/hyprlandsh/shell.json`.

To set the wallpaper, you can use the command `caelestia wallpaper`. Use `caelestia wallpaper -h` for more info about
the command.

## Updating

If installed manually, you can update by running `git pull` in `$XDG_CONFIG_HOME/quickshell/hyprlandsh`.

```sh
cd $XDG_CONFIG_HOME/quickshell/hyprlandsh
git pull
```

## Configuring

All configuration options should be put in `~/.config/hyprlandsh/shell.json`. This file is _not_ created by
default, you must create it manually. Options that you omit from the config file will use their default
values.

### Per-monitor configuration

You can configure options per-monitor in `~/.config/hyprlandsh/monitors/<screen-name>/shell.json`. Options
set in this file will **override** the respective options in the global config. Otherwise, the options will
use their values from the global config.

For example, to disable the bar on DP-1:

**`~/.config/hyprlandsh/monitors/DP-1/shell.json`**

```json
{
    "bar": {
        "persistent": false
    }
}
```

> [!NOTE]
> Not all options are respect per-monitor overrides. Most notably, the following options will only read
> from the global config, and ignore the respective option in per-monitor config files.
>
> <details><summary>Ignored options</summary>
>
> - `appearance` (`anim`, `transparency`)
> - `general` (`logo`, `apps`, `idle`, `battery`)
> - `bar.workspaces` (`perMonitorWorkspaces`, `specialWorkspaceIcons`, `windowIcons`)
> - `bar.tray` (`iconSubs`, `hiddenIcons`)
> - `dashboard` (`mediaUpdateInterval`, `resourceUpdateInterval`)
> - `launcher` (`specialPrefix`, `actionPrefix`, `enableDangerousActions`, `vimKeybinds`,
>   `favouriteApps`, `hiddenApps`, `actions`)
> - `launcher.useFuzzy` (`apps`, `actions`, `schemes`, `variants`, `wallpapers`)
> - `notifs` (`expire`, `fullscreen`, `defaultExpireTimeout`, `actionOnClick`)
> - `lock` (`enableFprint`, `maxFprintTries`)
> - `utilities` (`toasts`, `vpn`)
> - `services` (`weatherLocation`, `useFahrenheit`, `useFahrenheitPerformance`, `useTwelveHourClock`,
>   `gpuType`, `visualiserBars`, `audioIncrement`, `brightnessIncrement`, `maxVolume`, `smartScheme`,
>   `defaultPlayer`, `playerAliases`, `showLyrics`, `lyricsBackend`)
> - `paths` (`wallpaperDir`, `lyricsDir`)
>
> </details>

### Example configuration

> [!NOTE]
> The example configuration includes ALL configuration options in `shell.json`. You are
> **not** recommended to copy and paste this entire configuration into `shell.json`.
> This is meant to serve as a reference of all the available options, and you should
> only add the ones you want to change to `shell.json`.

<details><summary>Example</summary>

```json
{
    "enabled": true,
    "appearance": {
        "deformScale": 1,
        "anim": {
            "durations": {
                "scale": 1
            }
        },
        "font": {
            "family": {
                "clock": "Rubik",
                "material": "Material Symbols Rounded",
                "mono": "CaskaydiaCove NF",
                "sans": "Rubik"
            },
            "size": {
                "scale": 1
            }
        },
        "padding": {
            "scale": 1
        },
        "rounding": {
            "scale": 1
        },
        "spacing": {
            "scale": 1
        },
        "transparency": {
            "enabled": false,
            "base": 0.85,
            "layers": 0.4
        }
    },
    "general": {
        "logo": "hyprlandsh",
        "showOverFullscreen": false,
        "mediaGifSpeedAdjustment": 300,
        "sessionGifSpeed": 0.7,
        "apps": {
            "terminal": ["foot"],
            "audio": ["pavucontrol"],
            "playback": ["mpv"],
            "explorer": ["thunar"]
        },
        "battery": {
            "warnLevels": [
                {
                    "level": 20,
                    "title": "Low battery",
                    "message": "You might want to plug in a charger",
                    "icon": "battery_android_frame_2"
                },
                {
                    "level": 10,
                    "title": "Did you see the previous message?",
                    "message": "You should probably plug in a charger <b>now</b>",
                    "icon": "battery_android_frame_1"
                },
                {
                    "level": 5,
                    "title": "Critical battery level",
                    "message": "PLUG THE CHARGER RIGHT NOW!!",
                    "icon": "battery_android_alert",
                    "critical": true
                }
            ],
            "criticalLevel": 3
        },
        "idle": {
            "lockBeforeSleep": true,
            "inhibitWhenAudio": true,
            "timeouts": [
                {
                    "timeout": 180,
                    "idleAction": "lock"
                },
                {
                    "timeout": 300,
                    "idleAction": "dpms off",
                    "returnAction": "dpms on"
                },
                {
                    "timeout": 600,
                    "idleAction": ["systemctl", "suspend-then-hibernate"]
                }
            ]
        }
    },
    "background": {
        "desktopClock": {
            "enabled": false,
            "scale": 1.0,
            "position": "bottom-right",
            "shadow": {
                "enabled": true,
                "opacity": 0.7,
                "blur": 0.4
            },
            "background": {
                "enabled": false,
                "opacity": 0.7,
                "blur": true
            },
            "invertColors": false
        },
        "enabled": true,
        "visualiser": {
            "blur": false,
            "enabled": false,
            "autoHide": true,
            "rounding": 1,
            "spacing": 1
        }
    },
    "bar": {
        "activeWindow": {
            "compact": false,
            "inverted": false,
            "showOnHover": true
        },
        "clock": {
            "background": false,
            "showDate": false,
            "showIcon": true
        },
        "dragThreshold": 20,
        "entries": [
            {
                "id": "logo",
                "enabled": true
            },
            {
                "id": "workspaces",
                "enabled": true
            },
            {
                "id": "spacer",
                "enabled": true
            },
            {
                "id": "activeWindow",
                "enabled": true
            },
            {
                "id": "spacer",
                "enabled": true
            },
            {
                "id": "tray",
                "enabled": true
            },
            {
                "id": "clock",
                "enabled": true
            },
            {
                "id": "statusIcons",
                "enabled": true
            },
            {
                "id": "power",
                "enabled": true
            }
        ],
        "persistent": true,
        "popouts": {
            "activeWindow": true,
            "statusIcons": true,
            "tray": true
        },
        "scrollActions": {
            "brightness": true,
            "workspaces": true,
            "volume": true
        },
        "showOnHover": true,
        "status": {
            "showAudio": false,
            "showBattery": true,
            "showBluetooth": true,
            "showKbLayout": false,
            "showMicrophone": false,
            "showNetwork": true,
            "showWifi": true,
            "showLockStatus": true
        },
        "tray": {
            "background": false,
            "compact": false,
            "iconSubs": [],
            "recolour": false
        },
        "workspaces": {
            "activeIndicator": true,
            "activeLabel": "󰮯",
            "activeTrail": false,
            "label": "  ",
            "occupiedBg": false,
            "occupiedLabel": "󰮯",
            "perMonitorWorkspaces": true,
            "showWindows": true,
            "shown": 5,
            "specialWorkspaceIcons": [
                {
                    "name": "steam",
                    "icon": "sports_esports"
                }
            ],
            "windowIcons": [
                {
                    "regex": "steam(_app_(default|[0-9]+))?",
                    "icon": "sports_esports"
                }
            ]
        },
        "excludedScreens": [""],
        "activeWindow": {
            "inverted": false
        }
    },
    "border": {
        "rounding": 25,
        "smoothing": 32,
        "thickness": 10
    },
    "dashboard": {
        "enabled": true,
        "showOnHover": true,
        "showDashboard": true,
        "showMedia": true,
        "showPerformance": true,
        "showWeather": true,
        "dragThreshold": 50,
        "mediaUpdateInterval": 500
    },
    "launcher": {
        "actionPrefix": ">",
        "actions": [
            {
                "name": "Calculator",
                "icon": "calculate",
                "description": "Do simple math equations (powered by Qalc)",
                "command": ["autocomplete", "calc"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Scheme",
                "icon": "palette",
                "description": "Change the current colour scheme",
                "command": ["autocomplete", "scheme"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Wallpaper",
                "icon": "image",
                "description": "Change the current wallpaper",
                "command": ["autocomplete", "wallpaper"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Variant",
                "icon": "colors",
                "description": "Change the current scheme variant",
                "command": ["autocomplete", "variant"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Transparency",
                "icon": "opacity",
                "description": "Change shell transparency",
                "command": ["autocomplete", "transparency"],
                "enabled": false,
                "dangerous": false
            },
            {
                "name": "Random",
                "icon": "casino",
                "description": "Switch to a random wallpaper",
                "command": ["caelestia", "wallpaper", "-r"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Light",
                "icon": "light_mode",
                "description": "Change the scheme to light mode",
                "command": ["setMode", "light"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Dark",
                "icon": "dark_mode",
                "description": "Change the scheme to dark mode",
                "command": ["setMode", "dark"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Shutdown",
                "icon": "power_settings_new",
                "description": "Shutdown the system",
                "command": ["systemctl", "poweroff"],
                "enabled": true,
                "dangerous": true
            },
            {
                "name": "Reboot",
                "icon": "cached",
                "description": "Reboot the system",
                "command": ["systemctl", "reboot"],
                "enabled": true,
                "dangerous": true
            },
            {
                "name": "Logout",
                "icon": "exit_to_app",
                "description": "Log out of the current session",
                "command": ["loginctl", "terminate-user", ""],
                "enabled": true,
                "dangerous": true
            },
            {
                "name": "Lock",
                "icon": "lock",
                "description": "Lock the current session",
                "command": ["loginctl", "lock-session"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Sleep",
                "icon": "bedtime",
                "description": "Suspend then hibernate",
                "command": ["systemctl", "suspend-then-hibernate"],
                "enabled": true,
                "dangerous": false
            },
            {
                "name": "Settings",
                "icon": "settings",
                "description": "Configure the shell",
                "command": ["caelestia", "shell", "controlCenter", "open"],
                "enabled": true,
                "dangerous": false
            }
        ],
        "dragThreshold": 50,
        "vimKeybinds": false,
        "enableDangerousActions": false,
        "maxShown": 7,
        "maxWallpapers": 9,
        "specialPrefix": "@",
        "useFuzzy": {
            "apps": false,
            "actions": false,
            "schemes": false,
            "variants": false,
            "wallpapers": false
        },
        "showOnHover": false,
        "favouriteApps": [],
        "hiddenApps": []
    },
    "lock": {
        "recolourLogo": false,
        "hideNotifs": false
    },
    "notifs": {
        "actionOnClick": false,
        "clearThreshold": 0.3,
        "defaultExpireTimeout": 5000,
        "expandThreshold": 20,
        "openExpanded": false,
        "expire": false
    },
    "osd": {
        "enabled": true,
        "enableBrightness": true,
        "enableMicrophone": false,
        "hideDelay": 2000
    },
    "paths": {
        "mediaGif": "root:/assets/bongocat.gif",
        "sessionGif": "root:/assets/kurukuru.gif",
        "noNotifsPic": "root:/assets/dino.png",
        "lockNoNotifsPic": "root:/assets/dino.png",
        "wallpaperDir": "~/Pictures/Wallpapers",
        "lyricsDir": "~/Music/lyrics"
    },
    "services": {
        "audioIncrement": 0.1,
        "brightnessIncrement": 0.1,
        "maxVolume": 1.0,
        "defaultPlayer": "Spotify",
        "gpuType": "",
        "playerAliases": [{ "from": "com.github.th_ch.youtube_music", "to": "YT Music" }],
        "weatherLocation": "",
        "useFahrenheit": false,
        "useFahrenheitPerformance": false,
        "useTwelveHourClock": false,
        "smartScheme": true,
        "visualiserBars": 45
    },
    "session": {
        "dragThreshold": 30,
        "enabled": true,
        "vimKeybinds": false,
        "icons": {
            "logout": "logout",
            "shutdown": "power_settings_new",
            "hibernate": "downloading",
            "reboot": "cached"
        },
        "commands": {
            "logout": ["loginctl", "terminate-user", ""],
            "shutdown": ["systemctl", "poweroff"],
            "hibernate": ["systemctl", "hibernate"],
            "reboot": ["systemctl", "reboot"]
        }
    },
    "sidebar": {
        "dragThreshold": 80,
        "enabled": true
    },
    "utilities": {
        "enabled": true,
        "maxToasts": 4,
        "toasts": {
            "audioInputChanged": true,
            "audioOutputChanged": true,
            "capsLockChanged": true,
            "chargingChanged": true,
            "configLoaded": true,
            "dndChanged": true,
            "gameModeChanged": true,
            "kbLayoutChanged": true,
            "kbLimit": true,
            "numLockChanged": true,
            "vpnChanged": true,
            "nowPlaying": false
        },
        "vpn": {
            "enabled": true,
            "provider": [
                {
                    "name": "wireguard",
                    "interface": "your-connection-name",
                    "displayName": "Wireguard (Your VPN)",
                    "enabled": false
                }
            ]
        },
        "quickToggles": [
            {
                "id": "wifi",
                "enabled": true
            },
            {
                "id": "bluetooth",
                "enabled": true
            },
            {
                "id": "mic",
                "enabled": true
            },
            {
                "enabled": true,
                "id": "settings"
            },
            {
                "id": "gameMode",
                "enabled": true
            },
            {
                "id": "dnd",
                "enabled": true
            },
            {
                "id": "vpn",
                "enabled": true
            }
        ]
    }
}
```

</details>

### Advanced configuration

> [!WARNING]
> Do NOT change any of these options if you do not know what you are doing. These options control the
> tokens used internally within the shell, and can cause visual issues if changed. The existence of
> the options are also not guaranteed across versions, and may change or be removed without notice.

A separate `~/.config/hyprlandsh/shell-tokens.json` file allows editing the internal tokens without
touching the source code of the shell. These tokens affect, for example, individual rounding,
spacing, padding, font size, animation duration and easing curves tokens, and the sizes of certain
components. The appearance scale values in `shell.json` are multiplied against these base
token values to produce the final computed values.

Per-monitor token overrides are also available at
`~/.config/hyprlandsh/monitors/<screen-name>/shell-tokens.json`.

## FAQ

### Need help or support?

You can join the community Discord server for assistance and discussion:
https://discord.gg/BGDCFCmMBk

### My screen is flickering, help pls!

Try disabling VRR in the hyprland config. You can do this by adding the following to `~/.config/hyprlandsh/hypr-user.conf`:

```conf
misc {
    vrr = 0
}
```

### I want to make my own changes to the hyprland config!

You can add your custom hyprland configs to `~/.config/hyprlandsh/hypr-user.conf`.

### I want to make my own changes to other stuff!

See the [manual installation](#manual-installation) section and clone the repo instead of installing system-wide.

### I want to disable XXX feature!

Please read the [configuring](#configuring) section. If there is no corresponding option, make a feature request.

### How do I make my colour scheme change with my wallpaper?

Set a wallpaper via the launcher or `caelestia wallpaper` and set the scheme to the dynamic scheme via the launcher
or `caelestia scheme set`. e.g.

```sh
caelestia wallpaper -f <path/to/file>
caelestia scheme set -n dynamic
```

### My wallpapers aren't showing up in the launcher!

The launcher pulls wallpapers from `~/Pictures/Wallpapers` by default. You can change this in the config. Additionally,
the launcher only shows an odd number of wallpapers at one time. If you only have 2 wallpapers, consider getting more
(or just putting one).

## Credits

A special thanks to [@outfoxxed](https://github.com/outfoxxed) for making Quickshell and the effort put into fixing issues
and implementing various feature requests.

Thanks to [@end_4](https://github.com/end-4) for his [config](https://github.com/end-4/dots-hyprland)
which helped with learning how to use Quickshell.

Configs that inspired this project:

-   [caelestia-dots/shell](https://github.com/caelestia-dots/shell) — original upstream
-   [Axenide/Ax-Shell](https://github.com/Axenide/Ax-Shell)
