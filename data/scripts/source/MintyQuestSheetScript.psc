Scriptname MintyQuestSheetScript extends MintyWeatherUtils  
{ Quest to control the Sheet lightning strikes }

import MintyUtility
import game
import utility
import Weather

Activator property MintyActivator Auto
FormList Property MintySheetLightningSpells Auto
FormList Property MintySheetLightningSpellsHostile Auto
ImageSpaceModifier property MintySheetBloomImod Auto

Spell spellToCastSheet = None
ObjectReference CasterRef = None
ObjectReference TargetRef = None
Actor Property Player Auto

Weather Property SkyrimStormRainTU Auto ; 10a241
Weather Property SkyrimStormRainFF Auto ; 10a23c
Weather Property SkyrimStormRain Auto ; C8220
Weather Property SkyrimOvercastRainVT Auto ; 10A746
Weather Property FXMagicStormRain Auto ; D4886

Event OnInit()
	GotoState("CastingSheetStorm")
	Info("Casting Sheet Storm")
	RegisterForSingleUpdate(getUpdateFrequency())		
EndEvent


State CastingSheetStorm

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		if (isStormWeather())
			Debug("Storm Weather Detected - Sheeting, in " + getUpdateFrequency())
			if (isSheetEnabled())
				FireLightningStrike()
				Dispose()
			endif
		endif
		RegisterForSingleUpdate(getUpdateFrequency())		
	endEvent
	
EndState


Float Function getUpdateFrequency()
	return (getUpdateFrequencySheet() + RandomFloat(0.0, getUpdateFrequencySheet()))
EndFunction


Function FireLightningStrike()
	Debug("*** Player  [ X:" + Player.X + " Y:" + Player.Y + " Z:" + Player.Z + "] Player is " + Player)
	PlaceTarget()
	PlaceCaster()
	if (isSheetLightningHostile())
		FireLightningHostile()
	else
		FireLightning()		
	endif
	Debug("Target:" + TargetRef + " : 3D=" + TargetRef.Is3DLoaded() + " : Parent=" + TargetRef.GetParentCell())	
EndFunction


Function FireLightning()
	int size = MintySheetLightningSpells.GetSize() - 1
	int rand = RandomInt(0, size)
	spellToCastSheet = MintySheetLightningSpells.GetAt(rand) as Spell
	CastStrike(spellToCastSheet)
	Info("Sheet Lightning Casted")
EndFunction


Function FireLightningHostile()
	int Size = MintySheetLightningSpellsHostile.GetSize() - 1
	int rand = RandomInt(0, size)
	spellToCastSheet = MintySheetLightningSpellsHostile.GetAt(rand) as Spell
	CastStrike(spellToCastSheet)
	Info("Hostile Sheet Lightning Casted")
EndFunction


Function FireAllLightning()
	int index = MintySheetLightningSpells.GetSize() 
	While(index > 0)
		index -= 1
		spellToCastSheet = MintySheetLightningSpells.GetAt(index) as Spell
		CastStrike(spellToCastSheet)
		Info("Sheet Lightning Casted")
	endwhile
EndFunction


Function CastStrike(Spell strike)
	MintySheetBloomImod.Apply(getSheetBloom())
	strike.Cast(CasterRef, TargetRef)
	Wait(getSheetWait())
    MintySheetBloomImod.Remove() 
EndFunction

Function CastImod()
	Float fTDistance = Player.GetDistance(TargetRef)
	fTDistance = (getMinOffset()  - fTDistance)
	if fTDistance <= 0
		MintySheetBloomImod.apply(0.25) 
	else
		fTDistance = (fTDistance / getMinOffset())
		if fTDistance < 0.25
			fTDistance = 0.25
		endif
		MintySheetBloomImod.apply(fTDistance) 
	endif	
EndFunction


Float Function getOffsetDistance()
	Float offset = RandomFloat(getMinOffset(), getMaxOffset())
	Info("Sheet: getOffsetDistance: " + offset)
	return offset
EndFunction


Float Function getMinOffset() 
	if (getSheetDistanceMin() == 0)
		return RandomFloat(0.0, getCellSize())
	else
		return (getSheetDistanceMin() * getCellSize())
	endif
EndFunction


Float Function getMaxOffset()
	if (getSheetDistanceMax() == 0)
		return RandomFloat(0.0, getCellSize())
	else 
		return (getSheetDistanceMax() * getCellSize())
	endif
EndFunction



Function PlaceCaster()
	while (CasterRef == None)
		CasterRef = TargetRef.PlaceAtme(MintyActivator,1)
		Debug("CasterRef Placed : " + CasterRef)
	endwhile
	bool visable = false
	while (!visable)
  		PositionRandomCaster(CasterRef, TargetRef, getStrikeDistance())
		Debug("Sheet: CasterRef Moved, do we have a parent = " + CasterRef.GetParentCell() + ", 3D=" + CasterRef.Is3DLoaded() +", Attached=" + CasterRef.GetParentCell().IsAttached())
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
		if (shouldPlaceStrikeHeightsByRegion())
			PositionSheetStrikeByRegion(TargetRef, GetPlayer(), getOffsetDistance(), getRandomOffsetAngle(), shouldFaceTarget())
		else		
			MoveRefToPositionRelativeTo(TargetRef, GetPlayer(), getOffsetDistance(), getRandomOffsetAngle(), shouldFaceTarget(), GetCellHeight())
		endif
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


Float Function getStrikeHeightDependingOnWeather()
	Weather current = GetCurrentWeather()
	if (current == SkyrimStormRainTU) ; 10a241
		return -904.0
	elseif (current == SkyrimStormRainFF) ; 10a23c
		return 14596.0
	elseif (current == SkyrimStormRain) ; C8220
		return 3979.0
	elseif (current == SkyrimOvercastRainVT) ; 10A746
		return -5904.0
	endif  
	return (Player.Z + 4096.0) ; FXMagicStormRain D4886	
EndFunction


Function PositionSheetStrikeByRegion(ObjectReference akSubject, ObjectReference akTarget, Float OffsetDistance = 0.0, Float OffsetAngle = 0.0, bool FaceTarget = True) 
	float AngleZ = akTarget.GetAngleZ() + OffsetAngle
	float OffsetX = OffsetDistance * Math.Sin(AngleZ)
	float OffsetY = OffsetDistance * Math.Cos(AngleZ)
	akSubject.MoveTo(akTarget, OffsetX, OffsetY, getStrikeHeightDependingOnWeather())
	if (FaceTarget)
		akSubject.SetAngle(akSubject.GetAngleX(), akSubject.GetAngleY(), akSubject.GetAngleZ() + akSubject.GetHeadingAngle(akTarget))
	endif
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
