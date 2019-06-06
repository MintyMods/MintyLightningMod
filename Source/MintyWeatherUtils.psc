Scriptname MintyWeatherUtils extends MintyConfigScript
{ Weather Utility functions }

import Weather

FormList Property MintyBadWeathers Auto
Weather Reference

int SKYMODE_FULL = 3
int WEATHER_RAINING = 2


Bool Function isWeatherBadEnoughForLightning() 
	bool isBad = False
	if !IsWeatherTransitioning()
		int index = MintyBadWeathers.GetSize() 
		Debug(index + " Bad Weathers found")
		While(index > 0)
			index -= 1
			Reference = MintyBadWeathers.GetAt(index) as Weather
			if (GetCurrentWeather() == Reference)
				isBad = True
			endif			
		EndWhile
	endif		
	Info("Is Weather Bad : " + isBad)
	return isBad
EndFunction


Bool Function IsStormWeather() 
	bool isBad = false
	if IsOutsideWithFullSky()
		if IsWeatherBadEnoughForLightning()			
			isBad = true
		endif
	endif
	return isBad 
EndFunction


Bool Function IsOutsideWithFullSky() 
	Debug("SkyMode full : " + (GetSkyMode() == SKYMODE_FULL))
	return (GetSkyMode() == SKYMODE_FULL)
EndFunction


Bool Function IsWeatherRaining() 
	Debug("Is Raining " + (GetCurrentWeather().GetClassification() == WEATHER_RAINING))
	return (GetCurrentWeather().GetClassification() == WEATHER_RAINING)
EndFunction


Bool Function IsWeatherTransitioning() 
	Debug("Weather is transitioning " + !(GetCurrentWeatherTransition() == 1.0))
	return !(GetCurrentWeatherTransition() == 1.0)
EndFunction
