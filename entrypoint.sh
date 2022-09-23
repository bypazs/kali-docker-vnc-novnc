#!/bin/bash

###################
#WARNING needs to be saved als LT end of line file
###################

# Set password for VNC

mkdir -p /root/.vnc/
echo $VNCPWD | vncpasswd -f > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

# Set password for VNC as user sosecure
su sosecure -c "mkdir -p /home/sosecure/.vnc/"
su sosecure -c "echo $VNCPWD | vncpasswd -f > /home/sosecure/.vnc/passwd"
su sosecure -c "chmod 600 /home/sosecure/.vnc/passwd"

# Start VNC server as user sosecure
su sosecure -c "vncserver :0 -rfbport $VNCPORT -geometry $VNCDISPLAY -depth $VNCDEPTH \
  > /dev/null 2>&1 &"

# Start noVNC server as user sosecure

su sosecure -c "/usr/share/novnc/utils/launch.sh --listen $NOVNCPORT --vnc localhost:$VNCPORT \
  > /dev/null 2>&1 &"

echo "#!/bin/sh

autocutsel -fork
xrdb "$HOME/.Xresources"
xsetroot -solid grey
#x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
#x-window-manager &
# Fix to make GNOME work
export XKL_XMODMAP_DISABLE=1
/etc/X11/Xsession" > /home/sosecure/.vnc/xstartup

chmod 777 /home/sosecure/.vnc/xstartup

echo "Launch your web browser and open http://localhost:9020/vnc.html"

# Start shell
/bin/zsh && su - sosecure
