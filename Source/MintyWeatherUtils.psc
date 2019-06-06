Scriptname MintyWeatherUtils extends MintyLogging
{ Weather Utility functions }

import Weather

FormList Property MintyBadWeathers Auto
Weather Reference

int SKYMODE_FULL = 3
int WEATHER_RAINING = 2


Bool Function isWeatherBadEnoughForLightning() 
	bool isBad = False
	int index = MintyBadWeathers.GetSize() 
	While(index > 0)
		index -= 1
		Reference = MintyBadWeathers.GetAt(index) as Weather
		if (GetCurrentWeather() == Reference)
			isBad = True
		endif
	EndWhile	
	return isBad
EndFunction


Bool Function isStormWeather() 
	bool isBad = false
	if IsOutsideWithFullSky()
		if !IsWeatherTransitioning()
			if IsWeatherRaining()
				if isWeatherBadEnoughForLightning()
					isBad = true
				endif
			endif
		endif
	endif
	return isBad 
EndFunction


Bool Function IsOutsideWithFullSky() 
	return (GetSkyMode() == SKYMODE_FULL)
EndFunction


Bool Function IsWeatherRaining() 
	return (GetCurrentWeather().GetClassification() == WEATHER_RAINING)
EndFunction


Bool Function IsWeatherTransitioning() 
	return !(GetCurrentWeatherTransition() == 1.0)
EndFunction
