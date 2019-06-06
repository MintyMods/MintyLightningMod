Scriptname MintySheetImodScript extends activemagiceffect  
{Parent lightning script}

import Utility

ImageSpaceModifier property MintySheetBloomImod Auto
MintyConfigScript Property MintyConfig Auto

Event OnEffectStart(Actor Target, Actor Caster) 
    ;MintySheetBloomImod.Remove()
    ;MintySheetBloomImod.Apply(MintyConfig.getSheetBloom())
	;MintySheetBloomImod.Apply(1.0)
	;Wait(MintyConfig.getSheetWait())
EndEvent 

Event OnEffectFinish(Actor Target, Actor Caster) 
    ;MintySheetBloomImod.Remove() 
endEvent 