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
# Email		: alain.dichiappari [at] gmail [dot] com
# Info License	: http://www.gnu.org/licenses/
#########################################################################

# Grafic User Interface to nrkNote

NOTE=''
HOUR=''
MIN=''
DAY=''
MON=''
tmpD=''

Add() {

	tmpD=`yad --calendar --title "Choose a day"`

	tmpH=`yad --form --field="Hour":CB '0!1!2!3!4!5!6!7!8!9!10!11!12!13!14!15!16!17!18!19!20!21!22!23' --field="Minutes":CB '0!1!2!3!4!5!6!7!8!9!10!11!12!13!14!15!16!17!18!19!20!21!22!23!24!25!26!27!28!29!30!31!32!33!34!35!36!37!38!39!40!41!42!43!44!45!46!47!48!49!50!51!52!53!54!55!56!57!58!59'`

	while [[ -z $NOTE ]]; do
		NOTE=`yad --entry --title "Insert your note"`
	done

	DAY=`echo $tmpD | cut -d'/' -f1`
	MON=`echo $tmpD | cut -d'/' -f2`
	HOUR=`echo $tmpH | cut -d'|' -f1`
	MIN=`echo $tmpH | cut -d'|' -f2`

	if [[ -z $tmpD ]]; then 
		DAY=0
		MON=0
	fi
	if [[ -z $tmpH ]]; then 
		HOUR=0
		MIN=0
	fi

	$MAINDIR/nrkNote --write --month $MON --day $DAY --hour $HOUR --minutes $MIN --note "$NOTE"

	return 0
}

Mod(){
	yad --text-info --geometry=400x200-0-0 --name="notes" --window-icon="text-editor" --title=$"Notes" --button="gtk-save:0" --button="gtk-close:1" --editable --filename=$MAINDIR/blocknote > $MAINDIR/.tmpNote

	[[ $? -eq 0 ]] && mv $MAINDIR/.tmpNote $MAINDIR/blocknote
	rm -f $MAINDIR/.tmpNotes
	return 0
}

Cle(){
	$MAINDIR/nrkNote --clear
}

MAINDIR="$HOME/NrkNote"
action=`yad --width 300 --entry --image=$MAINDIR/icon.jpg --title "nrkNote" --button="gtk-ok:0" --button="gtk-close:1" --text "Choose action:" --entry-text "Add a note" "Modify/Remove notes" "Clear all notes"`

ret=$?
[[ $ret -eq 1 ]] && exit 0


case $action in
	Add*) Add ;;
  Mod*) Mod ;;
  Cle*) Cle ;;
	*) exit 1 ;;        
esac

exit 0
