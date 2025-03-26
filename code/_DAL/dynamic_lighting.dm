// dynamic-lighting
// Library: Forum_account.DynamicLighting
// Author:  Forum_account

var
	const
		LIGHT_LAYER = 100

	Lighting/lighting = new()

Lighting
	var
		// the number of shades of light
		states = 7

		// the icon file to be used
		icon

		// the list of shading objects that have changed and
		// need to be updated this tick
		list/changed = list()

		// the list of z levels that have been initialized
		list/initialized = list()

		// the list of all light sources
		list/lights = list()

		pixel_movement = 1

		// a constant that's added to the illumination of all tiles
		ambient = 0
		__ambient = 0

	New()
		spawn(1)
			loop()

	proc
		loop()
			while(1)
				sleep(10 + world.tick_lag)

				if(!states)

					if(!icon)
						CRASH("The global var lighting.icon must be set.")
					states = 7

				if(__ambient != ambient)
					for(var/light/l in lights)
						l.ambient(ambient)

					__ambient = ambient

				// apply all light sources. each apply() proc will
				// check if any changes have occurred, so it's not
				// a bad thing that we're calling this for all lights,
				// if a light hasn't changed since the last tick,
				// nothing will happen.
				for(var/light/l in lights)
					l.loop()

				// update all shading objects in the list and clear
				// their "changed" flag, this guarantees that each
				// shading object is updated once per tick, even if
				// multiple light sources change in a way that affects
				// its illumination.

				for(var/shading/s in changed)
					s.icon_state = "[s.lum]"
					s.changed = 0

				// reset the changed list
				changed.Cut()

		// Initialize lighting for a single z level or for all
		// z levels. This initialization can be time consuming,
		// so you might want to initialize z levels only as you
		// need to.
		init()

			var/list/z_levels = list()

			for(var/a in args)
				if(isnum(a))
					z_levels += a
				else if(isicon(a))
					world.log << "The lighting's icon should now be set by setting the lighting.icon var directly, not by passing an icon to init()."

			// if you didn't specify any z levels, initialize all z levels
			if(z_levels.len == 0)
				for(var/i = 1 to world.maxz)
					z_levels += i

			var/list/light_objects = list()

			// initialize each z level
			for(var/z in z_levels)

				if(isnull(icon))
					CRASH("You have to first tell dynamic lighting which icon file to use by setting the lighting.icon var.")

				// if it's already been initialized, skip it
				if(z in initialized)
					continue

				// keep track of which z levels have been initialized
				initialized += z

				// to intialize a z level, we create a /shading object
				// on every turf of that level
				for(var/x = 1 to world.maxx)
					for(var/y = 1 to world.maxy)

						var/turf/t = locate(x, y, z)

						if(!t)
							break

						if(!t.RL_Ignore)
							t.shading = new(t, icon, 0)
							light_objects += t.shading
						else
							t.shading = 0

			// initialize the shading objects
			for(var/shading/s in light_objects)
				s.init()

				// this is the inline call to update()
				if(s.loc && !s.changed)
					s.changed = 1
					lighting.changed += s

turf
	var
		shading/shading

var
	shading/null_shading = new(null, null, 0)

// shading objects are a type of /obj placed in each
// turf that are used to graphically show the darkness
// as a result of dynamic lighting.
shading
	mouse_opacity = 0
	parent_type = /obj

	layer = LIGHT_LAYER

	var
		lum = 0
		__lum = 0

		// these are the shading objects whose icons need to
		// change when this object's lum value changes
		shading/u1
		shading/u2
		shading/u3

		changed = 0

		ambient = 0

	New(turf/t, i, l)
		..(t)
		icon = i
		lum = l

	proc
		init()

			u1 = locate(/shading) in locate(x + 1, y    , z)
			u2 = locate(/shading) in locate(x + 1, y + 1, z)
			u3 = locate(/shading) in locate(x    , y + 1, z)

			// some of these vars will be null around the edge of the
			// map, so in that case we set them to the global null_shading
			// instance so we don't constantly have to check if these
			// vars are null before referencing them.
			if(!u1) u1 = null_shading
			if(!u2) u2 = null_shading
			if(!u3) u3 = null_shading

		lum(l)
			__lum += l

			ambient = lighting.ambient

			// __lum can be a decimal, but lum is used to set the
			// icon_state, so we want it to be rounded off
			var/new_lum = round(__lum * lighting.states + ambient, 1)

			// we also have to keep lum within certain bounds
			if(new_lum < 0)
				new_lum = 0
			else if(new_lum >= lighting.states)
				new_lum = lighting.states - 1

			if(new_lum == lum) return

			lum = new_lum

			// update this shading object and its dependent neighbors
			if(loc && !changed)
				changed = 1
				lighting.changed += src

			if(u1.loc && !u1.changed)
				u1.changed = 1
				lighting.changed += u1

			if(u2.loc && !u2.changed)
				u2.changed = 1
				lighting.changed += u2

			if(u3.loc && !u3.changed)
				u3.changed = 1
				lighting.changed += u3

		changed()
			if(changed) return

			if(loc)
				changed = 1
				lighting.changed += src

				if(u1.loc && !u1.changed)
					u1.changed = 1
					lighting.changed += u1

				if(u2.loc && !u2.changed)
					u2.changed = 1
					lighting.changed += u2

				if(u3.loc && !u3.changed)
					u3.changed = 1
					lighting.changed += u3