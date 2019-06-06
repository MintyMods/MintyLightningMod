Scriptname MintyConfigScript extends MintyLogging 
{ Helper script to basically provide getters/setters to the global variables } 

import game
import utility

GlobalVariable Property MintyIsForkLightningHostile Auto
GlobalVariable Property MintyIsForkLightningHostileDefault Auto
GlobalVariable Property MintyIsSheetLightningHostile Auto
GlobalVariable Property MintyIsSheetLightningHostileDefault Auto
GlobalVariable Property MintyFaceTarget Auto
GlobalVariable Property MintyIsForkEnabled Auto
GlobalVariable Property MintyIsForkEnabledDefault Auto
GlobalVariable Property MintyForkDistanceMin Auto
GlobalVariable Property MintyForkDistanceMinDefault Auto
GlobalVariable Property MintyForkDistanceMax Auto
GlobalVariable Property MintyForkDistanceMaxDefault Auto
GlobalVariable Property MintyForkFrequency Auto
GlobalVariable Property MintyForkFrequencyDefault Auto
GlobalVariable Property MintyForkBloom Auto
GlobalVariable Property MintyForkBloomDefault Auto
GlobalVariable Property MintyForkWait Auto
GlobalVariable Property MintyForkWaitDefault Auto
GlobalVariable Property MintyIsSheetEnabled Auto
GlobalVariable Property MintyIsSheetEnabledDefault Auto
GlobalVariable Property MintySheetDistanceMin Auto
GlobalVariable Property MintySheetDistanceMinDefault Auto
GlobalVariable Property MintySheetDistanceMax Auto
GlobalVariable Property MintySheetDistanceMaxDefault Auto
GlobalVariable Property MintySheetFrequency Auto
GlobalVariable Property MintySheetFrequencyDefault Auto
GlobalVariable Property MintySheetBloom Auto
GlobalVariable Property MintySheetBloomDefault Auto
GlobalVariable Property MintySheetWait Auto 
GlobalVariable Property MintySheetWaitDefault Auto 
GlobalVariable Property MintyWeatherCheckFrequency Auto
GlobalVariable Property MintyCellSize Auto
GlobalVariable Property MintyCellHeight Auto
GlobalVariable Property MintyStrikeDistance Auto
GlobalVariable Property MintyStrikeHeightByRegion Auto
GlobalVariable Property MintyDisableLegacyMenu Auto

GlobalVariable Property MintySheetSoundDelay Auto
GlobalVariable Property MintyForkSoundDelay Auto
GlobalVariable Property MAGProjectileStormVar Auto

Book Property MintyLightningConfigBook Auto
Spell Property MintyLightningConfigSpell Auto

int YES = 1
int NO = 0

	
Function InitBooks()
	if (!isLegacyMenuDisabled())
		Actor Player = GetPlayer()
		if (Player.GetItemCount(MintyLightningConfigBook) < 1)
			if (!Player.HasSpell(MintyLightningConfigSpell))
				Player.addItem(MintyLightningConfigBook)
			endif
		endif
	endif
EndFunction

Bool Function isLegacyMenuDisabled()
	return MintyDisableLegacyMenu.getValueInt() as Bool
EndFunction

Function disableLegacyMenu()
	MintyDisableLegacyMenu.SetValueInt(YES)
	Actor Player = GetPlayer()
	if (Player.HasSpell(MintyLightningConfigSpell))
		Player.removeSpell(MintyLightningConfigSpell)
	endif	
	Player.RemoveItem(MintyLightningConfigBook)
EndFunction

Function enableLegacyMenu()
	MintyDisableLegacyMenu.SetValueInt(NO)
	Actor Player = GetPlayer()
	if (!Player.HasSpell(MintyLightningConfigSpell))
		Player.addSpell(MintyLightningConfigSpell)
	endif
EndFunction

Bool Function shouldPlaceStrikeHeightsByRegion()
	return MintyStrikeHeightByRegion.getValueInt() as Bool
EndFunction


Bool Function shouldFaceTarget()
	return MintyFaceTarget.getValueInt() as Bool
EndFunction

Float Function getSheetSoundDelay()
	return MintySheetSoundDelay.getValue()
EndFunction

Function setSheetSoundDelay(Float delay)
	MintySheetSoundDelay.setValue(delay)
EndFunction

Function setForkSoundDelay(Float delay)
	MintyForkSoundDelay.setValue(delay)
EndFunction

Float Function getForkSoundDelay()
	return MintyForkSoundDelay.getValue()
EndFunction


Float Function getForkBloom()
	return MintyForkBloom.getValue()
EndFunction

Float Function getForkBloomDefault()
	return MintyForkBloomDefault.getValue()
EndFunction

Float Function getSheetBloom()
	return MintySheetBloom.getValue()
EndFunction

Float Function getSheetBloomDefault()
	return MintySheetBloomDefault.getValue()
EndFunction


Float Function getForkWait()
	return MintyForkWait.getValue()
EndFunction

Float Function getForkWaitDefault()
	return MintyForkWaitDefault.getValue()
EndFunction

Float Function getSheetWait()
	return MintySheetWait.getValue()
EndFunction

Float Function getSheetWaitDefault()
	return MintySheetWaitDefault.getValue()
EndFunction

Function setForkBloom(Float amount)
	MintyForkBloom.setValue(amount)
EndFunction


Function setSheetBloom(Float amount)
	MintySheetBloom.setValue(amount)
EndFunction


Function setForkWait(Float time)
	MintyForkWait.setValue(time)
EndFunction


Function setSheetWait(Float time)
	MintySheetWait.setValue(time)
EndFunction


Function setForkFrequency(Float freq)
	MintyForkFrequency.setValue(freq)
EndFunction


Function setSheetFrequency(Float freq)
	MintySheetFrequency.setValue(freq)
EndFunction


Function setForkMinDistance(int distance)
	MintyForkDistanceMin.setValueInt(distance)
EndFunction


Function setForkMaxDistance(int distance)
	MintyForkDistanceMax.setValueInt(distance)
EndFunction


Function setSheetMinDistance(int distance)
	MintySheetDistanceMin.setValueInt(distance)
EndFunction


Function setSheetMaxDistance(int distance)
	MintySheetDistanceMax.setValueInt(distance)
EndFunction


Function setForkLightningHostile()
	Info("Fork Lightning is now hostile!")
	MintyIsForkLightningHostile.SetValueInt(YES)
EndFunction


Function setForkLightningHarmless()
	Info("Fork Lightning is now harmless")
	MintyIsForkLightningHostile.SetValueInt(NO)
EndFunction

Function setSheetLightningHostile()
	Info("Sheet Lightning is now hostile!")
	MintyIsSheetLightningHostile.SetValueInt(YES)
EndFunction


Function setSheetLightningHarmless()
	Info("Sheet Lightning is now harmless")
	MintyIsSheetLightningHostile.SetValueInt(NO)
EndFunction

Function disableFork()
	MintyIsForkEnabled.setValueInt(NO)
EndFunction


Function enableFork()
	MintyIsForkEnabled.setValueInt(YES)
EndFunction


Function disableSheet()
	MintyIsSheetEnabled.setValueInt(NO)
EndFunction


Function enableSheet()
	MintyIsSheetEnabled.setValueInt(YES)
EndFunction


Float Function getStrikeDistance()
	return MintyStrikeDistance.GetValue() as Float
EndFunction


Float Function getCellSize()
	return MintyCellSize.GetValue() as Float
EndFunction


Float Function GetCellHeight()
	return Utility.RandomFloat(MintyCellHeight.GetValue(), (MintyCellHeight.GetValue() * 2)) as Float
EndFunction
	
	
Int Function getSheetDistanceMin()
	return MintySheetDistanceMin.GetValueInt() as Int
EndFunction

Int Function getSheetDistanceMinDefault()
	return MintySheetDistanceMinDefault.GetValueInt() as Int
EndFunction

Int Function getSheetDistanceMax()
	return MintySheetDistanceMax.GetValueInt() as Int
EndFunction

Int Function getSheetDistanceMaxDefault()
	return MintySheetDistanceMaxDefault.GetValueInt() as Int
EndFunction

Int Function getForkDistanceMin()
	return MintyForkDistanceMin.GetValueInt() as Int
EndFunction

Int Function getForkDistanceMinDefault()
	return MintyForkDistanceMinDefault.GetValueInt() as Int
EndFunction

Int Function getForkDistanceMax()
	return MintyForkDistanceMax.GetValueInt() as Int
EndFunction

Int Function getForkDistanceMaxDefault()
	return MintyForkDistanceMaxDefault.GetValueInt() as Int
EndFunction

Bool Function isForkEnabled()
	return MintyIsForkEnabled.GetValueInt() as Bool
EndFunction

Bool Function isForkEnabledDefault()
	return MintyIsForkEnabledDefault.GetValueInt() as Bool
EndFunction


Bool Function isSheetEnabled()
	return MintyIsSheetEnabled.GetValueInt() as Bool
EndFunction

Bool Function isSheetEnabledDefault()
	return MintyIsSheetEnabledDefault.GetValueInt() as Bool
EndFunction

Bool Function isForkLightningHostile() 
	return MintyIsForkLightningHostile.GetValueInt() as Bool
EndFunction

Bool Function isForkLightningHostileDefault() 
	return MintyIsForkLightningHostileDefault.GetValueInt() as Bool
EndFunction


Bool Function isSheetLightningHostile() 
	return MintyIsSheetLightningHostile.GetValueInt() as Bool
EndFunction

Bool Function isSheetLightningHostileDefault() 
	return MintyIsSheetLightningHostileDefault.GetValueInt() as Bool
EndFunction


Float Function getUpdateFrequencyFork() 
	return MintyForkFrequency.GetValue() as Float
EndFunction

Float Function getUpdateFrequencyForkDefault() 
	return MintyForkFrequencyDefault.GetValue() as Float
EndFunction

Float Function getForkFrequency()
	return MintyForkFrequency.GetValue() as Float
EndFunction

Float Function getForkFrequencyDefault()
	return MintyForkFrequencyDefault.GetValue() as Float
EndFunction

Float Function getUpdateFrequencySheet() 
	return MintySheetFrequency.GetValue() as Float
EndFunction

Float Function getUpdateFrequencySheetDefault() 
	return MintySheetFrequencyDefault.GetValue() as Float
EndFunction

Float Function getSheetFrequency() 
	return MintySheetFrequency.GetValue() as Float
EndFunction

Float Function getSheetFrequencyDefault() 
	return MintySheetFrequencyDefault.GetValue() as Float
EndFunction

Float Function getUpdateFrequencyWeatherCheck() 
	return MintyWeatherCheckFrequency.GetValue() as Float
EndFunction
