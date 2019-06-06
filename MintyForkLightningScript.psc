Scriptname MintyForkLightningScript extends activemagiceffect  

import weather
import utility
import game
import debug

;======================================================================================;
;  PROPERTIES  /
;=============/
activator property FxEmptyPlacedActivator auto
{The name of the placed Activator that the spell will come from. REQUIRED!}
activator property FxEmptyPlacedTargetActivator auto
{The name of the placed Activator we aiming at for missing REQUIRED!}
Spell property MintyForkLightningSpell auto
{The name of the Spell the Sky will cast. (REQUIRED!)}
GlobalVariable Property MAGProjectileStormVar auto

bool Property isBusyCasting = false auto 

;======================================================================================;
;  VARIABLES   /
;=============/

Float fHeight = 3584.0; {From how high in the sky should the spell be cast? (Default = 3584.0)}

Float fXYBaseRandom = 1500.0; {Moves the casting point a random amount up to this value before first cast.  Also is the size of the area we aim for on "Miss" shots. (Default = 1500.0)}

Float fPOSRandom = 512.0; {We move the casting point by up to this amount each time we fire (Default = 512.0)}

objectReference property ActivatorRef auto
objectReference property ActivatorTargetRef auto
Actor CasterActor
Actor TargetActor
Float PosX 
Float PosY  
Float PosZ 
Float TPosX 
Float TPosY  
Float TPosZ 
Float fTDistance


;======================================================================================;
;   EVENTS     /
;=============/


Event OnInit()
	;debug.trace("Init Fork Lightning")
	;Notification("Init Fork Lightning")
	isBusyCasting = true
EndEvent


Event OnEffectStart(Actor Target, Actor Caster)
	GotoState("BusyCastingForkLightning")
	Notification("Building Fork Lightning effect")	
	MAGProjectileStormVar.setValue(1.0) ;We need this global for the Clear Skys shout to stop all Projectile Storms.
	
	TargetActor = Target
	CasterActor = Caster

	;debug.trace("Target X" + Target.GetPositionX() + ", Y" + Target.GetPositionY() +  ", Z" + Target.GetPositionZ())
	
	if (ActivatorRef == none)
		ActivatorRef = GetPlayer().placeAtMe(FxEmptyPlacedActivator,1)
		;ActivatorRef.SetPosition(PosX,PosY,PosZ)	
	endif
	if (ActivatorTargetRef == none) 
		ActivatorTargetRef = GetPlayer().placeAtMe(FxEmptyPlacedTargetActivator,1) ; Miss onPurpose
		;ActivatorTargetRef.SetPosition(PosX,PosY,PosZ)
	endif
	
	Utility.Wait(1)
	
	;RegisterForSingleUpdate(fDelay + RandomFloat(0.0,fStartDelayRand))
;	Self.RegisterForSingleUpdate(2)
	;debug.trace("updating")
	if MAGProjectileStormVar.GetValue() == 1.0
		if (TargetActor.GetParentCell() != none)
			if (ActivatorRef.GetParentCell() != none)
				if MintyForkLightningSpell != none
					;debug.trace("Spell is refernced")
					
					PosX = GetPlayer().GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					PosY = GetPlayer().GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					PosZ = GetPlayer().GetPositionZ()
					PosZ = (PosZ + fHeight)					
					ActivatorRef.SetPosition(PosX + RandomFloat(-fPOSRandom,fPOSRandom),PosY + RandomFloat(-fPOSRandom,fPOSRandom),PosZ)
			
					TPosX = GetPlayer().GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					TPosY = GetPlayer().GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					TPosZ = GetPlayer().GetPositionZ()
					ActivatorTargetRef.SetPosition(TPosX,TPosY,TPosZ)
					
					if GetPlayer().GetDistance(ActivatorTargetRef) <= 300
						debug.Trace("***** Moving target as too close")
						ActivatorTargetRef.SetPosition((TPosX + 600),(TPosY + 600),TPosZ)
						Utility.Wait(0.5)
					endif
					
					debug.Trace("ActivatorRef Position:       X:"+ ActivatorRef.GetPositionX() + ", Y:" + ActivatorRef.GetPositionY() +  ", Z:" + ActivatorRef.GetPositionZ())					
					debug.Trace("ActivatorTargetRef Position: X:"+ ActivatorTargetRef.GetPositionX() + ", Y:" + ActivatorTargetRef.GetPositionY() +  ", Z:" + ActivatorTargetRef.GetPositionZ())
					debug.Trace("***** Spell is ready to fire! Casting from " + ActivatorRef + " at " + ActivatorTargetRef + " and blaming " + CasterActor + "for everything.")
					Notification("Casting Fork Lightning effect")
					;MintyForkLightningSpell.RemoteCast(ActivatorRef,CasterActor,ActivatorTargetRef)
					debug.Trace("spell cast")
					RegisterForSingleUpdate(5)
					
				Endif
			Endif
		else
			if (ActivatorRef != none)
				ActivatorRef.disable()
				ActivatorRef.delete()
			endif
			if (ActivatorTargetRef != none)
				ActivatorTargetRef.disable()
				ActivatorTargetRef.delete()
			endif
		EndIf
	endif
EndEvent



Event OnUpdate()
Notification("On Update")	
	debug.trace("updating")
	if MAGProjectileStormVar.GetValue() == 1.0
		debug.trace("No clear skys detected")
		if (TargetActor.GetParentCell() != none)
			debug.trace("Target actor has parent cell")
			if (ActivatorRef.GetParentCell() != none)
				debug.trace("ActivatorRef has parent cell")
				if MintyForkLightningSpell != none
					debug.trace("Spell is not none")
					ActivatorRef.SetPosition(PosX + RandomFloat(-fPOSRandom,fPOSRandom),PosY + RandomFloat(-fPOSRandom,fPOSRandom),PosZ)
			
					debug.Trace("Casting at player")
					TPosX = GetPlayer().GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					TPosY = GetPlayer().GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
					TPosZ = GetPlayer().GetPositionZ()
					
					ActivatorTargetRef.SetPosition(TPosX,TPosY,TPosZ)
					if GetPlayer().GetDistance(ActivatorTargetRef) <= 300
						debug.Trace("Moving target as too close")
						ActivatorTargetRef.SetPosition((TPosX + 600),(TPosY + 600),TPosZ)
					endif
					
					;debug.Trace("" + MintyForkLightningSpell + " is ready to fire! Casting from " + ActivatorRef + " at " + ActivatorTargetRef + " and blaming " + CasterActor + "for everything.")
					Notification("Casting Fork Lightning...")
					MintyForkLightningSpell.RemoteCast(ActivatorRef,CasterActor,ActivatorTargetRef)
					
					;RegisterForSingleUpdate(5)
					
				Endif
			Endif
		else
			if (ActivatorRef != none)
				ActivatorRef.disable()
				ActivatorRef.delete()
			endif
			if (ActivatorTargetRef != none)
				ActivatorTargetRef.disable()
				ActivatorTargetRef.delete()
			endif
		EndIf
	endif
endEvent


Event OnEffectFinish(Actor Target, Actor Caster)
	GotoState("")
	debug.Trace("Ending Fork Lightning Strike")
	isBusyCasting = false
	if (ActivatorRef != none)
		ActivatorRef.disable()
		ActivatorRef.delete()
	endif
	if (ActivatorTargetRef != none)
		ActivatorTargetRef.disable()
		ActivatorTargetRef.delete()
	endif
EndEvent

state BusyCastingForkLightning
	Event OnInit()
		Notification("!!! Ignoring Init Fork Lightning")
	EndEvent
	event OnEffectStart(Actor Target, Actor Caster)
		; Do nothing
		Notification("!!! Ignoring request")
	endEvent  
endState
