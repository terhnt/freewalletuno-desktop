#!/bin/sh
# FreeWalletUno - Linux installer script
# Handles installing FreeWalletUno and integrating with window manager
###########################################################
basedir=/usr/share
echo "### Creating installation directories..."
mkdir -vp $basedir/FreeWalletUno
mkdir -vp $basedir/icons/FreeWalletUno
mkdir -vp $basedir/applications
echo "### Installing FreeWalletUno..."
cp -a * $basedir/FreeWalletUno/
cp FreeWalletUno.png $basedir/icons/FreeWalletUno/
echo "### Integrating FreeWalletUno with linux desktop..."
cp FreeWalletUno.desktop $basedir/applications
echo "### Setting file permissions..."
chmod 644 $basedir/icons/FreeWalletUno/FreeWalletUno.png
chmod 644 $basedir/applications/FreeWalletUno.desktop
chmod 755 $basedir/FreeWalletUno/*
echo "### Updating desktop database..."
/usr/bin/update-desktop-database
echo "### Installation Complete!"
