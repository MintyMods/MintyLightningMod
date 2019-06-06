Scriptname MintyQuestSheetScript extends MintyQuestScript  
{Quest to control Sheet lightning}

import game
import utility

; Props
Activator property MintyActivator Auto
ImageSpaceModifier property MintyDA09BloomImod Auto
FormList Property MintySheetLightningSpells Auto
FormList Property MintySheetLightningSpellsHostile Auto

; Variables
Spell spellToCastSheet = None
ObjectReference CasterRef = None
ObjectReference TargetRef = None


Event OnInit()
	GotoState("CastingSheetStorm")
	Info("Casting Sheet Storm")
	RegisterForSingleUpdate(getUpdateFrequency())		
EndEvent


; STATES
State CastingSheetStorm

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		bool weatherBad = isStormWeather()
		if (weatherBad)
			Debug("Storm Weather Detected - Sheeting, in " + getUpdateFrequency())
			if (isSheetEnabled)
				FireLightningStrike()
				Dispose()
			endif
		endif
		RegisterForSingleUpdate(getUpdateFrequency())		
	endEvent
	
EndState

Function FireLightningStrike()
	PlaceCaster()
	if (isLightningHostile)
		FireSheetHostile()
	else
		FireSheet()
	endif
	Debug("Target:" + TargetRef + " : 3D=" + TargetRef.Is3DLoaded() + " : Parent=" + TargetRef.GetParentCell())	
EndFunction


Function FireLightning()
	int Size = MintySheetLightningSpells.GetSize()
	int rand = RandomInt(1, size)
	int position = rand - 1
	spellToCastSheet = MintySheetLightningSpells.GetAt(position) as Spell
	spellToCastSheet.Cast(CasterRef, TargetRef)
	Info("Sheet Lightning Casted")
EndFunction


Function FireAllLightning()
	int index = MintySheetLightningSpells.GetSize() 
	While(index > 0)
		index -= 1
		spellToCastSheet = MintySheetLightningSpells.GetAt(index) as Spell
		spellToCastSheet.Cast(CasterRef, TargetRef)
		Info("Sheet Lightning Casted")
	endwhile
EndFunction


Function FireSheet()
	PlaceTarget()
	MintyDA09BloomImod.apply(GetBloomIntensity())
	firelightning()
	Wait(minAnimationTimeSheet)
	MintyDA09BloomImod.remove()	
EndFunction


Function FireSheetHostile()
	int index = MintySheetLightningSpellsHostile.GetSize() 
	While(index > 0)
		index -= 1
		PlaceTarget()
		spellToCastSheet = MintySheetLightningSpellsHostile.GetAt(index) as Spell
		MintyDA09BloomImod.apply(GetBloomIntensity())
		spellToCastSheet.Cast(CasterRef, TargetRef)
		Info("Hostile Sheet Lightning Casted")
		Wait(minAnimationTimeSheet)
		MintyDA09BloomImod.remove()	
	endwhile
EndFunction


Float Function getUpdateFrequency()
	return (updateFrequencySheet + (RandomFloat(0.0, updateFrequencySheet)))
EndFunction


Function PlaceCaster()

	Float strikeArea = halfCellSize
	strikeArea = (halfCellSize * distanceSheetMaxMultiplyer)
	
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
		wait(0.1)
		Debug("CasterRef Moved, do we have a parent = " + CasterRef.GetParentCell() + ", 3D=" + CasterRef.Is3DLoaded() +", Attached=" + CasterRef.GetParentCell().IsAttached() + " X:" + PosX + " Y:" + PosY)
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
	return bloomSheet
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


