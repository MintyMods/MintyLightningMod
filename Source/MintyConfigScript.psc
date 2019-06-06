Scriptname MintyConfigScript extends MintyLogging 
{ Helper script to basically provide getters/setters to the global variables } 

GlobalVariable Property MintyIsLightningHostile Auto
GlobalVariable Property MintyFaceTarget Auto
GlobalVariable Property MintyIsForkEnabled Auto
GlobalVariable Property MintyForkDistanceMin Auto
GlobalVariable Property MintyForkDistanceMax Auto
GlobalVariable Property MintyForkFrequency Auto
GlobalVariable Property MintyForkBloom Auto
GlobalVariable Property MintyForkWait Auto
GlobalVariable Property MintyIsSheetEnabled Auto
GlobalVariable Property MintySheetDistanceMin Auto
GlobalVariable Property MintySheetDistanceMax Auto
GlobalVariable Property MintySheetFrequency Auto
GlobalVariable Property MintySheetBloom Auto
GlobalVariable Property MintySheetWait Auto 
GlobalVariable Property MintyWeatherCheckFrequency Auto
GlobalVariable Property MintyCellSize Auto
GlobalVariable Property MintyCellHeight Auto
GlobalVariable Property MintyStrikeDistance Auto

int YES = 1
int NO = 0


Bool Function shouldFaceTarget()
	return MintyFaceTarget.getValueInt() as Bool
EndFunction


Float Function getForkBloom()
	return MintyForkBloom.getValue()
EndFunction


Float Function getSheetBloom()
	return MintySheetBloom.getValue()
EndFunction


Float Function getForkWait()
	return MintyForkWait.getValue()
EndFunction


Float Function getSheetWait()
	return MintySheetWait.getValue()
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


Function setLightningHostile()
	Info("Lightning is now hostile!")
	MintyIsLightningHostile.SetValueInt(YES)
EndFunction


Function setLightningHarmless()
	Info("Lightning is now harmless")
	MintyIsLightningHostile.SetValueInt(NO)
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


Int Function getSheetDistanceMax()
	return MintySheetDistanceMax.GetValueInt() as Int
EndFunction


Int Function getForkDistanceMin()
	return MintyForkDistanceMin.GetValueInt() as Int
EndFunction


Int Function getForkDistanceMax()
	return MintyForkDistanceMax.GetValueInt() as Int
EndFunction


Bool Function isForkEnabled()
	return MintyIsForkEnabled.GetValueInt() as Bool
EndFunction


Bool Function isSheetEnabled()
	return MintyIsSheetEnabled.GetValueInt() as Bool
EndFunction


Bool Function isLightningHostile()
	return MintyIsLightningHostile.GetValueInt() as Bool
EndFunction


Float Function getUpdateFrequencyFork() 
	return MintyForkFrequency.GetValue() as Float
EndFunction


Float Function getUpdateFrequencySheet() 
	return MintySheetFrequency.GetValue() as Float
EndFunction


Float Function getUpdateFrequencyWeatherCheck() 
	return MintyWeatherCheckFrequency.GetValue() as Float
EndFunction
