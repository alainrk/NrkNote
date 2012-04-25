#!/bin/bash

#	Copyright (C) Alain Di Chiappari

#	This program is free software; you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation; either version 2 of the License, or
#	(at your option) any later version.

#########################################################################
# Author 	: Alain Di Chiappari
# Date 		: 25/03/2012
# License	: GNU v2 General Public License
# Email		: alain.dichiappari@gmail.com
# Info License	: http://www.gnu.org/licenses/
#########################################################################

# Keep this file in NrkNote to install the program

MAINDIR="NrkNote"
YAD="yad_0.7.2-1_i386.deb"
YADTARGZ="yad-0.14.0"
CONKYONOFF="conkyOnOff"

testing1=`whereis conky | awk '{print $2}'`
if [[ -z $testing1 ]]; then 
	echo "Install conky..."
	sudo apt-get install conky
	if [[ $? -ne 0 ]]; then
		echo "You need to install conky"
		echo "See \"http://conky.sourceforge.net/\""
		exit 1
	fi
fi

testing2=`whereis yad | awk '{print $2}'`
if [[ -z $testing2 ]]; then 
	echo "Install yad..."
	sudo gdebi $YAD
	if [[ $? -ne 0 ]]; then
		echo "You need to install yad"
		echo "See \"http://code.google.com/p/yad/downloads/list\" or install by \"$YADTARGZ\" package or \"$YAD\" in this directory"
		exit 1
	fi
fi

echo "Checking for $HOME/$MAINDIR directory..." &&
if [[ -d "$HOME/$MAINDIR" ]]; then
	rm -rf "$HOME/$MAINDIR"
fi
echo -e "\nCopying folder in home directory..."
cp -rf ../$MAINDIR $HOME &&
echo "Check main directory ($HOME/$MAINDIR)" &&
cd $HOME/$MAINDIR &&
# Delete every backup file
rm -f *~ &&
echo "Configure blocknote file path..." &&
echo "#define FILENAME $HOME/$MAINDIR/blocknote" >> var.h &&
echo "$HOME/$MAINDIR" > path &&
# Utility
echo "Moving $CONKYONOFF in \"/usr/local/bin\"..." &&
sudo cp -f $CONKYONOFF /usr/local/bin &&
# Conkyrc
if [[ -f $HOME/.conkyrc ]]; then 
	echo "The .conkyrc file already exists, would you overwrite it? [y/n]"
	read res
	if [[ $res != "y" ]]; then
		echo "Configure your .conkyrc file with the right section (POST-IT). See the conkyrc file in this directory."
		echo "Exit..."
		exit 1
	fi
fi
echo "Copying .conkyrc file..." &&
(
cat << 'EOFEOFEOFEOF'
background yes
use_xft yes
xftfont 123:size=8
xftalpha 0.1
update_interval 7
total_run_times 0
own_window yes
own_window_type normal
own_window_transparent yes
own_window_hints undecorated,below,sticky,skip_taskbar,skip_pager
double_buffer yes
minimum_size 250 5
maximum_width 400
draw_shades no
draw_outline no
draw_borders no
draw_graph_borders no
default_color green
default_shade_color red
default_outline_color green
alignment top_right
gap_x 10
gap_y 10
no_buffers no
uppercase no
cpu_avg_samples 2
net_avg_samples 1
override_utf8_locale yes
use_spacer yes
text_buffer_size 256
TEXT

${font Arial:bold:size=8}${color white}SYSTEM ${color green} ${hr 2}
#$font${color green}$sysname $kernel $alignr $machine
${font}Intel Pentium D $alignr${freq_g cpu0}Ghz
${font}Uptime $alignr${uptime}
#File System $alignr${fs_type}
#
${font Arial:bold:size=8}${color white}PROCESSORS ${color green}${hr 2}
$font${color green}CPU1 ${cpu cpu1}% ${cpubar cpu1}
CPU2 ${cpu cpu2}% ${cpubar cpu2}
#
${font Arial:bold:size=8}${color white}MEMORY ${color green}${hr 2}
$font${color green}MEM $alignc $mem / $memmax $alignr $memperc%
$membar
#
${font Arial:bold:size=8}${color white}HDD ${color green}${hr 2}
$font${color green}/home $alignc ${fs_used /home} / ${fs_size /home} $alignr ${fs_free_perc /home}%
${fs_bar /home}
/disk $alignc ${fs_used /media/disk} / ${fs_size /media/disk} $alignr ${fs_free_perc /media/disk}%
${fs_bar /media/disk}
${if_mounted /media/DATA_}/DATA $alignc ${fs_used /media/DATA_} / ${fs_size /media/DATA_} $alignr ${fs_free_perc /media/DATA_}%
${fs_bar /media/DATA_}$endif
#
${font Arial:bold:size=8}${color white}TOP PROCESSES ${color green}${hr 2}
${font}${alignr}PID   CPU%  MEM%
$font${top name 1}${alignr} ${top pid 1} ${top cpu 1} ${top mem 1}
$font${top name 2}${alignr} ${top pid 2} ${top cpu 2} ${top mem 2}
$font${top name 3}${alignr} ${top pid 3} ${top cpu 3} ${top mem 3}
#
${font Arial:bold:size=8}${color white}NETWORK ${color green}${hr 2}
$font${color green}IP on wlan0 $alignr ${addr wlan0}
Uploaded: $alignr ${totalup wlan0}
Downloaded: $alignr ${totaldown wlan0}
${font}Up: ${upspeed wlan0}${alignr}${upspeedgraph wlan0 11,120 white white}
${font}Down: ${downspeed wlan0}${alignr}${downspeedgraph wlan0 11,120 white white}
#
${font Arial:bold:size=8}${color white}POST - IT ${color green}${hr 2}
EOFEOFEOFEOF
) > conkyrc &&
echo '$font${execi 32'" $HOME/$MAINDIR/nrkNote -r}" >> conkyrc &&
cp conkyrc $HOME/.conkyrc &&
echo "Exiting..."
exit 0

