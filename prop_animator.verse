using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

TranslatingPropsTip<localizes>:message = "The props that translate (move) using animation."
RotatingPropsTips<localizes>:message = "The props that rotate using animation."

# Coordinates moving props through animation by calling each moveable_prop's Setup() method.
prop_animator := class(creative_device):

    # The array of props that translate using animation
    @editable 
    TranslatingProps:[]translating_prop = array{}

    @editable 
    RotatingProps:[]rotating_prop = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # For each prop, call Setup() to begin animating.
        for:
            Prop:TranslatingProps
        do:
            Prop.Setup()
        for: 
            Prop:RotatingProps
        do:
            Prop.Setup()