using { /Fortnite.com/Devices }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

MovePositionTip<localizes>:message = "The optional position to move to World Space. Use this if you do not want to set a MoveTarget."

# A prop that moves (translates) toward either a Creative prop target
# or a position in world space.
translating_prop<public> := class<concrete>(movable_prop):

    # The Creative prop targets for the RootProp to move toward.
    @editable {ToolTip := MoveTargetsTip}
    var MoveTargets:[]creative_prop = array{}

    # The optional position for the RootProp to move toward. Use this if you
    # do not want to set a MoveTarget.
    @editable {ToolTip := MovePositionTip}

    var MovePosition:?vector3 = false

    # The position the prop is currently targeting.
    var TargetPosition:vector3 = vector3{}

    # Translate the RootProp toward the MoveTarget, or MovePosition if one is set.
    Move<override>()<suspends>:void=
        # Set the TargetPosition to the MovePosition if it is set.
        if:
            NewPosition := MovePosition?
        then:
            set TargetPosition = NewPosition

            # Call MoveToEase to start moving the prop. The OneShot animation mode will play the animation once.
            RootProp.MoveToEase(TargetPosition, MoveDuration, MoveEaseType, animation_mode.OneShot)
        else:
            # Otherwise, move to each target in the MoveTargets array.
            for:
                MoveTarget:MoveTargets
            do:
                # Set the TargetPosition to the MoveTarget's position if the
                # MoveTarget is valid.
                if:
                    MoveTarget.IsValid[]
                then:
                    set TargetPosition = MoveTarget.GetTransform().Translation
                # Call MoveToEase to start moving the prop. The OneShot animation mode will play the animation once.
                RootProp.MoveToEase(TargetPosition, MoveDuration, MoveEaseType, animation_mode.OneShot)