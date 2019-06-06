Scriptname MintyLogging extends Quest
{ Provides logging/debugging/feedback functionality }

import debug
import Game

GlobalVariable Property MintyLoggingEnabled Auto
GlobalVariable Property MintyFeedBackEnabled Auto
GlobalVariable Property MintyVersion Auto

String Property LogFileName = "Minty" Auto

int YES = 1
int NO = 0

int LOG_LEVEL_INFO = 0
int LOG_LEVEL_WARN = 1
int LOG_LEVEL_ERROR = 2


Event OnInit() 
	OpenUserLog(LogFileName) 
	TraceUser(LogFileName, LogFileName + " : (Version:" + getVersion() + ") Log file created.")
EndEvent


Function Debug(String msg) 
	if (isLoggingEnabled())
		 TraceUser(LogFileName, GetFormID() + " : " + msg)
	endif
EndFunction


Function Info(String msg)  
	Debug(msg)
	if (isFeedbackEnabled())
		Notification(msg)
	endif
EndFunction


Function Warn(String msg) 
	Info(msg)
	TraceStack("!WARN:" + msg, LOG_LEVEL_WARN)
EndFunction


Function Error(String msg) 
	Warn(msg)
	TraceAndBox("!ERROR:" + msg, LOG_LEVEL_ERROR)
EndFunction


Float Function getVersion()
	return MintyVersion.getValue() as Float
EndFunction


Function enableLogging()
	MintyLoggingEnabled.setValue(YES)
EndFunction


Function disableLogging()
	MintyLoggingEnabled.setValue(NO)
EndFunction


bool Function isLoggingEnabled()
	return MintyLoggingEnabled.getValue() as bool
EndFunction


Function enableFeedback()
	MintyFeedBackEnabled.setValue(YES)
EndFunction


Function disableFeedback()
	MintyFeedBackEnabled.setValue(NO)
EndFunction


bool Function isFeedbackEnabled()
	return MintyFeedBackEnabled.getValue() as bool
EndFunction

