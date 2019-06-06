Scriptname MintySheetLightningScript extends activemagiceffect  

import weather
import utility
import game
import debug

;======================================================================================;
;  PROPERTIES  /
;=============/
activator property FxEmptyPlacedActivator auto
{The name of the placed Activator that the spell will come from. (REQUIRED!)}
activator property FxEmptyPlacedTargetActivator auto
{The name of the placed Activator we aiming at for missing (REQUIRED! if missing)}
Spell property MintySheetLightningSpell auto
{The name of the Spell the Sky will cast. (REQUIRED!)}
GlobalVariable Property MAGProjectileStormVar auto

;======================================================================================;
;  VARIABLES   /
;=============/

Float fHeight = 3584.0; {From how high in the sky should the spell be cast? (Default = 3584.0)}

Float fXYBaseRandom = 3000.0; {Moves the casting point a random amount up to this value before first cast.  Also is the size of the area we aim for on "Miss" shots. (Default = 1500.0)}

Float fPOSRandom = 512.0; {We move the casting point by up to this amount each time we fire (Default = 512.0)}

objectReference ActivatorRef
objectReference ActivatorTargetRef
Actor CasterActor
Actor TargetActor
Float PosX 
Float PosY  
Float PosZ 
Float TPosX 
Float TPosY  
Float TPosZ 
Float fTDistance
objectReference CastFromHereRef
bool bCasterIsPlayer = false
Actor player

;======================================================================================;
;   EVENTS     /
;=============/

Event OnInit()
		player = GetPlayer()
EndEvent


Event OnEffectStart(Actor Target, Actor Caster)
		Notification("Casting Sheet Lightning")

		MAGProjectileStormVar.setValue(1.0) ;We need this global for the Clear Skys shout to stop all Projectile Storms.
		
		TargetActor = Target
		CasterActor = Caster
		
		if CasterActor == GetPlayer()
			bCasterIsPlayer = true
		endif
		
		CastFromHereRef = TargetActor
		ActivatorRef = CastFromHereRef.placeAtMe(FxEmptyPlacedActivator)

		PosX = CastFromHereRef.GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
		PosY = CastFromHereRef.GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
		PosZ = CastFromHereRef.GetPositionZ()
		
		ActivatorTargetRef = Target.placeAtMe(FxEmptyPlacedTargetActivator) ; Miss onPurpose
		PosZ = (PosZ + fHeight)
		ActivatorRef.SetPosition(PosX,PosY,PosZ)
		;RegisterForSingleUpdate(fDelay + RandomFloat(0.0,fStartDelayRand))
		RegisterForSingleUpdate(2)
EndEvent


Event OnUpdate()
	if MAGProjectileStormVar.GetValue() == 1.0
		if (TargetActor.GetParentCell() != none)
			if (ActivatorRef.GetParentCell() != none)
				if MintySheetLightningSpell != none
					ActivatorRef.SetPosition(PosX + RandomFloat(-fPOSRandom,fPOSRandom),PosY + RandomFloat(-fPOSRandom,fPOSRandom),PosZ)
			
						if bCasterIsPlayer == False
							TPosX = player.GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
							TPosY = player.GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
							TPosZ = player.GetPositionZ()
						else
							TPosX = TargetActor.GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
							TPosY = TargetActor.GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
							TPosZ = TargetActor.GetPositionZ()
						endif
						ActivatorTargetRef.SetPosition(TPosX,TPosY,TPosZ)
						if player.GetDistance(ActivatorTargetRef) <= 300
							ActivatorTargetRef.SetPosition((TPosX + 600),(TPosY + 600),TPosZ)
						endif
						
						MintySheetLightningSpell.RemoteCast(ActivatorRef,CasterActor,ActivatorTargetRef)
					
					
						Debug.Trace("moving" + ActivatorTargetRef)		
						ActivatorTargetRef.MoveTo(GetPlayer(), 120 * Math.Sin(GetPlayer().GetAngleZ()), 120 * Math.Cos(GetPlayer().GetAngleZ()), GetPlayer().GetHeight() - 35)
						Debug.Trace("moving" + ActivatorRef)		
						ActivatorRef.MoveTo(GetPlayer(), 120 * Math.Sin(GetPlayer().GetAngleZ()), 120 * Math.Cos(GetPlayer().GetAngleZ()), GetPlayer().GetHeight() )
						
						Debug.Trace("Casting" + MintySheetLightningSpell)		
						MintySheetLightningSpell.RemoteCast(ActivatorRef,CasterActor,ActivatorTargetRef)
						
						Debug.Trace("position" + ActivatorTargetRef)
						ActivatorTargetRef.SetPosition(120 * Math.Sin(GetPlayer().GetAngleZ()), 120 * Math.Cos(GetPlayer().GetAngleZ()), GetPlayer().GetHeight() - 35)
						Debug.Trace("position" + ActivatorRef)
						ActivatorRef.SetPosition(120 * Math.Sin(GetPlayer().GetAngleZ()), 120 * Math.Cos(GetPlayer().GetAngleZ()), GetPlayer().GetHeight() )
						
						MintySheetLightningSpell.RemoteCast(ActivatorRef,CasterActor,ActivatorTargetRef)
					
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
	Notification("Ending Sheet Lightning")
	if (ActivatorRef != none)
		ActivatorRef.disable()
		ActivatorRef.delete()
	endif
	if (ActivatorTargetRef != none)
		ActivatorTargetRef.disable()
		ActivatorTargetRef.delete()
	endif
EndEvent

