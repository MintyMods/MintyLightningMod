MintyLightningMod 


Installation :
It is recommended to let Nexus Mod Manager install the files 

Manual Installation :
Copy the contents of the archive into SkyRim/Data
Ensure the Lightning During Thunder Storms mod is checked within Data options in splash screen.

*** If upgrading from a previous version please create a clean save before installing ***

See the following resources for more information on creating a clean save :
http://forums.steampowered.com/forums/showthread.php?t=2791993
http://www.darkcreations.org/forums/topic/3752-skse-cleans-invalid-scripts-from-old-mods/


Minimum Requirements : SkyRim Version 1.4
"The CK requires a minimum of 1.4 to be present before mods generated with it can be guaranteed to work."

Credits :
PlayerTwo for the Video Links, the Sheet Nifs, The Visual tweeking, etc. basically helping me on the mod.
RandoomNoob for the scripting assistence.
Cipscis & JustinOther for the nice tutorials online and the Wiki work.
Arsenalrobert for the Video Link of version 1.0 - http://www.youtube.com/watch?v=R_KqjQVIP1k
Cocknocker, for the requirement ;o)
Jet Set Willy, for the beta testing.


=============================================================
Change Log:v21
* Fixed config menu to work against MCM 3.2
* Fixed order the menu was shown within MCM (e.g. it was always shown 1st)


Change Log:v20
* Cleaned mod - Removed incorrect change to base ChainLightningLeftHand!
* Removed update.esm as a master dependency due to issues with the CK
* Added support for SkyUI MCM (Mod Configuration Menu)
* Fixed sheet strikes incorrectly using fork bloom level.
* Added support to remove Legacy Config Menus. 
* Added Spanish translations : Gomstor! Original
* Added Polish translations : olbins / Magda
* Added Italian translations : Lucasssvt

* Added German translations : Mahlzeit88
* Fixed broken animation
* Removed broken strike sound
* Added Force Weather option
* Corrected translation key for globals tooltip


Change Log:v19 - Removed check for isItRaining() to support COT 2.1.

Change Log:v18 - Repacked and uploaded to include missing parent scripts.

Change Log:v15,16,17 - Corrupted upload causing CTD when saving! 

Change Log:v14 (12/13/14)
Re-uploaded to resolve deployment issues with CK and NMM 
Corrected version number displayed in game to 14.0 - skipping 12 & 13 due to deployment issues on Steam Workshop.
By Request (RavenousRaven9) Corrected the default bloom animation times which was causing a white out!
By Request (phaota) data directory added to archive to support NMM
By Request (xNoobxSaibotx): Fork strike sound changed to one more thunderbolt like ;o) THUNDER :o)
By Request (jacktthompson): Flaged which settings are the defaults within the menus before they are changed.
By Request (arlie0527): Smoke added to burning effect after a strike.
Major increments (12/13/14/etc) are due to how Steam workshop handles versioning of uploads!


Change Log:v11
12 *NEW* Sheet effects (created by PlayerTwo)
Code rework to allow more control over both fork and sheet strikes.
Better Menu System and you are now given the book on game start.
All variables are now global - see "help minty 3" in console,
Removed ring requirement to see debugging menu - renamed to misc and always visable.
The strikes should not be hostile anymore, unless you want them to be.
Toned down the explosion factors.
By Request (Tom2681) : Fixed bloom menu.
* Compiled against Ver 1.6.89.0 of Creation Kit.


Change Log:v10 (Mostly PlayerTwo's doings)
By Request (PlayerTwo): Changed max multipliers, Fork range to 3, Sheet range to 4
By Request (PlayerTwo): Added 0.15 as the default wait time for animations
By Request (PlayerTwo): Changed sound of fork strikes and added explosion
By Request (ryus27): Chance to leave a Fire when hitting grass or roof tops. 
By Request (Gantar): Strikes now come from above the clouds? Previously they started underneath the clouds.
New Default Values; You are still free to change these via the config options, but the defaults look great!

Change Log: v9
By Request (PlayerTwo): Split distance menu into two seperate menus fork/sheet. 
By Request (PlayerTwo): Toned down bloom levels and based intensity depending on distance
Fixed settings screen to show bloom, and AnimTime values

Change Log: v8
Repackaged to include scripts following issue with the CK not creating .bsa files in the correct location

Change Log: V7
Resolved issues with not seeing menus

Change Log: V6
Removed incorrect dependency against directors tools.

Change Log: V5
Implemented bloom effect 
Better placement of strikes

Change Log: V4
* Better Visual Effects, for both sheet lightning and fork. Still working on these, but I think they are better?
* configurable! There is now a book, on top of the guard house at WhiteRun (Opposite the blacksmiths, BreazeHome, Drunken Huntsman) which will teach you a Spell(Power), and when cast, will allow you to configure the Mod.
* Hidden Ring, (easter egg), that unlocks the 'Debugging Options - which can be fun to play with ;o)'

Change Log: V3
* Supports Sheet lightning with 10% chance to fork at ground
* Player no longer gets blamed for strikes
* Greater distances, no longer always strikes near player
* Only strikes during bad weather now rather than just while raining
- SkyrimStormRainTU = 10a241
- SkyrimStormRainFF = 10a23c
- SkyrimStormRain = C8220
- SkyrimOvercastRainVT = 10A746
- FXMagicStormRain = D4886