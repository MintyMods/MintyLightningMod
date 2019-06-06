Scriptname MintyQuestScript extends Quest Conditional
{Place holder to hook into weather system}

import debug
import game
import weather
import utility

Spell Property MintyForkLightningSpell Auto
Spell Property MintySheetLightningSpell Auto
Spell Property MintyForkLightningSpellHostile Auto
Spell Property MintySheetLightningSpellHostile Auto

; Weather Storms that justify Lightning Strikes
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
Float Property strikeOffset =  200.0 Auto hidden ; movement between sheet targets
Float Property updateFrequency =  1.0 Auto hidden ; game update cycle
Bool Property showDebugMessages = False Auto hidden ; Show debugging messages
Bool Property logDebugMessages = False Auto hidden ; Log debugging messages
Float Property bloom = 0.5 Auto hidden ; Bloom

; TEMP - debugging aid, so we can test changes without going to forking WhiteRun again! ;o)
Book Property MintyLightningConfigBook Auto
Form Property MintyDebuggingRing Auto 

; Variables
bool initalised = false
Float height = 3584.0
Float cellSize = 2048.0 
Float minAnimationTime = 1.0
Spell spellToCastFork = None
Spell spellToCastSheet = None
String version = "4.2"  
String LogFile = "Minty"
Float strikeDistance = 200.0
bool debugging = True

ObjectReference CasterRef = None
ObjectReference TargetRef = None


Event OnInit()
	GotoState("WatchingTheWeather")
	OpenUserLog(LogFile) 
	LogInfo("Minty Lightning Quest (Version:" + version + ") Init...")
	
	if (debugging)
	
		if (GetPlayer().GetItemCount(MintyLightningConfigBook) < 1)
			LogDebug("Adding Book")
			GetPlayer().addItem(MintyLightningConfigBook,1)
		endif
		
		if (GetPlayer().GetItemCount(MintyDebuggingRing) < 1)
			LogDebug("Adding Ring")
			GetPlayer().addItem(MintyDebuggingRing)
		endif			
		
	endif
	
	RegisterForSingleUpdate(updateFrequency)		
EndEvent


; STATES
State WatchingTheWeather

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		if (isStormWeather())
			LogDebug("Storm Weather Detected - Updating, in " + updateFrequency)

			bool forking = (RandomInt(0,100) < chanceToFork) ; % chance to get a fork ;o)
			LogDebug("Chance to Fork = " + chanceToFork + "% : Are we Forking? - " + forking)

			PlaceCaster()
			PlaceTarget(forking)
			InitLightning()
			
			if forking
				FireFork()
			else
				FireSheet()
			endif			
			LogDebug("Target:" + TargetRef + " : 3D=" + TargetRef.Is3DLoaded() + " : Parent=" + TargetRef.GetParentCell())	
			Dispose()
			
		endif
		RegisterForSingleUpdate(updateFrequency + (RandomFloat(0.0, updateFrequency)))		
	endEvent
	
EndState


Function PlaceCaster()
	Float strikeArea = (cellSize * distanceMultiplyer)
	LogDebug("StrikeArea = " + strikeArea + ", distanceMulti=" + distanceMultiplyer)
	
	if (CasterRef == None)
		CasterRef = GetPlayer().PlaceAtme(MintyActivator,1)
		LogDebug("CasterRef Placed : " + CasterRef)
	endif

	LogDebug("*** Player  [ X:" + GetPlayer().X + " Y:" + GetPlayer().Y + " Z:" + GetPlayer().Z + "] Player is " + GetPlayer())
	
	bool visable = false
	while (!visable)
		Float PosX = (RandomFloat(-strikeArea, strikeArea))
		Float PosY = (RandomFloat(-strikeArea, strikeArea))
		CasterRef.MoveTo(GetPlayer(), PosX, PosY, height) 
		Wait(1.0)
		LogDebug("CasterRef Moved, do we have a parent = " + CasterRef.GetParentCell() + ", 3D=" + CasterRef.Is3DLoaded() +", Attached=" + CasterRef.GetParentCell().IsAttached() + " X:" + PosX + " Y:" + PosY)
		if (CasterRef.GetParentCell() != None)
			if (CasterRef.GetParentCell().IsAttached()) 
				visable = true
				LogDebug("+++ Caster  [ X:" + CasterRef.X + " Y:" + CasterRef.Y + " Z:" + CasterRef.Z + "] Distance from Player: " + GetPlayer().GetDistance(CasterRef))
			endif
		endif
	endwhile

EndFunction


Function PlaceTarget(Bool forking)
	bool visable = false
	Float strikeOffsetAttempt = strikeOffset
	while (!visable)
		TargetRef = CasterRef.PlaceAtme(MintyActivator,1)
		PositionTarget(TargetRef, CasterRef, strikeOffsetAttempt)

		if (forking)
			TargetRef.setPosition(TargetRef.X, TargetRef.Y, GetPlayer().Z)
		endif
	
		if (TargetRef.GetParentCell() != None) 
			if (TargetRef.GetParentCell().IsAttached()) 
				visable = true
				LogDebug(" |- Target is attached, 3D Loaded=" + TargetRef.Is3DLoaded())
				LogDebug(" |- Target  [ X:" + TargetRef.X + " Y:" + TargetRef.Y + " Z:" + TargetRef.Z + " Distance:" +  CasterRef.GetDistance(TargetRef))
			endif
		endif
		strikeOffsetAttempt = strikeOffsetAttempt - 50.0 ; HACK
	endwhile
EndFunction


Function Dispose()
	if CasterRef != None
		CasterRef.disable()
		CasterRef.delete()
	endif				
	if TargetRef != None
		TargetRef.disable()
		TargetRef.delete()
	endif	
EndFunction


Float Function GetBloomIntensity()
	Float distance = GetPlayer().GetDistance(CasterRef)
	LogDebug("Casting Distance = " + distance + " away from player.")
	return bloom
EndFunction


Function FireFork()
	MintyDA09BloomImod.apply(GetBloomIntensity())
	spellToCastFork.Cast(CasterRef, TargetRef)
	LogInfo("Fork Lightning Casted")
	Wait(minAnimationTime)
	MintyDA09BloomImod.remove()					
EndFunction


Function FireSheet()
	MintyDA09BloomImod.apply(GetBloomIntensity())
	spellToCastSheet.Cast(CasterRef, TargetRef)
	LogInfo("Sheet Lightning Casted")
	Wait(minAnimationTime)
	MintyDA09BloomImod.remove()	
EndFunction


; Full Credit to RandoomNoob for the following Trig Function ;o)
Function PositionTarget(ObjectReference Target, ObjectReference Caster, Float Offset)
    Float AngleX = Caster.GetAngleX()
    Float AngleZ = Caster.GetAngleZ()
    Float DistanceZ = Offset * Math.Sin(-AngleX)
    Float DistanceXY = Offset * Math.Cos(-AngleX)
    Float DistanceX = DistanceXY * Math.Sin(AngleZ)
    Float DistanceY = DistanceXY * Math.Cos(AngleZ)
	Target.MoveTo(Caster, DistanceX, DistanceY, 0.0) ;DistanceZ
	LogDebug("Is target 3D visable " + Target.Is3DLoaded())
EndFunction


Function InitLightning()
	if isLightningHostile == True
		LogDebug("Going with Hostile Lightning")
		spellToCastFork = MintyForkLightningSpellHostile
		spellToCastSheet = MintySheetLightningSpellHostile
	else
		LogDebug("Going with Harmless Lightning")
		spellToCastFork = MintyForkLightningSpell
		spellToCastSheet = MintySheetLightningSpell
	endif
EndFunction


Function playSkyHazard(ObjectReference Caster)
	if MintyLightningHazard != none
		;Caster.placeAtMe(MintyLightningHazard)
		; REMEMBER TO REMOVE IF PLACED
	endif	
EndFunction


; IMOD Effects, @ TODO move to external script


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


Float Function getImodIntensity(ObjectReference Caster) 
	Float distance = GetPlayer().GetDistance(Caster)
	if ((distance <= (cellSize * 3)) && (distance >= (cellSize * 2)))
		return 0.10
	elseif ((distance <= (cellSize * 2)) && (distance >= cellSize))
		return 0.15
	else
		return 0.25
	endif
EndFunction


; Weather functions @ TODO MOve to external script

int SKYMODE_FULL = 3
int WEATHER_RAINING = 2

bool Function isStormWeather() 
	;MAGProjectileStormVar.setValue(1.0) ;We need this global for the Clear Skys shout to stop all Projectile Storms.
	;if MAGProjectileStormVar.GetValue() == 1.0

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
		isBad = true
	elseif GetCurrentWeather() == SkyrimStormRainFF
		isBad = true
	elseif GetCurrentWeather() == SkyrimStormRain
		isBad = true
	elseif GetCurrentWeather() == SkyrimOvercastRainVT
		isBad = true
	elseif GetCurrentWeather() == FXMagicStormRain
		isBad = true
	else
		isBad = false
	endif
	return isBad
EndFunction


bool Function IsOutsideWithFullSky() 
	return (GetSkyMode() == SKYMODE_FULL)
EndFunction


bool Function IsWeatherRaining() 
	return (GetCurrentWeather().GetClassification() == WEATHER_RAINING)
EndFunction


bool Function IsWeatherTransitioning() 
	return !(GetCurrentWeatherTransition() == 1.0)
EndFunction


; Logging Functions, @TODO MOVE to utility script
int INFO = 0
int WARN = 1
int ERROR = 2

Function LogDebug(String msg) 
	if (logDebugMessages)
		 TraceUser(LogFile,msg)
	endif
EndFunction


Function LogInfo(String msg) 
	if (showDebugMessages)
		Notification(msg)
	endif
	LogDebug(msg)
EndFunction


Function LogWarn(String msg) 
	TraceStack("!WARN:" + msg, WARN)
	LogInfo(msg)
EndFunction


Function LogError(String msg) 
	if (showDebugMessages)
		TraceAndBox("!ERROR:" + msg, ERROR)
	elseif (logDebugMessages)
		TraceStack("!ERROR:" + msg, ERROR) 
	endif
EndFunction
