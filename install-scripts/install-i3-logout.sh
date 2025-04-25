#!/bin/bash

# Install dependencies
echo "Installing dependencies..."
sudo apt-get update
sudo apt-get install -y \
  python3 \
  python3-gi \
  gir1.2-wnck-3.0 \
  python3-psutil \
  python3-cairo \
  python3-distro
if [ $? -ne 0 ]; then
    echo "Error: Failed to install dependencies. Exiting."
    exit 1
fi

# Clone or update i3-logout repository
if [ -d "/home/brett/i3-logout/.git" ]; then
    echo "i3-logout repository already exists at /home/brett/i3-logout, updating..."
    cd /home/brett/i3-logout
    git pull
    if [ $? -ne 0 ]; then
        echo "Error: Failed to update i3-logout repository. Exiting."
        exit 1
    fi
else
    echo "Cloning i3-logout repository..."
    git clone git@github.com:Sugarcrisp-ui/i3-logout.git /home/brett/i3-logout
    if [ $? -ne 0 ]; then
        echo "Error: Failed to clone i3-logout repository. Exiting."
        exit 1
    fi
fi

# Extract the tarball
echo "Extracting i3-logout-files.tar.gz..."
cd /home/brett/i3-logout
tar -xzf i3-logout-files.tar.gz -C /home/brett/tmp
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract i3-logout-files.tar.gz. Exiting."
    exit 1
fi

# Install config
echo "Installing config..."
if [ -f "/home/brett/tmp/etc/i3-logout.conf" ]; then
    sudo install -Dm644 /home/brett/tmp/etc/i3-logout.conf /etc/i3-logout.conf
else
    echo "Warning: i3-logout.conf not found in extracted files. Skipping config installation."
fi

# Install binaries
echo "Installing binaries..."
if [ -f "/home/brett/tmp/usr/bin/i3-logout" ]; then
    sudo install -Dm755 /home/brett/tmp/usr/bin/i3-logout /usr/bin/i3-logout
else
    echo "Warning: i3-logout binary not found. Skipping."
fi

if [ -f "/home/brett/tmp/usr/bin/betterlockscreen" ]; then
    sudo install -Dm755 /home/brett/tmp/usr/bin/betterlockscreen /usr/bin/betterlockscreen
else
    echo "Warning: betterlockscreen binary not found. Skipping."
fi

# Install desktop file
echo "Installing desktop file..."
if [ -f "/home/brett/tmp/usr/share/applications/betterlockscreen.desktop" ]; then
    sudo install -Dm644 /home/brett/tmp/usr/share/applications/betterlockscreen.desktop /usr/share/applications/betterlockscreen.desktop
else
    echo "Warning: betterlockscreen.desktop not found. Skipping."
fi

# Install Python files
echo "Installing Python files..."
if [ -d "/home/brett/tmp/usr/share/i3-logout" ]; then
    sudo mkdir -p /usr/share/i3-logout
    sudo cp -r /home/brett/tmp/usr/share/i3-logout/*.py /usr/share/i3-logout/ 2>/dev/null || echo "Warning: No Python files found in /home/brett/tmp/usr/share/i3-logout."
else
    echo "Warning: i3-logout Python directory not found. Skipping."
fi

if [ -d "/home/brett/tmp/usr/share/betterlockscreen" ]; then
    sudo mkdir -p /usr/share/betterlockscreen
    sudo cp -r /home/brett/tmp/usr/share/betterlockscreen/*.py /usr/share/betterlockscreen/ 2>/dev/null || echo "Warning: No Python files found in /home/brett/tmp/usr/share/betterlockscreen."
else
    echo "Warning: betterlockscreen Python directory not found. Skipping."
fi

# Install images and wallpapers
echo "Installing images and wallpapers..."
if [ -d "/home/brett/tmp/usr/share/betterlockscreen/images" ]; then
    sudo mkdir -p /usr/share/betterlockscreen/images
    sudo cp -r /home/brett/tmp/usr/share/betterlockscreen/images/* /usr/share/betterlockscreen/images/ 2>/dev/null || echo "Warning: No images found."
else
    echo "Warning: betterlockscreen images directory not found. Skipping."
fi

if [ -d "/home/brett/tmp/usr/share/betterlockscreen/wallpapers" ]; then
    sudo mkdir -p /usr/share/betterlockscreen/wallpapers
    sudo cp -r /home/brett/tmp/usr/share/betterlockscreen/wallpapers/* /usr/share/betterlockscreen/wallpapers/ 2>/dev/null || echo "Warning: No wallpapers found."
else
    echo "Warning: betterlockscreen wallpapers directory not found. Skipping."
fi

# Install themes
echo "Installing themes..."
if [ -d "/home/brett/tmp/usr/share/i3-logout-themes" ]; then
    sudo mkdir -p /usr/share/i3-logout-themes
    sudo cp -r /home/brett/tmp/usr/share/i3-logout-themes/* /usr/share/i3-logout-themes/ 2>/dev/null || echo "Warning: No themes found."
else
    echo "Warning: i3-logout-themes directory not found. Skipping."
fi

# Install icon
echo "Installing icon..."
if [ -f "/home/brett/tmp/usr/share/icons/hicolor/scalable/apps/better-lock-screen.svg" ]; then
    sudo install -Dm644 /home/brett/tmp/usr/share/icons/hicolor/scalable/apps/better-lock-screen.svg /usr/share/icons/hicolor/scalable/apps/better-lock-screen.svg
else
    echo "Warning: better-lock-screen.svg not found. Skipping."
fi

# Install documentation
echo "Installing documentation..."
if [ -d "/home/brett/tmp/usr/share/doc/i3-logout" ]; then
    sudo mkdir -p /usr/share/doc/i3-logout
    sudo cp -r /home/brett/tmp/usr/share/doc/i3-logout/* /usr/share/doc/i3-logout/ 2>/dev/null || echo "Warning: No documentation found."
else
    echo "Warning: i3-logout documentation directory not found. Skipping."
fi

# Clean up
rm -rf /home/brett/tmp/etc /home/brett/tmp/usr

echo "i3-logout installation complete."
