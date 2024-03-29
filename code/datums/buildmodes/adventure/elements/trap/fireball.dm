/datum/puzzlewizard/trap/fireballtrap
	name = "AB CREATE: Fireball trap"
	var/turf/target = null
	var/power = 5

	var/selection

	initialize()
		..()
		selection = unpool(/obj/adventurepuzzle/marker)
		power = input("Fireball explosion power? (default should do if you want this to be doable)", "Fireball explosion", 5) as num
		boutput(usr, "<span style=\"color:orange\">Right click to set trap target. Right click active target to clear target. Left click to place trap. Ctrl+click anywhere to finish.</span>")
		boutput(usr, "<span style=\"color:orange\">Special note: If no target is set, the fireball will launch at the nearest mob.</span>")

	disposing()
		if (target)
			target.overlays -= selection
		if (selection)
			pool(selection)

	build_click(var/mob/user, var/datum/buildmode_holder/holder, var/list/pa, var/atom/object)
		if (pa.Find("left"))
			var/turf/T = get_turf(object)
			if (pa.Find("ctrl"))
				finished = 1
				target.overlays -= selection
				target = null
				return
			if (T)
				var/obj/adventurepuzzle/triggerable/fireballtrap/F = new /obj/adventurepuzzle/triggerable/fireballtrap(T)
				if (target)
					var/obj/adventurepuzzle/invisible/I = locate() in target
					if (!I)
						I = new /obj/adventurepuzzle/invisible(target)
					F.target = I
					F.power = power
					F.trap_delay = trap_delay
		else if (pa.Find("right"))
			if (isturf(object))
				if (target == object)
					target.overlays -= selection
					target = null
				else
					if (target)
						target.overlays -= selection
					target = object
					target.overlays += selection

/obj/adventurepuzzle/triggerable/fireballtrap
	name = "fireball trap"
	invisibility = 20
	icon = 'icons/obj/wizard.dmi'
	icon_state = "fireball"
	density = 0
	opacity = 0
	anchored = 1
	var/obj/adventurepuzzle/invisible/target
	var/range = 6
	var/power = 5
	var/trap_delay = 100
	var/is_on = 1
	var/next_trap = 0

	var/static/list/triggeracts = list("Activate" = "act", "Disable" = "off", "Destroy" = "del", "Do nothing" = "nop", "Enable" = "on")

	trigger_actions()
		return triggeracts

	trigger(var/act)
		switch(act)
			if ("del")
				is_on = 0
				qdel(src)
			if ("act")
				if (is_on && next_trap <= world.time)
					if (target)
						var/obj/adventurepuzzle/fireball/F = new(src.loc)
						F.target = target
						F.power = power
						F.launch()
						next_trap = world.time + trap_delay
					else
						var/D = range + 1
						var/mob/living/M = null
						for (var/mob/living/C in view(src.range))
							var/dist = get_dist(src, C)
							if (dist < D)
								M = C
								D = dist
						if (M)
							var/obj/adventurepuzzle/fireball/F = new(src.loc)
							F.target = M
							F.power = power
							F.launch()
							next_trap = world.time + trap_delay
			if ("off")
				is_on = 0
				return
			if ("on")
				is_on = 1
				return

	serialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		..()
		F["[path].is_on"] << is_on
		F["[path].range"] << range
		F["[path].trap_delay"] << trap_delay
		F["[path].power"] << power

		if (target)
			F["[path].has_target"] << 1
			F["[path].target"] << "ser:\ref[target]"
		else
			F["[path].has_target"] << 0


	deserialize(var/savefile/F, var/path, var/datum/sandbox/sandbox)
		. = ..()
		F["[path].is_on"] >> is_on
		F["[path].range"] >> range
		F["[path].trap_delay"] >> trap_delay
		F["[path].power"] >> power

		var/has_target
		F["[path].has_target"] >> has_target
		if (has_target)
			F["[path].target"] >> target
			. |= DESERIALIZE_NEED_POSTPROCESS

	deserialize_postprocess()
		..()
		if (target)
			target = locate(target)

	setTarget(var/atom/A)
		target = A

	reset()
		next_trap = 0

/obj/adventurepuzzle/fireball
	name = "fireball"
	icon = 'icons/obj/wizard.dmi'
	icon_state = "fireball"
	density = 1
	opacity = 0
	anchored = 1
	var/atom/target = null
	var/timeout = 15
	var/power = 5
	var/exploding = 0

	New()
		..()
		src.flags |= TABLEPASS

	Bump(var/atom/A)
		var/turf/T = get_turf(A)
		if (T)
			set_loc(T)
		explode()

	proc/launch()
		if (!target)
			loc = null
			qdel(src)
		spawn(0)
			while (loc != get_turf(target))
				if (exploding)
					return
				step_towards(src, target)
				timeout--
				if (!timeout)
					break
				sleep(1)
			explode()

	proc/explode()
		if (exploding)
			return
		for (var/mob/M in viewers(src))
			boutput(M, "<span style=\"color:red\">The [name] explodes!</span>")
		exploding = 1
		var/turf/T = get_turf(src)
		explosion_new(src, T, power)
		fireflash(T, 0)
		qdel(src)