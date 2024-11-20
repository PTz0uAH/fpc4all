#!/data/data/com.termux/files/usr/bin/sh
# This script starts the lazarus installed by fpcupdeluxe
# and ignores any system-wide fpc.cfg files
LD_LIBRARY_PATH=$PREFIX/lib
export LD_LIBRARY_PATH
cd $LD_LIBRARY_PATH/fpc4all/lazarus
./startlazarus "$@" &
