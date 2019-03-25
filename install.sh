#!/bin/bash
apt install unzip

# Make Directories
echo "Making Directories"
mkdir /u01
mkdir /u01/strm
mkdir /u01/emby-transcode
mkdir /u01/emby-cache
mkdir /u01/emby-metadata
mkdir /u01/emby-bk
mkdir /u01/scripts

# Install Repo's
echo "Installing Repo's"
git clone https://github.com/ddurdle/Python-GoogleDrive-VideoStream.git /u01/Python-GoogleDrive-VideoStream
git clone https://github.com/ddurdle/GoogleDrive-VideoStream_extra.git /u01/GoogleDrive-VideoStream_extra
wget https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
tar -xvf ffmpeg-release-amd64-static.tar.xz

# Install Emby
echo "Installing latest Emby"
cd /tmp
wget https://github.com/MediaBrowser/Emby.Releases/releases/download/4.0.2.0/emby-server-deb_4.0.2.0_amd64.deb
dpkg -i emby-server-deb_4.0.2.0_amd64.deb
systemctl stop emby-server

# Setting up GDrive Transcodes
echo "Fixing transcoding"
cd /opt/emby-server/
wget https://github.com/Thomvh/emby-strm/raw/master/lib332.tar
tar -xvf lib332.tar
rm lib332.tar
wget https://github.com/Thomvh/emby-strm/raw/master/old_emby_lib.zip
unzip old_emby_lib.zip
rm old_emby_lib.zip
cd /opt/emby-server/bin/
mv ffmpeg ffmpeg.oem
mv ffprobe ffprobe.oem
ln -s /u01/GoogleDrive-VideoStream_extra/transcoders/emby_ffprobe.pl ffprobe
ln -s /u01/GoogleDrive-VideoStream_extra/transcoders/emby_ffmpge.pl ffmpeg