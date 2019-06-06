Scriptname MintyActivatorScript extends ObjectReference  
{Fires a spell from the activator}

import Utility
 
Float Property xOffset = 00.0 Auto  
{Relative X position for the target}
 
Float Property yOffset = 00.0 Auto  
{Y Offset for Target}
 
Float Property zOffset = 0.0 Auto ; 3584.0 Auto  
{Z offset for Target}
 
Float Property RandomOffsetX = 0.0 Auto
{Randomness applied to X Offset}
 
Float Property RandomOffsetY = 0.0 Auto
{Randomness applied to Y Offset}
 
Float Property RandomOffsetZ = 0.0 Auto
{Randomness applied to Z Offset}
 
Float Property PulseRate = 5.0 Auto  
{How often do we shoot?}
 
Float Property RandomRate = 0.0 Auto
{Add random delay to pulse rate, capped at this value}
 
Activator Property TargetType  Auto  
{What type of object are we zapping if we're spawning a node?}
 
ObjectReference Property CurrentTarget  Auto  
{The actual target we're shooting at}
 
Bool Property SpawnNode = true Auto  
{Do we spawn a target? If not, zap the nearest valid target.}
 
Spell Property Zap Auto
{What spell shall we use for the effect?}
 
FormList Property TargetTypeList Auto
{List of potential targets}
 
Float Property SeekRange = 1000.0 Auto
{The range it will "Lock into" a target if not making a node.}
 
int count = 0 
 
Event OnInit()
    if SpawnNode && !CurrentTarget
        CurrentTarget = PlaceAtMe(TargetType,1)
        CurrentTarget.MoveTo(Self,XOffSet,YOffSet,ZOffSet)
    endif
    RegisterForSingleUpdate(PulseRate)
EndEvent
 
Event OnUpdate()
    if !SpawnNode
        CurrentTarget = Game.FindClosestReferenceOfAnyTypeInListfromRef(TargetTypeList,Self,SeekRange) 
	; find something nearby to shoot at if we're not making our own target.
		if !TargetTypeList && GetDistance(Game.GetPlayer()) < SeekRange ; No list given, Default to the player.
			CurrentTarget = Game.GetPlayer()
		endif
    else
        CurrentTarget.MoveTo(Self, \
							 XOffSet+(RandomFloat(0.0,RandomOffsetX)-RandomOffsetX/2 ), \
							 YOffSet+(RandomFloat(0.0,RandomOffsetY)-RandomOffsetY/2), \
							 ZOffSet) ;+(RandomFloat(0.0,RandomOffsetZ)-RandomOffsetZ/2))
    endif
    Zap.Cast(Self,CurrentTarget)
	;count = count + 1
	;if (count < 100)
		RegisterForSingleUpdate(PulseRate+RandomFloat(0.0,RandomRate))
	;endif
EndEvent
