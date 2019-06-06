Scriptname MintyQuestScript extends MintyWeatherUtils Conditional
{Place holder to hook into weather system}

import game
import utility

Quest Property qMintyLightningQuestFork Auto
Quest Property qMintyLightningQuestSheet Auto

; Script available variables
Bool Property isLightningHostile = False Auto
Bool Property isSheetEnabled = True Auto
Bool Property isForkEnabled = True Auto
int Property distanceForkMinMultiplyer = 1 Auto
int Property distanceForkMaxMultiplyer = 2 Auto
int Property distanceSheetMinMultiplyer = 2 Auto
int Property distanceSheetMaxMultiplyer = 4 Auto
Float Property updateFrequency = 0.5 Auto
Float Property updateFrequencyFork = 2.0 Auto
Float Property updateFrequencySheet = 2.0 Auto
Float Property bloomFork = 3.0 Auto  
Float Property bloomSheet = 3.0 Auto  
Float Property minAnimationTimeFork = 0.3 Auto 
Float Property minAnimationTimeSheet = 0.3 Auto 
Float Property strikeDistance = 100.0 Auto
Float Property height = 4096.0 Auto
Float Property halfCellSize = 2048.0 Auto

; TEMP - debugging aid, so we can test changes without going to forking WhiteRun again! ;o)
Book Property MintyLightningConfigBook Auto
Book Property MintyCreditNote Auto
Form Property MintyDebuggingRing Auto 
Spell Property MintySheetLightningSpellNew Auto


Event OnInit()
	GotoState("WatchingTheWeather")
	Info("Minty Lightning Quest (Version:" + version + ") Init...")
	InitDebugging()
	RegisterForSingleUpdate(updateFrequency)		
EndEvent


; STATES
State WatchingTheWeather

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		bool weatherBad = isStormWeather()
		if (weatherBad)
			Debug("Storm Weather Detected - Updating, in " + updateFrequency)
			qMintyLightningQuestFork.start()
			qMintyLightningQuestSheet.start()
		else 
			Debug("Shutting down weather system")
			qMintyLightningQuestFork.stop()
			qMintyLightningQuestSheet.stop()
		endif
		RegisterForSingleUpdate(updateFrequency)		
	endEvent
	
EndState


Function InitDebugging()
	if (debugging)
		if (GetPlayer().GetItemCount(MintyLightningConfigBook) < 1)
			Debug("Adding Book")
			GetPlayer().addItem(MintyLightningConfigBook,1)
		endif
		if (GetPlayer().GetItemCount(MintyDebuggingRing) < 1)
			Debug("Adding Ring")
			GetPlayer().addItem(MintyDebuggingRing)
		endif
		if (GetPlayer().GetItemCount(MintyCreditNote) < 1)
			Debug("Adding Spell")
			GetPlayer().addItem(MintyCreditNote)
		endif
	endif
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
	Wait(0.1)
	Debug("Is target 3D visable " + Target.Is3DLoaded())
EndFunction

