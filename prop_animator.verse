using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }

TranslatingPropsTip<localizes>:message = "The props that translate (move) using animation."

# Coordinates moving props through animation by calling each moveable_prop's Setup() method.
prop_animator := class(creative_device):

    # Array of moveable_props that translate using animation.
    @editable {ToolTip := TranslatingPropsTip}
    TranslatingProps:[]translating_prop = array{}

    # Runs when the device is started in a running game
    OnBegin<override>()<suspends>:void=
        # For each prop, call Setup() to begin animating.
        for:
            Prop:TranslatingProps
        do:
            Prop.Setup()