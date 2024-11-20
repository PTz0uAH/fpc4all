"Indeed it was a road-trip alike journey to build our favorite set of oldskool-craftsmen-dev-tools with our bare hands"

Quick build instructions for Termux-app/X11/XFCE4: (assuming all libs needed are installed)
- make sure LD_LIBRARY_PATH exists and points to /data/data/com.termux/files/usr/lib
- if LD_LIBRARY_PATH does not exist add it to .bashrc for permanent usage or..
- type export LD_LIBRARY_PATH=$PREFIX/lib before continuing or..
- make use of my run.sh script and make a link: ln -s $PREFIX/lib/fpc4all/run.sh $PREFIX/bin/run  
- cd $PREFIX/lib
- clone this repo (via ssh works best) 
- cd fpc4all/fpcupdeluxe
- run fpcupdeluxe-aarch64-android
- create FPC
- create LAZARUS
- read the final instructions displayed at a successfull build
- if the desktop icon of lazarus is not working use workaround with a a new launcher-link with path to the lazarus.sh script
- as soon as FPCUPDELUXE "termuxified" is adapted previous steps will not be needed anymore..
- have fun..

 FPC4ALL (AARCH64) is an experimental repo to define the FPC4TERMUX blueprint (next-door-repo), meant
 for circular learning.. thus enhancing self-sustainability.. even on a non-high-end android device..
 Our repo contains combined trunk snapshots of FPC(rev.7ac4e38b) and LAZARUS(rev.aeca9749)..
 On Termux we are going to work the code to build FPC and our very own Lazarus IDE.. and while
 editing the sources, try to make use of conditional define TMX to isolate our code from the rest..
 (a simple "make -DTMX" would set the define i.e. if mainstream would implement our "cherries")
 
 Naturally we are also going to utilize on-device FPCUPDELUXE "termuxified" to make the process less
 elaborate.. so the Termux user can finally work with a recent developer edition of FPC and Lazarus.
 The aarch64-android bootstrap compiler we borrowed from the fpc-3.2.2.aarch64-termux.deb experiment
 is stable enough to become the build engine of our project.
 Now we have patched/buildable sources we simply addded our tmx-trunk to the list of sources on the
 "and more.."-tab so FPCUPDELUXE can perform the delicate build procedure as usual..

 To make it a true ootb-(my "middlename")-experience, for your convenience, the "termuxified"
 FPCUPDELUXE binary will be available in this repo to get you started right away..
 Any Termux-app/X11 user now can build "on the fly" a functional FPC and LAZARUS..
 
 Nothing is lost.. since all commits are back-trackable the fpc-upstream devs can implement the changes
 into their mainstream git if needed. Overhere we are pioneering and use unorthodox methods to present
 a workable version for experimentation.. which means utilizing neat stuff that would "normally" take ages
 to prep via the official repos..
  
 As "spoiled" Delphi7-pro user I observed the past decades of FreePascal development with
 anticipation and patience, always comparing my "paid" version with the "free" surrogate, and
 now, as the modern Lazarus IDE seems to be on par with Delphi7 IDE with a lot the extras also to be
 seen at modern Delphi releases, we are going to bring that developer environment to Termux including
 all kinds of non-standard features activated to create desktop apps and more cool stuff..

 Last but not least, for now, is my secondary motive to create with fpc a classic Amiga toolchain-
 compatible crosscompiler, the "V3"-binutils are already available via a "termuxified" Amiga-gcc
 toolchain available from the earlier experiments and should work with fpc4all and fpc4termux..
 This means we are also building an alternative developer platform to create programs with fpc
 and lazarus for the good ole Commodore Amiga.. and even to run on real amiga machines though most
 likely to run inside "termuxified" emulators Amiberry, Fs-uae and even on vAmigaWeb and Uae4arm-apk..
 The latter 2 do not need Termux X11 apk to run and can be called from the plain Termux-app. 

"Hope you'll be surprised with the results of this extra-ordinary educational endeavor.."

Thanks all who made this possible!

With kind regards,

PTz(Peter Slootbeek)uAH

p.s. during development there is limited support as this is an experiment, please only post bugs at issues..
nevertheless you are very welcome to post your screenshot at [issues](https://github.com/PTz0uAH/fpc4all/issues/1)
if you managed to get it working.. and maybe show off your very first project.. we're already sincerely proud of you!

ergo: getting the Castle Game Engine to work was my main drive.. that was a success in early alpha phase so
now the experience is used to work more complient at porting from scratch for the better, we shall see..
though one thing is for sure.. once build, lazarus and fpc keep working even if no internet is available 
what makes our "dynamic duo" also perfect tools for any offline scenario..

