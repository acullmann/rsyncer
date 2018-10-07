#!/bin/bash

# acullmann 2018-08-26
# sync a file to a remote machine and another one back
# do this every x seconds.

TIME_TO_SLEEP=10

REMOTE_SERVER=example.com
REMOTE_USER=root

UP_LOCAL_FILE=up.txt
UP_REMOTE_FILE=up.txt

DOWN_REMOTE_FILE=down.txt
DOWN_LOCAL_FILE=down.txt

# uncomment for verbose output
#RSYNC_VERBOSE="-v"





CleanUp() {
    echo "exiting"
    exit
}
trap CleanUp EXIT INT TERM SIGINT SIGTERM SIGTSTP

print_date() {
	date +'%Y-%m-%d %H:%M:%S'
}


rsync_up() {
	echo -n "uploading   ... "
	rsync -a ${RSYNC_VERBOSE} -e "ssh -l ${REMOTE_USER}" ${UP_LOCAL_FILE}  ${REMOTE_SERVER}:${UP_REMOTE_FILE} 
	if [ $? -eq 0 ]   
	then
	    echo -n " done at "
	    print_date
	else
	    echo -n -e "\e[31mfailed\e[0m at "
	    print_date
	    # insert aditional error handling here
	fi
}

rsync_down() {
	echo -n "downloading ... "
	rsync -a ${RSYNC_VERBOSE} -e "ssh -l ${REMOTE_USER}" ${REMOTE_SERVER}:${DOWN_REMOTE_FILE} ${DOWN_LOCAL_FILE}
	if [ $? -eq 0 ]
	then
	    echo -n " done at "
	    print_date
	else
	    echo -n -e "\e[31mfailed\e[0m at "
	    print_date
	    # insert aditional error handling here
	fi
}

## sleep some time

my_sleep() {
	for i in $(seq 1 ${TIME_TO_SLEEP})
	do
	  echo -n .
	  sleep 1
	done
	echo .  

}


## main

echo uploading:   rsync -a ${RSYNC_VERBOSE} -e \"ssh -l ${REMOTE_USER}\" ${UP_LOCAL_FILE}  ${REMOTE_SERVER}:${UP_REMOTE_FILE}
echo downloading: rsync -a ${RSYNC_VERBOSE} -e \"ssh -l ${REMOTE_USER}\" ${REMOTE_SERVER}:${DOWN_REMOTE_FILE} ${DOWN_LOCAL_FILE}
echo sleep in between: ${TIME_TO_SLEEP} sec. 
echo ""


while true; do
	rsync_up
	rsync_down
	my_sleep
done
