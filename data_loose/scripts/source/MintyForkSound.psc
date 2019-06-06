Scriptname MintyForkSound extends activemagiceffect  

import game
import Utility

MintyConfigScript Property MintyConfig Auto
FormList Property MintyForkStrikeSounds Auto
Sound MintyForkSoundFX = None

Event OnEffectStart(Actor Target, Actor Caster) 
	;int Size = MintyForkStrikeSounds.GetSize()
	;int rand = RandomInt(1, size)
	;int position = rand - 1
	;MintyForkSoundFX = MintyForkStrikeSounds.GetAt(position) as Sound
	
	;Wait(MintyConfig.getForkSoundDelay())
	;int instanceID = MintyForkSoundFX.Play(Game.GetPlayer())
	;Sound.SetInstanceVolume(instanceID, 1.0)
EndEvent 

Event OnEffectFinish(Actor Target, Actor Caster) 

endEvent 