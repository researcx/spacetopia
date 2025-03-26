/obj/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	layer = EFFECTS_LAYER_UNDER_1
	var/light/light

/obj/light/New()
	light = new(src, 6)