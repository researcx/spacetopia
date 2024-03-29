/obj/machinery/bot/secbot
	name = "Securitron"
#ifdef HALLOWEEN
	desc = "A little security robot, apparently carved out of a pumpkin.  He looks...spooky?"
	icon = 'icons/misc/halloween.dmi'
#else
	desc = "A little security robot.  He looks less than thrilled."
	icon = 'icons/obj/aibots.dmi'
#endif
	icon_state = "secbot0"
	layer = 5.0 //TODO LAYER
	density = 0
	anchored = 0
	luminosity = 2
//	weight = 1.0E7
	req_access = list(access_security)
	var/weapon_access = access_carrypermit
	var/obj/item/baton/secbot/our_baton // Our baton.
	on = 1
	locked = 1 //Behavior Controls lock
	var/mob/living/carbon/target
	var/oldtarget_name
	var/threatlevel = 0
	var/target_lastloc //Loc of target when arrested.
	var/last_found //There's a delay
	var/frustration = 0
	emagged = 0 //Emagged Secbots view everyone as a criminal
	health = 25
	var/idcheck = 1 //If false, all station IDs are authorized for weapons.
	var/check_records = 1 //Does it check security records?
	var/arrest_type = 0 //If true, don't handcuff
	var/report_arrests = 0 //If true, report arrests over PDA messages.

	var/botcard_access = "Head of Security" //Job access for doors.
	var/hat = null //Add an overlay from aibots.dmi with this state.  hats.

	var/mode = 0
#define SECBOT_IDLE 		0		// idle
#define SECBOT_HUNT 		1		// found target, hunting
#define SECBOT_PREP_ARREST 	2		// at target, preparing to arrest
#define SECBOT_ARREST		3		// arresting target
#define SECBOT_START_PATROL	4		// start patrol
#define SECBOT_PATROL		5		// patrolling
#define SECBOT_SUMMON		6		// summoned by PDA

	var/auto_patrol = 0		// set to make bot automatically patrol

	var/beacon_freq = 1445		// navigation beacon frequency
	var/control_freq = 1447		// bot control frequency


	var/turf/patrol_target	// this is turf to navigate to (location of beacon)
	var/new_destination		// pending new destination (waiting for beacon response)
	var/destination			// destination description tag
	var/next_destination	// the next destination in the patrol route
	var/list/path = null	// list of path turfs

	var/moving = 0 //Are we currently ON THE MOVE?
	var/current_movepath = 0
	var/datum/secbot_mover/mover = null
	var/arrest_move_delay = 2.5

	var/blockcount = 0		//number of times retried a blocked path
	var/awaiting_beacon	= 0	// count of pticks awaiting a beacon response

	var/nearest_beacon			// the nearest beacon's tag
	var/turf/nearest_beacon_loc	// the nearest beacon's location

	var/datum/light/light

/obj/machinery/bot/secbot/autopatrol
	auto_patrol = 1

/obj/machinery/bot/secbot/beepsky
	name = "Officer Beepsky"
	desc = "It's Officer Beepsky! He's a loose cannon but he gets the job done."
	idcheck = 1
	auto_patrol = 1
	report_arrests = 1
	hat = "nt"

/obj/machinery/bot/secbot/warden
	name = "Warden Jack"
	desc = "The mechanical guardian of the brig."
	auto_patrol = 1
	beacon_freq = 1444
	hat = "helm"

/obj/machinery/bot/secbot/commissar
	name = "Commissar Beepevich"
	desc = "Nobody gets in his way and lives to tell about it."
	health = 40000
	hat = "hos"

/obj/machinery/bot/secbot/formal
	name = "Lord Beepingshire"
	desc = "The most distinguished of security robots."
	hat = "that"

/obj/machinery/bot/secbot/haunted
	name = "Beep-o-Lantern"
	desc = "A little security robot, apparently carved out of a pumpkin.  He looks...spooky?"
	icon = 'icons/misc/halloween.dmi'

/obj/item/secbot_assembly
	name = "helmet/signaler assembly"
	desc = "Some sort of bizarre assembly."
	icon = 'icons/obj/aibots.dmi'
	icon_state = "helmet_signaler"
	item_state = "helmet"
	var/build_step = 0
	var/created_name = "Securitron" //To preserve the name if it's a unique securitron I guess
	var/beacon_freq = 1445 //If it's running on another beacon circuit I guess
	var/hat = null


/obj/machinery/bot/secbot
	New()
		..()
		src.icon_state = "secbot[src.on]"
		if (!src.our_baton || !istype(src.our_baton))
			src.our_baton = new /obj/item/baton/secbot(src)

		light = new /datum/light/point
		light.set_brightness(0.4)
		light.attach(src)
		light.enable()

		spawn(5)
			src.botcard = new /obj/item/card/id(src)
			src.botcard.access = get_access(src.botcard_access)
			if(radio_controller)
				radio_controller.add_object(src, "[control_freq]")
				radio_controller.add_object(src, "[beacon_freq]")
			if(src.hat)
				src.overlays += image('icons/obj/aibots.dmi', "hat-[src.hat]")

	examine()
		set src in view()
		..()

		if (src.health < initial(health))
			if (src.health > 15)
				boutput(usr, text("<span style=\"color:red\">[src]'s parts look loose.</span>"))
			else
				boutput(usr, text("<span style=\"color:red\"><B>[src]'s parts look very loose!</B></span>"))
		return

	attack_hand(user as mob)
		var/dat

		dat += {"<style>body,html{text-align: center;}</style>
<TT><B>Automatic Security Unit v2.0</B></TT><BR><BR>
Status<br><A href='?src=\ref[src];power=1' class='toggle-[src.on]'>[src.on ? "On" : "Off"]</A><BR>
Behaviour controls are [src.locked ? "locked" : "unlocked"]"}

		if(!src.locked)
			dat += {"<BR>
Check for Weapon Authorization<br><A href='?src=\ref[src];operation=idcheck'>[src.idcheck ? "Yes" : "No"]</A><BR>
Check Security Records<br><A href='?src=\ref[src];operation=ignorerec'>[src.check_records ? "Yes" : "No"]</A><BR>
Operating Mode<br><A href='?src=\ref[src];operation=switchmode'>[src.arrest_type ? "Detain" : "Arrest"]</A><BR>
Auto Patrol<br><A href='?src=\ref[src];operation=patrol'>[auto_patrol ? "On" : "Off"]</A><BR>
Report Arrests<br><A href='?src=\ref[src];operation=report'>[report_arrests ? "On" : "Off"]</A>"}


		user << browse("<HEAD><TITLE>Securitron v2.0 controls</TITLE>[css_interfaces]</head>[dat]", "window=autosec")
		onclose(user, "autosec")
		return

	Topic(href, href_list)
		usr.machine = src
		src.add_fingerprint(usr)
		if ((href_list["power"]) && (!src.locked || src.allowed(usr, req_only_one_required)))
			src.on = !src.on
			if (src.on)
				light.enable()
			else
				light.disable()
			src.target = null
			src.oldtarget_name = null
			src.anchored = 0
			src.mode = SECBOT_IDLE
			walk_to(src,0)
			src.icon_state = "secbot[src.on][(src.on && src.emagged == 2) ? "-spaz" : null]"
			src.updateUsrDialog()

		switch(href_list["operation"])
			if ("idcheck")
				src.idcheck = !src.idcheck
				src.updateUsrDialog()
			if ("ignorerec")
				src.check_records = !src.check_records
				src.updateUsrDialog()
			if ("switchmode")
				src.arrest_type = !src.arrest_type
				src.updateUsrDialog()
			if("patrol")
				auto_patrol = !auto_patrol
				mode = SECBOT_IDLE
				updateUsrDialog()
			if("report")
				report_arrests = !src.report_arrests
				updateUsrDialog()

	attack_ai(mob/user as mob)
		if (src.on && src.emagged)
			boutput(user, "<span style=\"color:red\">[src] refuses your authority!</span>")
			return
		src.on = !src.on
		src.target = null
		src.oldtarget_name = null
		mode = SECBOT_IDLE
		src.anchored = 0
		src.icon_state = "secbot[src.on][(src.on && src.emagged == 2) ? "-spaz" : null]"
		walk_to(src,0)

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (src.emagged < 2)
			if (emagged)
				if (user)
					boutput(user, "<span style=\"color:red\">You short out [src]'s system clock inhibition circuis.</span>")
				src.overlays.len = 0
			else if (user)
				boutput(user, "<span style=\"color:red\">You short out [src]'s target assessment circuits.</span>")
			spawn(0)
				for(var/mob/O in hearers(src, null))
					O.show_message("<span style=\"color:red\"><B>[src] buzzes oddly!</B></span>", 1)

			src.anchored = 0
			src.emagged++
			src.on = 1
			src.icon_state = "secbot[src.on][(src.on && src.emagged == 2) ? "-spaz" : null]"
			mode = SECBOT_IDLE
			src.target = null

			if(user)
				src.oldtarget_name = user.name
				src.last_found = world.time
			return 1
		return 0

	demag(var/mob/user)
		if (!src.emagged)
			return 0
		if (user)
			user.show_text("You repair [src]'s damaged electronics. Thank God.", "blue")
		src.emagged = 0
		mode = SECBOT_IDLE
		src.target = null
		src.anchored = 0
		src.icon_state = "secbot0"
		return 1


	emp_act()
		..()
		if(!src.emagged && prob(75))
			src.emagged = 1
			src.visible_message("<span style=\"color:red\"><B>[src] buzzes oddly!</B></span>")
			src.on = 1
		else
			src.explode()
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/device/pda2) && W:ID_card)
			W = W:ID_card
		if (istype(W, /obj/item/card/id))
			if (src.allowed(user, req_only_one_required))
				src.locked = !src.locked
				boutput(user, "Controls are now [src.locked ? "locked." : "unlocked."]")
			else
				boutput(user, "<span style=\"color:red\">Access denied.</span>")

		else if (istype(W, /obj/item/screwdriver))
			if (src.health < initial(health))
				src.health = initial(health)
				src.visible_message("<span style=\"color:red\">[user] repairs [src]!</span>", "<span style=\"color:red\">You repair [src].</span>")
		else
			switch(W.damtype)
				if("fire")
					src.health -= W.force * 0.75
				if("brute")
					src.health -= W.force * 0.5
				else
			if (src.health <= 0)
				src.explode()
			else if (W.force && (!iscarbon(src.target) || (src.mode != SECBOT_HUNT)))
				src.target = user
				src.mode = SECBOT_HUNT
			..()

	proc/navigate_to(atom/the_target,var/move_delay=3,var/adjacent=0)
		if(src.moving) return 1
		src.moving = 1
		src.frustration = 0
		if(src.mover)
			src.mover.master = null
			src.mover = null

		current_movepath = world.time

		src.mover = new /datum/secbot_mover(src)

		// drsingh for cannot modify null.delay
		if (!isnull(src.mover))
			src.mover.master_move(the_target,current_movepath,adjacent)

		// drsingh again for the same thing further down in a moment.
		// Because master_move can delete the mover

		if (!isnull(src.mover))
			src.mover.delay = max(min(move_delay,5),2)

		return 0

	process()
		if (!src.on)
			return

		switch(mode)

			if(SECBOT_IDLE)		// idle

				walk_to(src,0)
				look_for_perp()	// see if any criminals are in range
				if(!mode && auto_patrol)	// still idle, and set to patrol
					mode = SECBOT_START_PATROL	// switch to patrol mode

			if(SECBOT_HUNT)		// hunting for perp

				// if can't reach perp for long enough, go idle
				if (src.frustration >= 8)
			//		for(var/mob/O in hearers(src, null))
			//			boutput(O, "<span class='game say'><span class='name'>[src]</span> beeps, \"Backup requested! Suspect has evaded arrest.\"")
					src.target = null
					src.last_found = world.time
					src.frustration = 0
					src.mode = 0
					//qdel(src.mover)
					if (src.mover)
						src.mover.master = null
						src.mover = null
					src.moving = 0
					//walk_to(src,0)

				if (target)		// make sure target exists
					if (get_dist(src, src.target) <= 1)		// if right next to perp
						src.icon_state = "secbot-c[src.emagged == 2 ? "-spaz" : null]"
						var/mob/living/carbon/M = src.target
						var/maxstuns = 4
						var/stuncount = (src.emagged == 2) ? rand(5,10) : 1

						while (stuncount > 0 && src.target)
							// No need for unnecessary hassle, just make it ignore charges entirely for the time being.
							if (src.our_baton && istype(src.our_baton))
								if (src.our_baton.uses_electricity == 0)
									src.our_baton.uses_electricity = 1
								if (src.our_baton.uses_charges != 0)
									src.our_baton.uses_charges = 0
							else
								src.our_baton = new /obj/item/baton/secbot(src)

							stuncount--
							src.our_baton.do_stun(src, M, "stun", 2)
							if (!stuncount && maxstuns-- <= 0)
								target = null
							if (stuncount > 0)
								sleep(3)

						spawn(2)
							src.icon_state = "secbot[src.on][(src.on && src.emagged == 2) ? "-spaz" : null]"
						mode = SECBOT_PREP_ARREST
						src.anchored = 1
						src.target_lastloc = M.loc
						moving = 0
						//qdel(src.mover)
						if (src.mover)
							src.mover.master = null
							src.mover = null
						src.frustration = 0
						return

						if(!path || !path.len || (4 < get_dist(src.target,path[path.len])) )
							moving = 0
							if (src.mover)
								src.mover.master = null
								src.mover = null
							//current_movepath = "HEH" //Stop any current movement.
							navigate_to(src.target,arrest_move_delay)

					else								// not next to perp
						if(!(src.target in view(7,src)) || !moving)
							//qdel(src.mover)
							if (src.mover)
								src.mover.master = null
								src.mover = null
							src.moving = 0
							navigate_to(src.target,(src.emagged == 2) ? (arrest_move_delay/2) : arrest_move_delay)
							return
					/*
						var/turf/olddist = get_dist(src, src.target)
						walk_to(src, src.target,1,4)
						if ((get_dist(src, src.target)) >= (olddist))
							src.frustration++
						else
							src.frustration = 0
					*/

			if(SECBOT_PREP_ARREST)		// preparing to arrest target

				// see if he got away
				if ((get_dist(src, src.target) > 1) || ((src.target:loc != src.target_lastloc) && src.target:weakened < 2))
					src.anchored = 0
					mode = SECBOT_HUNT
					if (!src.mover)
						src.moving = 0
						navigate_to(src.target)
					return
/*
				if (istype(src.target, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src.target
					if(istype(H.mutantrace, /datum/mutantrace/abomination))
						return
*/
				if (!src.target.handcuffed && !src.arrest_type)
					playsound(src.loc, "sound/weapons/handcuffs.ogg", 30, 1, -2)
					mode = SECBOT_ARREST
					src.visible_message("<span style=\"color:red\"><B>[src] is trying to put handcuffs on [src.target]!</B></span>")

					spawn(60)
						if (get_dist(src, src.target) <= 1)
							if (!src.target || src.target.handcuffed)
								return

							var/uncuffable = 0
							if (ishuman(src.target))
								var/mob/living/carbon/human/H = src.target
								//if(H.bioHolder.HasEffect("lost_left_arm") || H.bioHolder.HasEffect("lost_right_arm"))
								if(!H.limbs.l_arm || !H.limbs.r_arm)
									uncuffable = 1

							if (!isturf(src.target.loc))
								uncuffable = 1

							if(iscarbon(src.target) && !uncuffable)
								src.target.handcuffed = new /obj/item/handcuffs(src.target)

							var/last_target = target

							mode = SECBOT_IDLE
							src.target = null
							src.anchored = 0
							src.last_found = world.time
							src.frustration = 0

							if(!uncuffable) playsound(src.loc, pick('sound/voice/bgod.ogg', 'sound/voice/biamthelaw.ogg', 'sound/voice/bsecureday.ogg', 'sound/voice/bradio.ogg', 'sound/voice/binsult.ogg', 'sound/voice/bcreep.ogg'), 50, 0, 0, 1)
			//					var/arrest_message = pick("Have a secure day!","I AM THE LAW.", "God made tomorrow for the crooks we don't catch today.","You can't outrun a radio.")
			//					src.speak(arrest_message)
							if (src.report_arrests && !uncuffable)
								var/bot_location = get_area(src)
									//////PDA NOTIFY/////
								var/datum/radio_frequency/transmit_connection = radio_controller.return_frequency("1149")
								var/datum/signal/pdaSignal = get_free_signal()
								pdaSignal.data = list("address_1"="00000000", "command"="text_message", "sender_name"="SECURITY-MAILBOT",  "group"="security", "sender"="00000000", "message"="Notification: [last_target] detained by [src] in [bot_location].")
								pdaSignal.transmission_method = TRANSMISSION_RADIO
								if(transmit_connection != null)
									transmit_connection.post_signal(src, pdaSignal)

			if(SECBOT_ARREST)		// arresting

				if (src.frustration >= 8)
					src.target = null
					src.last_found = world.time
					src.frustration = 0
					src.mode = 0
					//qdel(src.mover)
					if (src.mover)
						src.mover.master = null
						src.mover = null
					src.moving = 0

				if(src.target)
					if (src.target.handcuffed)
						src.anchored = 0
						mode = SECBOT_IDLE
						return
					else if (!src.target.weakened)
						src.anchored = 0
						mode = SECBOT_HUNT

					if (get_dist(src, src.target) > 1 && (!src.mover || !src.moving))
						//qdel(src.mover)
						if (src.mover)
							src.mover.master = null
							src.mover = null
						src.moving = 0
						navigate_to(src.target)
						return
				else
					mode = SECBOT_IDLE
					return


			if(SECBOT_START_PATROL)	// start a patrol

				if(path && path.len && patrol_target) // have a valid path, so just resume
					mode = SECBOT_PATROL
					return

				else if(patrol_target)		// has patrol target already
					spawn(0)
						calc_path()		// so just find a route to it
						if(!path || !path.len)
							patrol_target = 0
							return
						mode = SECBOT_PATROL


				else					// no patrol target, so need a new one
					find_patrol_target()
						//speak("Engaging patrol mode.")


			if(SECBOT_PATROL)		// patrol mode

				patrol_step()
				spawn(5)
					if(mode == SECBOT_PATROL)
						patrol_step()

			if(SECBOT_SUMMON)		// summoned to PDA
				patrol_step()
				spawn(4)
					if(mode == SECBOT_SUMMON)
						patrol_step()
						sleep(4)
						patrol_step()

		return


	// perform a single patrol step

	proc/patrol_step()

		if(loc == patrol_target)		// reached target
			at_patrol_target()
			return

		else if (path && path.len && patrol_target) // valid path

			var/turf/next = path[1]
			if(next == loc)
				path -= next
				return


			if(istype( next, /turf/simulated))

				var/moved = step_towards(src, next)	// attempt to move
				if(moved)	// successful move
					blockcount = 0
					path -= loc

					look_for_perp()
				else		// failed to move

					blockcount++

					if(blockcount > 5)	// attempt 5 times before recomputing
						// find new path excluding blocked turf

						spawn(2)
							calc_path(next)
							if (!path)
								find_patrol_target()
							else
								blockcount = 0

						return

					return

			else	// not a valid turf
				mode = SECBOT_IDLE
				return

		else	// no path, so calculate new one
			mode = SECBOT_START_PATROL


	// finds a new patrol target
	proc/find_patrol_target()
		send_status()
		if(awaiting_beacon)			// awaiting beacon response
			awaiting_beacon++
			if(awaiting_beacon > 5)	// wait 5 secs for beacon response
				find_nearest_beacon()	// then go to nearest instead
				return 0
			else
				return 1

		if(next_destination)
			set_destination(next_destination)
			return 1
		else
			find_nearest_beacon()
			return 0


	// finds the nearest beacon to self
	// signals all beacons matching the patrol code
	proc/find_nearest_beacon()
		nearest_beacon = null
		new_destination = "__nearest__"
		post_signal(beacon_freq, "findbeacon", "patrol")
		awaiting_beacon = 1
		spawn(10)
			awaiting_beacon = 0
			if(nearest_beacon)
				set_destination(nearest_beacon)
			else
				auto_patrol = 0
				mode = SECBOT_IDLE
				//speak("Disengaging patrol mode.")
				send_status()


	proc/at_patrol_target()
		find_patrol_target()
		return


	// sets the current destination
	// signals all beacons matching the patrol code
	// beacons will return a signal giving their locations
	proc/set_destination(var/new_dest)
		new_destination = new_dest
		post_signal(beacon_freq, "findbeacon", "patrol")
		awaiting_beacon = 1


	// receive a radio signal
	// used for beacon reception

	receive_signal(datum/signal/signal)

		if(!on)
			return

		/*
		boutput(world, "rec signal: [signal.source]")
		for(var/x in signal.data)
			boutput(world, "* [x] = [signal.data[x]]")
		*/

		var/recv = signal.data["command"]
		// process all-bot input
		if(recv=="bot_status")
			send_status()

		// check to see if we are the commanded bot
		if(signal.data["active"] == src)
		// process control input
			switch(recv)
				if("stop")
					mode = SECBOT_IDLE
					auto_patrol = 0
					return

				if("go")
					mode = SECBOT_IDLE
					auto_patrol = 1
					return

				if("summon")
					patrol_target = signal.data["target"]
					next_destination = destination
					destination = null
					awaiting_beacon = 0
					mode = SECBOT_SUMMON
					calc_path()
					speak("Responding.")

					return



		// receive response from beacon
		recv = signal.data["beacon"]
		var/valid = signal.data["patrol"]
		if(!recv || !valid)
			return

		if(recv == new_destination)	// if the recvd beacon location matches the set destination
									// the we will navigate there
			destination = new_destination
			patrol_target = signal.source.loc
			next_destination = signal.data["next_patrol"]
			awaiting_beacon = 0

		// if looking for nearest beacon
		else if(new_destination == "__nearest__")
			var/dist = get_dist(src,signal.source.loc)
			if(nearest_beacon)

				// note we ignore the beacon we are located at
				if(dist>1 && dist<get_dist(src,nearest_beacon_loc))
					nearest_beacon = recv
					nearest_beacon_loc = signal.source.loc
					return
				else
					return
			else if(dist > 1)
				nearest_beacon = recv
				nearest_beacon_loc = signal.source.loc
		return


	// send a radio signal with a single data key/value pair
	proc/post_signal(var/freq, var/key, var/value)
		post_signal_multiple(freq, list("[key]" = value) )

	// send a radio signal with multiple data key/values
	proc/post_signal_multiple(var/freq, var/list/keyval)

		var/datum/radio_frequency/frequency = radio_controller.return_frequency("[freq]")

		if(!frequency) return

		var/datum/signal/signal = get_free_signal()
		signal.source = src
		signal.transmission_method = 1
		for(var/key in keyval)
			signal.data[key] = keyval[key]
			//boutput(world, "sent [key],[keyval[key]] on [freq]")
		frequency.post_signal(src, signal)

	// signals bot status etc. to controller
	proc/send_status()
		var/list/kv = new()
		kv["type"] = "secbot"
		kv["name"] = name
		kv["loca"] = get_area(src)
		kv["mode"] = mode
		post_signal_multiple(control_freq, kv)



// calculates a path to the current destination
// given an optional turf to avoid
	proc/calc_path(var/turf/avoid = null)
		if (!isturf(src.loc))
			return
		src.path = AStar(src.loc, patrol_target, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 120, botcard, avoid)


// look for a criminal in view of the bot

	proc/look_for_perp()
		src.anchored = 0
		for (var/mob/living/carbon/C in view(7,src)) //Let's find us a criminal
			if ((C.stat) || (C.handcuffed))
				continue
			if ((C.name == src.oldtarget_name) && (world.time < src.last_found + 100))
				continue
			if (ishuman(C))
				src.threatlevel = src.assess_perp(C)
			if (!src.threatlevel)
				continue

			else if (src.threatlevel >= 4)
				src.target = C
				src.oldtarget_name = C.name
				src.speak("Level [src.threatlevel] infraction alert!")
				playsound(src.loc, pick('sound/voice/bcriminal.ogg', 'sound/voice/bjustice.ogg', 'sound/voice/bfreeze.ogg'), 50, 0)
				src.visible_message("<b>[src]</b> points at [C.name]!")
				mode = SECBOT_HUNT
				spawn(0)
					src.frustration = 0
					if(!src.moving || !src.mover)
						src.moving = 0
						src.navigate_to(src.target)
					process()	// ensure bot quickly responds to a perp
				// sorry for making a mess here i will clean it up later i promise xoxoxo -drsingh
				spawn(0)
					var/weeoo = 10
					playsound(src.loc, "sound/machines/siren_police.ogg", 50, 1)

					light.set_brightness(0.8)
					while (weeoo)
						light.set_color(0.9, 0.1, 0.1)
						sleep(3)
						light.set_color(0.1, 0.1, 0.9)
						sleep(3)
						weeoo--

					light.set_brightness(0.4)
					light.set_color(1, 1, 1)

				break
			else
				continue


//If the security records say to arrest them, arrest them
//Or if they have weapons and aren't security, arrest them.
	proc/assess_perp(mob/living/carbon/human/perp as mob)
		var/threatcount = 0

		if(src.emagged) return 10 //Everyone is a criminal!

		if((src.idcheck) || (isnull(perp:wear_id)) || (istype(perp:wear_id, /obj/item/card/id/syndicate)))
			var/obj/item/card/id/perp_id = perp.equipped()
			if (!istype(perp_id))
				perp_id = perp.wear_id

			if(perp_id && (weapon_access in perp_id.access)) //Corrupt cops cannot exist, beep boop
				return 0
/*
			if(istype(perp.l_hand, /obj/item/gun) || istype(perp.l_hand, /obj/item/baton) || istype(perp.l_hand, /obj/item/sword))
				threatcount += 4

			if(istype(perp.r_hand, /obj/item/gun) || istype(perp.r_hand, /obj/item/baton) || istype(perp.r_hand, /obj/item/sword))
				threatcount += 4

			if(istype(perp:belt, /obj/item/gun) || istype(perp:belt, /obj/item/baton) || istype(perp:belt, /obj/item/sword))
				threatcount += 2

			if(istype(perp:wear_suit, /obj/item/clothing/suit/wizrobe))
				threatcount += 4
*/
			if (istype(perp.l_hand))
				threatcount += perp.l_hand.contraband

			if (istype(perp.r_hand))
				threatcount += perp.r_hand.contraband

			if (istype(perp:belt))
				threatcount += perp:belt.contraband * 0.5

			if (istype(perp:wear_suit))
				threatcount += perp:wear_suit.contraband

			if(perp.mutantrace)
				threatcount += 2

	//Agent cards lower threatlevel when normal idchecking is off.
			if((istype(perp:wear_id, /obj/item/card/id/syndicate)) && src.idcheck)
				threatcount -= 2

		if (src.check_records)
			for (var/datum/data/record/E in data_core.general)
				var/perpname = perp.name
				if (perp:wear_id && perp:wear_id:registered)
					perpname = perp.wear_id:registered
				if (E.fields["name"] == perpname)
					for (var/datum/data/record/R in data_core.security)
						if ((R.fields["id"] == E.fields["id"]) && (R.fields["criminal"] == "*Arrest*"))
							threatcount = 4
							break

		return threatcount

	Bumped(M as mob|obj)
		spawn(0)
			var/turf/T = get_turf(src)
			M:set_loc(T)

	bullet_act(var/obj/projectile/P)
		var/damage = 0
		damage = round(((P.power/4)*P.proj_data.ks_ratio), 1.0)

		if(P.proj_data.damage_type == D_KINETIC)
			src.health -= damage
		else if(P.proj_data.damage_type == D_PIERCING)
			src.health -= (damage*2)
		else if(P.proj_data.damage_type == D_ENERGY)
			src.health -= damage

		if (src.health <= 0)
			src.explode()
			return

		if (ismob(P.shooter))
			var/mob/living/M = P.shooter
			if (P && iscarbon(M) && (!iscarbon(src.target) || (src.mode != SECBOT_HUNT)))
				src.target = M
				src.mode = SECBOT_HUNT
		return

	speak(var/message)
		if (src.emagged == 2)
			message = capitalize(ckeyEx(message))
			..(message)

	//Generally we want to explode() instead of just deleting the securitron.
	ex_act(severity)
		switch(severity)
			if(1.0)
				src.explode()
				return
			if(2.0)
				src.health -= 15
				if (src.health <= 0)
					src.explode()
				return
		return

	meteorhit()
		src.explode()
		return

	blob_act(var/power)
		if(prob(25 * power / 20))
			src.explode()
		return

	explode()

		walk_to(src,0)
		for(var/mob/O in hearers(src, null))
			O.show_message("<span style=\"color:red\"><B>[src] blows apart!</B></span>", 1)
		var/turf/Tsec = get_turf(src)

		var/obj/item/secbot_assembly/Sa = new /obj/item/secbot_assembly(Tsec)
		Sa.build_step = 1
		Sa.overlays += image('icons/obj/aibots.dmi', "hs_hole")
		Sa.created_name = src.name
		Sa.beacon_freq = src.beacon_freq
		Sa.hat = src.hat
		new /obj/item/device/prox_sensor(Tsec)

		// Not charged when dropped (ran on Beepsky's internal battery or whatever).
		var/obj/item/baton/B = new /obj/item/baton(Tsec)
		B.status = 0
		B.process_charges(-INFINITY)

		if (prob(50))
			new /obj/item/parts/robot_parts/arm/left(Tsec)

		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(3, 1, src)
		s.start()
		qdel(src)


//movement control datum. Why yes, this is copied from guardbot.dm
/datum/secbot_mover
	var/obj/machinery/bot/secbot/master = null
	var/delay = 3

	New(var/newmaster)
		..()
		if(istype(newmaster, /obj/machinery/bot/secbot))
			src.master = newmaster
		return

	proc/master_move(var/atom/the_target as obj|mob, var/current_movepath,var/adjacent=0)
		if(!master || !isturf(master.loc))
			src.master = null
			//dispose()
			return
		var/target_turf = null
		if(isturf(the_target))
			target_turf = the_target
		else
			target_turf = get_turf(the_target)
		spawn(0)
			if (!master)
				return
			var/compare_movepath = current_movepath
			master.path = AStar(get_turf(master), target_turf, /turf/proc/CardinalTurfsWithAccess, /turf/proc/Distance, 60, master.botcard)
			if(adjacent && master.path && master.path.len) //Make sure to check it isn't null!!
				master.path.len-- //Only go UP to the target, not the same tile.
			if(!master.path || !master.path.len || !the_target)
				//if(master.task)
				//	master.task.task_input("path_error")

				master.frustration = INFINITY
				master.mover = null
				master = null
				//dispose()
				return 1

			while(master && master.path && master.path.len && target_turf && master.moving)
//				boutput(world, "[compare_movepath] : [current_movepath]")
				if(compare_movepath != current_movepath) break
				if(!master.on)
					master.frustration = 0
					break
				step_to(master, master.path[1])
				if(master.loc != master.path[1])
					master.frustration++
					sleep(delay)
					continue
				master.path -= master.path[1]
				sleep(delay)

			if (master)
				master.moving = 0
				master.mover = null
				master = null

			//dispose()
			return

		return



//Secbot Construction

/obj/item/clothing/head/helmet/attackby(var/obj/item/device/radio/signaler/S, mob/user as mob)
	if (!istype(S, /obj/item/device/radio/signaler))
		..()
		return

	if (src.type != /obj/item/clothing/head/helmet) //Eh, but we don't want people making secbots out of space helmets.
		return

	if (!S.b_stat)
		return
	else
		var/obj/item/secbot_assembly/A = new /obj/item/secbot_assembly
		user.u_equip(S)
		user.put_in_hand_or_drop(A)
		boutput(user, "You add the signaler to the helmet.")
		qdel(S)
		qdel(src)


/obj/item/secbot_assembly/attackby(obj/item/W as obj, mob/user as mob)
	if ((istype(W, /obj/item/weldingtool)) && (!src.build_step))
		if ((W:welding) && (W:get_fuel() >= 1))
			W:use_fuel(1)
			src.build_step++
			src.overlays += image('icons/obj/aibots.dmi', "hs_hole")
			boutput(user, "You weld a hole in [src]!")

	else if ((istype(W, /obj/item/device/prox_sensor)) && (src.build_step == 1))
		src.build_step++
		boutput(user, "You add the prox sensor to [src]!")
		src.overlays += image('icons/obj/aibots.dmi', "hs_eye")
		src.name = "helmet/signaler/prox sensor assembly"
		qdel(W)

	else if (istype(W, /obj/item/parts/robot_parts/arm/) && src.build_step == 2)
		src.build_step++
		boutput(user, "You add the robot arm to [src]!")
		src.name = "helmet/signaler/prox sensor/robot arm assembly"
		src.overlays += image('icons/obj/aibots.dmi', "hs_arm")
		qdel(W)

	else if ((istype(W, /obj/item/baton)) && (src.build_step >= 3))
		src.build_step++
		boutput(user, "You complete the Securitron! Beep boop.")
		var/obj/machinery/bot/secbot/S = new /obj/machinery/bot/secbot(get_turf(src))
		S.beacon_freq = src.beacon_freq
		S.hat = src.hat
		S.name = src.created_name
		qdel(W)
		qdel(src)

	else if (istype(W, /obj/item/pen))
		var/t = input(user, "Enter new robot name", src.name, src.created_name) as text
		t = strip_html(replacetext(t, "'",""))
		t = copytext(t, 1, 45)
		if (!t)
			return
		if (!in_range(src, usr) && src.loc != usr)
			return

		src.created_name = t