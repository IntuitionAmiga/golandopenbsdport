#!/bin/sh
#
# $OpenBSD: idea,v 1.4 2019/04/26 12:38:02 rsadowski Exp $
#
# OpenBSD-specific startup script for IntelliJ IDE

IDEA_HOME=/usr/local/goland
DATASIZE="2048000"
[[ `arch -s` == i386 ]] && DATASIZE="1536000"

#-----------------------------------------------------------------------------
# Determine configuraideation settings
#-----------------------------------------------------------------------------

export JAVA_BIN=$(javaPathHelper -c intellij)
export JAVA_HOME=$(javaPathHelper -h intellij)

if [ ! -x "${JAVA_BIN}" ]; then
	echo "Error: JAVA_HOME may not be defined correctly: ${JAVA_HOME}"
	echo "       Unable to find Java binary ${JAVA_BIN}"
        exit 1
fi

# Check if 'idea' executable can be found
if [ ! -x "${IDEA_HOME}/bin/goland.sh" ]; then
	echo "Error: IDEA_HOME may not be defined correctly: ${IDEA_HOME}"
	echo "       Unable to find launcher binary: ${IDEA_HOME}/bin/goland.sh"
	exit 1
fi

xm_log() {
	echo -n "$@\nDo you want to run IntelliJ IDEA anyway?\n\
(If you don't increase these limits, IntelliJ IDEA might fail to work properly.)" | \
		/usr/X11R6/bin/xmessage -file - -center -buttons yes:0,no:1 -default no
}

if [ $(ulimit -Sd) -lt ${DATASIZE} ]; then
	ulimit -Sd ${DATASIZE} || \
		xm_log "Cannot increase datasize-cur to at least ${DATASIZE}"
		[ $? -eq 0 ] || exit
fi

PATH=${JAVA_HOME}/bin:$PATH exec "${IDEA_HOME}/bin/goland.sh" $@