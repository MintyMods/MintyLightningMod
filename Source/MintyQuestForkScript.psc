Scriptname MintyQuestForkScript extends MintyQuestScript
{Quest to control Fork lightning}

;import debug
import game
import utility

; Props
Activator property MintyActivator Auto
ImageSpaceModifier property MintyDA09BloomImod Auto
FormList Property MintyForkLightningSpells Auto
FormList Property MintyForkLightningSpellsHostile Auto

; Variables
Spell spellToCastFork = None
ObjectReference CasterRef = None
ObjectReference TargetRef = None


Event OnInit()
	GotoState("CastingForkStorm")
	Info("Casting Fork Storm")
	RegisterForSingleUpdate(getUpdateFrequency())		
EndEvent


; STATES
State CastingForkStorm

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		bool weatherBad = isStormWeather()
		if (weatherBad)			
			Debug("Storm Weather Detected - Forking, in " + getUpdateFrequency())
			if (isForkEnabled)
				FireLightningStrike()			
				Debug("Target:" + TargetRef + " : 3D=" + TargetRef.Is3DLoaded() + " : Parent=" + TargetRef.GetParentCell())	
				Dispose()
			endif
		endif
		RegisterForSingleUpdate(getUpdateFrequency())		
	endEvent

EndState

Function FireLightningStrike()
	PlaceCaster()
	if (isLightningHostile)
		FireForkHostile()
	else 
		FireFork()
	endif
EndFunction


Function FireFork()
	int index = MintyForkLightningSpells.GetSize() 
	While(index > 0)
		index -= 1
		PlaceTarget()
		;if (spellToCastFork.IsHostile())
		spellToCastFork = MintyForkLightningSpells.GetAt(index) as Spell
		MintyDA09BloomImod.apply(GetBloomIntensity())
		Info("Fork Lightning Casted")
		spellToCastFork.Cast(CasterRef, TargetRef)
		Wait(minAnimationTimeFork)
		MintyDA09BloomImod.remove()
	EndWhile
EndFunction


Function FireForkHostile()
	int index = MintyForkLightningSpellsHostile.GetSize() 
	While(index > 0)
		index -= 1
		PlaceTarget()
		spellToCastFork = MintyForkLightningSpellsHostile.GetAt(index) as Spell
		MintyDA09BloomImod.apply(GetBloomIntensity())
		Info("Hostile Fork Lightning Casted")
		spellToCastFork.Cast(CasterRef, TargetRef)
		Wait(minAnimationTimeFork)
		MintyDA09BloomImod.remove()
	EndWhile
EndFunction


Float Function getUpdateFrequency()
	return (updateFrequencyFork + (RandomFloat(0.0, updateFrequencyFork)))
EndFunction


Function PlaceCaster()

	Float strikeArea = halfCellSize
	strikeArea = (halfCellSize * distanceForkMaxMultiplyer)
	
	while (CasterRef == None)
		CasterRef = GetPlayer().PlaceAtme(MintyActivator,1)
		wait(0.1)
		Debug("CasterRef Placed : " + CasterRef)
	endwhile

	Debug("*** Player  [ X:" + GetPlayer().X + " Y:" + GetPlayer().Y + " Z:" + GetPlayer().Z + "] Player is " + GetPlayer())
	
	bool visable = false
	while (!visable)
		Float PosX = (RandomFloat(-strikeArea, strikeArea))
		Float PosY = (RandomFloat(-strikeArea, strikeArea))
		CasterRef.MoveTo(GetPlayer(), PosX, PosY, height) 
		Wait(0.1)
		;Debug("CasterRef Moved, do we have a parent = " + CasterRef.GetParentCell() + ", 3D=" + CasterRef.Is3DLoaded() +", Attached=" + CasterRef.GetParentCell().IsAttached() + " X:" + PosX + " Y:" + PosY)
		if (CasterRef.GetParentCell() != None)
			if (CasterRef.GetParentCell().IsAttached()) 
				visable = true
				Debug("+++ Caster  [ X:" + CasterRef.X + " Y:" + CasterRef.Y + " Z:" + CasterRef.Z + "] Distance from Player: " + GetPlayer().GetDistance(CasterRef))
			endif
		endif
	endwhile

EndFunction


Function PlaceTarget()
	bool visable = false
	Float strikeOffsetAttempt = strikeDistance
	while (!visable)
		TargetRef = CasterRef.PlaceAtme(MintyActivator,1)
		PositionTarget(TargetRef, CasterRef, strikeOffsetAttempt)
		TargetRef.setPosition(TargetRef.X, TargetRef.Y, GetPlayer().Z)
		
		if (TargetRef.GetParentCell() != None) 
			if (TargetRef.GetParentCell().IsAttached()) 
				visable = true
				Debug(" |- Target is attached, 3D Loaded=" + TargetRef.Is3DLoaded())
				Debug(" |- Target  [ X:" + TargetRef.X + " Y:" + TargetRef.Y + " Z:" + TargetRef.Z + " Distance:" +  CasterRef.GetDistance(TargetRef))
			endif
		endif
		strikeOffsetAttempt = strikeOffsetAttempt - 10.0 ; HACK
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


Float Function getBloom()
	return bloomFork
EndFunction


Float Function GetBloomIntensity()
	Float distance = GetPlayer().GetDistance(CasterRef) ; strikeDistance
	distance = (getBloom() - distance)
	
	if distance <= 0
		return 0.25
	else
		distance = (distance / getBloom())
		if distance < 0.25
			distance = 0.25
		endif
	endif
	Debug("BloomIntensity Distance = " + distance + ", Bloom = " + getBloom())
	return distance
EndFunction

