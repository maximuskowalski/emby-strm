#!/bin/bash
# Update Emby
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
ln -s /u01/GoogleDrive-VideoStream_extra/transcoders/emby_ffmpeg.pl ffmpeg
wget https://raw.githubusercontent.com/Thomvh/emby-strm/master/config/config.cfg

# Start Emby
echo "Starting Emby"
systemctl start emby-server

# Setup Scripts
echo "Install cronjobs"
crontab -l | { cat; echo "*/1 * * * * cd "/u01/GoogleDrive-VideoStream_extra/emby helpers/";perl monitor_videostream.pl -p 9988 -d /u01/Python-GoogleDrive-VideoStream/ -l videostream"; } | crontab -
crontab -l | { cat; echo "*/1 * * * * cd "/u01/GoogleDrive-VideoStream_extra/emby helpers/";perl monitor_emby.pl -p 8096 -i emby-server -l emby"; } | crontab -

exit 0