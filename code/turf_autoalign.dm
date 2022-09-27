// maps: COG2 causes nornwalls, DESTINY causes gannetwalls, anything else doesn't get saved
// SPACETOPIA is love, SPACETOPIA is life

var/global/map_setting = "SPACETOPIA"

/obj/landmark/map
	name = "map_setting"
	icon_state = "x3"
	invisibility = 101

	New()
		if (src.name && (src.name == "COG2" || src.name == "DESTINY"))
			map_setting = src.name
		qdel(src)

/* =================================================== */
/* -------------------- SIMULATED -------------------- */
/* =================================================== */

/turf/simulated/wall/auto
	icon = 'icons/turf/walls_auto.dmi'
	var/mod = null
	var/light_mod = null
	var/connect_overlay = 0 // do we have wall connection overlays, ex nornwalls?
	var/list/connects_to = list(/turf/simulated/wall/auto)
	var/list/connects_with_overlay = list()
	var/image/connect_image = null
	var/d_state = 0

	New()
		..()
		spawn(0)
			src.update_icon()

	// ty to somepotato for assistance with making this proc actually work right :I
	proc/update_icon()
		var/builtdir = 0
		var/overlaydir = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type == src.type || (T.type in connects_to))
				builtdir |= dir
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						break
			if (connect_overlay && connects_with_overlay)
				if (T.type in connects_with_overlay)
					overlaydir |= dir
				else
					for (var/i=1, i <= connects_with_overlay.len, i++)
						var/atom/A = locate(connects_with_overlay[i]) in T
						if (!isnull(A))
							if (istype(A, /atom/movable))
								var/atom/movable/M = A
								if (!M.anchored)
									continue
							overlaydir |= dir

		src.icon_state = "[mod][builtdir][src.d_state ? "C" : null]"
		if (light_mod)
			src.RL_SetSprite("[light_mod][builtdir]")

		if (connect_overlay)
			if (overlaydir)
				if (!src.connect_image)
					src.connect_image = image(src.icon, "connect[overlaydir]")
				else
					src.connect_image.icon_state = "connect[overlaydir]"
				src.UpdateOverlays(src.connect_image, "connect")
			else
				src.UpdateOverlays(null, "connect")

/turf/simulated/wall/auto/reinforced
	name = "reinforced wall"
	health = 300
	explosion_resistance = 7
	mod = "R"
	icon_state = "mapwall_r"
	connects_to = list(/turf/simulated/wall/auto/reinforced)

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/light_parts))
			src.attach_light_fixture_parts(user, W) // Made this a proc to avoid duplicate code (Convair880).
			return

	/* ----- Deconstruction ----- */
		if (istype(W, /obj/item/wirecutters))
			if (src.d_state == 0)
				playsound(src.loc, "sound/items/Wirecutter.ogg", 100, 1)
				src.d_state = 1
				var/atom/A = new /obj/item/rods(src)
				if (src.material)
					A.setMaterial(src.material)
				else
					A.setMaterial(getCachedMaterial("steel"))
				src.update_icon()

		else if (istype(W, /obj/item/screwdriver))
			if (src.d_state == 1)
				var/turf/T = user.loc
				playsound(src.loc, "sound/items/Screwdriver.ogg", 100, 1)
				boutput(user, "<span style=\"color:orange\">Removing support lines.</span>")
				sleep(40)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 2
					boutput(user, "<span style=\"color:orange\">You removed the support lines.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 2
					boutput(user, "<span style=\"color:orange\">You removed the support lines.</span>")

		else if (istype(W, /obj/item/weldingtool) && W:welding)
			var/obj/item/weldingtool/Weld = W
			Weld.eyecheck(user)
			var/turf/T = user.loc
			if (!(istype(T, /turf)))
				return

			if (src.d_state == 2)
				boutput(user, "<span style=\"color:orange\">Slicing metal cover.</span>")
				playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
				sleep(60)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 3
					boutput(user, "<span style=\"color:orange\">You removed the metal cover.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 3
					boutput(user, "<span style=\"color:orange\">You removed the metal cover.</span>")

			else if (src.d_state == 5)
				boutput(user, "<span style=\"color:orange\">Removing support rods.</span>")
				playsound(src.loc, "sound/items/Welder.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 6
					var/atom/A = new /obj/item/rods( src )
					if (src.material)
						A.setMaterial(src.material)
					else
						A.setMaterial(getCachedMaterial("steel"))
					boutput(user, "<span style=\"color:orange\">You removed the support rods.</span>")
				else if ((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 6
					var/atom/A = new /obj/item/rods( src )
					if (src.material)
						A.setMaterial(src.material)
					else
						A.setMaterial(getCachedMaterial("steel"))
					boutput(user, "<span style=\"color:orange\">You removed the support rods.</span>")

		else if (istype(W, /obj/item/crowbar))
			if (src.d_state == 3)
				var/turf/T = user.loc
				boutput(user, "<span style=\"color:orange\">Prying cover off.</span>")
				playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 4
					boutput(user, "<span style=\"color:orange\">You removed the cover.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 4
					boutput(user, "<span style=\"color:orange\">You removed the cover.</span>")

			else if (src.d_state == 6)
				var/turf/T = user.loc
				boutput(user, "<span style=\"color:orange\">Prying outer sheath off.</span>")
				playsound(src.loc, "sound/items/Crowbar.ogg", 100, 1)
				sleep(100)
				if ((user.loc == T && user.equipped() == W))
					boutput(user, "<span style=\"color:orange\">You removed the outer sheath.</span>")
					logTheThing("station", user, null, "dismantles a Reinforced Wall in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					dismantle_wall()
					return
				else if ((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					boutput(user, "<span style=\"color:orange\">You removed the outer sheath.</span>")
					logTheThing("station", user, null, "dismantles a Reinforced Wall in [user.loc.loc] ([showCoords(user.x, user.y, user.z)])")
					dismantle_wall()
					return

		else if (istype(W, /obj/item/wrench))
			if (src.d_state == 4)
				var/turf/T = user.loc
				boutput(user, "<span style=\"color:orange\">Detaching support rods.</span>")
				playsound(src.loc, "sound/items/Ratchet.ogg", 100, 1)
				sleep(40)
				if ((user.loc == T && user.equipped() == W))
					src.d_state = 5
					boutput(user, "<span style=\"color:orange\">You detach the support rods.</span>")
				else if((istype(user, /mob/living/silicon/robot) && (user.loc == T)))
					src.d_state = 5
					boutput(user, "<span style=\"color:orange\">You detach the support rods.</span>")
	/* ----- End Deconstruction ----- */

		else if (istype(W, /obj/item/device/key/haunted))
			var/obj/item/device/key/haunted/H = W
			//Okay, create a temporary false wall.
			if (H.last_use && ((H.last_use + 300) >= world.time))
				boutput(user, "<span style=\"color:red\">The key won't fit in all the way!</span>")
				return
			user.visible_message("<span style=\"color:red\">[user] inserts [W] into [src]!</span>","<span style=\"color:red\">The key seems to phase into the wall.</span>")
			H.last_use = world.time
			blink(src)
			var/turf/simulated/wall/false_wall/temp/fakewall = new /turf/simulated/wall/false_wall/temp(src)
			fakewall.was_rwall = 1
			fakewall.opacity = 0
			fakewall.RL_SetOpacity(1) //Lighting rebuild.
			return

		else if (istype(W, /obj/item/sheet) && src.d_state)
			var/obj/item/sheet/S = W
			var/turf/T = user.loc
			boutput(user, "<span style=\"color:orange\">Repairing wall.</span>")
			sleep(100)
			if (user.loc == T && user.equipped() == S)
				src.d_state = 0
				src.icon_state = initial(src.icon_state)
				if (S.material)
					src.setMaterial(S.material)
				else
					var/datum/material/M = getCachedMaterial("steel")
					src.setMaterial(M)
				boutput(user, "<span style=\"color:orange\">You repaired the wall.</span>")
				if (S.amount > 1)
					S.amount--
				else
					qdel(W)
			else if (istype(user, /mob/living/silicon/robot) && user.loc == T)
				src.d_state = 0
				src.icon_state = initial(src.icon_state)
				if (W.material)
					src.setMaterial(S.material)
				boutput(user, "<span style=\"color:orange\">You repaired the wall.</span>")
				if (S.amount > 1)
					S.amount--
				else
					qdel(W)

		else if (istype(W, /obj/item/grab))
			var/obj/item/grab/G = W
			if (!grab_smash(G, user))
				return ..(W, user)
			else
				return

		if (src.material)
			var/fail = 0
			if (prob(src.material.getProperty(PROP_INSTABILITY)))
				fail = 1
			if (src.material.quality < 0) if(prob(abs(src.material.quality)))
				fail = 1
			if (fail)
				user.visible_message("<span style=\"color:red\">You hit the wall and it [getMatFailString(src.material.material_flags)]!</span>","<span style=\"color:red\">[user] hits the wall and it [getMatFailString(src.material.material_flags)]!</span>")
				playsound(src.loc, "sound/weapons/Genhit.ogg", 25, 1)
				del(src)
				return

		src.take_hit(W)

/turf/simulated/wall/auto/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)
	connects_with_overlay = list(/turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)

/turf/simulated/wall/auto/reinforced/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/simulated/wall/auto/supernorn, /turf/simulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)
	connects_with_overlay = list(/turf/simulated/wall/auto/supernorn, /obj/machinery/door,
	/obj/window)

/turf/simulated/wall/auto/gannets
	icon = 'icons/turf/walls_destiny.dmi'
	connects_to = list(/turf/simulated/wall/auto/gannets)

/turf/simulated/wall/auto/reinforced/gannets
	icon = 'icons/turf/walls_destiny.dmi'
	connects_to = list(/turf/simulated/wall/auto/reinforced/gannets)

/* ===================================================== */
/* -------------------- UNSIMULATED -------------------- */
/* ===================================================== */

// I should really just have the auto-wall stuff on the base /turf so there's less copy/paste code shit going on
// but that will have to wait for another day so for now, copy/paste it is
/turf/unsimulated/wall/auto
	icon = 'icons/turf/walls_auto.dmi'
	var/mod = null
	var/light_mod = null
	var/connect_overlay = 0 // do we have wall connection overlays, ex nornwalls?
	var/list/connects_to = list(/turf/unsimulated/wall/auto)
	var/list/connects_with_overlay = list()
	var/image/connect_image = null
	var/d_state = 0

	New()
		..()
		spawn(0)
			src.update_icon()

	proc/update_icon()
		var/builtdir = 0
		var/overlaydir = 0
		for (var/dir in cardinal)
			var/turf/T = get_step(src, dir)
			if (T.type == src.type || (T.type in connects_to))
				builtdir |= dir
			else if (connects_to)
				for (var/i=1, i <= connects_to.len, i++)
					var/atom/A = locate(connects_to[i]) in T
					if (!isnull(A))
						if (istype(A, /atom/movable))
							var/atom/movable/M = A
							if (!M.anchored)
								continue
						builtdir |= dir
						break
			if (connect_overlay && connects_with_overlay)
				if (T.type in connects_with_overlay)
					overlaydir |= dir
				else
					for (var/i=1, i <= connects_with_overlay.len, i++)
						var/atom/A = locate(connects_with_overlay[i]) in T
						if (!isnull(A))
							if (istype(A, /atom/movable))
								var/atom/movable/M = A
								if (!M.anchored)
									continue
							overlaydir |= dir

		src.icon_state = "[mod][builtdir][src.d_state ? "C" : null]"
		if (light_mod)
			src.RL_SetSprite("[light_mod][builtdir]")

		if (connect_overlay)
			if (overlaydir)
				if (!src.connect_image)
					src.connect_image = image(src.icon, "connect[overlaydir]")
				else
					src.connect_image.icon_state = "connect[overlaydir]"
				src.UpdateOverlays(src.connect_image, "connect")
			else
				src.UpdateOverlays(null, "connect")

/turf/unsimulated/wall/auto/reinforced
	name = "reinforced wall"
	mod = "R"
	icon_state = "mapwall_r"
	connects_to = list(/turf/unsimulated/wall/auto/reinforced)

/turf/unsimulated/wall/auto/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/unsimulated/wall/auto/supernorn, /turf/unsimulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)
	connects_with_overlay = list(/turf/unsimulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)

/turf/unsimulated/wall/auto/reinforced/supernorn
	icon = 'icons/turf/walls_supernorn.dmi'
	light_mod = "wall-"
	connect_overlay = 1
	connects_to = list(/turf/unsimulated/wall/auto/supernorn, /turf/unsimulated/wall/auto/reinforced/supernorn, /obj/machinery/door,
	/obj/window)
	connects_with_overlay = list(/turf/unsimulated/wall/auto/supernorn, /obj/machinery/door,
	/obj/window)

/turf/unsimulated/wall/auto/gannets
	icon = 'icons/turf/walls_destiny.dmi'
	connects_to = list(/turf/unsimulated/wall/auto/gannets)

/turf/unsimulated/wall/auto/reinforced/gannets
	icon = 'icons/turf/walls_destiny.dmi'
	connects_to = list(/turf/unsimulated/wall/auto/reinforced/gannets)
