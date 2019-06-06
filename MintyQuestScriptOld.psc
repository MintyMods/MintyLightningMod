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

; Props
Activator property MintyActivator Auto
ImageSpaceModifier property MintyMagShockStormImod Auto
ImageSpaceModifier property MintyDA09BloomImod Auto
Hazard property MintyLightningHazard Auto

; Script available variables
Bool Property isLightningHostile = False Auto hidden ; will a strike kill anyone
int Property chanceToFork = 25 Auto hidden ; Percentage to hit ground
int Property distanceMultiplyer = 2 Auto hidden ; how many cells should we cover
Float Property strikeOffset =  100.0 Auto hidden ; movement between sheet targets
int Property maxTargets = 3 Auto hidden ; maximum sheet targets
Float Property updateFrequency =  5.0 Auto hidden ; game update cycle
Bool Property showDebugMessages = False Auto hidden ; Show debugging messages
Bool Property logDebugMessages = False Auto hidden ; Log debugging messages
Float Property bloom = 2.0 Auto hidden ; Bloom

; Variables
bool initalised = false
bool cleanup = true
Float height = 3584.0
Float cellSize = 2048.0 
Float PosX
Float PosY
Float PosZ
ObjectReference[] TargetRefs
Float minAnimationTime = 1.0
Spell spellToCastFork = None
Spell spellToCastSheet = None
String version = "4.2"  ; Current Version


Event OnInit()
	if !initalised
		if Self != None
			LogInfo("Minty Lightning Quest (Version:" + version + ") Init...")
			RegisterForSingleUpdate(updateFrequency)		
			initalised = true;
		endif
	endif
EndEvent


Event OnUpdate()
	if isStormWeather()
		LogDebug("Storm Weather Detected - Updating, in " + updateFrequency)
		
		;MAGProjectileStormVar.setValue(1.0) ;We need this global for the Clear Skys shout to stop all Projectile Storms.
		;if MAGProjectileStormVar.GetValue() == 1.0
		
		TargetRefs = new ObjectReference[20]	
		ObjectReference PlaceTarget = None
		ObjectReference CasterRef = None
		ObjectReference TargetRef = None
		int totalTargets = maxTargets - 1 ; as Int
		
		
		if MintyActivator != None
			PlaceTarget = GetPlayer().PlaceAtMe(MintyActivator,1)
			Wait(1)
		endif
		
		bool fork = (RandomInt(0,100) < chanceToFork) ; 10% chance to fork
		LogDebug("Chance to Fork = " + chanceToFork + "% : Are we Forking? - " + fork)
		
		if PlaceTarget != None
			float strikeArea = (cellSize * distanceMultiplyer)
			LogDebug("StrikeArea = " + strikeArea)
			PosX = (RandomFloat(-strikeArea, strikeArea))
			PosY = (RandomFloat(-strikeArea, strikeArea))
			
			PlaceTarget.MoveTo(GetPlayer(), PosX, PosY, height) ; Position our CasterRef 
			Wait(0.5)
			CasterRef = PlaceTarget.PlaceAtme(MintyActivator,1)			
			Wait(0.5)

			LogDebug("*** Player [ X:" + GetPlayer().X + " Y:" + GetPlayer().Y + " Z:" + GetPlayer().Z + " IS " + GetPlayer() + "]")
			LogDebug("+++ Caster [ Distance: " + GetPlayer().GetDistance(CasterRef) + " X:" + CasterRef.X + " Y:" + CasterRef.Y + " Z:" + CasterRef.Z + " IS " + CasterRef + "]")
			
			if fork 
				PosZ = GetPlayer().GetPositionZ() ; Fork so drop targets to ground level
			else
				PosZ = CasterRef.Z ; Sheet so place targets in the sky level with caster
			endif

			LogDebug("--- Total Targets = " + totalTargets)
			int count = 0
			while count < totalTargets
				;Float tPosX = (PosX + (strikeOffset * count))  ; RandomFloat(-strikeOffset, strikeOffset)
				;Float tPosY = (PosY + (strikeOffset * count))  ; (PosY + (RandomFloat(-strikeOffset, strikeOffset)))
				Float tPosX = (PosX + RandomFloat(-strikeOffset, strikeOffset))
				Float tPosY = (PosY + RandomFloat(-strikeOffset, strikeOffset))
				PlaceTarget.MoveTo(CasterRef, tPosX, tPosY, PosZ)
				Wait(0.5)
				TargetRefs[count] = PlaceTarget.PlaceAtme(MintyActivator,1)
				Wait(0.5)
				LogDebug(" |- Target[" + count + "] X:" + TargetRefs[count].X + " Y:" + TargetRefs[count].Y + " Z:" + TargetRefs[count].Z) + " Distance:" +  CasterRef.GetDistance(TargetRefs[count])
				count += 1
			endwhile			
			
		endif
		
		InitLightning()
		

		if (CasterRef != None && CasterRef.Is3DLoaded() && CasterRef.GetParentCell() != none)
			if fork
				if (spellToCastFork != None)
					TargetRef = TargetRefs[RandomInt(0, totalTargets)]
					if (TargetRef != None && TargetRef.Is3DLoaded() && TargetRef.GetParentCell() != none)
						Float intensity = getImodIntensity(CasterRef)
						LogInfo(getImodDistanceDescription(intensity) + ", FORK Lightning, hostile=" + isLightningHostile)
						;adjustCastingHeight(CasterRef, TargetRef)
						;playImodEffect(intensity * 2)
						playImodBloomEffect()
						spellToCastFork.Cast(CasterRef, TargetRef)
						Wait(minAnimationTime)
					endif
				endif
			else
				if (spellToCastSheet != None)
					int count = 0
					while (count < totalTargets)
						TargetRef = TargetRefs[count]
						if (TargetRef != None && TargetRef.Is3DLoaded() && TargetRef.GetParentCell() != none)
							Float intensity = getImodIntensity(CasterRef)
							LogInfo(getImodDistanceDescription(intensity) + ", SHEET Lightning, hostile=" + isLightningHostile)
							;playImodEffect(intensity * 2)
							playImodBloomEffect()
							spellToCastSheet.Cast(CasterRef, TargetRef)
							Wait(minAnimationTime)
						endif	
						count += 1
					endwhile							
				endif
			endif			
		endif
		
		if cleanup
			int count = 0
			while count < totalTargets		
				if None != TargetRefs[count]
					TargetRefs[count].disable()
					TargetRefs[count].delete()
				endif	
				count += 1
			endwhile
			TargetRefs = None
			if PlaceTarget != None
				PlaceTarget.disable()
				PlaceTarget.delete()
			endif	
			if CasterRef != None
				CasterRef.disable()
				CasterRef.delete()
			endif				
			if TargetRef != None
				TargetRef.disable()
				TargetRef.delete()
			endif	
		endif
		
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


Function adjustCastingHeight(ObjectReference CasterRef, ObjectReference TargetRef)
	float castingHeight = CasterRef.Z
	float targetHeight = TargetRef.Z
	if (castingHeight >= 512.0)
		CasterRef.MoveTo(TargetRef, RandomFloat(-20.0, 20.0), RandomFloat(-20.0, 20.0), 512.0)
		Wait(0.5)
	endif
EndFunction


Function playSkyHazard(ObjectReference CasterRef)
	if MintyLightningHazard != none
		;CasterRef.placeAtMe(MintyLightningHazard)
		; REMEMBER TO REMOVE IF PLACED
	endif	
EndFunction


Function playImodBloomEffect()
	if MintyDA09BloomImod != None
		;MintyDA09BloomImod.apply(intensity * RandomInt(1,5))
		MintyDA09BloomImod.apply(bloom)
		Wait(1.5)
		MintyDA09BloomImod.remove()
		
;		float FallTime = 6
;		float preEffectTime = 1
;		float FadeTime = 1.5
;		MintyDA09BloomImod.ApplyCrossFade(bloom)
;		utility.wait(FallTime - (FadeTime + preEffectTime))
;		ImageSpaceModifier.RemoveCrossFade(FallTime)
		
	endif
EndFunction


Function playImodEffect(Float intensity)
	if MintyMagShockStormImod != None
		;MintyMagShockStormImod.apply(intensity)
		MintyMagShockStormImod.apply(0.10)
	endif
EndFunction


String Function getImodDistanceDescription(Float distance)
	String desc = ("ERROR Getting Imod Distance (getImodDistanceDescription)")
	if (distance == 0.10)
		desc = "Distant"
	elseif (distance == 0.15)
		desc = "Medium"
	elseif (distance == 0.25)
		desc = "Local"
	endif
	LogDebug("Imod Distance is " + desc + " Distance: " + distance)
	return desc
EndFunction



Float Function getImodIntensity(ObjectReference CasterRef)
	Float distance = GetPlayer().GetDistance(CasterRef)
	;if ((distance <= (cellSize * 3)) && (distance >= (cellSize * 2)))
	if ((distance <= 6144.0) && (distance >= 4092))
		LogDebug("Returning Distant Imod level : " + distance)
		return 0.10
	;elseif ((distance <= (cellSize * 2)) && (distance >= cellSize))
	elseif ((distance <= 4092) && (distance >= 2046))
		LogDebug("Returning Medium Imod level : " + distance)
		return 0.15
	else
		LogDebug("Returning Local Imod level : " + distance)
		return 0.25
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
	if SkyrimStormRainTU != None && GetCurrentWeather() == SkyrimStormRainTU
		LogDebug("Weather is BadArse, SkyrimStormRainTU = 10a241")
		isBad = true
	elseif SkyrimStormRainFF != None && GetCurrentWeather() == SkyrimStormRainFF
		LogDebug("Weather is BadArse, SkyrimStormRainFF = 10a23c")
		isBad = true
	elseif SkyrimStormRain != None && GetCurrentWeather() == SkyrimStormRain
		LogDebug("Weather is BadArse, SkyrimStormRain = C8220")
		isBad = true
	elseif SkyrimOvercastRainVT != None && GetCurrentWeather() == SkyrimOvercastRainVT
		LogDebug("Weather is BadArse, SkyrimOvercastRainVT = 10A746")
		isBad = true
	elseif FXMagicStormRain != None && GetCurrentWeather() == FXMagicStormRain
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
