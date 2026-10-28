cat << 'EOF' > setup_ubuntu_exact.sh
#!/usr/bin/env bash
set -e

echo "==> Configuring exact Ubuntu GNOME desktop layout and terminal..."

# ==============================================================================
# 1. INSTALL ESSENTIAL PACKAGES, THEMES, ICONS & WALLPAPERS
# ==============================================================================
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  yaru-theme-gtk \
  yaru-theme-icon \
  ubuntu-wallpapers \
  fonts-ubuntu \
  feh \
  gedit \
  thunar

# ==============================================================================
# 2. CONFIGURE GLOBAL THEME, ICONS & UBUNTU FONTS
# ==============================================================================
xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Yaru" --create -t string
xfconf-query -c xsettings -p /Gtk/FontName -s "Ubuntu 11" --create -t string
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Ubuntu Mono 13" --create -t string

# Window Manager: Dark header bar (Yaru-dark) matching authentic Ubuntu titlebars
xfconf-query -c xfwm4 -p /general/theme -s "Yaru-dark" --create -t string
xfconf-query -c xfwm4 -p /general/button_layout -s "O|HMC" --create -t string
xfconf-query -c xfwm4 -p /general/title_font -s "Ubuntu Bold 11" --create -t string

# ==============================================================================
# 3. BUILD TOP BAR (PANEL 1) & FULL-HEIGHT LEFT DOCK (PANEL 2)
# ==============================================================================
pkill -9 xfce4-panel 2>/dev/null || true
xfconf-query -c xfce4-panel -p / -r -R 2>/dev/null || true

# Register Panel 1 (Top Bar) and Panel 2 (Full-height Left Dock)
xfconf-query -c xfce4-panel -p /panels -a -t int -s 1 -t int -s 2 --create
xfconf-query -c xfce4-panel -p /dark-mode -s true --create -t bool

# --- Panel 1: Top Bar ---
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=6;x=0;y=0" --create -t string
xfconf-query -c xfce4-panel -p /panels/panel-1/length -s 100 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -s true --create -t bool
xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 28 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -a \
  -t int -s 1 -t int -s 2 -t int -s 3 -t int -s 4 -t int -s 5 --create

# Top Bar items: Activities, Spacer, Centered Clock, Spacer, System Status
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s "applicationsmenu" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-title -s "Activities" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-button-title -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-menu-icons -s true --create -t bool

xfconf-query -c xfce4-panel -p /plugins/plugin-2 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-2/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-2/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-3 -s "clock" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-3/digital-layout -s 3 --create -t int
xfconf-query -c xfce4-panel -p /plugins/plugin-3/digital-time-format -s "%d %b %H:%M" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-3/digital-format -s "%d %b %H:%M" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-4 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-4/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-4/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-5 -s "actions" --create -t string

# --- Panel 2: Full-Height Left Dock ---
xfconf-query -c xfce4-panel -p /panels/panel-2/mode -s 1 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/position -s "p=1;x=0;y=0" --create -t string
xfconf-query -c xfce4-panel -p /panels/panel-2/position-locked -s true --create -t bool
xfconf-query -c xfce4-panel -p /panels/panel-2/size -s 56 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/length -s 100 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/plugin-ids -a \
  -t int -s 6 -t int -s 7 -t int -s 8 -t int -s 9 -t int -s 10 -t int -s 11 -t int -s 12 --create

# Dock Apps: Chrome, Files, Text Editor, Terminal, Tasklist, Spacer, 9-Dot App Grid
xfconf-query -c xfce4-panel -p /plugins/plugin-6 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-6/items -a -t string -s "google-chrome.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-7 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-7/items -a -t string -s "thunar.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-8 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-8/items -a -t string -s "gedit.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-9 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-9/items -a -t string -s "xfce4-terminal.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-10 -s "tasklist" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-10/show-labels -s false --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-10/grouping -s true --create -t bool

xfconf-query -c xfce4-panel -p /plugins/plugin-11 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-11/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-11/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-12 -s "applicationsmenu" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-12/button-icon -s "view-app-grid-symbolic" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-12/show-button-title -s false --create -t bool

# ==============================================================================
# 4. CUSTOM GTK CSS FOR PANELS & MENUS
# ==============================================================================
mkdir -p ~/.config/gtk-3.0
cat << 'GTKEOF' > ~/.config/gtk-3.0/gtk.css
/* Top Bar */
#XfcePanelWindow-1 {
    background-color: #0c0c0c;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}
#XfcePanelWindow-1 button {
    color: #dfdfdf;
    font-weight: bold;
}

/* Full-Height Left Dock */
#XfcePanelWindow-2 {
    background-color: #111111;
    border-right: 1px solid rgba(255, 255, 255, 0.08);
    border-radius: 0px;
    padding: 4px 0px;
}
#XfcePanelWindow-2 button {
    border-radius: 8px;
    margin: 4px 6px;
    padding: 6px;
}
#XfcePanelWindow-2 button:hover {
    background-color: rgba(255, 255, 255, 0.12);
}

/* Modern Context Menus */
menu, .menu, .context-menu {
    background-color: #1e1e1e;
    color: #eeeeec;
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 8px;
    padding: 6px;
}
menu menuitem:hover, .menu menuitem:hover {
    background-color: #E95420;
    color: #ffffff;
}
GTKEOF

# ==============================================================================
# 5. LIVE TERMINAL XFCONF PROPERTIES & TERMINALRC
# ==============================================================================
# Configure terminal via live xfconf database
xfconf-query -c xfce4-terminal -p /font-name -s "Ubuntu Mono 13" --create -t string
xfconf-query -c xfce4-terminal -p /color-background -s "#300A24" --create -t string
xfconf-query -c xfce4-terminal -p /color-foreground -s "#FFFFFF" --create -t string
xfconf-query -c xfce4-terminal -p /color-cursor -s "#FFFFFF" --create -t string
xfconf-query -c xfce4-terminal -p /tab-activity-color -s "#E95420" --create -t string
xfconf-query -c xfce4-terminal -p /misc-menubar-default -s false --create -t bool
xfconf-query -c xfce4-terminal -p /misc-borders-default -s true --create -t bool
xfconf-query -c xfce4-terminal -p /scrolling-bar -s "TERMINAL_SCROLLING_BAR_OFF" --create -t string
xfconf-query -c xfce4-terminal -p /color-palette -s "#2e3436;#cc0000;#4e9a06;#c4a000;#3465a4;#75507b;#06989a;#d3d7cf;#555753;#ef2929;#8ae234;#fce94f;#729fcf;#ad7fa8;#34e2e2;#eeeeec" --create -t string

# Persistent file fallback
mkdir -p ~/.config/xfce4/terminal
cat << 'TERMEOF' > ~/.config/xfce4/terminal/terminalrc
[Configuration]
FontName=Ubuntu Mono 13
FontAllowBold=TRUE
FontUseSystem=FALSE
MiscAlwaysShowTabs=FALSE
MiscBell=FALSE
MiscBordersDefault=TRUE
MiscCursorBlinks=TRUE
MiscCursorShape=TERMINAL_CURSOR_SHAPE_IBEAM
MiscDefaultGeometry=90x26
MiscInheritGeometry=FALSE
MiscMenubarDefault=FALSE
MiscMouseAutohide=TRUE
MiscToolbarDefault=FALSE
MiscConfirmClose=FALSE
MiscCycleTabs=TRUE
MiscTabCloseButtons=TRUE
MiscTabCloseMiddleClick=TRUE
MiscMiddleClickOpensUri=TRUE
ScrollingBar=TERMINAL_SCROLLING_BAR_OFF
ScrollingLines=10000
ColorBackground=#300A24
ColorForeground=#FFFFFF
ColorCursor=#FFFFFF
ColorPalette=#2e3436;#cc0000;#4e9a06;#c4a000;#3465a4;#75507b;#06989a;#d3d7cf;#555753;#ef2929;#8ae234;#fce94f;#729fcf;#ad7fa8;#34e2e2;#eeeeec
TabActivityColor=#E95420
BackgroundMode=TERMINAL_BACKGROUND_TRANSPARENT
BackgroundDarkness=0.95
TERMEOF

# Set colored terminal prompt if not already present
if ! grep -q "Ubuntu Modern Colorful Prompt" ~/.bashrc; then
cat << 'PROMPTEOF' >> ~/.bashrc

# Ubuntu Modern Colorful Prompt
export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]\$\[\033[00m\] '
PROMPTEOF
fi

# ==============================================================================
# 6. AUTHENTIC FOCAL FOSSA MASCOT WALLPAPER & BACKDROPS
# ==============================================================================
sudo mkdir -p /usr/share/backgrounds /usr/share/xfce4/backdrops
sudo wget -q -O /usr/share/backgrounds/focal-mascot.png \
  "https://assets.ubuntu.com/v1/a24a138c-focal-fossa_1920x1080.png" 2>/dev/null || true

if [ ! -s /usr/share/backgrounds/focal-mascot.png ]; then
  LOCAL_BG=$(find /usr/share/backgrounds/ -type f \( -name "*.png" -o -name "*.jpg" \) | head -n 1)
  sudo cp -f "$LOCAL_BG" /usr/share/backgrounds/focal-mascot.png
fi

sudo cp -f /usr/share/backgrounds/focal-mascot.png /usr/share/xfce4/backdrops/xubuntu-wallpaper.png

TARGET_DISPLAY="${DISPLAY:-:20}"
DISPLAY="$TARGET_DISPLAY" feh --bg-fill /usr/share/backgrounds/focal-mascot.png 2>/dev/null || true

for prop in $(xfconf-query -c xfce4-desktop -l | grep -E "last-image|image-path"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s "/usr/share/backgrounds/focal-mascot.png" --create -t string
done
for prop in $(xfconf-query -c xfce4-desktop -l | grep "image-style"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s 5 --create -t int
done

# ==============================================================================
# 7. RESTART MANAGERS LIVE
# ==============================================================================
pkill -9 xfdesktop 2>/dev/null || true
nohup xfdesktop >/dev/null 2>&1 &
xfwm4 --replace >/dev/null 2>&1 &
xfsettingsd --replace >/dev/null 2>&1 &
nohup xfce4-panel >/dev/null 2>&1 &

echo "Modern Ubuntu UI & Terminal setup completed successfully!"
EOF

chmod +x setup_ubuntu_exact.sh
./setup_ubuntu_exact.sh
