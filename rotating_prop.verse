using { /Fortnite.com/Devices }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

AdditionalRotationTip<localizes>:message = "The rotation to apply to the RootProp"
ShouldRotateForeverTip<localizes>:message = "Whether the RootProp should rotate forever."
MatchRotationTargetTip<localizes>:message = "The optional prop whos rotation the RootProp should rotate to. Use this if you do not want to set an Additional Rotation."

# A prop that rotates by an additional rotation or rotates to match
# a Creative prop's rotation.
rotating_prop<public> := class<concrete>(movable_prop):

    # The additional rotation to apply to the RootProp
    @editable {ToolTip := AdditionalRotationTip}
    AdditionalRotation:rotation = rotation{}

    # Whether the RootProp should rotate forever
    @editable {ToolTip := ShouldRotateForeverTip}
    ShouldRotateForever:logic = true

    # The optional prop whos rotation RootProp should rotate to match. Use this if you do not want to set an additional rotation
    @editable {ToolTip := MatchRotationTargetTip}
    MatchRotationTarget:?creative_prop = false

    # The rotation the prop is currently rotating toward
    var TargetRotation:rotation = rotation{}

    # Rotate the RootProp by applying the TargetRotation, or toward the MoveTarget if one is set.
    Move<override>()<suspends>:void=

        # Set the TargetRotation to the MoveTarget's rotation if the MoveTarget is set.
        if: 
            RotationToMatch := MatchRotationTarget?.GetTransform().Rotation
        then:
            set TargetRotation = RotationToMatch
        else:
            set TargetRotation = AdditionalRotation

        # Set the default animation mode to play.
        # The OneShot animation mode will play the animation once.
        var AnimationMode:animation_mode := animation_mode.OneShot 

        # If the RootProp should not reset and not stop once it finishes rotating 
        # set the animation type to PingPong 
        if:
            not ShouldRotateForever?
            not MoveOnceAndStop?
        then:
            set AnimationMode = animation_mode.PingPong

        # Get the rotation to rotate toward by rotating the Starting Transform
        # by the AdditionalRotation. Then start rotating 
        RotateByTargetRotation := StartingTransform.Rotation.RotateBy(TargetRotation)
        RootProp.MoveToEase(RotateByTargetRotation, MoveDuration, MoveEaseType, AnimationMode)


