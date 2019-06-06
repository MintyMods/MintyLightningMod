Scriptname MintySheetSound extends activemagiceffect  

import Utility

MintyConfigScript Property MintyConfig Auto
FormList Property MintySheetStrikeSounds Auto
Sound MintySheetSoundFX = None

Event OnEffectStart(Actor Target, Actor Caster) 
	;int Size = MintySheetStrikeSounds.GetSize()
	;int rand = RandomInt(1, size)
	;int position = rand - 1
	;MintySheetSoundFX = MintySheetStrikeSounds.GetAt(position) as Sound
	;Wait(MintyConfig.getSheetSoundDelay())
	;MintySheetSoundFX.Play(Target)	
EndEvent 

Event OnEffectFinish(Actor Target, Actor Caster) 

endEvent 