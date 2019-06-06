Scriptname MintyQuestScript extends Quest Conditional
{Place holder to hook into weather system}

import debug
import game
import weather
import utility

; External properties
Spell Property MintyForkLightningSpell Auto
Spell Property MintySheetLightningSpell Auto
Spell Property MintyForkLightningSpellHostile Auto
Spell Property MintySheetLightningSpellHostile Auto

; Bad Arse Weathers that justify Lightning Strikes Dude
Weather Property SkyrimStormRainTU Auto ; 10a241
Weather Property SkyrimStormRainFF Auto ; 10a23c
Weather Property SkyrimStormRain Auto ; C8220
Weather Property SkyrimOvercastRainVT Auto ; 10A746
Weather Property FXMagicStormRain Auto ; D4886

ImageSpaceModifier property MintyMagShockStormImod auto
ImageSpaceModifier property MintyDA09BloomImod Auto

;TEMP
Book Property MintyLightningConfigBook Auto
Form Property MintyDebuggingRing Auto 

; Script available variables
Bool Property isLightningHostile = False Auto hidden ; will a strike kill anyone
int Property chanceToFork = 25 Auto hidden ; Percentage to hit ground
int Property distanceMultiplyer = 2 Auto hidden ; how many cells should we cover
Float Property strikeOffset =  100.0 Auto hidden ; movement between sheet targets
int Property maxTargets = 3 Auto hidden ; maximum sheet targets
Float Property updateFrequency =  2.0 Auto hidden ; game update cycle
Bool Property showDebugMessages = False Auto hidden ; Show debugging messages
Bool Property logDebugMessages = False Auto hidden ; Log debugging messages
Float Property bloom = 2.0 Auto hidden ; Bloom


; Variables
bool initalised = false
Float minAnimationTime = 1.0
Spell spellToCastFork = None
Spell spellToCastSheet = None
String version = "4.2"  ; Current Version


Event OnInit()
	if !initalised
		if Self != None
			LogInfo("Minty Lightning Quest (Version:" + version + ") Init...")
			if Game.GetPlayer().GetItemCount(MintyLightningConfigBook) < 1
				GetPlayer().addItem(MintyLightningConfigBook,1)
			endif
			if Game.GetPlayer().GetItemCount(MintyDebuggingRing) < 1
				GetPlayer().addItem(MintyDebuggingRing)
			endif
			RegisterForSingleUpdate(updateFrequency)		
			initalised = true;
		endif
	endif
EndEvent


Event OnUpdate()
	if isStormWeather()
		LogDebug("Storm Weather Detected - Updating, in " + updateFrequency)
		InitLightning()
		MintyDA09BloomImod.apply(bloom)
		spellToCastFork.Cast(GetPlayer(), GetPlayer())
		Wait(RandomFloat(0.5, 1.0))
		MintyDA09BloomImod.remove()
		Wait(minAnimationTime)
	endif
	RegisterForSingleUpdate(updateFrequency)		
endEvent


Function InitLightning()
	if isLightningHostile 
		LogDebug("Going with Hostile Lightning")
		spellToCastFork = MintyForkLightningSpellHostile
		spellToCastSheet = MintySheetLightningSpellHostile
	else
		LogDebug("Going with Harmless Lightning")
		spellToCastFork = MintyForkLightningSpell
		spellToCastSheet = MintySheetLightningSpell
	endif
EndFunction



bool Function isStormWeather()
	bool isBad = false
	if IsOutsideWithFullSky()
		if !IsWeatherTransitioning()
			if IsWeatherRaining()
				if isWeatherBadEnoughForLightning()
					isBad = true
				endif
			endif
		endif
	endif
	return isBad 
endFunction


bool Function isWeatherBadEnoughForLightning() 
	bool isBad = False
	if GetCurrentWeather() == SkyrimStormRainTU
		LogDebug("Weather is BadArse, SkyrimStormRainTU = 10a241")
		isBad = true
	elseif GetCurrentWeather() == SkyrimStormRainFF
		LogDebug("Weather is BadArse, SkyrimStormRainFF = 10a23c")
		isBad = true
	elseif GetCurrentWeather() == SkyrimStormRain
		LogDebug("Weather is BadArse, SkyrimStormRain = C8220")
		isBad = true
	elseif GetCurrentWeather() == SkyrimOvercastRainVT
		LogDebug("Weather is BadArse, SkyrimOvercastRainVT = 10A746")
		isBad = true
	elseif GetCurrentWeather() == FXMagicStormRain
		LogDebug("Weather is BadArse, FXMagicStormRain = D4886")
		isBad = true
	else
		isBad = false
	endif
	return isBad
EndFunction


bool Function LogDebug(String msg) 
	if (Self.logDebugMessages)
		Trace(msg)
	endif
EndFunction


bool Function LogInfo(String msg) 
	if (Self.showDebugMessages)
		Notification(msg)
	endif
	LogDebug(msg)
EndFunction


bool Function IsOutsideWithFullSky() 
	return (GetSkyMode() == 3) ; int SKYMODE_FULL = 3
EndFunction


bool Function IsWeatherRaining() 
	return (GetCurrentWeather().GetClassification() == 2) ; int WEATHER_RAINING = 2
EndFunction


bool Function IsWeatherTransitioning() 
	return !(GetCurrentWeatherTransition() == 1.0)
EndFunction
