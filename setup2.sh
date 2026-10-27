# 1. Detect the active X11 display automatically
TARGET_DISPLAY="${DISPLAY:-:20}"

# 2. Pick the official Ubuntu mascot wallpaper
WALLPAPER=$(find /usr/share/backgrounds -type f \( -name "*.png" -o -name "*.jpg" \) | grep -E "warty|Numbat|noble" | head -n 1)
[ -z "$WALLPAPER" ] && WALLPAPER=$(ls -S /usr/share/backgrounds/*.png /usr/share/backgrounds/*.jpg 2>/dev/null | head -n 1)

echo "Setting wallpaper on display $TARGET_DISPLAY: $WALLPAPER"

# 3. Draw wallpaper directly to the display root window
DISPLAY="$TARGET_DISPLAY" feh --bg-fill "$WALLPAPER"

# 4. Save into XFCE desktop properties so it stays persistent
for prop in $(xfconf-query -c xfce4-desktop -l | grep -E "last-image|image-path"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s "$WALLPAPER" --create -t string
done

for prop in $(xfconf-query -c xfce4-desktop -l | grep "image-style"); do
  xfconf-query -c xfce4-desktop -p "$prop" -s 5 --create -t int
done

# 5. Reload desktop daemon
xfdesktop --reload
