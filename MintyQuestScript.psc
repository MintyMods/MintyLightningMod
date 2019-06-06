Scriptname MintyQuestScript extends Quest  
{Place holder to hook into weather system}

import debug
import game
import weather
import utility

; External properties
Spell Property MintyForkLightningSpell Auto
Spell Property MintySheetLightningSpell Auto

; Bad Arse Weathers that justify Lightning Strikes Dude
Weather Property SkyrimStormRainTU Auto ; 10a241
Weather Property SkyrimStormRainFF Auto ; 10a23c
Weather Property SkyrimStormRain Auto ; C8220
Weather Property SkyrimOvercastRainVT Auto ; 10A746
Weather Property FXMagicStormRain Auto ; D4886

; Props
Activator Property BouncerType Auto
Activator property MarkerType Auto

; Variables
bool initalised = false
bool cleanup = true
Float height = 4096.0
Float cellSize = 8096.0 
Float PosX
Float PosY
Float PosZ
Float offset = 500.0
ObjectReference[] Bouncers


Event OnInit()
	if (!initalised)
		Trace("Minty Lightning Quest Init...")
		RegisterForUpdate(5.0)		
		initalised = true;
	endif
EndEvent


Event OnUpdate()

	if (isStormWeather())
		Trace("Storm Weather Detected - Updating...")
		Bouncers = new ObjectReference[5]	
		int totalBouncers = Bouncers.Length
		totalBouncers = totalBouncers - 1
		
		int count = 0
		ObjectReference targetRefOne = None
		ObjectReference targetRefTwo = None
		ObjectReference casterRef = None
		ObjectReference PlaceTarget = None
		
		if (MarkerType != None)
			PlaceTarget = GetPlayer().PlaceAtMe(MarkerType,1)
		endif
		
		bool fork = (RandomInt(0,100) < 10) ; 10% chance to fork
		
		if (PlaceTarget != None)
			PosZ = height
			PosX = (RandomFloat(-cellSize, cellSize))
			PosY = (RandomFloat(-cellSize, cellSize))

			; Position our caster bouncer
			;Trace("X:" + PosX + " Y:" + PosY + " PosZ:" + PosZ)
			PlaceTarget.MoveTo(GetPlayer(), PosX, PosY, PosZ)
			Bouncers[0] = PlaceTarget.PlaceAtme(BouncerType,1)			
			
			if (fork) 
				PosZ = 0 ; Fork so drop targets to ground level
			endif

			PlaceTarget.MoveTo(GetPlayer(), (PosX + offset), PosY, PosZ)
			Bouncers[1] = PlaceTarget.PlaceAtme(BouncerType,1)
			PlaceTarget.MoveTo(GetPlayer(), (PosX - offset), PosY, PosZ)
			Bouncers[2] = PlaceTarget.PlaceAtme(BouncerType,1)
			PlaceTarget.MoveTo(GetPlayer(), PosX, (PosY + offset), PosZ)
			Bouncers[3] = PlaceTarget.PlaceAtme(BouncerType,1)
			PlaceTarget.MoveTo(GetPlayer(), PosX, (PosY - offset), PosZ)
			Bouncers[4] = PlaceTarget.PlaceAtme(BouncerType,1)
			Wait(0.1)
		endif

		int randomTartget1 = RandomInt(1, totalBouncers)
		int randomTartget2 = RandomInt(1, totalBouncers)
		
		while (randomTartget1 == randomTartget2) 
			randomTartget1 = RandomInt(1, totalBouncers)
			randomTartget2 = RandomInt(1, totalBouncers)
		endwhile
		
		casterRef = Bouncers[0] ; our caster is always in the middle
		targetRefOne = Bouncers[randomTartget1]
		targetRefTwo = Bouncers[randomTartget2]
		
		if (casterRef != None && targetRefOne != None)
			if (casterRef.Is3DLoaded())
				if (fork)
					if (MintyForkLightningSpell != None)
						Trace("Casting Fork Lightning")
						MintyForkLightningSpell.Cast(casterRef, targetRefOne)
					endif
				else
					if (MintySheetLightningSpell != None)
						Trace("Casted Sheet Lightning")
						MintySheetLightningSpell.Cast(casterRef, targetRefOne)
						if (targetRefTwo != None)
							MintySheetLightningSpell.Cast(casterRef, targetRefTwo)
						endif
					endif
				endif			
				Wait(0.5)
			endif
		endif
		
		if (cleanup)
			count = 0
			while (count < totalBouncers)		
				if (Bouncers[count] != None)
					Bouncers[count].delete()
				endif	
				count += 1
			endwhile
			if (PlaceTarget != None)
				PlaceTarget.delete()
			endif	
			if (targetRefOne != None)
				targetRefOne.delete()
			endif	
			if (targetRefTwo != None)
				targetRefTwo.delete()
			endif	
			if (casterRef != None)
				casterRef.delete()
			endif	
		endif
	
	endif
	
endEvent

bool Function isStormWeather()
	if(IsOutsideWithFullSky())
		if (!IsWeatherTransitioning())
			if (IsWeatherRaining())
				if (isWeatherBadEnoughForLightning())
					return true
				endif
			endif
		endif
	else
		return false
	endif
endFunction

bool Function isWeatherBadEnoughForLightning() 
	if (SkyrimStormRainTU != None && GetCurrentWeather().GetFormID() == SkyrimStormRainTU.GetFormID())
		Trace("Weather is BadArse, SkyrimStormRainTU = 10a241")
		return true
	elseif (SkyrimStormRainFF != None && GetCurrentWeather().GetFormID() == SkyrimStormRainFF.GetFormID())
		Trace("Weather is BadArse, SkyrimStormRainFF = 10a23c")
		return true
	elseif (SkyrimStormRain != None && GetCurrentWeather().GetFormID() == SkyrimStormRain.GetFormID())
		Trace("Weather is BadArse, SkyrimStormRain = C8220")
		return true
	elseif (SkyrimOvercastRainVT != None && GetCurrentWeather().GetFormID() == SkyrimOvercastRainVT.GetFormID())
		Trace("Weather is BadArse, SkyrimOvercastRainVT = 10A746")
		return true
	elseif (FXMagicStormRain != None && GetCurrentWeather().GetFormID() == FXMagicStormRain.GetFormID())
		Trace("Weather is BadArse, FXMagicStormRain = D4886")
		return true
	else
		return false
	endif
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
