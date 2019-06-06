Scriptname MintyCreateActivator extends activemagiceffect  

import Debug
import Game
import Utility

Activator Property MintyActivator Auto
ObjectReference Property minty Auto 

Event OnEffectStart(Actor target, Actor caster)
	Notification("Placing Activator")
	minty = caster.PlaceAtMe(MintyActivator,1)
	wait(0.5)
	minty.MoveTo(caster,0.0,0.0,3096.0)
	wait(0.5)
EndEvent
