#!/data/data/com.termux/files/usr/bin/sh
# needed for GUI progs created with fpc or lazarus
LD_LIBRARY_PATH=$PREFIX/lib
export LD_LIBRARY_PATH
./$@ &


