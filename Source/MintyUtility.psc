Scriptname MintyUtility   
{Utility functions}


; http://www.creationkit.com/Movement_Relative_to_Another_Object
Function MoveRefToPositionRelativeTo(ObjectReference akSubject, ObjectReference akTarget, Float OffsetDistance = 0.0, \
  Float OffsetAngle = 0.0, bool FaceTarget = False) Global
	float AngleZ = akTarget.GetAngleZ() + OffsetAngle
	float OffsetX = OffsetDistance * Math.Sin(AngleZ)
	float OffsetY = OffsetDistance * Math.Cos(AngleZ)
	akSubject.MoveTo(akTarget, OffsetX, OffsetY, 0.0)
	if (FaceTarget)
		akSubject.SetAngle(akSubject.GetAngleX(), akSubject.GetAngleY(), akSubject.GetAngleZ() + \
		  akSubject.GetHeadingAngle(akTarget))
	endif
EndFunction


; http://www.creationkit.com/Setting_Local_Rotation
Function SetLocalAngle(ObjectReference MyObject, Float LocalX, Float LocalY, Float LocalZ) Global
	float AngleX = LocalX * Math.Cos(LocalZ) + LocalY * Math.Sin(LocalZ)
	float AngleY = LocalY * Math.Cos(LocalZ) - LocalX * Math.Sin(LocalZ)
	MyObject.SetAngle(AngleX, AngleY, LocalZ)
EndFunction


; http://www.creationkit.com/User:Fg109
Function SmoothCurve(ObjectReference A, ObjectReference B, Float Speed)
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
Float[] Function ConvertRotation(Float AngleX, Float AngleY, Float AngleZ, Bool FromLocal = True)
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
