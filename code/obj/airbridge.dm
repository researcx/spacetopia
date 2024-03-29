// Includes:
// - Airbridge controllers
// - Airbridge computers
// - Airbridge test buttons
// - Dummy turfs

//air bridge controlers of the same id will automatically establish and destroy air bridges between each other if told to.
//air bridges have a width of 3 not including the walls.
//dont create more than 2 controlers with the same id or stuff will break. And itll be your fault.
//Also, make sure the bridges can extend in a straight line. Or you're gonna have a really bad time

var/global/list/airbridge_controllers = list()

/* -------------------- Controller -------------------- */

/obj/airbridge_controler
	name = "Airbridge Controller"
	desc = "This is an invisible thing. Yet you can see it. You notice reality unraveling around you."
	icon = 'icons/misc/mark.dmi'
	icon_state = "airbr"
	invisibility = 99
	anchored = 1
	density = 0

	var/tunnel_width = 1
	var/id = "noodles"
	var/working = 0
	var/maintaining_bridge = 0
	var/obj/airbridge_controler/linked = null

	var/list/path = new/list()
	var/list/maintaining_turfs = new/list()

	var/primary_controller = 0 // if 1, the bridge extends from this controller to the other one when toggled by an airbridge computer
	// ONLY SET ONE CONTROLLER TO 1 OR IT'S TOTALLY POINTLESS

	New()
		airbridge_controllers += src
		..()

	proc/get_link()
		for(var/obj/airbridge_controler/C in world)
			if(C.z == src.z && C.id == src.id && C != src)
				linked = C
				break

	proc/toggle_bridge()
		if(linked == null) get_link()
		if(linked == null) return

		if(linked.maintaining_bridge)
			return linked.remove_bridge()
		else if(maintaining_bridge)
			return linked.remove_bridge()
		else
			return establish_bridge()

	proc/pressurize()
		if(linked == null) get_link()
		if(linked == null) return

		if(linked.working || working) return
		if(!linked.maintaining_bridge && !maintaining_bridge) return

		if(!maintaining_turfs.len) return

		working = 1

		spawn(0)
			sleep(50)

			for(var/turf/simulated/T in maintaining_turfs)
				if(!T.air && T.density)
					continue
				T.air.toxins = 0
				T.air.toxins_archived = null
				T.air.oxygen = MOLES_O2STANDARD
				T.air.oxygen_archived = null
				T.air.carbon_dioxide = 0
				T.air.carbon_dioxide_archived = null
				T.air.nitrogen = MOLES_N2STANDARD
				T.air.nitrogen_archived = null
				T.air.fuel_burnt = 0
				T.air.trace_gases = null
				T.air.temperature = T20C
				T.air.temperature_archived = null
				sleep(-1)

			working = 0

		return

	proc/get_state_string()
		if(linked == null) get_link()
		if(linked == null) return "ERROR: Connection to secondary Airbridge controller lost."

		if(linked.working || working) return "Airbridge controller working. Please wait."
		if(linked.maintaining_bridge || maintaining_bridge) return "Airbridge established."
		if(!linked.maintaining_bridge && !maintaining_bridge) return "No active Airbridge."

		return "Unknown State."

	proc/is_working()
		if(linked == null) get_link()
		if(linked == null) return 0

		if(linked.working || working) return 1
		else return 0

	proc/establish_bridge()
		if(linked == null) get_link()
		if(linked == null) return

		if(linked.working || working) return
		if(linked.maintaining_bridge || maintaining_bridge) return

		working = 1
		maintaining_bridge = 1

		spawn(0)
			path.Cut()

			var/turf/current = src.loc
			path.Add(current)
			var/direction = get_dir(current, get_step(current,get_dir(current, linked.loc)))
			path[current] = direction

			while(current != linked.loc)
				var/previous = current
				current = get_step(current,get_dir(current, linked.loc))
				path.Add(current)
				direction = get_dir(previous,current)
				path[current] = direction

			for(var/turf/T in path)
				var/list/added = list()
				var/turf/curr = new/turf/simulated/shuttle/floor { RL_Ignore = 1 } (T)
				maintaining_turfs.Add(curr)
				added.Add(curr)

				for(var/i = 1, i <= tunnel_width, i++)

					if(i == tunnel_width)
						curr = new/turf/simulated/shuttle/wall/destroyable { RL_Ignore = 1 } ( get_steps(T, turn(path[T], 90),i) )
						maintaining_turfs.Add(curr)
						added.Add(curr)

						curr = new/turf/simulated/shuttle/wall/destroyable { RL_Ignore = 1 } ( get_steps(T, turn(path[T], -90),i) )
						maintaining_turfs.Add(curr)
						added.Add(curr)

					else
						curr = new/turf/simulated/shuttle/floor { RL_Ignore = 1 } ( get_steps(T, turn(path[T], 90),i) )
						maintaining_turfs.Add(curr)
						added.Add(curr)

						curr = new/turf/simulated/shuttle/floor { RL_Ignore = 1 } ( get_steps(T, turn(path[T], -90),i) )
						maintaining_turfs.Add(curr)
						added.Add(curr)

				//Please don't look at the following stuff or you might forget how to code properly.
				if(path.Find(T) != path.len)
					for(var/turf/A in added)
						var/obj/shuttledummy/D = null

						if(A.density)
							D = new/obj/shuttledummy/wall(A)
						else
							D = new/obj/shuttledummy/floor(A)

						if(added.Find(A) == added.len)
							if(D.slide(path[T]))
								D.layer = 3 // TODO LAYER
								spawn(20)  qdel(D)
						else
							spawn(0)
								if(D && D.slide(path[T]))
									D.layer = 3 // TODO LAYER
									spawn(20) qdel(D)

				playsound(T, "sound/effects/airbridge_dpl.ogg", 50, 1)
				sleep(1)

			working = 0

		return

	proc/remove_bridge()
		if(linked == null) get_link()
		if(linked == null) return

		if(linked.working || working) return
		if(!linked.maintaining_bridge && !maintaining_bridge) return

		if(!maintaining_bridge && linked.maintaining_bridge)
			linked.remove_bridge()
			return

		working = 1
		maintaining_bridge = 0
		playsound(src.loc, "sound/machines/warning-buzzer.ogg", 50, 1)

		spawn(20)
			var/list/path_reverse = reverse_list(path)

			for(var/turf/T in path_reverse)
				maintaining_turfs.Add(new/turf/space(T))
				harmless_smoke_puff(T)
				for(var/i = 1, i <= tunnel_width, i++)
					maintaining_turfs.Add(new/turf/space( get_steps(T, turn(path[T], 90),i) ) )
					//new/obj/effects/harmless_smoke(get_steps(T, turn(path[T], 90),i))
					maintaining_turfs.Add(new/turf/space( get_steps(T, turn(path[T], -90),i) ) )
					//new/obj/effects/harmless_smoke(get_steps(T, turn(path[T], -90),i))

				playsound(T, "sound/effects/airbridge_dpl.ogg", 50, 1)

				sleep(7)

			maintaining_turfs.Cut()
			working = 0

		return

/* -------------------- Computer -------------------- */


/obj/machinery/computer/airbr
	name = "Airbridge Computer"
	desc = "Used to control the airbridge."
	var/id = "noodles"
	icon_state = "airbr0"

	// set this var to 1 in the map editor if you want the airbridge to establish and pressurize when the round starts
	// only do it to ONE of the computers for the airbridge ID or they will both try to do it and get confused
	var/starts_established = 0

	var/working = 0
	var/state_str = ""

	req_access = list(access_heads)

	var/list/links = list()

	var/obj/airbridge_controler/primary_controller = null

	var/emergency = 0 // 1 to automatically extend when the emergency shuttle docks

	New()
		..()
		if (src.emergency && emergency_shuttle) // emergency_shuttle is the controller datum
			emergency_shuttle.airbridges += src

	proc/get_links()
		if (!airbridge_controllers.len)
			return
		for (var/obj/airbridge_controler/C in airbridge_controllers)//world)
			if (C.id == src.id)
				links.Add(C)
				if (C.primary_controller)
					src.primary_controller = C

	process()
		..()
		update_status()
		if (starts_established && links.len)
			spawn(10)
				do_initial_extend()
		return

	proc/pick_controller()
		if (istype(src.primary_controller))
			return src.primary_controller
		var/obj/airbridge_controler/C = pick(links)
		if (istype(C))
			return C

	proc/do_initial_extend()
		var/obj/airbridge_controler/C = src.pick_controller()
		if (!istype(C))
			return

		C.establish_bridge()

		var/sanity_counter = 0
		while (C.working && sanity_counter < 30)
			sanity_counter++
			sleep(20)

		C.pressurize()
		starts_established = 0

	proc/update_status()
		if (!links.len)
			get_links()

		if (!links.len)
			working = 0
			starts_established = 0
			state_str = "ERROR: No controlers found."
			return

		var/obj/airbridge_controler/C = src.pick_controller()
		if (!istype(C))
			return
		working = C.is_working()
		icon_state = "airbr[working]"
		state_str = C.get_state_string()

	attack_hand(var/mob/user as mob)
		if (..(user))
			return

		update_status()

		var/dat = ""
		dat += "<b>Controller Status:</b><BR>"
		dat += "[state_str]<BR>"
		dat += "[working ? "Working..." : "Idle..."]<BR><BR>"
		dat += "<b>Airbridge Control:</b><BR>"
		dat += "<A href='?src=\ref[src];create=1'>Establish</A><BR>"
		dat += "<A href='?src=\ref[src];remove=1'>Retract</A><BR>"
		dat += "<A href='?src=\ref[src];air=1'>Pressurize</A><BR>"

		user.machine = src
		user << browse("<TITLE>Airbridge Computer</TITLE><BR>[dat]", "window=t_computer;size=400x300")
		onclose(user, "airbr_computer")
		return

	proc/ensure_links()
		if (!src.links.len)
			src.get_links()
		if (!src.links.len)
			src.working = 0
			src.state_str = "ERROR: No controllers found."
			return 0
		else
			return 1

	proc/establish_bridge()
		if (!src.ensure_links())
			return 0
		var/obj/airbridge_controler/C = src.pick_controller()
		if (istype(C))
			C.establish_bridge()
			return 1

	proc/remove_bridge()
		if (!src.ensure_links())
			return 0
		var/obj/airbridge_controler/C = src.pick_controller()
		if (istype(C))
			C.remove_bridge()
			return 1

	proc/pressurize()
		if (!src.ensure_links())
			return 0
		var/obj/airbridge_controler/C = src.pick_controller()
		if (istype(C))
			C.pressurize()
			return 1

	Topic(href, href_list)
		if (..(href, href_list))
			return

		if (href_list["create"])
			if (src.emergency && emergency_shuttle)
				if (emergency_shuttle.location != SHUTTLE_LOC_STATION)
					boutput(usr, "<span style=\"color:red\">The airbridge cannot be deployed while the shuttle is not in position.</span>")
					return
			if (!(src.allowed(usr, req_only_one_required)))
				boutput(usr, "<span style=\"color:red\">Access denied.</span>")
				return
			if (src.establish_bridge())
				logTheThing("station", usr, null, "extended the airbridge at [usr.loc.loc] ([showCoords(usr.x, usr.y, usr.z)])")

		else if (href_list["remove"])
			if (!(src.allowed(usr, req_only_one_required)))
				boutput(usr, "<span style=\"color:red\">Access denied.</span>")
				return
			if (src.remove_bridge())
				logTheThing("station", usr, null, "retracted the airbridge at [usr.loc.loc] ([showCoords(usr.x, usr.y, usr.z)])")

		else if (href_list["air"])
			if (!(src.allowed(usr, req_only_one_required)))
				boutput(usr, "<span style=\"color:red\">Access denied.</span>")
				return
			if (src.pressurize())
				logTheThing("station", usr, null, "pressurized the airbridge at [usr.loc.loc] ([showCoords(usr.x, usr.y, usr.z)])")

		update_status()
		usr << browse(null, "window=airbr_computer")
		//src.updateUsrDialog()
		src.updateDialog()
		return

	power_change()
		if(stat & BROKEN)
			icon_state = "airbrbr"
			light.disable()

		else if(powered())
			icon_state = "airbr0"
			stat &= ~NOPOWER
			light.enable()
		else
			spawn(rand(0, 15))
				icon_state = "airbroff"
				stat |= NOPOWER
				light.disable()
	set_broken()
		if (stat & BROKEN) return
		var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
		smoke.set_up(5, 0, src)
		smoke.start()
		icon_state = initial(icon_state)
		icon_state = "airbrbr"
		light.disable()
		stat |= BROKEN

/obj/machinery/computer/airbr/emergency_shuttle
	icon = 'icons/obj/airtunnel.dmi'
	emergency = 1

/* -------------------- Button -------------------- */

/obj/machinery/airbr_test_button
	name = "Airbridge Button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	desc = ""
	var/id = "noodles"
	var/state = 0
	anchored = 1.0

	attack_hand(mob/user as mob)
		for(var/obj/airbridge_controler/C in range(3, src))
			boutput(usr, "<span style=\"color:orange\">[C.toggle_bridge()]</span>")
			break
		return

/* -------------------- Dummy Turfs -------------------- */

/obj/shuttledummy
	desc = ""
	density = 0
	opacity = 1
	anchored = 1
	layer = FLOOR_EQUIP_LAYER1
	proc/slide(var/direction)
		switch(direction)
			if(NORTH)
				while(pixel_y < 32)
					pixel_y += 4
					sleep(1)
				return 1
			if(SOUTH)
				while(pixel_y > -32)
					pixel_y -= 4
					sleep(1)
				return 1
			if(EAST)
				while(pixel_x < 32)
					pixel_x += 4
					sleep(1)
				return 1
			if(WEST)
				while(pixel_x > -32)
					pixel_x -= 4
					sleep(1)
				return 1
		return 0

/obj/shuttledummy/wall
	name = "wall"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "wall"
	density = 1
	opacity = 1

/obj/shuttledummy/floor
	name = "floor"
	icon = 'icons/turf/shuttle.dmi'
	icon_state = "floor"
	density = 1
	opacity = 0
