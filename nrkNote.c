/************************************************************************

	Copyright (C) Alain Di Chiappari

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation; either version 2 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	You should have received a copy of the GNU General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

************************************************************************/

/**********************************************************************
* Author 	: Alain Di Chiappari
* Date 		: 25/03/2012
* License	: GNU v2 General Public License
* Email		: alain.dichiappari@gmail.com
* Info License	: http://www.gnu.org/licenses/
**********************************************************************/

/* A simple blocknote designed to interact with conky */
 
#include "var.h"
#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <string.h>


void usage () {
	printf("\nCopyright (C) Alain Di Chiappari\nalain.dichiappari@gmail.com\n\
Usage:\n\
\t-h, --help\t\tDisplay this help and exit.\n\
\t-c, --clear\t\tClear the blocknote, delete all notes.\n\
\t-r, --read\t\tDisplay all notes.\n\
\t-w, --write\t\tWrite a note. To add a note use this options\n\
\t\t\t\t(only \"note\" option to avoid to insert the date):\n\
\t\t--day [1-31]\n\
\t\t--month [1-12]\n\
\t\t--hour [0-23]\n\
\t\t--minutes [0-59]\n\
\t\t--note [string]\n\n");
}


int readnotes () {
	FILE *fp;
	char buffer[4096];
	int i;
	if (!(fp=fopen(FILENAME,"r"))) {
		printf ("Error on open notefile (readnotes)\n");
		return -1;
	}
		
	i=0;

	/* Una riga per volta */
	while (fgets(buffer,sizeof(buffer), fp) != NULL){
		printf("%s",buffer);
	}

	fclose (fp);
	}

int writenote (short int onlynote, int hour, int minutes, int day, int month, char *note){
	FILE *fp;

	/* Un po' di controlli */
	if ( !onlynote && ((hour<0)||(hour>23)||(minutes<0)||(minutes>59)||(day<1)||(day>31)||(month<1)||(month>12)||(strlen(note)>4000))){
		printf ("Format not valid\n");
		return -1;
	}

	/* Composizione della nota */
	char buffer[4096];
	if (onlynote)
		sprintf (buffer, "- %s",note);
	else
		sprintf (buffer, "%d/%d %d:%d - %s",day,month,hour,minutes,note);

	/* Scrivo sul file */
	if (!(fp=fopen(FILENAME,"a"))) {
		printf ("Error on open notefile (writenote)\n");
		return -2;
	}
	fprintf (fp, "%s\n",buffer);
	return 0;
}


int clearallnotes () {
	FILE *fp;
	/* Pulisco file - truncate to 0 */
	if (!(fp=fopen(FILENAME,"w"))) {
		printf ("Error on open notefile (clearallnotes)\n");
		return -2;
	}
	printf ("Blocknote cleared!\n");
	return 0;
}


int main (int argc, char *argv[]) {

short int c;
short int readopt=0;
short int writeopt=0;
short int clearallopt=0;
short int onlynote=0;
int option_index = 0; /* getopt_long ci mette l'indice delle opzioni */
char arguments[4096];
/* For write */
int hour=0;
int minutes=0;
int day=0;
int month=0;
char note[4096];

while (1) {

static struct option long_options[] =
             {
               {"write", no_argument, 0, 'w'},
               {"day", required_argument, 0, 0},
               {"month", required_argument, 0, 0},
               {"hour", required_argument, 0, 0},
               {"minutes", required_argument, 0, 0},
               {"note", required_argument, 0, 0},
							 {"read", no_argument, 0, 'r'},
							 {"clear", no_argument, 0, 'c'},
               {"help", no_argument, 0, 'h'},
               {0, 0, 0, 0}
             };

	c=getopt_long(argc, argv, "wrch", long_options, &option_index);
	
	if (c==-1) break;

		switch (c) {
			case 'w':
				writeopt=1;
				break;
			case 'r':
				readopt=1;
				break; 	
			case 'c':
				clearallopt=1;
				break;
			case 'h':
				usage();
				return(-1);
			case 0:
				if( strcmp( "day", long_options[option_index].name ) == 0 ) {
        	day=atoi(optarg);
        }
				else if( strcmp( "month", long_options[option_index].name ) == 0 ) {
					month=atoi(optarg);
        }
				else if( strcmp( "hour", long_options[option_index].name ) == 0 ) {
					hour=atoi(optarg);
        }
				else if( strcmp( "minutes", long_options[option_index].name ) == 0 ) {
					minutes=atoi(optarg);
        }
				else if( strcmp( "note", long_options[option_index].name ) == 0 ) {
        	strcpy(note,optarg);
        }
			break;
			case '?': 
				usage();
				return(-1);	
			default:
				usage();
				return(-1);
		}
}

	/* 1 opzione alla volta */
	if ((writeopt&&readopt)||(writeopt&&clearallopt)||(clearallopt&&readopt)){
		usage();
		return -1;
	}

	if (readopt) {
		readnotes();
	}

	else if (clearallopt) {
		clearallnotes();
	}

	else if (writeopt) {
		if ((day+month+hour+minutes)==0)
			onlynote=1;
		//printf ("hour %d,minutes %d,day %d,month %d,note %s",hour,minutes,day,month,note);return 0;
		writenote (onlynote,hour,minutes,day,month,note);
		readnotes();
	}

	return (0);
}
