#!/bin/bash
set -o errexit  # exit if error
set -o nounset  # exit if variable not initalized
set +h          # disable hashall

source $TOPDIR/config.inc
source $TOPDIR/function.inc
_prgname=${0##*/}	# script name minus the path

_package="ncurses"
_version="5.9"
_sourcedir="$_package-$_version"
_log="$LFS$LFS_TOP/$LOGDIR/$_prgname.log"
_completed="$LFS$LFS_TOP/$LOGDIR/$_prgname.completed"

msg_line "Building $_package-$_version"

[ -e $_completed ] && {
	msg ":  SKIPPING"
	exit 0
}

msg ""
	
# unpack sources
unpack "${PWD}" "${_package}-${_version}"

# cd to source dir
cd $_sourcedir

# prep
build "+ sh ../../sources/ncurses-5.9-20141206-patch.sh" "sh ../../sources/ncurses-5.9-20141206-patch.sh"  $_log
build "+ patch -Np1 -i ../../sources/ncurses-5.9-bash_fix-1.patch" "patch -Np1 -i ../../sources/ncurses-5.9-bash_fix-1.patch" $_log
#build "+ patch -Np1 -i ../../sources/ncurses-5.9-branch_update-4.patch" "patch -Np1 -i ../../sources/ncurses-5.9-branch_update-4.patch" $_log
build "+ ./configure --prefix=$CROSS_TOOLS --without-debug --without-shared" "./configure --prefix=$CROSS_TOOLS --without-debug --without-shared" $_log
#build "  Configuring... " "./configure --prefix=/cross-tools --disable-static" $_log

# build
build "+ make $MKFLAGS -C include" "make $MKFLAGS -C include" $_log
build "+ make $MKFLAGS -C progs tic" "make $MKFLAGS -C progs tic" $_log

# install
build "+ install -v -m755 progs/tic $CROSS_TOOLS/bin" "install -v -m755 progs/tic $CROSS_TOOLS/bin" $_log

# clean up
cd ..
rm -rf $_sourcedir

# make .completed file
touch $_completed

# exit sucessfull
exit 0