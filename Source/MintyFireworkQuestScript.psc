Scriptname MintyFireworkQuestScript extends MintyLogging  
{Minty Firework Quest}

import game
import utility

Form Property MintyFireworkBox Auto 
Form Property MintyFireworkBarrel Auto
Activator Property MintyFireworkActivator Auto

objectReference source 

Float updateFrequency = 5.0

Event OnInit()
	GotoState("WatchingTheWorld")
	Info("Minty Firework Quest")
	InitDebugging()
	RegisterForSingleUpdate(updateFrequency)		
EndEvent


; STATES
State WatchingTheWorld

	Event OnInit()
		; Ignore any further Inits...
	EndEvent

	Event OnUpdate()
		;RegisterForSingleUpdate(updateFrequency)		
	endEvent
	
EndState


Function InitDebugging()
	if (debugging)
		source = GetPlayer().placeAtMe(MintyFireworkActivator)
		source.MoveTo(getPlayer(), 50.0, 50.0, 1.0 )
		wait(1.0)
		if (GetPlayer().GetItemCount(MintyFireworkBox) < 1)
			Info("Adding Box")
			GetPlayer().addItem(MintyFireworkBox,1)
		endif
		if (GetPlayer().GetItemCount(MintyFireworkBarrel) < 1)
			Info("Adding Barrel")
			GetPlayer().addItem(MintyFireworkBarrel,1)
		endif		
	endif
EndFunction
