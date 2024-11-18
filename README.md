"A road-trip alike journey to build our favorite set of oldskool-craftsmen-dev-tools with our bare hands"

 FPC4ALL is an experimental repo to define the FPC4TERMUX blueprint (next-door-repo), meant
 for circular learning.. thus enhancing self-sustainability.. even on a non-high-end android device..
 Our repo contains combined trunk snapshots of FPC(rev.7ac4e38b) and LAZARUS(rev.aeca9749)..
 On Termux we are going to work the code to build FPC and our very own Lazarus IDE.. and while
 editing, use conditional define TMX to isolate our code from the rest..
 
 Naturally we are also going to utilize on-device FPCUPDELUXE "termuxified" to make the process less
 elaborate.. so the Termux user can finally work with a recent developer edition of FPC and Lazarus.
 The aarch64-android bootstrap compiler we borrowed from the fpc-3.2.2.aarch64-termux.deb experiment
 is stable enough to become the build engine of our project.
 Now we have patched/buildable sources we simply addded our tmx-trunk to the list of sources on the
 "and more.."-tab so FPCUPDELUXE can perform the delicate build procedure as usual..

 To make it a true ootb-(my "middlename")-experience, for your convenience, the "termuxified"
 FPCUPDELUXE binary will be available in this repo to get you started right away..
 Final target is to let the user build this legendary dev-environment with only 2 clicks..
 
 Nothing is lost.. since all commits are back-trackable the fpc-upstream devs can implement the changes
 into their mainstream git if needed. Overhere we are pioneering and use unorthodox methods to present
 a workable version to the somewhat more demanding devs and Termux users.. which means utilizing
 gtk2,x11,opengl,opengles,sdl etc.. mostly neat stuff that would take ages to prep via the official repos..
  
 As "spoiled" Delphi7-pro user I observed the past decades of FreePascal development with
 anticipation and patience, always comparing my "paid" version with the "free" surrogate, and
 now, as the modern Lazarus IDE seems to be on par with Delphi7 IDE with a lot the extras also to be
 seen at modern Delphi releases, we are going to bring that developer environment to Termux including
 all kinds of non-standard features activated to create desktop apps and more cool stuff..

 Last but not least, for now, is my secondary motive to create with fpc a classic Amiga toolchain-
 compatible crosscompiler, the "V3"-binutils are already available via a "termuxified" Amiga-gcc
 toolchain available from the earlier experiments and should work with fpc4all and fpc4termux..
 This means we are also building an alternative developer platform to create programs with fpc
 and lazarus for the good ole Commodore Amiga.. to run on real amiga machines but primarely to
 run inside the "termuxified" emulators Amiberry, Fs-uae and even on vAmigaWeb and Uae4arm-apk..
 The latter 2 do not need Termux X11 apk to run and can be called from the plain Termux-app. 

"Hope to surprise you soon with the results of an extra-ordinary educational endeavor.."

With kind regards,

PTz0uAH

ergo: getting the Castle Game Engine to work was my main drive.. that was a success so
now the experience is used to work more complient at porting from scratch for the better,
we shall see.. and one thing is for sure.. once build, lazarus and fpc keep working even
if no internet is available what makes them also perfect tools for any offline scenario..

