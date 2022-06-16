# ubuntu 20 seems to be lacking the ability to 'snap to grid'
# install nemo for desktop, keeping nautilus as the default file explorer
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.nemo.desktop show-desktop-icons true
xdg-mime default org.gnome.Nautilus.desktop inode/directory
sudo apt install nemo dconf-editor
sudo apt-get remove gnome-shell-extension-desktop-icons
# dont start (nemo-desktop &) until you have removed previous icons and rebooted  
# create startup entry 
echo  "[Desktop Entry]
Type=Application
Exec=nemo-desktop &
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_US]=nemo-desktop
Name=nemo-desktop
Comment[en_US]=
Comment=" > ~/.config/autostart/nemo-desktop.desktop

# have to reboot to take effect 
sudo reboot
