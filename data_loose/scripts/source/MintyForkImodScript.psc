Scriptname MintyForkImodScript extends activemagiceffect  
{Parent lightning script}

import Utility

ImageSpaceModifier property MintyForkBloomImod Auto
MintyConfigScript Property MintyConfig Auto

Sound property MintyForkSoundFX Auto

Event OnEffectStart(Actor Target, Actor Caster) 
	Wait(MintyConfig.getForkSoundDelay())
	MintyForkSoundFX.Play(Target)	
EndEvent 

Event OnEffectFinish(Actor Target, Actor Caster) 

endEvent 