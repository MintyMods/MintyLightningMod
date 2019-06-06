Scriptname MintyForkLightningScript extends activemagiceffect  

import weather
import utility
import game
import debug


;FormList Property AimedSpellsList Auto
Spell property MintyForkLightningSpell auto
Activator property MintyActivator Auto
;Activator Property DummyObject Auto
Int Property ProjectilesMax Auto
Int Property ProjectilesMin Auto
Float Property CastingDistance Auto
ObjectReference[] Dummies


Event OnEffectStart(Actor akTarget, Actor akCaster)

        Dummies = New ObjectReference[128]
        int Count = Utility.RandomInt(ProjectilesMin, ProjectilesMax)
        int index = 0
        while (index < Count)
                Dummies[index] = PlaceInFrontOfMeRandom(akCaster, MintyActivator, CastingDistance)
                index += 1
        endwhile
        Spell TempSpell
        index = 0
        while (index < Count)
                ;TempSpell = AimedSpellsList.GetAt(Utility.RandomInt(0, AimedSpellsList.GetSize() - 1)) as Spell
                MintyForkLightningSpell.RemoteCast(Dummies[index], akCaster, akTarget)
                Dummies[index].Delete()
                index += 1
        endwhile

EndEvent


ObjectReference Function PlaceInFrontOfMeRandom(ObjectReference Target, Form akObject, Float Distance)

        ObjectReference PlacedObject = Target.PlaceAtMe(akObject, 1, false, true)
        Float AngleZ = Target.GetAngleZ()
        AngleZ = Utility.RandomFloat(AngleZ - 30.0, AngleZ + 30.0)
        Float AngleX = Utility.RandomFloat(-30.0, 30.0)
        Float OffsetZ = Distance * Math.Sin(AngleX)
        Float DistanceXY = Distance * Math.Cos(AngleX)
        Float OffsetX = DistanceXY * Math.Sin(AngleZ)
        Float OffsetY = DistanceXY * Math.Cos(AngleZ)
        PlacedObject.MoveTo(Target, OffsetX, OffsetY, OffsetZ)
        Return PlacedObject

EndFunction
