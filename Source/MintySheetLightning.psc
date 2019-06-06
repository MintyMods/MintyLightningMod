Scriptname MintySheetLightning extends activemagiceffect  

import debug
import utility
import game

Spell Property SpellToCast Auto
Activator property MintyActivator Auto

ObjectReference CasterRef = None
ObjectReference TargetRef = None

; Event received when this effect is first started (OnInit may not have been run yet!)
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Notification("Casting")
	PlaceCaster()
	
	RegisterForSingleUpdate(1.0)
	MessageBox("Testing")
EndEvent

Event OnUpdate()
	PlaceTarget()
	Wait(1.0)
	;SpellToCast.Cast(CasterRef, TargetRef)
	SpellToCast.RemoteCast(CasterRef, getPlayer(), TargetRef)
	Wait(3.0)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	Dispose()
EndEvent

Event OnInit() 
	Notification("Cast Test")
EndEvent

Function PlaceCaster()

	Float strikeArea = 4096.0
	Float height = 3096
	
	if (CasterRef == None)
		CasterRef = GetPlayer().PlaceAtme(MintyActivator,1)
		wait(1.0)
	endif

	bool visable = false
	while (!visable)
		Float PosX = (RandomFloat(-strikeArea, strikeArea))
		Float PosY = (RandomFloat(-strikeArea, strikeArea))
		CasterRef.MoveTo(GetPlayer(), PosX, PosY, height) 
		Wait(1.0)
		if (CasterRef.GetParentCell() != None)
			if (CasterRef.GetParentCell().IsAttached()) 
				visable = true
			endif
		endif
	endwhile

EndFunction


Function PlaceTarget()
	bool visable = false
	Float strikeOffsetAttempt = 200.0
	while (!visable)
		TargetRef = CasterRef.PlaceAtme(MintyActivator,1)
		PositionTarget(TargetRef, CasterRef, strikeOffsetAttempt)
		Wait(1.0)
		if (TargetRef.GetParentCell() != None) 
			if (TargetRef.GetParentCell().IsAttached()) 
				visable = true
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


; Full Credit to RandoomNoob for the following Trig Function ;o)
Function PositionTarget(ObjectReference Target, ObjectReference Caster, Float Offset)
    Float AngleX = Caster.GetAngleX()
    Float AngleZ = Caster.GetAngleZ()
    Float DistanceZ = Offset * Math.Sin(-AngleX)
    Float DistanceXY = Offset * Math.Cos(-AngleX)
    Float DistanceX = DistanceXY * Math.Sin(AngleZ)
    Float DistanceY = DistanceXY * Math.Cos(AngleZ)
	Target.MoveTo(Caster, DistanceX, DistanceY, 0.0) ;DistanceZ
EndFunction
