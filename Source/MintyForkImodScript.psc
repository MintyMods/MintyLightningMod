Scriptname MintyForkImodScript extends activemagiceffect  
{Parent lightning script}

import Utility

ImageSpaceModifier property MintyForkBloomImod Auto
MintyConfigScript Property MintyConfig Auto

Event OnEffectStart(Actor Target, Actor Caster) 
    ;MintyForkBloomImod.Remove()
    ;MintyForkBloomImod.Apply(MintyConfig.getForkBloom())
	;Wait(MintyConfig.getForkWait())
EndEvent 

Event OnEffectFinish(Actor Target, Actor Caster) 
    ;MintyForkBloomImod.Remove() 
endEvent 