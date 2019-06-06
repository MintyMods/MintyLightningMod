# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [21.0]
### Added
* Fixed config menu to work against MCM 3.2
* Fixed order the menu was shown within MCM (e.g. it was always shown 1st)


## [20.0]
### Added
* Added support for [SkyUI MCM Alternative Freamwork](https://www.nexusmods.com/skyrim/mods/81760) (Mod Configuration Menu)
* Fixed sheet strikes incorrectly using fork bloom level.
* Added support to remove Legacy Config Menus. 
* Added Spanish translations : <b>Gomstor! Original</b>
* Added Polish translations : <b>olbins</b> and <b>Magda</b>
* Added Italian translations : <b>Lucasssvt</b>
* Added German translations : <b>Mahlzeit88</b>
* Fixed broken animation
* Added Force Weather option
* Corrected translation key for globals tooltip

### Removed
 *  removed Legacy Config Menus. 
 * Cleaned mod - Removed incorrect change to base ChainLightningLeftHand! 
 * Removed update.esm as a master dependency due to issues with the CK
 * Removed broken strike sound


## [19.0]
### Removed
- Removed check for isItRaining() to support [Climates Of Tamriel](https://www.nexusmods.com/skyrim/mods/17802/) 2.1.


## [18.0]
### Added
 Repacked and uploaded to include missing parent scripts.


## [17.0]
 - Corrupted upload causing CTD when saving! 


## [16.0]
 - Corrupted upload causing CTD when saving! 


## [15.0]
 - Corrupted upload causing CTD when saving! 


## [14.0]  (12/13/14)
### Added
 * Re-uploaded to resolve deployment issues with CK and NMM 
 * By Request (<b>RavenousRaven9</b>) Corrected the default bloom animation times which was causing a white out!
 * By Request (<b>phaota</b>) data directory added to archive to support NMM
 * By Request (<b>xNoobxSaibotx</b>): Fork strike sound changed to one more thunderbolt like ;o) THUNDER :o)
 * By Request (<b>jacktthompson</b>): Flaged which settings are the defaults within the menus before they are changed.
 * By Request (<b>arlie0527</b>): Smoke added to burning effect after a strike.
 * Corrected version number displayed in game to 14.0
 * Major increments (12/13/14/etc) are due to how Steam workshop handles versioning of uploads!


## [13.0]
- skipping 13 due to deployment issues on Steam Workshop.


## [12.0]
- skipping 12 due to deployment issues on Steam Workshop.


## [11.0]
### Added
 * 12 *NEW* Sheet effects created by <b>PlayerTwo</b>[Real Rain](https://www.nexusmods.com/skyrim/mods/16541/?)
 * Code rework to allow more control over both fork and sheet strikes.
 * Better Menu System and you are now given the book on game start.
 * All variables are now global - see "<b>help minty 3</b>" in console,
 * The strikes should not be hostile anymore, unless you want them to be.
 * Toned down the explosion factors.
 * By Request (<b>Tom2681</b>) : Fixed bloom menu.
 * Compiled against Ver 1.6.89.0 of Creation Kit.
 
 
### Removed
 Removed ring requirement to see debugging menu - renamed to misc and always visable.


## [10.0]
### Added
 * By Request (<b>PlayerTwo</b>): Changed max multipliers, Fork range to 3, Sheet range to 4
 * By Request (<b>PlayerTwo</b>): Added 0.15 as the default wait time for animations
 * By Request (<b>PlayerTwo</b>): Changed sound of fork strikes and added explosion
 * By Request (<b>ryus27</b>): Chance to leave a Fire when hitting grass or roof tops. 
 * By Request (<b>Gantar</b>): Strikes now come from above the clouds? Previously they started underneath the clouds.
 * New Default Values; You are still free to change these via the config options, but the defaults look great!


## [9.0]
### Added
 * By Request (<b>PlayerTwo</b>): Split distance menu into two seperate menus fork/sheet. 
 * By Request (<b>PlayerTwo</b>): Toned down bloom levels and based intensity depending on distance
 * Fixed settings screen to show bloom, and AnimTime values


## [8.0]
### Added
 Repackaged to include scripts following issue with the CK not creating .bsa files in the correct location


## [7.0]
### Added
 Resolved issues with not seeing menus


## [6.0]
### Removed
Removed incorrect dependency against directors tools.


## [5.0]
### Added
 * Implemented bloom effect 
 * Better placement of strikes


## [4.0]  
### Added
* Better Visual Effects, for both sheet lightning and fork. Still working on these, but I think they are better?
* configurable! There is now a book, on top of the guard house at WhiteRun (Opposite the blacksmiths, BreazeHome, Drunken Huntsman) which will teach you a Spell(Power), and when cast, will allow you to configure the Mod.
* Hidden Ring, (easter egg), that unlocks the 'Debugging Options - which can be fun to play with ;o)'


## [3.0]  
### Added
* Supports Sheet lightning with 10% chance to fork at ground
* Player no longer gets blamed for strikes
* Greater distances, no longer always strikes near player
* Only strikes during bad weather now rather than just while raining

~~~~
- SkyrimStormRainTU = 10a241
- SkyrimStormRainFF = 10a23c
- SkyrimStormRain = C8220
- SkyrimOvercastRainVT = 10A746
- FXMagicStormRain = D4886
~~~~

[Back to README.md](../README.md)