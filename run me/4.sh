#!/usr/bin/env bash
set -e

# ==============================================================================
# 1. INSTALL ESSENTIAL PACKAGES, THEMES, ICONS & WALLPAPERS
# ==============================================================================
sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y \
  ubuntu-wallpapers \
  ubuntu-wallpapers-noble \
  fonts-ubuntu \
  yaru-theme-gtk \
  yaru-theme-icon \
  papirus-icon-theme \
  feh \
  gedit \
  thunar

# ==============================================================================
# 2. CONFIGURE GLOBAL THEME, ICONS & UBUNTU FONTS
# ==============================================================================
xfconf-query -c xsettings -p /Net/ThemeName -s "Yaru-dark" --create -t string
xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark" --create -t string
xfconf-query -c xsettings -p /Gtk/FontName -s "Ubuntu 11" --create -t string
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Ubuntu Mono 13" --create -t string

# Window Manager controls (Minimize, Maximize, Close on right side)
xfconf-query -c xfwm4 -p /general/theme -s "Yaru-dark" --create -t string
xfconf-query -c xfwm4 -p /general/button_layout -s "O|HMC" --create -t string
xfconf-query -c xfwm4 -p /general/title_font -s "Ubuntu Bold 11" --create -t string

# ==============================================================================
# 3. BUILD TOP BAR (PANEL 1) & FLOATING LEFT DOCK (PANEL 2)
# ==============================================================================
pkill -9 xfce4-panel 2>/dev/null || true
xfconf-query -c xfce4-panel -p / -r -R 2>/dev/null || true

# Register Panel 1 and Panel 2
xfconf-query -c xfce4-panel -p /panels -a -t int -s 1 -t int -s 2 --create
xfconf-query -c xfce4-panel -p /dark-mode -s true --create -t bool

# --- Panel 1: Top Bar ---
xfconf-query -c xfce4-panel -p /panels/panel-1/position -s "p=6;x=0;y=0" --create -t string
xfconf-query -c xfce4-panel -p /panels/panel-1/length -s 100 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -s true --create -t bool
xfconf-query -c xfce4-panel -p /panels/panel-1/size -s 28 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -a -t int -s 1 -t int -s 2 -t int -s 3 -t int -s 4 --create

# Top Bar Plugins: Spacer, Centered 12-Hour IST Clock, Spacer, System Actions
xfconf-query -c xfce4-panel -p /plugins/plugin-1 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-1/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-1/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-2 -s "clock" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-2/digital-layout -s 3 --create -t int
xfconf-query -c xfce4-panel -p /plugins/plugin-2/digital-time-format -s "%a, %d %b   %I:%M %p" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-2/digital-format -s "%a, %d %b   %I:%M %p" --create -t string

xfconf-query -c xfce4-panel -p /plugins/plugin-3 -s "separator" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-3/expand -s true --create -t bool
xfconf-query -c xfce4-panel -p /plugins/plugin-3/style -s 0 --create -t uint

xfconf-query -c xfce4-panel -p /plugins/plugin-4 -s "actions" --create -t string

# --- Panel 2: Floating Left Dock ---
xfconf-query -c xfce4-panel -p /panels/panel-2/mode -s 1 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/position -s "p=7;x=10;y=0" --create -t string
xfconf-query -c xfce4-panel -p /panels/panel-2/position-locked -s true --create -t bool
xfconf-query -c xfce4-panel -p /panels/panel-2/size -s 54 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/length -s 1 --create -t uint
xfconf-query -c xfce4-panel -p /panels/panel-2/plugin-ids -a -t int -s 5 -t int -s 6 -t int -s 7 -t int -s 8 -t int -s 9 --create

# Pinned Dock Launchers: Chrome, Files, Text Editor, Terminal, App Menu
xfconf-query -c xfce4-panel -p /plugins/plugin-5 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-5/items -a -t string -s "google-chrome.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-6 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-6/items -a -t string -s "thunar.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-7 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-7/items -a -t string -s "gedit.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-8 -s "launcher" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-8/items -a -t string -s "xfce4-terminal.desktop" --create

xfconf-query -c xfce4-panel -p /plugins/plugin-9 -s "applicationsmenu" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-9/button-icon -s "ubuntu-logo-icon" --create -t string
xfconf-query -c xfce4-panel -p /plugins/plugin-9/show-button-title -s false --create -t bool

# ==============================================================================
# 4. CUSTOM GTK CSS: ROUNDED DOCK & MODERN CONTEXT MENUS
# ==============================================================================
mkdir -p ~/.config/gtk-3.0
cat << 'GTKEOF' > ~/.config/gtk-3.0/gtk.css
/* Top Bar Styling */
#XfcePanelWindow-1 {
    background-color: #0c0c0c;
    border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

/* Floating Pill Left Dock */
#XfcePanelWindow-2 {
    background-color: rgba(18, 18, 18, 0.90);
    border-radius: 20px;
    border: 1px solid rgba(255, 255, 255, 0.12);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.65);
    padding: 6px 2px;
}

#XfcePanelWindow-2 button {
    border-radius: 12px;
    margin: 3px 2px;
    transition: all 0.15s ease-in-out;
}

#XfcePanelWindow-2 button:hover {
    background-color: rgba(255, 255, 255, 0.14);
}

/* Modern Right-Click Context Menu */
menu, .menu, .context-menu {
    background-color: #1e1e1e;
    color: #eeeeec;
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 10px;
    padding: 6px;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.55);
}

menu menuitem, .menu menuitem {
    border-radius: 6px;
    padding: 6px 12px;
    margin: 1px 0;
    transition: background-color 0.15s ease;
}

menu menuitem:hover, .menu menuitem:hover {
    background-color: #E95420;
    color: #ffffff;
}

menu separator, .menu separator {
    background-color: rgba(255, 255, 255, 0.08);
    margin: 4px 6px;
}
GTKEOF

# ==============================================================================
# 5. UBUNTU DARK TERMINAL PROFILE
# ==============================================================================
mkdir -p ~/.config/xfce4/terminal
cat << 'TERMEOF' > ~/.config/xfce4/terminal/terminalrc
[Configuration]
FontName=Ubuntu Mono 13
ColorPalette=#2e3436;#cc0000;#4e9a06;#c4a000;#3465a4;#75507b;#06989a;#d3d7cf;#555753;#ef2929;#8ae234;#fce94f;#729fcf;#ad7fa8;#34e2e2;#eeeeec
ColorForeground=#eeeeec
ColorBackground=#171421
ColorCursor=#eeeeec
TabActivityColor=#e95420
TERMEOF

# ==============================================================================
# 6. RENDER OFFICIAL MASCOT WALLPAPER & REFRESH DESKTOP
# ==============================================================================
WALLPAPER=$(find /usr/share/backgrounds -type f \( -name "*.png" -o -name "*.jpg" \) | grep -E "warty|Numbat|noble|wallpaper" | head -n 1)
[ -z "$WALLPAPER" ] && WALLPAPER=$(ls -S /usr/share/backgrounds/*.png /usr/share/backgrounds/*.jpg 2>/dev/null | head -n 1)

# Render to display buffer
feh --bg-fill "$WALLPAPER"

# Save persistent configuration across monitors
for prop in $(xfconf-query -c xfce4-desktop -l | grep -E "last-image|image-path"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s "$WALLPAPER" --create -t string
done
for prop in $(xfconf-query -c xfce4-desktop -l | grep "image-style"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s 5 --create -t int
done

# Restart daemons to apply everything live
xfwm4 --replace >/dev/null 2>&1 &
xfsettingsd --replace >/dev/null 2>&1 &
xfdesktop --reload >/dev/null 2>&1 &
nohup xfce4-panel >/dev/null 2>&1 &

echo "Modern Ubuntu UI setup successfully completed!"
