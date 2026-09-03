from libqtile.config import Key, Click, Drag, Screen
from libqtile.lazy import lazy
from libqtile.bar import Bar
from libqtile import widget
from subprocess import Popen
from libqtile.hook import subscribe


@subscribe.startup_once
def startup():
    Popen(["picom"])


keys = [
    Key(["mod4"], "r", lazy.reload_config(), desc="Reload the config"),
]

mouse = [
    Drag(["mod4"], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag(["mod4"], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([], "Button2", lazy.window.bring_to_front()),
]

screens = [
    Screen(
        wallpaper="~/Arch-Install/Wallpaper.jpg",
        wallpaper_mode="fill",
        bottom=Bar(
            [
                widget.Spacer(),
                widget.LaunchBar(
                    progs=[
                        ("kitty", "kitty"),
                        ("chrome", "google-chrome-stable"),
                        ("vscode", "code"),
                        ("spotify", "spotify"),
                    ],
                    padding=10,
                    background="#000000"
                ),
                widget.Spacer(),
            ],
            70,
            background="#00000000",
        ),
    ),
]




"""
cpu
thermalsensor or thermalzone
load - cpu avg
memory
memorygraph
swapgraph
net - internet connection
netgraph
wlan or wlaniw
cpugraph
checkupdates
clock or verticalclock
cryptoticker?
DF (disk free)
HDDgraph
HDD (disk IO%)
HDDBusygraph
genpollcommand (run a command occasionally and display output)
genpolltext - python function
genpollurl - web data
gmailchecker or imapwidget or maildir
image - display image with click callback
launchbar - typical task manager app launcher
mpris2 - media player
notify - desktop notifications
nvidiasensors - gpu
openweather or wttr
prompt - enter commands
pulsevolume or volume
quickexit - exit qtile
sep or spacer - spacing widgets
statusnotifier or systray - system tray
tasklist - shows open apps
stockticker
wallpaper
widgetbox - hides widgets until clicked
"""