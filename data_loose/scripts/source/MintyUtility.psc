Scriptname MintyUtility   
{Utility functions}

import Utility

; http://forums.bethsoft.com/topic/1381594-any-way-to-floor-a-float-from-1000000-to-1000/
Float Function RoundFloatToXDecimalPlaces(Float MyFloat, Int DecPlaces)
    Int Multiplier = Math.Pow(10, DecPlaces) as Int
    MyFloat *= Multiplier
    Int Floored = Math.Floor(MyFloat)
    if (MyFloat - Floored >= 0.5)
        Return ((Floored + 1) / Multiplier) as Float
    else
        Return (Floored / Multiplier) as Float
    endif
EndFunction


; Full Credit to RandoomNoob for the following Trig Function ;o)
Function PositionTarget(ObjectReference Target, ObjectReference Caster, Float Offset) Global
    Float AngleX = Caster.GetAngleX()
    Float AngleZ = Caster.GetAngleZ()
    Float DistanceZ = Offset * Math.Sin(-AngleX)
    Float DistanceXY = Offset * Math.Cos(-AngleX)
    Float DistanceX = DistanceXY * Math.Sin(AngleZ)
    Float DistanceY = DistanceXY * Math.Cos(AngleZ)
	Target.MoveTo(Caster, DistanceX, DistanceY, 0.0) ;DistanceZ
	Caster.SetAngle(Target.GetAngleX(), Target.GetAngleY(), Target.GetAngleZ() + Caster.GetHeadingAngle(Target))
EndFunction


; Full Credit to RandoomNoob for the following Trig Function ;o)
Function PositionRandomCaster(ObjectReference Caster, ObjectReference Target, Float distance = 200.00) Global
	float anglez = Target.GetAngleZ() + getRandomOffsetAngle() ; 180.0 or +90 for right, -90 for left, 0 for in front
	float offsetx = distance * math.sin(anglez)
	float offsety = distance * math.cos(anglez)
	Caster.MoveTo(Target, offsetx, offsety, 0)
EndFunction


; http://www.creationkit.com/Movement_Relative_to_Another_Object
Function MoveRefToPositionRelativeTo(ObjectReference akSubject, ObjectReference akTarget, Float OffsetDistance = 0.0, Float OffsetAngle = 0.0, bool FaceTarget = True, Float Height = 0.0) Global
	float AngleZ = akTarget.GetAngleZ() + OffsetAngle
	float OffsetX = OffsetDistance * Math.Sin(AngleZ)
	float OffsetY = OffsetDistance * Math.Cos(AngleZ)
	akSubject.MoveTo(akTarget, OffsetX, OffsetY, Height)
	if (FaceTarget)
		akSubject.SetAngle(akSubject.GetAngleX(), akSubject.GetAngleY(), akSubject.GetAngleZ() + akSubject.GetHeadingAngle(akTarget))
	endif
EndFunction


Float Function getRandomOffsetAngle() Global
	return RandomFloat(-180.0, 180.0)
EndFunction


;Function SetRandomAngle(ObjectReference MyObject) Global
;	SetLocalAngle(MyObject, Utility.RandomFloat(-180.0, 180.0), Utility.RandomFloat(-180.0, 180.0), 0.0)
;EndFunction


; http://www.creationkit.com/Setting_Local_Rotation
Function SetLocalAngle(ObjectReference MyObject, Float LocalX, Float LocalY, Float LocalZ) Global
	float AngleX = LocalX * Math.Cos(LocalZ) + LocalY * Math.Sin(LocalZ)
	float AngleY = LocalY * Math.Cos(LocalZ) - LocalX * Math.Sin(LocalZ)
	MyObject.SetAngle(AngleX, AngleY, LocalZ)
EndFunction


; http://www.creationkit.com/User:Fg109
Function SmoothCurve(ObjectReference A, ObjectReference B, Float Speed) Global
    Float AngleZ = A.GetHeadingAngle(B)
    if (AngleZ < -45)
        Float OffsetAngle = -45.0 - AngleZ
        AngleZ = -45.0
        A.SetAngle(0, 0, A.GetAngleZ() + OffsetAngle)
    elseif (AngleZ > 45)
        Float OffsetAngle = 45.0 - AngleZ
        AngleZ = 45.0
        A.SetAngle(0, 0, A.GetAngleZ() + OffsetAngle)
    endif
    Float DistanceXY = Math.sqrt((B.X - A.X) * (B.X - A.X) + (B.Y - A.Y) * (B.Y - A.Y))
    Float SplineMagnitude = DistanceXY / Math.Cos(AngleZ)
    Float AngleZEnd = A.GetAngleZ() + (A.GetHeadingAngle(B) * 2)
    A.SplineTranslateTo(B.X, B.Y, B.Z, 0, 0, AngleZEnd, Math.Abs(SplineMagnitude) * 0.75, Speed)
EndFunction


; http://www.creationkit.com/User:Fg109 
; I wrote a function for converting from local to global rotation. I find that I use it a lot.
Float[] Function ConvertRotation(Float AngleX, Float AngleY, Float AngleZ, Bool FromLocal = True) Global
    Float NewX
    Float NewY
    if (FromLocal)
        NewX = AngleX * Math.Cos(AngleZ) + AngleY * Math.Sin(AngleZ)
        NewY = AngleY * Math.Cos(AngleZ) - AngleX * Math.Sin(AngleZ)
    else
        NewX = AngleX * Math.Cos(AngleZ) - AngleY * Math.Sin(AngleZ)
        NewY = AngleY * Math.Cos(AngleZ) + AngleX * Math.Sin(AngleZ)
    endif
    Float[] Angles = new Float[3]
    Angles[0] = NewX
    Angles[1] = NewY
    Angles[2] = AngleZ
    Return Angles
EndFunction
