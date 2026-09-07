# This file stores functions common to animating creative props using keyframes.
# It also defines the move_to_ease_type enum to help in building animations.
using { /Fortnite.com/Devices }
using { /UnrealEngine.com/Temporary/SpatialMath }
using { /Fortnite.com/Characters}
using { /Fortnite.com/Devices/CreativeAnimation }

# Represents the different movement easing types.
move_to_ease_type<public> := enum {Linear, Ease, EaseIn, EaseOut, EaseInOut}

# Return the cubic_bezier_parameters based on the given move_to_ease_type.
GetCubicBezierForEaseType(EaseType:move_to_ease_type):cubic_bezier_parameters=
    case (EaseType):
        move_to_ease_type.Linear => InterpolationTypes.Linear
        move_to_ease_type.Ease => InterpolationTypes.Ease
        move_to_ease_type.EaseIn => InterpolationTypes.EaseIn
        move_to_ease_type.EaseOut => InterpolationTypes.EaseOut
        move_to_ease_type.EaseInOut => InterpolationTypes.EaseInOut

# Initializes a vector3 with all values set to 1.0.
VectorOnes<public>:vector3 = vector3{X:=1.0, Y:=1.0, Z:=1.0}

# An overload of MoveToEase() that changes the position of the prop while keeping the rotation and scale the same.
(CreativeProp:creative_prop).MoveToEase<public>(Position:vector3, Duration:float, EaseType:move_to_ease_type, AnimationMode:animation_mode)<suspends>:void=
    CreativeProp.MoveToEase(Position, IdentityRotation(), VectorOnes, Duration, EaseType, AnimationMode)

# An overload of MoveToEase() that changes the rotation of the prop while keeping the position and scale the same.
(CreativeProp:creative_prop).MoveToEase<public>(Rotation:rotation, Duration:float, EaseType:move_to_ease_type, AnimationMode:animation_mode)<suspends>:void=
    CreativeProp.MoveToEase(CreativeProp.GetTransform().Translation, Rotation, VectorOnes, Duration, EaseType, AnimationMode)

# An overload of MoveToEase() that changes the position and scale of the prop while keeping the rotation the same.
(CreativeProp:creative_prop).MoveToEase<public>(Duration:float, Scale:vector3, EaseType:move_to_ease_type, AnimationMode:animation_mode)<suspends>:void=
    CreativeProp.MoveToEase(CreativeProp.GetTransform().Translation, IdentityRotation(), Scale, Duration, EaseType, AnimationMode)

# An overload of MoveToEase() that takes a pre-built array of keyframes and plays an animation.
(CreativeProp:creative_prop).MoveToEase<public>(Keyframes:[]keyframe_delta, AnimationMode:animation_mode)<suspends>:void=
    if (AnimController := CreativeProp.GetAnimationController[]):
        AnimController.SetAnimation(Keyframes, ?Mode:=AnimationMode)
        AnimController.Play()
        AnimController.MovementCompleteEvent.Await()

# Animate a creative_prop by constructing an animation from a single keyframe, and then playing that animation on the prop.
# This method takes a Position, Rotation, and Scale for the prop to end at, the duration of the animation,
# the type of easing to apply to the movement, and the animation mode of the animation.
(CreativeProp:creative_prop).MoveToEase<public>(Position:vector3, Rotation:rotation, Scale:vector3, Duration:float, EaseType:move_to_ease_type, AnimationMode:animation_mode)<suspends>:void=
    # Get the animation controller for the CreativeProp to move.
    if (AnimController := CreativeProp.GetAnimationController[]):

        # Calculate the multiplicative scale for the keyframe to scale to.
        ScaleMultiplicative:vector3 = VectorOnes + ((Scale - CreativeProp.GetTransform().Scale) / CreativeProp.GetTransform().Scale)

        # Build the keyframe array from a single keyframe_delta of the given values.
        Keyframes:[]keyframe_delta = array:
            keyframe_delta:
                DeltaLocation := Position - CreativeProp.GetTransform().Translation,
                DeltaRotation := Rotation,
                DeltaScale := ScaleMultiplicative,
                Time := Duration,
                Interpolation := GetCubicBezierForEaseType(EaseType)

        # Set the animation on the animation controller, play it, and await the animation ending.
        AnimController.SetAnimation(Keyframes, ?Mode:=AnimationMode)
        AnimController.Play()
        AnimController.MovementCompleteEvent.Await()