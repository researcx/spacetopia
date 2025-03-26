var
	RL_Generation = 0

#define RL_Atten_Quadratic 2.2 // basically just brightness scaling atm
#define RL_Atten_Constant -0.1 // constant subtracted at every point to make sure it goes <0 after some distance
#define RL_MaxRadius 7 // maximum allowed light.radius value. if any light ends up needing more than this it'll cap and look screwy


//fukc off tobba this sux lmao

datum/light
	var
		x
		y
		z

		r = 1
		g = 1
		b = 1
		brightness = 1
		height = 1
		enabled = 0

		radius = 1
		premul_r = 1
		premul_g = 1
		premul_b = 1

		atom/attached_to = null
		attach_x = 0.5
		attach_y = 0.5

	New(x=0, y=0, z=0)
		src.x = x
		src.y = y
		src.z = z

	proc
		set_brightness(brightness)
			return
		set_height(height)
			return
		set_color(r, g, b)
			return
		enable()
			return
		disable()
			return
		detach()
			return
		attach(atom/A, offset_x=0.5, offset_y=0.5)
			return
		precalc()
			return
		apply()
			return
		strip(generation)
			return
		move(x, y, z)
			return
		move_defer(x, y, z)
			return

		apply_to(turf/T)
			return

		apply_internal(generation, r, g, b) // per light type
			return

	point
		apply_to(turf/T)
			return

var
	RL_Started = 0

proc
	RL_Start()
		return

	RL_Suspend()
		// TODO

	RL_Resume()
		// TODO

turf
	var
		RL_ApplyGeneration = 0
		RL_UpdateGeneration = 0
		obj/overlay/tile_effect/RL_MulOverlay = null
		obj/overlay/tile_effect/RL_AddOverlay = null
		RL_LumR = 0
		RL_LumG = 0
		RL_LumB = 0
		RL_AddLumR = 0
		RL_AddLumG = 0
		RL_AddLumB = 0
		RL_NeedsAdditive = 0
		RL_OverlayState = ""
		list/datum/light/RL_Lights = null

		RL_Ignore = 0

	luminosity = 1 // TODO

	New()
		..()

	disposing()
		..()

	proc
		RL_ApplyLight(lx, ly, brightness, height2, r, g, b)
			return

		RL_UpdateLight()
			return

		RL_SetSprite(state)
			return

		RL_GetBrightness()
			return

		RL_Cleanup()
			return

		RL_Reset()
			return

area
	var
		RL_Lighting = 0
		RL_AmbientRed = 0.1
		RL_AmbientGreen = 0.1
		RL_AmbientBlue = 0.1

atom
	var
		RL_Attached = null

	disposing()
		..()

	proc
		RL_SetOpacity(new_opacity)
			return