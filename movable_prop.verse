using { /Fortnite.com/Devices }
using { /Fortnite.com/Devices/CreativeAnimation }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/SpatialMath }

MoveDurationTip<localizes>:message = "The amount of time in seconds the prop takes to move to its destination."
MoveEaseTypeTip<localizes>:message = "The animation easing applied to the movement."
MoveEndDelayTip<localizes>:message = "The delay after the movement finishes."
MoveOnceAndStopTip<localizes>:message = "Whether the RootProp should stop in place after it finishes moving."
MoveStartDelayTip<localizes>:message = "The delay before the movement starts."
MoveTargetsTip<localizes>:message = "The array of CreativeProp to move towards. These targets can be children of the RootProp."
RootPropTip<localizes>:message = "The prop that moves. This should be the root prop of the object you want to move."
ShouldResetTip<localizes>:message = "Whether the RootProp should reset back to its starting position after it finishes moving."

# Defines a creative prop that moves to a target or location using animation.
movable_prop<public> := class<abstract>():

    # The creative prop associated with this class.
    # This should be the root prop of the object you want to move.
    @editable {ToolTip := RootPropTip}
    RootProp:creative_prop = creative_prop{}

    # The duration in seconds it takes for the prop to move to its destination.
    @editable {ToolTip := MoveDurationTip}
    MoveDuration:float = 3.0

    # The duration in seconds to wait before movement begins.
    @editable {ToolTip := MoveStartDelayTip}
    MoveStartDelay:float = 0.0

    # The duration in seconds to wait after movement ends.
    @editable {ToolTip := MoveEndDelayTip}
    MoveEndDelay:float = 0.0

    # Whether the RootProp should stop in place when it finishes moving.
    @editable {ToolTip := MoveOnceAndStopTip}
    MoveOnceAndStop:logic = false

    # Whether the RootProp should reset back to the starting position when it
    # finishes moving.
    @editable {ToolTip := ShouldResetTip}
    ShouldReset:logic = false

    # The type of animation easing to apply to the RootProp's movement. The easing type
    # changes the speed of the animation based on its animation curve.
    @editable {ToolTip := MoveEaseTypeTip}
    MoveEaseType:move_to_ease_type = move_to_ease_type.EaseInOut

    # The starting transform of the RootProp.
    var StartingTransform:transform = transform{}

    # Loops moving the RootProp to its target by calling Move(), and handles
    # any logic when the movement begins and ends.
    ManageMovement()<suspends>:void=
        loop:
            Sleep(MoveStartDelay)

            Move()

            # If the prop should only move once and stop, then exit the loop.
            if:
                MoveOnceAndStop?
            then:
                break

            Sleep(MoveEndDelay)

            # If this prop should reset, move the prop back to the starting transform.
            if:
                ShouldReset?
                Reset[]

    # Move the RootProp to its target. This is the base class
    # version of this function and should not be used.
    Move()<suspends>:void=
        return

    # Reset the RootProp by teleporting it back to its StartingTransform.
    Reset()<decides><transacts>:void=
        RootProp.TeleportTo[StartingTransform]

    # Sets the StartingTransform to the current transform of the RootProp.
    SetStartingTransform():void=
        set StartingTransform = RootProp.GetTransform()

    # Set the StartingTransform, then begin movement by spawning ManageMovement.
    Setup<public>():void=
        SetStartingTransform()
        spawn{ManageMovement()}