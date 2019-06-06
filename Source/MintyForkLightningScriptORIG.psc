Scriptname MintyForkLightningScript extends activemagiceffect  

import weather
import utility
import game
import debug

;======================================================================================;
;  PROPERTIES  /
;=============/
Activator property MintyActivator Auto
Spell property MintyForkLightningSpell auto
GlobalVariable Property MAGProjectileStormVar auto
MintyQuestScript Property MintyLightningQuest Auto
bool Property isBusyCasting = false auto 

;======================================================================================;
;  VARIABLES   /
;=============/

Float height = 3584.0
Float fXYBaseRandom = 4096.0
Float fPOSRandom = 512.0

; Props
ObjectReference CasterRef = None
ObjectReference TargetRef = None

Float PosX 
Float PosY  
Float PosZ 
Float TPosX 
Float TPosY  
Float TPosZ 
Float fTDistance

Actor player
Actor CasterActor
Actor TargetActor

;======================================================================================;
;   EVENTS     /
;=============/


Event OnInit()
	Trace("Init Fork Lightning")
	player = GetPlayer()
	isBusyCasting = true
EndEvent


Event OnEffectStart(Actor Target, Actor Caster)
	Notification("Building Fork Lightning effect")	

	TargetActor = Target
	CasterActor = Caster	
		
	ObjectReference PlaceTarget = None
	PlaceTarget = GetPlayer().PlaceAtMe(MintyActivator,1)
    Wait(1)
	
	PosX = GetPlayer().GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
	PosY = GetPlayer().GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
	PosZ = GetPlayer().GetPositionZ() + height
	PlaceTarget.MoveTo(GetPlayer(), PosX, PosY, PosZ) ; Position our CasterRef
	Wait(1.0)
	CasterRef = PlaceTarget.PlaceAtme(MintyActivator,1)                     
	Wait(1.0)	
	
	TPosX = GetPlayer().GetPositionX() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
	TPosY = GetPlayer().GetPositionY() + RandomFloat(-fXYBaseRandom,fXYBaseRandom)
	TPosZ = GetPlayer().GetPositionZ() 
	PlaceTarget.MoveTo(CasterRef, TPosX, TPosY, TPosZ) ; Position our TargetRef
	Wait(1.0)
	TargetRef = PlaceTarget.PlaceAtMe(MintyActivator,1)
	Wait(1.0)	

	RegisterForSingleUpdate(3.0)
EndEvent



Event OnUpdate()
Notification("On Update")	
	debug.trace("updating")
	if (CasterRef.GetParentCell() != none)
		debug.trace("Target actor has parent cell")
		if (TargetRef.GetParentCell() != none)
		
	
		
		
;			PosX = RandomFloat(-fXYBaseRandom,fXYBaseRandom)
;			PosY = RandomFloat(-fXYBaseRandom,fXYBaseRandom)
;			PosZ = height
;			CasterRef.MoveTo(player, PosX ,PosY ,PosZ)
;			;CasterRef.SetPosition(PosX,PosY,PosZ)
;			Wait(3)
;			TPosX = RandomFloat(-fXYBaseRandom,fXYBaseRandom)
;			TPosY = RandomFloat(-fXYBaseRandom,fXYBaseRandom)
;			;TPosZ = player.GetPositionZ()
;			TargetRef.MoveTo(player, TPosX, TPosY, 0.0)
;			;TargetRef.SetPosition(TPosX, TPosY, TPosZ)
;			Wait(3)					
		
			debug.trace("ActivatorRef has parent cell")
			Notification("Casting Fork Lightning...")
			;MintyForkLightningSpell.Cast(CasterRef, TargetRef)
			Trace("CasterRef:" + CasterRef)
			Trace("TargetRef:" + TargetRef)
			MintyForkLightningSpell.RemoteCast(CasterRef, None, TargetRef)
			
			Wait(3.5)
		endIf
	endif
endEvent


Event OnEffectFinish(Actor Target, Actor Caster)
	debug.Trace("Ending Fork Lightning Strike")
	Wait(2.0)
	isBusyCasting = false
	if (CasterRef != none)
		CasterRef.disable()
		CasterRef.delete()
	endif
	if (TargetRef != none)
		TargetRef.disable()
		TargetRef.delete()
	endif
EndEvent
