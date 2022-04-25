#!/bin/sh
# FreeWallet - Linux installer script
# Handles installing FreeWallet and integrating with window manager
###########################################################
basedir=/usr/share
echo "### Creating installation directories..."
mkdir -vp $basedir/FreeWalletUno
mkdir -vp $basedir/icons/FreeWalletUno
mkdir -vp $basedir/applications
echo "### Installing FreeWalletUno..."
cp -a * $basedir/FreeWalletUno/
cp FreeWallet.png $basedir/icons/FreeWalletUno/
echo "### Integrating FreeWalletUno with linux desktop..."
cp FreeWallet.desktop $basedir/applications
echo "### Setting file permissions..."
chmod 644 $basedir/icons/FreeWalletUno/FreeWallet.png
chmod 644 $basedir/applications/FreeWalletUno.desktop
chmod 755 $basedir/FreeWalletUno/*
echo "### Updating desktop database..."
/usr/bin/update-desktop-database
echo "### Installation Complete!"
