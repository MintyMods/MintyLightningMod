Scriptname MintyFireworkActivatorScript extends ObjectReference  
{Script to fire fireworks}

import Utility
 
Float Property xOffset = 0.0  Auto  
{Relative X position for the target}
 
Float Property yOffset = 0.0  Auto  
{Y Offset for Target}
 
Float Property zOffset = 4096.0  Auto  
{Z offset for Target}
 
Float Property RandomOffsetX = 4096.0 Auto
{Randomness applied to X Offset}
 
Float Property RandomOffsetY = 4096.0 Auto
{Randomness applied to Y Offset}
 
Float Property RandomOffsetZ = 0.0 Auto
{Randomness applied to Z Offset}
 
Float Property PulseRate = 0.5 Auto  
{How often do we shoot?}
 
Float Property RandomRate = 0.0 Auto
{Add random delay to pulse rate, capped at this value}
 
Activator Property TargetType  Auto  
{What type of object are we zapping if we're spawning a node?}
 
ObjectReference Property CurrentTarget  Auto  
{The actual target we're shooting at}
 
Bool Property SpawnNode  Auto  
{Do we spawn a target? If not, zap the nearest valid target.}
 
FormList Property MintyFireworkList Auto 
Spell Property Firework Auto
{What spell shall we use for the effect?}
 
FormList Property TargetTypeList Auto
{List of potential targets}
 
Float Property SeekRange = 1000.0 Auto
{The range it will "Lock into" a target if not making a node.}
 
Event OnInit()
    if SpawnNode && !CurrentTarget
        CurrentTarget = PlaceAtme(TargetType,1)
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
        CurrentTarget.MoveTo(Self, XOffSet+(RandomFloat(0.0,RandomOffsetX)-RandomOffsetX/2 ), \
            YOffSet+(RandomFloat(0.0,RandomOffsetY)-RandomOffsetY/2), \
            ZOffSet+(RandomFloat(0.0,RandomOffsetZ)-RandomOffsetZ/2))
    endif
	
	LightFireworks()
    
    RegisterForSingleUpdate(PulseRate+RandomFloat(0.0,RandomRate))
EndEvent

Function LightFireworks() 
	int index = MintyFireworkList.GetSize() 
	While(index > 0)
		index -= 1
		;PlaceTarget()
		Firework = MintyFireworkList.GetAt(index) as Spell
		Firework.Cast(Self,CurrentTarget)
		wait(2.0)
	endwhile	
EndFunction
