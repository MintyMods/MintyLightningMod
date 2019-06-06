Scriptname MintyQuestForkScript extends MintyWeatherUtils
{ Quest to control the Fork lightning strikes }

import MintyUtility
import game
import utility

Activator property MintyActivator Auto
FormList Property MintyForkLightningSpells Auto
FormList Property MintyForkLightningSpellsHostile Auto
ImageSpaceModifier property MintyForkBloomImod Auto
Spell spellToCastFork = None
ObjectReference CasterRef = None
ObjectReference TargetRef = None
Actor Property Player Auto


Event OnInit()
	GotoState("CastingForkStorm")
	Debug("Casting Fork Storm")
	RegisterForSingleUpdate(getUpdateFrequency())		
EndEvent


; STATES
State CastingForkStorm

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		if (isStormWeather())			
			Debug("Storm Weather Detected - Forking, in " + getUpdateFrequency())
			if (isForkEnabled())
				FireLightningStrike()			
				Dispose()
			endif
		endif
		RegisterForSingleUpdate(getUpdateFrequency())		
	endEvent
	
EndState


Function FireLightningStrike()
	Debug("*** Player  [ X:" + Player.X + " Y:" + Player.Y + " Z:" + Player.Z + "] Player is " + Player)
	PlaceTarget()
	PlaceCaster()
	if (isForkLightningHostile())
		FireLightningHostile()
	else 
		FireLightning()
	endif
	Debug("Target:" + TargetRef + " : 3D=" + TargetRef.Is3DLoaded() + " : Parent=" + TargetRef.GetParentCell())	
EndFunction


Function FireLightning()
	int Size = MintyForkLightningSpells.GetSize()
	int rand = RandomInt(1, size)
	int position = rand - 1
	spellToCastFork = MintyForkLightningSpells.GetAt(position) as Spell
	CastStrike(spellToCastFork)
	Info("Fork Lightning Casted")
EndFunction


Function FireLightningHostile()
	int Size = MintyForkLightningSpells.GetSize()
	int rand = RandomInt(1, size)
	int position = rand - 1
	spellToCastFork = MintyForkLightningSpellsHostile.GetAt(position) as Spell
	CastStrike(spellToCastFork)
	Info("Hostile Fork Lightning Casted")
EndFunction


Function FireAllLightning()
	int index = MintyForkLightningSpells.GetSize() 
	While(index > 0)
		index -= 1
		spellToCastFork = MintyForkLightningSpells.GetAt(index) as Spell
		CastStrike(spellToCastFork)
		Info("** Fork Lightning Casted")
	endwhile
EndFunction


Function CastStrike(Spell strike)
	strike.Cast(CasterRef, TargetRef)
	ApplyBloom()
EndFunction

Function ApplyBloom()
	MintyForkBloomImod.Apply(getForkBloom())
	Wait(getForkWait())
    MintyForkBloomImod.Remove() 
EndFunction

Float Function getUpdateFrequency()
	return (getUpdateFrequencyFork() + RandomFloat(0.0, getUpdateFrequencyFork()))
EndFunction


Float Function getOffsetDistance()
	Float offset = RandomFloat(getMinOffset(), getMaxOffset())
	Info("Fork: getOffsetDistance: " + offset)
	return offset
EndFunction


Float Function getMinOffset() 
	if (getForkDistanceMin() == 0)
		return RandomFloat(0.0, getCellSize())
	else
		return (getForkDistanceMin() * getCellSize())
	endif
EndFunction


Float Function getMaxOffset()
	if (getForkDistanceMax() == 0)
		return RandomFloat(0.0, getCellSize())
	else 
		return (getForkDistanceMax() * getCellSize())
	endif
EndFunction


Function PlaceCaster()
	while (CasterRef == None)
		CasterRef = TargetRef.PlaceAtme(MintyActivator,1)
		Debug("CasterRef Placed : " + CasterRef)
	endwhile	
	bool visable = false
	while (!visable)
		MoveRefToPositionRelativeTo(CasterRef, TargetRef, getStrikeDistance(), 0.0, shouldFaceTarget(), GetCellHeight())
		Debug("Fork: CasterRef Moved, do we have a parent = " + CasterRef.GetParentCell() + ", 3D=" + CasterRef.Is3DLoaded() +", Attached=" + CasterRef.GetParentCell().IsAttached())
		if (CasterRef.GetParentCell() != None)
			if (CasterRef.GetParentCell().IsAttached()) 
				visable = true
				Debug("+++ Caster  [ X:" + CasterRef.X + " Y:" + CasterRef.Y + " Z:" + CasterRef.Z + "] Distance from Player: " + Player.GetDistance(CasterRef))
			endif
		endif
	endwhile
EndFunction


Function PlaceTarget()
	bool visable = false
	while (TargetRef == None)
		TargetRef = Player.PlaceAtme(MintyActivator,1)
	endwhile
	while (!visable)
		MoveRefToPositionRelativeTo(TargetRef, GetPlayer(), getOffsetDistance(), getRandomOffsetAngle(), shouldFaceTarget(), 0.0)
		if (TargetRef.GetParentCell() != None) 
			if (TargetRef.GetParentCell().IsAttached()) 
				visable = true
				Debug(" |- Target is attached, 3D Loaded=" + TargetRef.Is3DLoaded())
				if (CasterRef != None)
					Debug(" |- Target  [ X:" + TargetRef.X + " Y:" + TargetRef.Y + " Z:" + TargetRef.Z + " Distance:" +  CasterRef.GetDistance(TargetRef))
				endif
			endif
		endif
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
