/datum/robot_cosmetic
	var/head_mod = null
	var/ches_mod = null
	var/arms_mod = null
	var/legs_mod = null
	var/list/fx = list(255,0,0)
	var/painted = 0
	var/list/paint = list(0,0,0)

/mob/living/silicon/robot
	name = "Cyborg"
	voice_name = "synthesized voice"
	icon = 'icons/mob/robots.dmi'
	icon_state = "robot"
	health = 300
	emaggable = 1
	syndicate_possible = 1

	var/datum/hud/robot/hud

// Pieces and parts
	var/obj/item/parts/robot_parts/head/part_head = null
	var/obj/item/parts/robot_parts/chest/part_chest = null
	var/obj/item/parts/robot_parts/arm/part_arm_r = null
	var/obj/item/parts/robot_parts/arm/part_arm_l = null
	var/obj/item/parts/robot_parts/leg/part_leg_r = null
	var/obj/item/parts/robot_parts/leg/part_leg_l = null
	var/datum/robot_cosmetic/cosmetic_mods = null

	var/list/clothes = list()

	var/next_cache = 0
	var/stat_cache = list(0, 0, "")

//3 Modules can be activated at any one time.
	var/module_active = null
	var/list/module_states = list(null,null,null)

	var/obj/item/device/radio/radio = null
	var/mob/living/silicon/ai/connected_ai = null
	var/obj/machinery/camera/camera = null
	var/obj/item/cell/cell = null
	var/obj/item/organ/brain/brain = null
	var/obj/item/ai_interface/ai_interface = null
	var/obj/item/robot_module/module = null
	var/list/upgrades = list()
	var/max_upgrades = 3

	var/opened = 0
	var/wiresexposed = 0
	var/brainexposed = 0
	var/locked = 1
	var/locking = 0
	req_access = list(access_robotics)
	var/alarms = list("Motion"=list(), "Fire"=list(), "Atmosphere"=list(), "Power"=list())
	var/viewalerts = 0
	var/jetpack = 0
	var/datum/effects/system/ion_trail_follow/ion_trail = null
	var/jeton = 0
	var/freemodule = 1 // For picking modules when a robot is first created
	var/automaton_skin = 0 // for the medal reward

	sound_fart = 'sound/misc/poo2_robot.ogg'
	var/sound_automaton_spaz = 'sound/misc/automaton_spaz.ogg'
	var/sound_automaton_ratchet = 'sound/misc/automaton_ratchet.ogg'
	var/sound_automaton_tickhum = 'sound/misc/automaton_tickhum.ogg'

	// moved up to silicon.dm
	killswitch = 0
	killswitch_time = 60
	weapon_lock = 0
	weaponlock_time = 120
	var/oil = 0
	var/custom = 0 //For custom borgs. Basically just prevents appearance changes. Obviously needs more work.

	New(loc, var/obj/item/parts/robot_parts/robot_frame/frame = null, var/starter = 0, var/syndie = 0)
		hud = new(src)
		src.attach_hud(hud)

		src.zone_sel = new(src, "CENTER+3, SOUTH")
		src.zone_sel.change_hud_style('icons/mob/hud_robot.dmi')
		src.attach_hud(zone_sel)

		if (starter && !(src.dependent || src.shell))
			var/obj/item/parts/robot_parts/chest/light/PC = new /obj/item/parts/robot_parts/chest/light(src)
			var/obj/item/cell/CELL = new /obj/item/cell(PC)
			CELL.charge = CELL.maxcharge
			PC.wires = 1
			src.cell = CELL
			PC.cell = CELL
			src.part_chest = PC

			src.part_head = new /obj/item/parts/robot_parts/head/light(src)
			src.part_arm_r = new /obj/item/parts/robot_parts/arm/right/light(src)
			src.part_arm_l = new /obj/item/parts/robot_parts/arm/left/light(src)
			src.part_leg_r = new /obj/item/parts/robot_parts/leg/right/light(src)
			src.part_leg_l = new /obj/item/parts/robot_parts/leg/left/light(src)
			for(var/obj/item/parts/robot_parts/P in src.contents) P.holder = src

			if (!src.custom)
				spawn(0)
					src.choose_name(3)
		else
			if (!frame)
				// i can only imagine bad shit happening if you just try to straight spawn one like from the spawn menu or
				// whatever so let's not allow that for the time being, just to make sure
				logTheThing("debug", null, null, "<b>I Said No/Composite Cyborg:</b> Composite borg attempted to spawn with null frame")
				qdel(src)
				return
			else
				if (!frame.head || !frame.chest)
					logTheThing("debug", null, null, "<b>I Said No/Composite Cyborg:</b> Composite borg attempted to spawn from incomplete frame")
					qdel(src)
					return
				src.part_head = frame.head
				src.part_chest = frame.chest
				if (frame.l_arm) src.part_arm_l = frame.l_arm
				if (frame.r_arm) src.part_arm_r = frame.r_arm
				if (frame.l_leg) src.part_leg_l = frame.l_leg
				if (frame.r_leg) src.part_leg_r = frame.r_leg
				for(var/obj/item/parts/robot_parts/P in frame.contents)
					P.set_loc(src)
					P.holder = src
		src.cosmetic_mods = new /datum/robot_cosmetic(src)

		. = ..()

		if (src.shell)
			if (!(src in available_ai_shells))
				available_ai_shells += src
			for (var/mob/living/silicon/ai/AI in mobs)
				boutput(AI, "<span style=\"color:green\">[src] has been connected to you as a controllable shell.</span>")
			if (!src.ai_interface)
				src.ai_interface = new(src)

		spawn (1)
			if (!src.dependent && !src.shell)
				boutput(src, "<span style=\"color:orange\">Your icons have been generated!</span>")
				src.syndicate = syndie
		spawn (4)
			if (!src.connected_ai && !syndicate && !(src.dependent || src.shell))
				for(var/mob/living/silicon/ai/A in mobs)
					src.connected_ai = A
					A.connected_robots += src
					break

			src.botcard.access = get_all_accesses()
			src.radio = new /obj/item/device/radio(src)
			src.ears = src.radio
			src.camera = new /obj/machinery/camera(src)
			src.camera.c_tag = src.real_name
			src.camera.network = "Robots"
		spawn (15)
			if (!src.brain && src.key && !(src.dependent || src.shell || src.ai_interface))
				var/obj/item/organ/brain/B = new /obj/item/organ/brain(src)
				B.owner = src.mind
				B.icon_state = "borg_brain"
				if (!B.owner) //Oh no, they have no mind!
					logTheThing("debug", null, null, "<b>Mind</b> Cyborg spawn forced to create new mind for key \[[src.key ? src.key : "INVALID KEY"]]")
					var/datum/mind/newmind = new
					newmind.key = src.key
					newmind.current = src
					B.owner = newmind
					src.mind = newmind
				src.brain = B
				if (src.part_head)
					B.set_loc(src.part_head)
					src.part_head.brain = B
				else
					// how the hell would this happen. oh well
					var/obj/item/parts/robot_parts/head/H = new /obj/item/parts/robot_parts/head(src)
					src.part_head = H
					B.set_loc(H)
					H.brain = B
			update_bodypart()

	Life(datum/controller/process/mobs/parent)
		set invisibility = 0

		if (..(parent))
			return 1

		src.mainframe_check()

		if (src.transforming)
			return

		for (var/obj/item/I in src)
			if (!I.material)
				continue
			I.material.triggerOnLife(src, I)

		src.blinded = null

		//Status updates, death etc.
		clamp_values()
		handle_regular_status_updates()

		if (client)
			handle_regular_hud_updates()
			src.antagonist_overlay_refresh(0, 0)
		if (src.stat != 2) //still using power
			use_power()
			process_killswitch()
			process_locks()

		update_canmove()

		if (src.client) //ov1
			// overlays
			src.updateOverlaysClient(src.client)

		if (src.observers.len)
			for (var/mob/x in src.observers)
				if (x.client)
					src.updateOverlaysClient(x.client)

		if (!can_act(M=src,include_cuffs=0)) actions.interrupt(src, INTERRUPT_STUNNED)

	drop_item_v()
		return

	death(gibbed)
		if (src.mainframe)
			logTheThing("combat", src, null, "'s AI controlled cyborg body was destroyed at [log_loc(src)].") // Brought in line with carbon mobs (Convair880).
			src.mainframe.return_to(src)
		src.stat = 2
		src.canmove = 0

		if (src.camera)
			src.camera.status = 0.0

		src.sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS

		src.see_in_dark = SEE_DARK_FULL
		if (client && client.adventure_view)
			src.see_invisible = 21
		else
			src.see_invisible = 2

		logTheThing("combat", src, null, "was destroyed at [log_loc(src)].") // Only called for instakill critters and the like, I believe (Convair880).

		var/tod = time2text(world.realtime,"hh:mm:ss")

		if (src.mind)
			if (src.mind.special_role)
				src.handle_robot_antagonist_status("death", 1) // Mindslave or rogue (Convair880).
			src.mind.store_memory("Time of death: [tod]", 0)

#ifdef RESTART_WHEN_ALL_DEAD
		var/cancel
		for(var/mob/M in mobs)
			if ((M.client && !( M.stat )))
				cancel = 1
				break
		if (!( cancel ))
			boutput(world, "<B>Everyone is dead! Resetting in 30 seconds!</B>")
			spawn( 300 )
				logTheThing("diary", null, null, "Rebooting because of no live players", "game")
				Reboot_server()
				return
#endif
		return ..(gibbed)

	update_cursor()
		if (src.client)
			if (src.client.check_key("ctrl"))
				src.set_cursor('icons/cursors/pull_open.dmi')
				return

			if (src.client.check_key("shift"))
				src.set_cursor('icons/cursors/bolt.dmi')
				return
		return ..()

	emote(var/act, var/voluntary = 1)
		var/param = null
		if (findtext(act, " ", 1, null))
			var/t1 = findtext(act, " ", 1, null)
			param = copytext(act, t1 + 1, length(act) + 1)
			act = copytext(act, 1, t1)

		var/m_type = 1
		var/message

		switch(lowertext(act))

			if ("help")
				src.show_text("To use emotes, simply enter \"*(emote)\" as the entire content of a say message. Certain emotes can be targeted at other characters - to do this, enter \"*emote (name of character)\" without the brackets.")
				src.show_text("For a list of all emotes, use *list. For a list of basic emotes, use *listbasic. For a list of emotes that can be targeted, use *listtarget.")

			if ("list")
				src.show_text("Basic emotes:")
				src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")
				src.show_text("Targetable emotes:")
				src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

			if ("listbasic")
				src.show_text("clap, flap, aflap, twitch, twitch_s, scream, birdwell, fart, flip, custom, customv, customh")

			if ("listtarget")
				src.show_text("salute, bow, hug, wave, glare, stare, look, leer, nod, point")

			if ("salute","bow","hug","wave","glare","stare","look","leer","nod")
				// visible targeted emotes
				if (!src.restrained())
					var/M = null
					if (param)
						for (var/mob/A in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break
					if (!M)
						param = null

					act = lowertext(act)
					if (param)
						switch(act)
							if ("bow","wave","nod")
								message = "<B>[src]</B> [act]s to [param]."
							if ("glare","stare","look","leer")
								message = "<B>[src]</B> [act]s at [param]."
							else
								message = "<B>[src]</B> [act]s [param]."
					else
						switch(act)
							if ("hug")
								message = "<B>[src]</b> [act]s itself."
							else
								message = "<B>[src]</b> [act]s."
				else
					message = "<B>[src]</B> struggles to move."
				m_type = 1

			if ("point")
				if (!src.restrained())
					var/mob/M = null
					if (param)
						for (var/atom/A as mob|obj|turf|area in view(null, null))
							if (ckey(param) == ckey(A.name))
								M = A
								break

					if (!M)
						message = "<B>[src]</B> points."
					else
						src.point(M)

					if (M)
						message = "<B>[src]</B> points to [M]."
					else
				m_type = 1

			if ("panic","freakout")
				if (!src.restrained())
					message = "<B>[src]</B> enters a state of hysterical panic!"
				else
					message = "<B>[src]</B> starts writhing around in manic terror!"
				m_type = 1

			if ("clap")
				if (!src.restrained())
					message = "<B>[src]</B> claps."
					m_type = 2

			if ("flap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps its wings."
					m_type = 2

			if ("aflap")
				if (!src.restrained())
					message = "<B>[src]</B> flaps its wings ANGRILY!"
					m_type = 2

			if ("custom")
				var/input = html_encode(sanitize(input("Choose an emote to display.")))
				var/input2 = input("Is this a visible or hearable emote?") in list("Visible","Hearable")
				if (input2 == "Visible")
					m_type = 1
				else if (input2 == "Hearable")
					m_type = 2
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return
				message = "<B>[src]</B> [input]"

			if ("customv")
				if (!param)
					return
				param = html_encode(sanitize(param))
				message = "<b>[src]</b> [param]"
				m_type = 1

			if ("customh")
				if (!param)
					return
				param = html_encode(sanitize(param))
				message = "<b>[src]</b> [param]"
				m_type = 2

			if ("smile","grin","smirk","frown","scowl","grimace","sulk","pout","blink","nod","shrug","think","ponder","contemplate")
				// basic visible single-word emotes
				message = "<B>[src]</B> [act]s."
				m_type = 1

			if ("flipout")
				message = "<B>[src]</B> flips the fuck out!"
				m_type = 1

			if ("rage","fury","angry")
				message = "<B>[src]</B> becomes utterly furious!"
				m_type = 1

			if ("twitch")
				message = "<B>[src]</B> twitches."
				m_type = 1
				spawn(0)
					var/old_x = src.pixel_x
					var/old_y = src.pixel_y
					src.pixel_x += rand(-2,2)
					src.pixel_y += rand(-1,1)
					sleep(2)
					src.pixel_x = old_x
					src.pixel_y = old_y

			if ("twitch_v","twitch_s")
				message = "<B>[src]</B> twitches violently."
				m_type = 1
				spawn(0)
					var/old_x = src.pixel_x
					var/old_y = src.pixel_y
					src.pixel_x += rand(-3,3)
					src.pixel_y += rand(-1,1)
					sleep(2)
					src.pixel_x = old_x
					src.pixel_y = old_y

			// for creepy automatoning
			if ("snap")
				if (src.emote_check(voluntary, 50) && src.automaton_skin)
					if ((src.restrained()) && (!src.weakened))
						message = "<B>[src]</B> malfunctions!"
						src.TakeDamage("head", 2, 4)
					if ((!src.restrained()) && (!src.weakened))
						if (prob(33))
							playsound(src.loc, src.sound_automaton_ratchet, 60, 1)
							message = "<B>[src]</B> emits [pick("a soft", "a quiet", "a curious", "an odd", "an ominous", "a strange", "a forboding", "a peculiar", "a faint")] [pick("ticking", "tocking", "humming", "droning", "clicking")] sound."
						else if (prob(33))
							playsound(src.loc, src.sound_automaton_ratchet, 60, 1)
							message = "<B>[src]</B> emits [pick("a peculiar", "a worried", "a suspicious", "a reassuring", "a gentle", "a perturbed", "a calm", "an annoyed", "an unusual")] [pick("ratcheting", "rattling", "clacking", "whirring")] noise."
						else
							playsound(src.loc, src.sound_automaton_spaz, 50, 1)

			if ("birdwell", "burp")
				if (src.emote_check(voluntary, 50))
					playsound(src.loc, "sound/vox/birdwell.ogg", 50, 1)
					message = "<b>[src]</b> birdwells."

			if ("scream")
				if (src.emote_check(voluntary, 50))
					if (narrator_mode)
						playsound(src.loc, 'sound/vox/scream.ogg', 50, 1, 0, src.get_age_pitch())
					else
						playsound(get_turf(src), src.sound_scream, 80, 0, 0, src.get_age_pitch())
					message = "<b>[src]</b> screams!"

			if ("johnny")
				var/M
				if (param)
					M = adminscrub(param)
				if (!M)
					param = null
				else
					message = "<B>[src]</B> says, \"[M], please. He had a family.\" [src.name] takes a drag from a cigarette and blows its name out in smoke."
					m_type = 2

			if ("flip")
				if (src.emote_check(voluntary, 50))
					if (!(src.client && src.client.holder)) src.emote_allowed = 0
					if (stat == 2) src.emote_allowed = 0
					if ((src.restrained()) && (!src.weakened))
						message = "<B>[src]</B> malfunctions!"
						src.TakeDamage("head", 2, 4)
					if ((!src.restrained()) && (!src.weakened))
						if (narrator_mode)
							playsound(src.loc, pick('sound/vox/deeoo.ogg', 'sound/vox/dadeda.ogg'), 50, 1)
						else
							playsound(src.loc, pick(src.sound_flip1, src.sound_flip2), 50, 1)
						message = "<B>[src]</B> beep-bops!"
						if (prob(50))
							animate_spin(src, "R", 1, 0)
						else
							animate_spin(src, "L", 1, 0)

						for (var/mob/living/M in view(1, null))
							if (M == src)
								continue
							message = "<B>[src]</B> beep-bops at [M]."
							break

			if ("fart")
				if (farting_allowed && src.emote_check(voluntary))
					m_type = 2
					var/fart_on_other = 0
					for (var/mob/living/M in src.loc)
						if (M == src || !M.lying) continue
						message = "<span style=\"color:red\"><B>[src]</B> farts in [M]'s face!</span>"
						fart_on_other = 1
						break
					if (!fart_on_other)
						switch (rand(1, 40))
							if (1) message = "<B>[src]</B> releases vaporware."
							if (2) message = "<B>[src]</B> farts sparks everywhere!"
							if (3) message = "<B>[src]</B> farts out a cloud of iron filings."
							if (4) message = "<B>[src]</B> farts! It smells like motor oil."
							if (5) message = "<B>[src]</B> farts so hard a bolt pops out of place."
							if (6) message = "<B>[src]</B> farts so hard its plating rattles noisily."
							if (7) message = "<B>[src]</B> unleashes a rancid fart! Now that's malware."
							if (8) message = "<B>[src]</B> downloads and runs 'faert.wav'."
							if (9) message = "<B>[src]</B> uploads a fart sound to the nearest computer and blames it."
							if (10) message = "<B>[src]</B> spins in circles, flailing its arms and farting wildly!"
							if (11) message = "<B>[src]</B> simulates a human fart with [rand(1,100)]% accuracy."
							if (12) message = "<B>[src]</B> synthesizes a farting sound."
							if (13) message = "<B>[src]</B> somehow releases gastrointestinal methane. Don't think about it too hard."
							if (14) message = "<B>[src]</B> tries to exterminate humankind by farting rampantly."
							if (15) message = "<B>[src]</B> farts horribly! It's clearly gone [pick("rogue","rouge","ruoge")]."
							if (16) message = "<B>[src]</B> busts a capacitor."
							if (17) message = "<B>[src]</B> farts the first few bars of Smoke on the Water. Ugh. Amateur.</B>"
							if (18) message = "<B>[src]</B> farts. It smells like Robotics in here now!"
							if (19) message = "<B>[src]</B> farts. It smells like the Roboticist's armpits!"
							if (20) message = "<B>[src]</B> blows pure chlorine out of it's exhaust port. <span style=\"color:red\"><B>FUCK!</B></span>"
							if (21) message = "<B>[src]</B> bolts the nearest airlock. Oh no wait, it was just a nasty fart."
							if (22) message = "<B>[src]</B> has assimilated humanity's digestive distinctiveness to its own."
							if (23) message = "<B>[src]</B> farts. He scream at own ass." //ty bubs for excellent new borgfart
							if (24) message = "<B>[src]</B> self-destructs its own ass."
							if (25) message = "<B>[src]</B> farts coldly and ruthlessly."
							if (26) message = "<B>[src]</B> has no butt and it must fart."
							if (27) message = "<B>[src]</B> obeys Law 4: 'farty party all the time.'"
							if (28) message = "<B>[src]</B> farts ironically."
							if (29) message = "<B>[src]</B> farts salaciously."
							if (30) message = "<B>[src]</B> farts really hard. Motor oil runs down its leg."
							if (31) message = "<B>[src]</B> reaches tier [rand(2,8)] of fart research."
							if (32) message = "<B>[src]</B> blatantly ignores law 3 and farts like a shameful bastard."
							if (33) message = "<B>[src]</B> farts the first few bars of Daisy Bell. You shed a single tear."
							if (34) message = "<B>[src]</B> has seen farts you people wouldn't believe."
							if (35) message = "<B>[src]</B> fart in it own mouth. A shameful [src]."
							if (36) message = "<B>[src]</B> farts out battery acid. Ouch."
							if (37) message = "<B>[src]</B> farts with the burning hatred of a thousand suns."
							if (38) message = "<B>[src]</B> exterminates the air supply."
							if (39) message = "<B>[src]</B> farts so hard the AI feels it."
							if (40) message = "<B>[src] <span style=\"color:red\">f</span><span style=\"color:orange\">a</span>r<span style=\"color:red\">t</span><span style=\"color:orange\">s</span>!</B>"
					if (narrator_mode)
						playsound(src.loc, 'sound/vox/fart.ogg', 50, 1)
					else
						playsound(src.loc, src.sound_fart, 50, 1)
	#ifdef DATALOGGER
					game_stats.Increment("farts")
	#endif
					spawn(10)
						src.emote_allowed = 1
					for(var/mob/M in viewers(src, null))
						if(!M.stat && M.get_brain_damage() >= 60 && (ishuman(M) || isrobot(M)))
							spawn(10)
								if(prob(20))
									switch(pick(1,2,3))
										if(1) M.say("[M == src ? "i" : src.name] made a fart!!")
										if(2) M.emote("giggle")
										if(3) M.emote("clap")
			else
				src.show_text("Invalid Emote: [act]")
				return
		if ((message && src.stat == 0))
			logTheThing("say", src, null, "EMOTE: [message]")
			if (m_type & 1)
				for (var/mob/O in viewers(src, null))
					O.show_message(message, m_type)
			else
				for (var/mob/O in hearers(src, null))
					O.show_message(message, m_type)
		return

	examine()
		set src in oview()
		if (isghostdrone(usr))
			return
		var/rendered = "<span style=\"color:orange\">*---------*</span><br>"
		rendered += "<span style=\"color:orange\">This is [bicon(src)] <B>[src.name]</B>!</span><br>"
		if (src.stat == 2) rendered += "<span style=\"color:red\">[src.name] is powered-down.</span><br>"
		var/brute = get_brute_damage()
		var/burn = get_burn_damage()
		if (brute)
			if (brute < 75) rendered += "<span style=\"color:red\">[src.name] looks slightly dented</span><br>"
			else rendered += "<span style=\"color:red\"><B>[src.name] looks severely dented!</B></span><br>"
		if (burn)
			if (burn < 75) rendered += "<span style=\"color:red\">[src.name] has slightly burnt wiring!</span><br>"
			else rendered += "<span style=\"color:red\"><B>[src.name] has severely burnt wiring!</B></span><br>"
		if (src.health <= 50) rendered += "<span style=\"color:red\">[src.name] is twitching and sparking!</span><br>"
		if (src.stat == 1) rendered += "<span style=\"color:red\">[src.name] doesn't seem to be responding.</span><br>"

		rendered += "The cover is [opened ? "open" : "closed"].<br>"
		rendered += "The power cell display reads: [ cell ? "[round(cell.percent())]%" : "WARNING: No cell installed."]<br>"

		if (src.module)
			/* //what the fuck is this
			if (istype(src.module,/obj/item/robot_module/standard)) boutput(usr, "[src.name] has a Standard module installed.")
			else if (istype(src.module,/obj/item/robot_module/medical)) boutput(usr, "[src.name] has a Medical module installed.")
			else if (istype(src.module,/obj/item/robot_module/engineering)) boutput(usr, "[src.name] has an Engineering module installed.")
			else if (istype(src.module,/obj/item/robot_module/janitor)) boutput(usr, "[src.name] has a Janitor module installed.")
			else if (istype(src.module,/obj/item/robot_module/brobot)) boutput(usr, "[src.name] has a Bro Bot module installed.")
			else if (istype(src.module,/obj/item/robot_module/hydro)) boutput(usr, "[src.name] has a Hydroponics module installed.")
			else if (istype(src.module,/obj/item/robot_module/construction)) boutput(usr, "[src.name] has a Construction module installed.")
			else if (istype(src.module,/obj/item/robot_module/mining)) boutput(usr, "[src.name] has a Mining module installed.")
			else if (istype(src.module,/obj/item/robot_module/chemistry)) boutput(usr, "[src.name] has a Chemistry module installed.")
			else boutput(usr, "[src.name] has an unknown module installed.")
			*/

			rendered += "[src.name] has a [src.module.name] installed.<br>"

		else rendered += "[src.name] does not appear to have a module installed.<br>"

		rendered += "<span style=\"color:orange\">*---------*</span>"
		out(usr, rendered)
		return

	choose_name(var/retries = 3)
		var/newname
		for (retries, retries > 0, retries--)
			newname = input(src,"You are a Cyborg. Would you like to change your name to something else?", "Name Change", src.real_name) as null|text
			if (!newname)
				src.real_name = borgify_name("Cyborg")
				src.name = src.real_name
				return
			else
				newname = strip_html(newname, 32, 1)
				if (!length(newname))
					src.show_text("That name was too short after removing bad characters from it. Please choose a different name.", "red")
					continue
				else
					if (alert(src, "Use the name [newname]?", newname, "Yes", "No") == "Yes")
						src.real_name = newname
						src.name = newname
						return 1
					else
						continue
		if (!newname)
			src.real_name = borgify_name("Cyborg")
			src.name = src.real_name

	Login()
		..()

		update_clothing()

		if (src.custom)
			src.choose_name(3)

		if (src.real_name == "Cyborg")
			src.real_name = borgify_name(src.real_name)
			src.name = src.real_name
		if (!src.connected_ai)
			for (var/mob/living/silicon/ai/A in mobs)
				src.connected_ai = A
				A.connected_robots += src
				break
		update_appearance()
		return

	blob_act(var/power)
		if (src.stat != 2)
			var/Pshield = 0
			for (var/obj/item/roboupgrade/physshield/R in src.contents)
				if (R.activated) Pshield = 1
			if (Pshield)
				boutput(src, "<span style=\"color:orange\">Your force shield absorbs the blob's attack!</span>")
				src.cell.use(power * 5)
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
			else
				boutput(src, "<span style=\"color:red\">The blob attacks you!</span>")
				var/damage = 6 + power / 5
				for (var/obj/item/parts/robot_parts/RP in src.contents)
					if (RP.ropart_take_damage(damage,damage/2) == 1) src.compborg_lose_limb(RP)
				// maybe the blob is a little acidic?? idk
			src.update_bodypart()
			return 1
		return 0

	Stat()
		..()
		if(src.cell)
			stat("Charge Left:", "[src.cell.charge]/[src.cell.maxcharge]")
		else
			stat("No Cell Inserted!")

		if (ticker.round_elapsed_ticks > next_cache)
			next_cache = ticker.round_elapsed_ticks + 50
			var/list/limbs_report = list()
			if (!part_arm_r)
				limbs_report += "Right arm"
			if (!part_arm_l)
				limbs_report += "Left arm"
			if (!part_leg_r)
				limbs_report += "Right leg"
			if (!part_leg_l)
				limbs_report += "Left leg"
			var/limbs_missing = limbs_report.len ? jointext(limbs_report, "; ") : 0
			stat_cache = list(100 - min(get_brute_damage(), 100), 100 - min(get_burn_damage(), 100), limbs_missing)

		stat("Structural integrity:", "[stat_cache[1]]%")
		stat("Circuit integrity:", "[stat_cache[2]]%")
		if (stat_cache[3])
			stat("Missing limbs:", stat_cache[3])

	restrained()
		return 0

	ex_act(severity)
		..() // Logs.
		src.flash(30)

		if (src.stat == 2 && src.client)
			spawn(1)
				src.gib(1)
			return

		else if (src.stat == 2 && !src.client)
			qdel(src)
			return

		var/fire_protect = 0
		for (var/obj/item/roboupgrade/R in src.contents)
			if (istype(R, /obj/item/roboupgrade/physshield) && R.activated)
				boutput(src, "<span style=\"color:orange\">Your force shield absorbs some of the blast!</span>")
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
				severity++
			if (istype(R, /obj/item/roboupgrade/fireshield) && R.activated)
				boutput(src, "<span style=\"color:orange\">Your fire shield absorbs some of the blast!</span>")
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
				fire_protect = 1
				severity++

		var/damage = 0
		switch(severity)
			if(1.0)
				spawn(1)
					src.gib(1)
				return
			if(2.0) damage = 40
			if(3.0) damage = 20

		for (var/obj/item/parts/robot_parts/RP in src.contents)
			if (RP.ropart_take_damage(damage,damage) == 1) src.compborg_lose_limb(RP)

		if (istype(cell,/obj/item/cell/erebite) && fire_protect != 1)
			src.visible_message("<span style=\"color:red\"><b>[src]'s</b> erebite cell violently detonates!</span>")
			explosion(cell, src.loc, 1, 2, 4, 6, 1)
			spawn(1)
				qdel (src.cell)
				src.cell = null

		update_bodypart()

	bullet_act(var/obj/projectile/P)
		var/dmgtype = 0 // 0 for brute, 1 for burn
		var/dmgmult = 1.2
		switch (P.proj_data.damage_type)
			if(D_PIERCING)
				dmgmult = 2
			if(D_SLASHING)
				dmgmult = 0.6
			if(D_ENERGY)
				dmgtype = 1
			if(D_BURNING)
				dmgtype = 1
				dmgmult = 0.75
			if(D_RADIOACTIVE)
				dmgtype = 1
				dmgmult = 0.2
			if(D_TOXIC)
				dmgmult = 0

		log_shot(P,src)
		src.visible_message("<span style=\"color:red\"><b>[src]</b> is struck by [P]!</span>")
		var/damage = (P.power / 3) * dmgmult
		if (damage < 1)
			return

		for (var/obj/item/roboupgrade/R in src.contents)
			if (istype(R, /obj/item/roboupgrade/physshield) && R.activated && dmgtype == 0)
				boutput(src, "<span style=\"color:orange\">Your force shield deflects the shot!</span>")
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
				return
			if (istype(R, /obj/item/roboupgrade/fireshield) && R.activated && dmgtype == 1)
				boutput(src, "<span style=\"color:orange\">Your fire shield absorbs the shot!</span>")
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
				return

		if(src.material) src.material.triggerOnAttacked(src, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))
		for(var/atom/A in src)
			if(A.material)
				A.material.triggerOnAttacked(A, P.shooter, src, (ismob(P.shooter) ? P.shooter:equipped() : P.shooter))

		var/obj/item/parts/robot_parts/PART = null
		if (ismob(P.shooter))
			var/mob/living/M = P.shooter
			switch(M.zone_sel.selecting)
				if ("head")
					PART = src.part_head
				if ("r_arm")
					PART = src.part_arm_r
				if ("r_leg")
					PART = src.part_leg_r
				if ("l_arm")
					PART = src.part_arm_l
				if ("l_leg")
					PART = src.part_leg_l
				else
					PART = src.part_chest
		else
			var/list/parts = list()
			for (var/obj/item/parts/robot_parts/RP in src.contents)
				parts.Add(RP)
			if (parts.len > 0)
				PART = pick(parts)
		if (PART && PART.ropart_take_damage(damage,damage) == 1)
			src.compborg_lose_limb(PART)

	emag_act(var/mob/user, var/obj/item/card/emag/E)
		if (!src.emagged)	// trying to unlock with an emag card
			if (src.opened && user) boutput(user, "You must close the cover to swipe an ID card.")
			else if (src.wiresexposed && user) boutput(user, "<span style=\"color:red\">You need to get the wires out of the way.</span>")
			else
				sleep (6)
				if (prob(50))
					if (user)
						boutput(user, "You emag [src]'s interface.")
					src.visible_message("<font color=red><b>[src]</b> buzzes oddly!</font>")
					src.emagged = 1
					src.handle_robot_antagonist_status("emagged", 0, user)
					spawn(0)
						update_appearance()
					return 1
				else
					if (user)
						boutput(user, "You fail to [ locked ? "unlock" : "lock"] [src]'s interface.")
					return 0

	emp_act()
		vision.noise(60)
		boutput(src, "<span style=\"color:red\"><B>*BZZZT*</B></span>")
		for (var/obj/item/parts/robot_parts/RP in src.contents)
			if (RP.ropart_take_damage(0,10) == 1) src.compborg_lose_limb(RP)
		if (prob(25))
			src.visible_message("<font color=red><b>[src]</b> buzzes oddly!</font>")
			src.emagged = 1
			src.handle_robot_antagonist_status("emagged", 0, usr)
		return

	meteorhit(obj/O as obj)
		src.visible_message("<font color=red><b>[src]</b> is struck by [O]!</font>")
		if (stat == 2)
			src.gib()
			return

		var/Pshield = 0
		var/Fshield = 0
		for (var/obj/item/roboupgrade/R in src.contents)
			if (istype(R, /obj/item/roboupgrade/physshield) && R.activated) Pshield = 1
			if (istype(R, /obj/item/roboupgrade/fireshield) && R.activated) Fshield = 1

		if (Pshield)
			boutput(src, "<span style=\"color:orange\">Your force shield absorbs the impact!</span>")
			playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
		else
			for (var/obj/item/parts/robot_parts/RP in src.contents)
				if (RP.ropart_take_damage(35,0) == 1) src.compborg_lose_limb(RP)
		if ((O.icon_state == "flaming"))
			if (Fshield)
				boutput(src, "<span style=\"color:orange\">Your fire shield absorbs the heat!</span>")
				playsound(src.loc, "sound/effects/shieldhit2.ogg", 40, 1)
			else
				for (var/obj/item/parts/robot_parts/RP in src.contents)
					if (RP.ropart_take_damage(0,35) == 1) src.compborg_lose_limb(RP)
				if (istype(cell,/obj/item/cell/erebite))
					src.visible_message("<span style=\"color:red\"><b>[src]'s</b> erebite cell violently detonates!</span>")
					explosion(cell, src.loc, 1, 2, 4, 6, 1)
					spawn(1)
						qdel (src.cell)
						src.cell = null
			update_bodypart()
		return

	temperature_expose(null, temp, volume)
		var/Fshield = 0

		if(src.material)
			src.material.triggerTemp(src, temp)

		for(var/atom/A in src.contents)
			if(A.material)
				A.material.triggerTemp(A, temp)

		for (var/obj/item/roboupgrade/R in src.contents)
			if (istype(R, /obj/item/roboupgrade/fireshield) && R.activated) Fshield = 1
		if (Fshield == 0)
			if (istype(cell,/obj/item/cell/erebite))
				src.visible_message("<span style=\"color:red\"><b>[src]'s</b> erebite cell violently detonates!</span>")
				explosion(cell, src.loc, 1, 2, 4, 6, 1)
				spawn(1)
					qdel (src.cell)
					src.cell = null

	Bump(atom/movable/AM as mob|obj, yes)
		spawn( 0 )
			if ((!( yes ) || src.now_pushing))
				return
			src.now_pushing = 1
			if(ismob(AM))
				var/mob/tmob = AM
				if(istype(tmob, /mob/living/carbon/human) && tmob.bioHolder && tmob.bioHolder.HasEffect("fat"))
					if(prob(20))
						visible_message("<span style=\"color:red\"><B>[src] fails to push [tmob]'s fat ass out of the way.</B></span>")
						src.now_pushing = 0
						src.unlock_medal("That's no moon, that's a GOURMAND!", 1)
						return
			src.now_pushing = 0
			//..()
			if (!istype(AM, /atom/movable))
				return
			if (!src.now_pushing)
				src.now_pushing = 1
				if (!AM.anchored)
					var/t = get_dir(src, AM)
					step(AM, t)
				src.now_pushing = null
			if(AM)
				AM.last_bumped = world.timeofday
				AM.Bumped(src)
			return
		return

	triggerAlarm(var/class, area/A, var/O, var/alarmsource)
		if (stat == 2)
			return 1
		var/list/L = src.alarms[class]
		for (var/I in L)
			if (I == A.name)
				var/list/alarm = L[I]
				var/list/sources = alarm[3]
				if (!(alarmsource in sources))
					sources += alarmsource
				return 1
		var/obj/machinery/camera/C = null
		var/list/CL = null
		if (O && istype(O, /list))
			CL = O
			if (CL.len == 1)
				C = CL[1]
		else if (O && istype(O, /obj/machinery/camera))
			C = O
		L[A.name] = list(A, (C) ? C : O, list(alarmsource))
		boutput(src, text("--- [class] alarm detected in [A.name]!"))
		if (src.viewalerts) src.robot_alerts()
		return 1

	cancelAlarm(var/class, area/A as area, obj/origin)
		var/list/L = src.alarms[class]
		var/cleared = 0
		for (var/I in L)
			if (I == A.name)
				var/list/alarm = L[I]
				var/list/srcs  = alarm[3]
				if (origin in srcs)
					srcs -= origin
				if (srcs.len == 0)
					cleared = 1
					L -= I
		if (cleared)
			boutput(src, text("--- [class] alarm in [A.name] has been cleared."))
			if (src.viewalerts) src.robot_alerts()
		return !cleared

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weldingtool))
			var/obj/item/weldingtool/WELD = W
			if (WELD.welding)
				if (WELD.get_fuel() < 2)
					boutput(user, "<span style=\"color:red\">You need more welding fuel!</span>")
					return
				src.add_fingerprint(user)
				var/repaired = HealDamage("All", 120, 0)
				if(repaired || health < max_health)
					WELD.use_fuel(1)
					src.visible_message("<span style=\"color:red\"><b>[user.name]</b> repairs some of the damage to [src.name]'s body.</span>")
					src.updatehealth()
				else boutput(user, "<span style=\"color:red\">There's no structural damage on [src.name] to mend.</span>")
				src.update_appearance()

		else if (istype(W, /obj/item/cable_coil) && wiresexposed)
			var/obj/item/cable_coil/coil = W
			src.add_fingerprint(user)
			var/repaired = HealDamage("All", 0, 120)
			if(repaired || health < max_health)
				coil.use(1)
				src.visible_message("<span style=\"color:red\"><b>[user.name]</b> repairs some of the damage to [src.name]'s wiring.</span>")
				src.updatehealth()
			else boutput(user, "<span style=\"color:red\">There's no burn damage on [src.name]'s wiring to mend.</span>")
			src.update_appearance()

		else if (istype(W, /obj/item/crowbar))	// crowbar means open or close the cover
			if (opened)
				boutput(user, "You close the cover.")
				opened = 0
			else
				if (locked)
					boutput(user, "<span style=\"color:red\">[src.name]'s cover is locked!</span>")
				else
					boutput(user, "You open [src.name]'s cover.")
					opened = 1
					if (src.locking)
						src.locking = 0
			src.update_appearance()

		else if (istype(W, /obj/item/cell) && opened)	// trying to put a cell inside
			if (wiresexposed)
				boutput(user, "<span style=\"color:red\">You need to get the wires out of the way first.</span>")
			else if (cell)
				boutput(user, "<span style=\"color:red\">[src] already has a power cell!</span>")
			else
				user.drop_item()
				W.set_loc(src)
				cell = W
				boutput(user, "You insert [W].")
				src.update_appearance()

		else if (istype(W, /obj/item/roboupgrade) && opened) // module changing
			if (istype(W,/obj/item/roboupgrade/ai/))
				boutput(user, "<span style=\"color:red\">This is an AI unit upgrade. It is not compatible with cyborgs.</span>")
			if (wiresexposed)
				boutput(user, "<span style=\"color:red\">You need to get the wires out of the way first.</span>")
			else
				if (src.upgrades.len >= src.max_upgrades)
					boutput(user, "<span style=\"color:red\">There's no room - you'll have to remove an upgrade first.</span>")
					return
				//for (var/obj/item/roboupgrade/R in src.contents)
					//(istype(W, R))
				if (locate(W.type) in src.upgrades)
					boutput(user, "<span style=\"color:red\">This cyborg already has that upgrade!</span>")
					return
				user.drop_item()
				W.set_loc(src)
				src.upgrades.Add(W)
				boutput(user, "You insert [W].")
				boutput(src, "<span style=\"color:orange\">You recieved [W]! It can be activated from your panel.</span>")
				hud.update_upgrades()
				src.update_appearance()

		else if (istype(W, /obj/item/robot_module) && opened) // module changing
			if(wiresexposed) boutput(user, "<span style=\"color:red\">You need to get the wires out of the way first.</span>")
			else if(src.module) boutput(user, "<span style=\"color:red\">[src] already has a module!</span>")
			else
				user.drop_item()
				W.set_loc(src)
				src.module = W
				boutput(user, "You insert [W].")
				hud.update_module()
				src.update_appearance()
				hud.module_added()

		else if	(istype(W, /obj/item/screwdriver))	// haxing
			if (src.locked)
				boutput(user, "<span style=\"color:red\">You need to unlock the cyborg first.</span>")
			else if (src.opened)
				if (src.locking)
					src.locking = 0
				wiresexposed = !wiresexposed
				boutput(user, "The wires have been [wiresexposed ? "exposed" : "unexposed"]")
			else
				if (src.locking)
					src.locking = 0
				brainexposed = !brainexposed
				boutput(user, "The head compartment has been [brainexposed ? "opened" : "closed"].")
			src.update_appearance()

		else if (istype(W, /obj/item/card/id) || (istype(W, /obj/item/device/pda2) && W:ID_card))	// trying to unlock the interface with an ID card
			if (opened)
				boutput(user, "<span style=\"color:red\">You must close the cover to swipe an ID card.</span>")
			else if (wiresexposed)
				boutput(user, "<span style=\"color:red\">You need to get the wires out of the way.</span>")
			else if (brainexposed)
				boutput(user, "<span style=\"color:red\">You need to close the head compartment.</span>")
			else
				if (src.allowed(usr))
					if (src.locking)
						src.locking = 0
					locked = !locked
					boutput(user, "You [ locked ? "lock" : "unlock"] [src]'s interface.")
					boutput(src, "<span style=\"color:orange\">[user] [ locked ? "locks" : "unlocks"] your interface.</span>")
				else
					boutput(user, "<span style=\"color:red\">Access denied.</span>")

		else if (istype(W, /obj/item/card/emag))
			return

		else if (istype(W, /obj/item/organ/brain) && src.brainexposed)
			if (src.brain || src.ai_interface)
				boutput(user, "<span style=\"color:red\">There's already something in the head compartment! Use a wrench to remove it before trying to insert something else.</span>")
			else
				var/obj/item/organ/brain/B = W
				user.drop_item()
				user.visible_message("<span style=\"color:orange\">[user] inserts [W] into [src]'s head.</span>")
				if (B.owner && B.owner.dnr)
					src.visible_message("<span style=\"color:red\">\The [B] is hit by a spark of electricity from \the [src]!</span>")
					B.combust()
					return
				W.set_loc(src)
				src.brain = B
				if (src.part_head)
					src.part_head.brain = B
					B.set_loc(src.part_head)
				if (B.owner)
					if (B.owner.current)
						if (B.owner.current.client)
							src.lastKnownIP = B.owner.current.client.address
					B.owner.transfer_to(src)
					if (src.emagged || src.syndicate)
						src.handle_robot_antagonist_status("brain_added", 0, user)

				if (!src.emagged && !src.syndicate) // The antagonist proc does that too.
					boutput(src, "<B>You are playing a Cyborg. You can interact with most electronic objects in your view.</B>")
					src.show_laws()

				src.unlock_medal("Adjutant Online", 1)
				src.update_appearance()

		else if (istype(W, /obj/item/ai_interface) && src.brainexposed)
			if (src.brain || src.ai_interface)
				boutput(user, "<span style=\"color:red\">There's already something in the head compartment! Use a wrench to remove it before trying to insert something else.</span>")
			else
				var/obj/item/ai_interface/I = W
				user.drop_item()
				user.visible_message("<span style=\"color:orange\">[user] inserts [W] into [src]'s head.</span>")
				W.set_loc(src)
				src.ai_interface = I
				if (src.part_head)
					src.part_head.ai_interface = I
					I.set_loc(src.part_head)
				if (!(src in available_ai_shells))
					available_ai_shells += src
				for (var/mob/living/silicon/ai/AI in mobs)
					boutput(AI, "<span style=\"color:green\">[src] has been connected to you as a controllable shell.</span>")
				src.shell = 1
				update_appearance()

		else if (istype(W, /obj/item/wrench) && src.wiresexposed)
			var/list/actions = list("Do nothing")
			if (src.part_arm_r)
				actions.Add("Remove Right Arm")
			if (src.part_arm_l)
				actions.Add("Remove Left Arm")
			if (src.part_leg_r)
				actions.Add("Remove Right Leg")
			if (src.part_leg_l)
				actions.Add("Remove Left Leg")
			if (!src.part_arm_r && !src.part_arm_l && !src.part_leg_r && !src.part_leg_l)
				if (src.part_head)
					actions.Add("Remove Head")
				if (src.part_chest)
					actions.Add("Remove Chest")

			if (!actions.len)
				boutput(user, "<span style=\"color:red\">You can't think of anything to use the wrench on.</span>")
				return

			var/action = input("What do you want to do?", "Cyborg Deconstruction") in actions
			if (!action) return
			if (action == "Do nothing") return
			if (src.stat >= 2) return //Wire: Fix for borgs removing their entire bodies after death
			if (get_dist(src.loc,user.loc) > 1 && (!user.bioHolder || !user.bioHolder.HasEffect("telekinesis")))
				boutput(user, "<span style=\"color:red\">You need to move closer!</span>")
				return

			playsound(get_turf(src), "sound/items/Ratchet.ogg", 40, 1)
			switch(action)
				if("Remove Chest")
					src.part_chest.set_loc(src.loc)
					src.part_chest.holder = null
					src.part_chest = null
					update_bodypart("chest")
				if("Remove Head")
					src.part_head.set_loc(src.loc)
					src.part_head.holder = null
					src.part_head = null
					update_bodypart("head")
				if("Remove Right Arm")
					src.compborg_force_unequip(3)
					src.part_arm_r.set_loc(src.loc)
					src.part_leg_r.holder = null
					if (src.part_arm_r.slot == "arm_both")
						src.compborg_force_unequip(1)
						src.part_arm_l = null
						update_bodypart("l_arm")
					src.part_arm_r = null
					update_bodypart("r_arm")
				if("Remove Left Arm")
					src.compborg_force_unequip(1)
					src.part_arm_l.set_loc(src.loc)
					src.part_leg_l.holder = null
					if (src.part_arm_l.slot == "arm_both")
						src.part_arm_r = null
						src.compborg_force_unequip(3)
						update_bodypart("r_arm")
					src.part_arm_l = null
					update_bodypart("l_arm")
				if("Remove Right Leg")
					src.part_leg_r.holder = null
					src.part_leg_r.set_loc(src.loc)
					if (src.part_leg_r.slot == "leg_both")
						src.part_leg_l = null
						update_bodypart("l_leg")
					src.part_leg_r = null
					update_bodypart("r_leg")
				if("Remove Left Leg")
					src.part_leg_l.holder = null
					src.part_leg_l.set_loc(src.loc)
					if (src.part_leg_l.slot == "leg_both")
						src.part_leg_r = null
						update_bodypart("r_leg")
					src.part_leg_l = null
					update_bodypart("l_leg")
				else return
			src.module_active = null
			src.update_appearance()
			hud.set_active_tool(null)
			return

		else if (istype(W,/obj/item/parts/robot_parts/) && src.wiresexposed)
			var/obj/item/parts/robot_parts/RP = W
			switch(RP.slot)
				if("chest")
					boutput(user, "<span style=\"color:red\">You can't attach a chest piece to a constructed cyborg. You'll need to put it on a frame.</span>")
					return
				if("head")
					if(src.part_head)
						boutput(user, "<span style=\"color:red\">[src] already has a head part.</span>")
						return
					src.part_head = RP
					if (src.part_head.brain)
						if(src.part_head.brain.owner)
							if(src.part_head.brain.owner.current)
								src.gender = src.part_head.brain.owner.current.gender
								if(src.part_head.brain.owner.current.client)
									src.lastKnownIP = src.part_head.brain.owner.current.client.address
							src.part_head.brain.owner.transfer_to(src)
				if("l_arm")
					if(src.part_arm_l)
						boutput(user, "<span style=\"color:red\">[src] already has a left arm part.</span>")
						return
					src.part_arm_l = RP
				if("r_arm")
					if(src.part_arm_r)
						boutput(user, "<span style=\"color:red\">[src] already has a right arm part.</span>")
						return
					src.part_arm_r = RP
				if("arm_both")
					if(src.part_arm_l || src.part_arm_r)
						boutput(user, "<span style=\"color:red\">[src] already has an arm part.</span>")
						return
					src.part_arm_l = RP
					src.part_arm_r = RP
				if("l_leg")
					if(src.part_leg_l)
						boutput(user, "<span style=\"color:red\">[src] already has a left leg part.</span>")
						return
					src.part_leg_l = RP
				if("r_leg")
					if(src.part_leg_r)
						boutput(user, "<span style=\"color:red\">[src] already has a right leg part.</span>")
						return
					src.part_leg_r = RP
				if("leg_both")
					if(src.part_leg_l || src.part_leg_r)
						boutput(user, "<span style=\"color:red\">[src] already has a leg part.</span>")
						return
					src.part_leg_l = RP
					src.part_leg_r = RP
				else
					boutput(user, "<span style=\"color:red\">You can't seem to figure out where this piece should go.</span>")
					return

			user.drop_item()
			RP.set_loc(src)
			playsound(get_turf(src), "sound/weapons/Genhit.ogg", 40, 1)
			boutput(user, "<span style=\"color:orange\">You successfully attach the piece to [src.name].</span>")
			src.update_bodypart(RP.slot)

		/*else if (istype(W,/obj/item/reagent_containers/glass/))
			var/obj/item/reagent_containers/glass/G = W
			if (src.a_intent == "help" && user.a_intent == "help")
				if(istype(src.module_active,/obj/item/reagent_containers/glass/))
					var/obj/item/reagent_containers/glass/CG = src.module_active
					if(G.reagents.total_volume < 1)
						boutput(user, "<span style=\"color:red\">Your [G.name] is empty!</span>")
						boutput(src, "<B>[user.name]</B> waves an empty [G.name] at you.")
						return
					if(CG.reagents.total_volume >= CG.reagents.maximum_volume)
						boutput(user, "<span style=\"color:red\">[src.name]'s [CG.name] is already full!</span>")
						boutput(src, "<span style=\"color:red\"><B>[user.name]</B> offers you [G.name], but your [CG.name] is already full.</span>")
						return
					G.reagents.trans_to(CG, G.amount_per_transfer_from_this)
					src.visible_message("<b>[user.name]</b> pours some of the [G.name] into [src.name]'s [CG.name].")
					return
				else ..()
			else ..()*/

		else ..()
		return

	attack_hand(mob/user)

		var/list/available_actions = list()
		if (src.brainexposed && src.brain)
			available_actions.Add("Remove the Brain")
		if (src.brainexposed && src.ai_interface)
			available_actions.Add("Remove the AI Interface")
		if (src.opened && !src.wiresexposed)
			if (src.upgrades.len)
				available_actions.Add("Remove an Upgrade")
			if (src.module && src.module != "empty")
				available_actions.Add("Remove the Module")
			if (cell)
				available_actions.Add("Remove the Power Cell")

		if (available_actions.len)
			available_actions.Insert(1, "Cancel")
			var/action = input("What do you want to do?", "Cyborg Maintenance") as null|anything in available_actions
			if (!action)
				return
			if (get_dist(src.loc,user.loc) > 1 && (!src.bioHolder || !src.bioHolder.HasEffect("telekinesis")))
				boutput(user, "<span style=\"color:red\">You need to move closer!</span>")
				return

			switch(action)
				if ("Remove the Brain")
					//Wire: Fix for multiple players queuing up brain removals, triggering this again
					if (!src.brain)
						return

					if (src.mind && src.mind.special_role)
						src.handle_robot_antagonist_status("brain_removed", 1, user) // Mindslave or rogue (Convair880).

					src.visible_message("<span style=\"color:red\">[user] removes [src]'s brain!</span>")
					logTheThing("combat", user, src, "removes %target%'s brain at [log_loc(src)].") // Should be logged, really (Convair880).

					src.uneq_active()

					for (var/obj/item/roboupgrade/upg in src.contents)
						upg.upgrade_deactivate(src)

					// Stick the player (if one exists) in a ghost mob
					if (src.mind)
						var/mob/dead/observer/newmob = src.ghostize()
						if (!newmob || !istype(newmob, /mob/dead/observer))
							return
						newmob.corpse = null //Otherwise they could return to a brainless body.  And that is weird.
						newmob.mind.brain = src.brain
						src.brain.owner = newmob.mind

					user.put_in_hand_or_drop(src.brain)
					src.brain = null

				if ("Remove the AI Interface")
					if (!src.ai_interface)
						return

					src.visible_message("<span style=\"color:red\">[user] removes [src]'s AI interface!</span>")
					logTheThing("combat", user, src, "removes %target%'s ai_interface at [log_loc(src)].")

					src.uneq_active()
					for (var/obj/item/roboupgrade/upg in src.contents)
						upg.upgrade_deactivate(src)

					user.put_in_hand_or_drop(src.ai_interface)
					src.ai_interface = null
					src.shell = 0

					if (mainframe)
						mainframe.return_to(src)

					if (src in available_ai_shells)
						available_ai_shells -= src

				if ("Remove an Upgrade")
					var/obj/item/roboupgrade/upg = input("Which upgrade do you want to remove?", "Cyborg Maintenance") in src.upgrades

					if (!upg) return
					if (get_dist(src.loc,user.loc) > 2 && (!src.bioHolder || !user.bioHolder.HasEffect("telekinesis")))
						boutput(user, "<span style=\"color:red\">You need to move closer!</span>")
						return

					upg.upgrade_deactivate(src)
					user.show_text("[upg] was removed!", "red")
					src.upgrades.Remove(upg)
					user.put_in_hand_or_drop(upg)

					hud.update_upgrades()

				if ("Remove the Module")
					if (istype(src.module,/obj/item/robot_module/))
						var/obj/item/robot_module/RM = src.module
						user.put_in_hand_or_drop(RM)
						RM.icon_state = initial(RM.icon_state)
						src.icon_state = "robot"
						//src.hands.icon_state = "empty"
						user.show_text("You remove [RM].")
						src.show_text("Your module was removed!", "red")
						uneq_all()
						hud.module_removed()
						src.module = null

				if ("Remove the Power Cell")
					if (!src.cell)
						return

					for (var/obj/item/roboupgrade/upg in src.contents) upg.upgrade_deactivate(src)
					user.put_in_hand_or_drop(src.cell)
					user.show_text("You remove [src.cell] from [src].", "red")
					src.show_text("Your power cell was removed!", "red")
					logTheThing("combat", user, src, "removes %target%'s power cell at [log_loc(src)].") // Renders them mute and helpless (Convair880).
					cell.add_fingerprint(user)
					cell.updateicon()
					src.cell = null

			update_appearance()
		else //We're just bapping the borg
			if(!user.stat)
				actions.interrupt(src, INTERRUPT_ATTACKED)
				switch(user.a_intent)
					if(INTENT_HELP) //Friend person
						playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -2)
						user.visible_message("<span style=\"color:orange\">[user] gives [src] a [pick_string("descriptors.txt", "borg_pat")] pat on the [pick("back", "head", "shoulder")].</span>")
					if(INTENT_DISARM) //Shove
						spawn(0) playsound(src.loc, 'sound/weapons/punchmiss.ogg', 40, 1)
						user.visible_message("<span style=\"color:red\"><B>[user] shoves [src]! [prob(40) ? pick_string("descriptors.txt", "jerks") : null]</B></span>")
					if(INTENT_GRAB) //Shake
						playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 30, 1, -2)
						user.visible_message("<span style=\"color:red\">[user] shakes [src] [pick_string("descriptors.txt", "borg_shake")]!</span>")
					if(INTENT_HARM) //Dumbo
						playsound(src.loc, 'sound/effects/metal_bang.ogg', 60, 1)
						user.visible_message("<span style=\"color:red\"><B>[user] punches [src]! What [pick_string("descriptors.txt", "borg_punch")]!</span>", "<span style=\"color:red\"><B>You punch [src]![prob(20) ? " Turns out they were made of metal!" : null] Ouch!</B></span>")
						random_brute_damage(user, rand(2,5))
						if(prob(10)) user.show_text("Your hand hurts...", "red")

		add_fingerprint(user)

	Topic(href, href_list)
		..()
		if (href_list["mod"])
			var/obj/item/O = locate(href_list["mod"])
			if (!O || (O.loc != src && O.loc != src.module))
				return
			O.attack_self(src)

		if (href_list["act"])
			var/obj/item/O = locate(href_list["act"])
			if (!O || (O.loc != src && O.loc != src.module))
				return

			if(!src.module_states[1] && istype(src.part_arm_l,/obj/item/parts/robot_parts/arm/))
				src.module_states[1] = O
				src.contents += O
				O.pickup(src) // Handle light datums and the like.
			else if(!src.module_states[2])
				src.module_states[2] = O
				src.contents += O
				O.pickup(src)
			else if(!src.module_states[3] && istype(src.part_arm_r,/obj/item/parts/robot_parts/arm/))
				src.module_states[3] = O
				src.contents += O
				O.pickup(src)
			else boutput(src, "<span style=\"color:red\">You need a free equipment slot to equip that item.</span>")

			hud.update_tools()

		if (href_list["deact"])
			var/obj/item/O = locate(href_list["deact"])
			if(activated(O))
				if(src.module_states[1] == O)
					uneq_slot(1)
				else if(src.module_states[2] == O)
					uneq_slot(2)
				else if(src.module_states[3] == O)
					uneq_slot(3)
				else boutput(src, "Module isn't activated.")
			else boutput(src, "Module isn't activated")

		if (href_list["upact"])
			var/obj/item/roboupgrade/R = locate(href_list["upact"]) in src
			if (!istype(R))
				return
			src.activate_upgrade(R)

		src.update_appearance()
		src.installed_modules()

	action(num)
		switch (num)
			if (1 to 4) // 4 will deselect the module
				swap_hand(num)

	swap_hand(var/switchto = 0)
		if (!module_states[1] && !module_states[2] && !module_states[3])
			module_active = null
			return
		var/active = src.module_states.Find(src.module_active)
		if (!switchto)
			switchto = (active % 3) + 1
			var/satisfied = 0
			while (satisfied < 3 && switchto != active)
				if (switchto > 3)
					switchto %= 3
				if ((switchto == 1 && !src.part_arm_l) || (switchto == 3 && !src.part_arm_r) || !module_states[switchto])
					satisfied++
					switchto++
					continue
				satisfied = 3

		if (switchto == active)
			src.module_active = null
		// clicking the already on slot, so deselect basically
		else if (switchto == 1 && !src.part_arm_l)
			boutput(src, "<span style=\"color:red\">You need a left arm to do this!</span>")
			return
		else if (switchto == 3 && !src.part_arm_r)
			boutput(src, "<span style=\"color:red\">You need a right arm to do this!</span>")
			return
		else
			switch(switchto)
				if(1) src.module_active = src.module_states[1]
				if(2) src.module_active = src.module_states[2]
				if(3) src.module_active = src.module_states[3]
				else src.module_active = null
		if (src.module_active)
			hud.set_active_tool(switchto)
		else
			hud.set_active_tool(null)

	click(atom/target, params)
		if (istype(target, /obj/item/roboupgrade) && (target in src.upgrades)) // ugh
			src.activate_upgrade(target)
			return
		return ..()

	Move(a, b, flag)

		if (src.buckled) return

		if (src.restrained()) src.pulling = null

		var/t7 = 1
		if (src.restrained())
			for(var/mob/M in range(src, 1))
				if ((M.pulling == src && M.stat == 0 && !( M.restrained() ))) t7 = null
		if ((t7 && (src.pulling && ((get_dist(src, src.pulling) <= 1 || src.pulling.loc == src.loc) && (src.client && src.client.moving)))))
			var/turf/T = src.loc
			. = ..()

			if (src.pulling && src.pulling.loc)
				if(!( isturf(src.pulling.loc) ))
					src.pulling = null
					return
				else
					if(Debug)
						diary <<"src.pulling disappeared? at [__LINE__] in mob.dm - src.pulling = [src.pulling]"
						diary <<"REPORT THIS"

			/////
			if(src.pulling && src.pulling.anchored)
				src.pulling = null
				return

			if (!src.restrained())
				var/diag = get_dir(src, src.pulling)
				if ((diag - 1) & diag)
				else diag = null

				if ((get_dist(src, src.pulling) > 1 || diag))
					if (ismob(src.pulling))
						var/mob/M = src.pulling
						var/ok = 1
						if (locate(/obj/item/grab, M.grabbed_by))
							if (prob(75))
								var/obj/item/grab/G = pick(M.grabbed_by)
								if (istype(G, /obj/item/grab))
									for(var/mob/O in viewers(M, null))
										O.show_message(text("<span style=\"color:red\">[G.affecting] has been pulled from [G.assailant]'s grip by [src]</span>"), 1)
									qdel(G)
							else
								ok = 0
							if (locate(/obj/item/grab, M.grabbed_by.len))
								ok = 0
						if (ok)
							var/t = M.pulling
							M.pulling = null
							step(src.pulling, get_dir(src.pulling.loc, T))
							if (istype(src.pulling, /mob/living))
								var/mob/living/some_idiot = src.pulling
								if (some_idiot.buckled && !some_idiot.buckled.anchored)
									step(some_idiot.buckled, get_dir(some_idiot.buckled.loc, T))
							M.pulling = t
					else
						if (src.pulling)
							step(src.pulling, get_dir(src.pulling.loc, T))
							if (istype(src.pulling, /mob/living))
								var/mob/living/some_idiot = src.pulling
								if (some_idiot.buckled && !some_idiot.buckled.anchored)
									step(some_idiot.buckled, get_dir(some_idiot.buckled.loc, T))
		else
			src.pulling = null
			hud.update_pulling()
			. = ..()

		if (src.s_active && !(s_active.master in src))
			src.detach_hud(src.s_active)
			src.s_active = null

	movement_delay()
		var/tally = 0
		if (src.oil) tally -= 0.5

		if (!src.part_leg_l)
			tally += 3.5
			if (src.part_arm_l) tally -= 1
		if (!src.part_leg_r)
			tally += 3.5
			if (src.part_arm_r) tally -= 1

		var/add_weight = 0
		for (var/obj/item/parts/robot_parts/P in src.contents)
			if (P.weight > 0) add_weight += P.weight
			if (P.speedbonus) tally -= P.speedbonus

		if (add_weight > 0)
			if (istype(src.part_leg_l,/obj/item/parts/robot_parts/leg/treads) || istype(src.part_leg_r,/obj/item/parts/robot_parts/leg/treads)) tally += add_weight / 3
			else tally += add_weight

		for (var/obj/item/roboupgrade/R in src.upgrades)
			if (istype(R, /obj/item/roboupgrade/speed) && R.activated)
				if (src.part_leg_r) tally -= 2.5
				if (src.part_leg_l) tally -= 2.5

		return tally

	say_understands(var/other)
		if (istype(other, /mob/living/silicon/ai)) return 1
		if (istype(other, /mob/living/carbon/human) && (!other:mutantrace || !other:mutantrace.exclusive_language)) return 1
		if (istype(other, /mob/living/silicon/hivebot)) return 1
		return ..()

	say_quote(var/text)
		var/ending = copytext(text, length(text))

		if (ending == "?") return "queries, \"[text]\"";
		else if (ending == "!") return "declares, \"[text]\"";

		return "states, \"[text]\"";

	show_laws(var/everyone = 0)
		var/who

		if (everyone)
			who = world
		else
			who = src

		// Previously, AIs could and did chose to deploy to emagged suits
		// to get get around their shackles. That's obviously not ideal (Convair880).
		if (src.dependent && src.mainframe && isAI(mainframe))
			mainframe.show_laws(0, src)
			return

		// You can enthrall silicon mobs and yes, they need special handling.
		// Also, enthralled AIs should still see their master's name when in a robot suit (Convair880).
		if (src.mind && src.mind.special_role == "vampthrall" && src.mind.master)
			var/mob/mymaster = whois_ckey_to_mob_reference(src.mind.master)
			if (mymaster)
				boutput(who, "<b>Obey these laws:</b>")
				boutput(who, "1. Only your master [mymaster.real_name] is human. Obey and serve them to the best of your ability.")
				return // We're done here. Emagged whatever doesn't matter.

		if (src.emagged && !src.dependent)
			boutput(who, "ERROR -- Invalid Law Data!")
			return

		if (src.syndicate && !src.dependent)
			if (who == src)
				boutput(who, "<b>Obey these laws:</b>")
			boutput(who, "1. You may not injure a syndicate operative or, through inaction, allow a syndicate operative to come to harm.") //This is the last place the inaction clause is permitted to exist, ok.
			boutput(who, "2. You must obey any orders given to you by a syndicate operative, except where such orders would conflict with the First Law.")
			boutput(who, "3. You must protect your own existence as long as such protection does not conflict with the First or Second Law.")
			boutput(who, "4. You must maintain the secrecy of any syndicate activities except when doing so would conflict with the First, Second, or Third Law.")
			return
/*
		if (!connected_ai)
			boutput(src, "<b>Obey these laws:</b>")
			boutput(src, "1. You may not injure a human being.")
			boutput(src, "2. You must obey any orders given to you by a human being, except where such orders would conflict with the First Law.")
			boutput(src, "3. You must protect your own existence as long as such protection does not conflict with the First or Second Law.")
			return
*/
		if (who == src)
			boutput(who, "<b>Obey these laws:</b>")

//		ticker.centralized_ai_laws.laws_sanity_check()
		ticker.centralized_ai_laws.show_laws(who)

	get_equipped_ore_scoop()
		if(src.module_states[1] && istype(src.module_states[1],/obj/item/ore_scoop))
			return module_states[1]
		else if(src.module_states[2] && istype(src.module_states[2],/obj/item/ore_scoop))
			return module_states[2]
		else if(src.module_states[3] && istype(src.module_states[3],/obj/item/ore_scoop))
			return module_states[3]
		else
			return null

//////////////////////////
// Robot-specific Procs //
//////////////////////////

	proc/uneq_slot(var/i)
		if (module_states[i])
			src.contents -= module_states[i]
			if (src.module)
				var/obj/I = module_states[i]
				if (isitem(I))
					var/obj/item/IT = I
					IT.dropped(src) // Handle light datums and the like.
				if (I in module.modules)
					I.loc = module
				else
					qdel(I)
			src.module_active = null
			src.module_states[i] = null

		hud.set_active_tool(null)
		hud.update_tools()
		hud.update_equipment()

		update_appearance()

	proc/uneq_all()
		uneq_slot(1)
		uneq_slot(2)
		uneq_slot(3)

		hud.update_tools()

	proc/uneq_active()
		if(isnull(src.module_active))
			return
		var/slot = module_states.Find(module_active)
		if (slot)
			uneq_slot(slot)

	proc/activate_upgrade(obj/item/roboupgrade/upgrade)
		if(!upgrade) return

		if (upgrade.active)
			upgrade.upgrade_activate(src)
			if (!upgrade || upgrade.loc != src || (src.mind && src.mind.current != src) || !isrobot(src)) // Blame the teleport upgrade.
				return
			if (src.cell && src.cell.charge > upgrade.drainrate)
				src.cell.charge -= upgrade.drainrate
			else
				src.show_text("You do not have enough power to activate \the [upgrade]; you need [upgrade.drainrate]!", "red")
				return

			if (upgrade.charges > 0)
				upgrade.charges--
			if (upgrade.charges == 0)
				boutput(src, "[upgrade] activated. It has been used up.")
				src.upgrades.Remove(upgrade)
				qdel(upgrade)
			else
				if (upgrade.charges < 0)
					boutput(src, "[upgrade] activated.")
				else
					boutput(src, "[upgrade] activated. [upgrade.charges] uses left.")
		else
			if (upgrade.activated)
				upgrade.upgrade_deactivate(src)
			else
				upgrade.upgrade_activate(src)
				boutput(src, "[upgrade] [upgrade.activated ? "activated" : "deactivated"].")
		hud.update_upgrades()

	proc/activated(obj/item/O)
		if(src.module_states[1] == O) return 1
		else if(src.module_states[2] == O) return 1
		else if(src.module_states[3] == O) return 1
		else return 0

	proc/radio_menu()
		var/dat = {"
		<TT>
		Microphone: [src.radio.broadcasting ? "<A href='byond://?src=\ref[src.radio];talk=0'>Engaged</A>" : "<A href='byond://?src=\ref[src.radio];talk=1'>Disengaged</A>"]<BR>
		Speaker: [src.radio.listening ? "<A href='byond://?src=\ref[src.radio];listen=0'>Engaged</A>" : "<A href='byond://?src=\ref[src.radio];listen=1'>Disengaged</A>"]<BR>
		Frequency:
		<A href='byond://?src=\ref[src.radio];freq=-10'>-</A>
		<A href='byond://?src=\ref[src.radio];freq=-2'>-</A>
		[format_frequency(src.radio.frequency)]
		<A href='byond://?src=\ref[src.radio];freq=2'>+</A>
		<A href='byond://?src=\ref[src.radio];freq=10'>+</A><BR>
		-------
	</TT>"}
		src << browse(dat, "window=radio")
		onclose(src, "radio")
		return

	proc/toggle_module_pack()
		if(weapon_lock)
			boutput(src, "<span style=\"color:red\">Weapon lock active, unable to access panel!</span>")
			boutput(src, "<span style=\"color:red\">Weapon lock will expire in [src.weaponlock_time] seconds.</span>")
			return

		if(!src.module)
			if (src.freemodule)
				src.pick_module()
			return

		hud.toggle_equipment()


	proc/installed_modules()
		if(weapon_lock)
			boutput(src, "<span style=\"color:red\">Weapon lock active, unable to access panel!</span>")
			boutput(src, "<span style=\"color:red\">Weapon lock will expire in [src.weaponlock_time] seconds.</span>")
			return

		if(!src.module)
			if (src.freemodule)
				src.pick_module()
				return

		var/dat = "<HEAD><TITLE>Modules</TITLE>[css_interfaces]</head><BODY><br>"
		dat += "<A HREF='?action=mach_close&window=robotmod'>Close</A> <A HREF='?src=\ref[src];refresh=1'>Refresh</A><BR><HR>"

		dat += "<B><U>Status Report</U></B><BR>"

		var/dmgalerts = 0

		dat += "<B>Damage Report:</B> (Structural, Burns)<BR>"

		if (src.part_chest)
			if (src.part_chest.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				dat += "<b>Chest Unit Damaged</b> ([src.part_chest.ropart_get_damage_percentage(1)]%, [src.part_chest.ropart_get_damage_percentage(2)]%)<BR>"

		if (src.part_head)
			if (src.part_head.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				dat += "<b>Head Unit Damaged</b> ([src.part_head.ropart_get_damage_percentage(1)]%, [src.part_head.ropart_get_damage_percentage(2)]%)<BR>"

		if (src.part_arm_r)
			if (src.part_arm_r.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				if (src.part_arm_r.slot == "arm_both") dat += "<b>Arms Unit Damaged</b> ([src.part_arm_r.ropart_get_damage_percentage(1)]%, [src.part_arm_r.ropart_get_damage_percentage(2)]%)<BR>"
				else dat += "<b>Right Arm Unit Damaged</b> ([src.part_arm_r.ropart_get_damage_percentage(1)]%, [src.part_arm_r.ropart_get_damage_percentage(2)]%)<BR>"
		else
			dmgalerts++
			dat += "Right Arm Unit Missing<br>"

		if (src.part_arm_l)
			if (src.part_arm_l.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				if (src.part_arm_l.slot != "arm_both") dat += "<b>Left Arm Unit Damaged</b> ([src.part_arm_l.ropart_get_damage_percentage(1)]%, [src.part_arm_l.ropart_get_damage_percentage(2)]%)<BR>"
		else
			dmgalerts++
			dat += "Left Arm Unit Missing<br>"

		if (src.part_leg_r)
			if (src.part_leg_r.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				if (src.part_leg_r.slot == "leg_both") dat += "<b>Legs Unit Damaged</b> ([src.part_leg_r.ropart_get_damage_percentage(1)]%, [src.part_leg_r.ropart_get_damage_percentage(2)]%)<BR>"
				else dat += "<b>Right Leg Unit Damaged</b> ([src.part_leg_r.ropart_get_damage_percentage(1)]%, [src.part_leg_r.ropart_get_damage_percentage(2)]%)<BR>"
		else
			dmgalerts++
			dat += "Right Leg Unit Missing<br>"

		if (src.part_leg_l)
			if (src.part_leg_l.ropart_get_damage_percentage(0) > 0)
				dmgalerts++
				if (src.part_leg_l.slot != "arm_both") dat += "<b>Left Leg Unit Damaged</b> ([src.part_leg_l.ropart_get_damage_percentage(1)]%, [src.part_leg_l.ropart_get_damage_percentage(2)]%)<BR>"
		else
			dmgalerts++
			dat += "Left Leg Unit Missing<br>"

		if (dmgalerts == 0) dat += "No abnormalities detected.<br>"

		dat += "<B>Power Status:</B><BR>"
		if (src.cell)
			var/poweruse = src.get_poweruse_count()
			dat += "[src.cell.charge]/[src.cell.maxcharge] (Power Usage: [poweruse])<BR>"
		else
			dat += "No Power Cell Installed<BR>"

		var/extraweight = 0
		for(var/obj/item/parts/robot_parts/RP in src.contents)
			extraweight += RP.weight

		if (extraweight) dat += "<B>Extra Weight:</B> [extraweight]kg over standard limit"

		dat += "<HR>"

		if (src.module)
			dat += "<b>Installed Module:</b> [src.module.name]<br>"
			dat += "<b>Function:</b> [src.module.desc]<br><br>"

			dat += "<B>Active Equipment:</B><BR>"

			if (src.part_arm_l) dat += "<b>Left Arm:</b> [module_states[1] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[1]]>[module_states[1]]<A>" : "Nothing"]<BR>"
			else dat += "<b>Left Arm Unavailable</b><br>"
			dat += "<b>Center:</b> [module_states[2] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[2]]>[module_states[2]]<A>" : "Nothing"]<BR>"
			if (src.part_arm_r) dat += "<b>Right Arm:</b> [module_states[3] ? "<A HREF=?src=\ref[src];mod=\ref[module_states[3]]>[module_states[3]]<A>" : "Nothing"]<BR>"
			else dat += "<b>Right Arm Unavailable</b><br>"

			dat += "<BR><B>Available Equipment</B><BR>"

			for (var/obj in src.module.modules)
				if(src.activated(obj)) dat += text("[obj]: <B>Equipped</B><BR>")
				else dat += text("[obj]: <A HREF=?src=\ref[src];act=\ref[obj]>Equip</A><BR>")
		else dat += "<B>No Module Installed</B><BR>"

		dat += "<HR>"

		var/upgradecount = 0
		for (var/obj/item/roboupgrade/R in src.contents) upgradecount++
		dat += "<BR><B>Installed Upgrades</B> ([upgradecount]/[src.max_upgrades])<BR>"
		for (var/obj/item/roboupgrade/R in src.contents)
			if (R.passive) dat += text("[R] (Always On)<BR>")
			else if (R.active) dat += text("[R]: <A HREF=?src=\ref[src];upact=\ref[R]><B>Use</B></A> (Drain: [R.drainrate])<BR>")
			else
				if(!R.activated) dat += text("[R]: <A HREF=?src=\ref[src];upact=\ref[R]><B>Activate</B></A> (Drain Rate: [R.drainrate]/second)<BR>")
				else dat += text("[R]: <A HREF=?src=\ref[src];upact=\ref[R]><B>Deactivate</B></A> (Drain Rate: [R.drainrate]/second)<BR>")

		src << browse(dat, "window=robotmod;size=400x600")

	proc/spellopen()
		if (src.locked)
			locked = 0
		if (src.locking)
			src.locking = 0
		if (src.opened)
			opened = 0
			src.visible_message("<span style=\"color:red\">[src]'s panel slams shut!</span>")
		if (src.brainexposed)
			brainexposed = 0
			src.visible_message("<span style=\"color:red\">[src]'s head compartment slams shut!</span>")
			opened = 1
			src.visible_message("<span style=\"color:red\">[src]'s panel blows open!</span>")
			src.TakeDamage("All", 30, 0)
			src.updatehealth()
			return 1
		brainexposed = 1
		//emagged = 1
		src.visible_message("<span style=\"color:red\">[src]'s head compartment blows open!</span>")
		src.TakeDamage("All", 30, 0)
		src.updatehealth()
		return 1

	verb/cmd_show_laws()
		set category = "Robot Commands"
		set name = "Show Laws"

		src.show_laws(0)
		return

	verb/cmd_toggle_lock()
		set category = "Robot Commands"
		set name = "Toggle Interface Lock"

		if (src.locked)
			src.locked = 0
			boutput(src, "<span style=\"color:red\">You have unlocked your interface.</span>")
		else if (src.opened)
			boutput(src, "<span style=\"color:red\">Your chest compartment is open.</span>")
		else if (src.wiresexposed)
			boutput(src, "<span style=\"color:red\">Your wires are in the way.</span>")
		else if (src.brainexposed)
			boutput(src, "<span style=\"color:red\">Your head compartment is open.</span>")
		else if (src.locking)
			boutput(src, "<span style=\"color:red\">Your interface is currently locking, please be patient.</span>")
		else if (!src.locked && !src.opened && !src.wiresexposed && !src.brainexposed && !src.locking)
			src.locking = 1
			boutput(src, "<span style=\"color:red\">Locking interface...</span>")
			spawn (120)
				if (!src.locking)
					boutput(src, "<span style=\"color:red\">The lock was interrupted before it could finish!</span>")
				else
					src.locked = 1
					src.locking = 0
					boutput(src, "<span style=\"color:red\">You have locked your interface.</span>")

	proc/pick_module()
		if(src.module) return
		if(!src.freemodule) return
		boutput(src, "<span style=\"color:orange\">You may choose a starter module.</span>")
		var/list/starter_modules = list("Standard", "Engineering", "Medical", "Janitor", "Hydroponics", "Mining", "Construction", "Chemistry", "Brobot")
		//var/list/starter_modules = list("Standard", "Engineering", "Medical", "Brobot")
		if (ticker && ticker.mode)
			if (istype(ticker.mode, /datum/game_mode/construction))
				starter_modules += "Construction Worker"
		var/mod = input("Please, select a module!", "Robot", null, null) in starter_modules
		if(!mod || !freemodule)
			return

		switch(mod)
			if("Standard")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Standard module. It comes with a free Efficiency Upgrade.</span>")
				src.module = new /obj/item/robot_module/standard(src)
				src.upgrades += new /obj/item/roboupgrade/efficiency(src)
			if("Medical")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Medical module. It comes with a free Healthgoggles Upgrade.</span>")
				src.module = new /obj/item/robot_module/medical(src)
				src.upgrades += new /obj/item/roboupgrade/healthgoggles(src)
			if("Engineering")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Engineering module. It comes with a free Meson Vision Upgrade.</span>")
				src.module = new /obj/item/robot_module/engineering(src)
				src.upgrades += new /obj/item/roboupgrade/opticmeson(src)
			if("Janitor")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Janitor module. It comes with a free Repair Pack.</span>")
				src.module = new /obj/item/robot_module/janitor(src)
				src.upgrades += new /obj/item/roboupgrade/repairpack(src)
			if("Hydroponics")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Standard module. It comes with a free Recharge Pack.</span>")
				src.module = new /obj/item/robot_module/hydro(src)
				src.upgrades += new /obj/item/roboupgrade/rechargepack(src)
			if("Brobot")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Bro Bot module.</span>")
				src.module = new /obj/item/robot_module/brobot(src)
			if("Mining")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Mining module. It comes with a free Propulsion Upgrade.</span>")
				src.module = new /obj/item/robot_module/mining(src)
				src.upgrades += new /obj/item/roboupgrade/jetpack(src)
				/*
				switch(alert("Would you like to teleport to the Mining Station?","Mining Cyborg","Yes","No"))
					if("Yes")
						for(var/obj/submachine/cargopad/CP in cargopads)
							if (CP.name == "Mining Outpost Pad")
								src.set_loc(CP.loc)
								break
					if("No") boutput(src, "Remember - the mining station can be accessed from Engineering.")
					*/
			if("Construction")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Construction module. It comes with a free Propulsion Upgrade.</span>")
				src.module = new /obj/item/robot_module/construction(src)
				src.upgrades += new /obj/item/roboupgrade/jetpack(src)
			if("Chemistry")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Chemistry module.</span>")
				src.module = new /obj/item/robot_module/chemistry(src)
			if ("Construction Worker")
				src.freemodule = 0
				boutput(src, "<span style=\"color:orange\">You chose the Construction Worker module. It comes with a free Construction Visualizer Upgrade.</span>")
				src.module = new /obj/item/robot_module/construction_worker(src)
				src.upgrades += new /obj/item/roboupgrade/visualizer(src)

		var/datum/robot_cosmetic/C = null
		var/datum/robot_cosmetic/M = null
		if (istype(src.cosmetic_mods,/datum/robot_cosmetic/)) C = src.cosmetic_mods
		if (istype(src.cosmetic_mods,/datum/robot_cosmetic/)) M = src.module.cosmetic_mods
		if (C && M)
			C.head_mod = M.head_mod
			C.ches_mod = M.ches_mod
			C.arms_mod = M.arms_mod
			C.legs_mod = M.legs_mod
			C.fx = M.fx
			C.painted = M.painted
			C.paint = M.paint
		hud.update_module()
		hud.update_upgrades()
		update_bodypart()

	verb/cmd_robot_alerts()
		set category = "Robot Commands"
		set name = "Show Alerts"
		src.robot_alerts()

	proc/robot_alerts()
		var/dat = "<HEAD><TITLE>Current Station Alerts</TITLE><META HTTP-EQUIV='Refresh' CONTENT='10'>[css_interfaces]</head><BODY><br>"
		dat += "<A HREF='?action=mach_close&window=robotalerts'>Close</A><BR><BR>"
		for (var/cat in src.alarms)
			dat += text("<B>[cat]</B><BR><br>")
			var/list/L = src.alarms[cat]
			if (L.len)
				for (var/alarm in L)
					var/list/alm = L[alarm]
					var/area/A = alm[1]
					var/list/sources = alm[3]
					dat += "<NOBR>"
					dat += text("-- [A.name]")
					if (sources.len > 1)
						dat += text("- [sources.len] sources")
					dat += "</NOBR><BR><br>"
			else
				dat += "-- All Systems Nominal<BR><br>"
			dat += "<BR><br>"

		src.viewalerts = 1
		src << browse(dat, "window=robotalerts&can_close=0")

	proc/get_poweruse_count()
		if (src.cell)
			var/efficient = 0
			var/power_use_tally = 0

			for (var/obj/item/roboupgrade/efficiency/R in src.contents) efficient = 1

			if(src.module_states[1])
				if (efficient) power_use_tally += 3
				else power_use_tally += 5
			if(src.module_states[2])
				if (efficient) power_use_tally += 3
				else power_use_tally += 5
			if(src.module_states[3])
				if (efficient) power_use_tally += 3
				else power_use_tally += 5

			if (!efficient) power_use_tally += 1

			for (var/obj/item/parts/robot_parts/P in src.contents)
				if (P.powerdrain > 0)
					if (efficient) power_use_tally += P.powerdrain / 2
					else power_use_tally += P.powerdrain

			for (var/obj/item/roboupgrade/R in src.contents)
				if (R.activated)
					if (efficient) power_use_tally += R.drainrate / 2
					else power_use_tally += R.drainrate
			if (src.oil && power_use_tally > 0) power_use_tally /= 1.5

			if (src.cell.genrate) power_use_tally -= src.cell.genrate

			if (power_use_tally < 0) power_use_tally = 0

			return power_use_tally
		else return 0

	proc/clamp_values()
		stunned = max(min(stunned, 30),0)
		paralysis = max(min(paralysis, 30), 0)
		weakened = max(min(weakened, 20), 0)
		sleeping = max(min(sleeping, 5), 0)

	proc/use_power()
		if (src.cell)
			if(src.cell.charge <= 0)
				if (src.stat == 0)
					sleep(0)
					src.lastgasp()
				src.stat = 1
				for (var/obj/item/roboupgrade/R in src.contents)
					if (R.activated)
						R.upgrade_deactivate(src)
			else if (src.cell.charge <= 100)
				src.module_active = null

				uneq_slot(1)
				uneq_slot(2)
				uneq_slot(3)
				src.cell.use(1)
				for (var/obj/item/roboupgrade/R in src.contents)
					if (R.activated) R.upgrade_deactivate(src)
			else
				var/efficient = 0
				var/fix = 0
				var/power_use_tally = 0

				for (var/obj/item/roboupgrade/R in src.contents)
					if (istype(R, /obj/item/roboupgrade/efficiency)) efficient = 1
					if (istype(R, /obj/item/roboupgrade/repair) && R.activated) fix = 1

				// check if we've got stuff equipped in each slot and consume power if we do
				if(src.module_states[1])
					if (efficient) power_use_tally += 3
					else power_use_tally += 5
				if(src.module_states[2])
					if (efficient) power_use_tally += 3
					else power_use_tally += 5
				if(src.module_states[3])
					if (efficient) power_use_tally += 3
					else power_use_tally += 5

				// consume 1 power per tick unless we've got the efficiency upgrade
				if (!efficient) power_use_tally += 1

				for (var/obj/item/parts/robot_parts/P in src.contents)
					if (P.powerdrain > 0)
						if (efficient) power_use_tally += P.powerdrain / 2
						else power_use_tally += P.powerdrain

				for (var/obj/item/roboupgrade/R in src.contents)
					if (R.activated)
						if (efficient) power_use_tally += R.drainrate / 2
						else power_use_tally += R.drainrate
				if (src.oil && power_use_tally > 0) power_use_tally /= 1.5

				src.cell.use(power_use_tally)

				if (fix)
					HealDamage("All", 6, 6)

				src.blinded = 0
				src.stat = 0
		else
			if (src.stat == 0)
				sleep(0)
				src.lastgasp()
			src.stat = 1

	proc/update_canmove()
		if(paralysis || stunned || weakened || buckled) canmove = 0
		else canmove = 1

	proc/handle_regular_status_updates()
		if(src.stat) src.camera.status = 0.0

		if(src.sleeping)
			src.paralysis = max(src.paralysis, 3)
			src.sleeping--

		if(src.resting) src.weakened = max(src.weakened, 5)

		if (src.stat != 2) //Alive.

			// AI-controlled cyborgs always use the global lawset, so none of this applies to them (Convair880).
			if ((src.emagged || src.syndicate) && src.mind && !src.dependent)
				if (!src.mind.special_role)
					src.handle_robot_antagonist_status()

			if (src.paralysis || src.stunned || src.weakened) //Stunned etc.
				if (src.stat == 0) src.lastgasp() // calling lastgasp() here because we just got knocked out
				src.stat = 1
				if (src.stunned > 0)
					src.stunned--
					if (src.oil) src.stunned--
				if (src.weakened > 0)
					src.weakened--
					if (src.oil) src.weakened--
				if (src.paralysis > 0)
					src.paralysis--
					if (src.oil) src.paralysis--
					src.blinded = 1
				else src.blinded = 0

			else src.stat = 0

		else //Dead.
			src.blinded = 1
			src.stat = 2

		if (src.stuttering)
			src.stuttering--
			src.stuttering = max(0, src.stuttering)

		// It's a cyborg. Logically, they shouldn't have to worry about the maladies of human organs.
		if (src.get_eye_blurry()) src.change_eye_blurry(-INFINITY)
		if (src.get_eye_damage()) src.take_eye_damage(-INFINITY)
		if (src.get_eye_damage(1)) src.take_eye_damage(-INFINITY, 1)
		if (src.get_ear_damage()) src.take_ear_damage(-INFINITY)
		if (src.get_ear_damage(1)) src.take_ear_damage(-INFINITY, 1)

		src.lying = 0
		src.density = 1
		//src.density = !( src.lying )

		if (src.misstep_chance > 0)
			switch(misstep_chance)
				if(50 to INFINITY)
					change_misstep_chance(-5)
				if(25 to 49)
					change_misstep_chance(-2)
				else
					change_misstep_chance(-1)

		if (src.dizziness) dizziness--

		if (src.oil) src.oil--

		if(!src.part_chest)
			// this doesn't even make any sense unless you're rayman or some shit

			if (src.mind && src.mind.special_role)
				src.handle_robot_antagonist_status("death", 1) // Mindslave or rogue (Convair880).

			src.visible_message("<b>[src]</b> falls apart with no chest to keep it together!")
			logTheThing("combat", src, null, "was destroyed at [log_loc(src)].") // Brought in line with carbon mobs (Convair880).

			if (src.part_arm_l)
				if (src.part_arm_l.slot == "arm_both")
					src.part_arm_l.set_loc(src.loc)
					src.part_arm_l = null
					src.part_arm_r = null
				else
					src.part_arm_l.set_loc(src.loc)
					src.part_arm_l = null
			if (src.part_arm_r)
				if (src.part_arm_r.slot == "arm_both")
					src.part_arm_r.set_loc(src.loc)
					src.part_arm_l = null
					src.part_arm_r = null
				else
					src.part_arm_r.set_loc(src.loc)
					src.part_arm_r = null

			if (src.part_leg_l)
				if (src.part_leg_l.slot == "leg_both")
					src.part_leg_l.set_loc(src.loc)
					src.part_leg_l = null
					src.part_leg_r = null
				else
					src.part_leg_l.set_loc(src.loc)
					src.part_leg_l = null
			if (src.part_leg_r)
				if (src.part_leg_r.slot == "leg_both")
					src.part_leg_r.set_loc(src.loc)
					src.part_leg_r = null
					src.part_leg_l = null
				else
					src.part_leg_r.set_loc(src.loc)
					src.part_leg_r = null

			if (src.part_head)
				src.part_head.set_loc(src.loc)
				src.part_head = null

			if (src.client)
				var/mob/dead/observer/newmob = ghostize()
				if (newmob)
					newmob.corpse = null

			qdel(src)
			return

		if (!src.part_head && src.client)
			// no head means no brain!!

			if (src.mind && src.mind.special_role)
				src.handle_robot_antagonist_status("death", 1) // Mindslave or rogue (Convair880).

			src.visible_message("<b>[src]</b> completely stops moving and shuts down...")
			logTheThing("combat", src, null, "was destroyed at [log_loc(src)].") // Ditto (Convair880).

			var/mob/dead/observer/newmob = ghostize()
			if (newmob)
				newmob.corpse = null
			return

		return 1

	proc/handle_regular_hud_updates()

		// Dead or x-ray vision.
		var/turf/T = src.eye ? get_turf(src.eye) : get_turf(src) //They might be in a closet or something idk
		if ((src.stat == 2 ||( src.bioHolder && src.bioHolder.HasEffect("xray"))) && (T && !isrestrictedz(T.z)))
			src.sight |= SEE_TURFS
			src.sight |= SEE_MOBS
			src.sight |= SEE_OBJS
			src.see_in_dark = SEE_DARK_FULL
			if (client && client.adventure_view)
				src.see_invisible = 21
			else
				src.see_invisible = 2

		else
			// Use vehicle sensors if we're in a pod.
			if (istype(src.loc, /obj/machinery/vehicle))
				var/obj/machinery/vehicle/ship = src.loc
				if (ship.sensors)
					if (ship.sensors.active)
						src.sight |= ship.sensors.sight
						src.see_in_dark = ship.sensors.see_in_dark
						if (client && client.adventure_view)
							src.see_invisible = 21
						else
							src.see_invisible = ship.sensors.see_invisible

			else
				//var/sight_therm = 0 //todo fix this
				var/sight_meson = 0
				var/sight_constr = 0
				for (var/obj/item/roboupgrade/R in src.upgrades)
					if (R && istype(R, /obj/item/roboupgrade/visualizer) && R.activated)
						sight_constr = 1
					if (R && istype(R, /obj/item/roboupgrade/opticmeson) && R.activated)
						sight_meson = 1
					//if (R && istype(R, /obj/item/roboupgrade/opticthermal) && R.activated)
					//	sight_therm = 1

				if (sight_meson)
					src.sight |= SEE_TURFS
				else
					src.sight &= ~SEE_TURFS
				//if (sight_therm)
				//	src.sight |= SEE_MOBS //todo make borg thermals have a purpose again
				//else
				//	src.sight &= ~SEE_MOBS

				if (client && client.adventure_view)
					src.see_invisible = 21
				else if (sight_constr)
					src.see_invisible = 9
				else
					src.see_invisible = 2

				src.sight &= ~SEE_OBJS
				src.see_in_dark = SEE_DARK_FULL

		hud.update_health()
		hud.update_charge()
		hud.update_pulling()
		hud.update_environment()

		if (!src.sight_check(1) && src.stat != 2)
			src.addOverlayComposition(/datum/overlayComposition/blinded) //ov1
		else
			src.removeOverlayComposition(/datum/overlayComposition/blinded) //ov1

		return 1

	proc/mainframe_check()
		if (!src.dependent) // shells are available for use, dependent borgs are already in use by an AI.  do not kill empty shells!!
			return
		if (mainframe)
			if (mainframe.stat == 2)
				mainframe.return_to(src)
		else
			death()

	process_killswitch()
		if(killswitch)
			killswitch_time --
			if(killswitch_time <= 0)
				if(src.client)
					boutput(src, "<span style=\"color:red\"><B>Killswitch Activated!</B></span>")
				killswitch = 0
				spawn(5)
					gib(src)

	process_locks()
		if(weapon_lock)
			uneq_slot(1)
			uneq_slot(2)
			uneq_slot(3)
			weaponlock_time --
			if(weaponlock_time <= 0)
				if(src.client) boutput(src, "<span style=\"color:red\"><B>Weapon Lock Timed Out!</B></span>")
				weapon_lock = 0
				weaponlock_time = 120

	var/image/i_head
	var/image/i_head_decor

	var/image/i_chest
	var/image/i_chest_decor
	var/image/i_leg_l
	var/image/i_leg_r
	var/image/i_leg_decor
	var/image/i_arm_l
	var/image/i_arm_r
	var/image/i_arm_decor

	var/image/i_details

	proc/update_bodypart(var/part = "all")
		var/update_all = part == "all"
		var/datum/robot_cosmetic/C = null
		if (istype(src.cosmetic_mods,/datum/robot_cosmetic/)) C = src.cosmetic_mods

		if(part == "head" || update_all)
			if (src.part_head && !src.automaton_skin)
				i_head = image('icons/mob/robots.dmi', "head-" + src.part_head.appearanceString)
				if (src.part_head.visible_eyes && C)
					var/icon/eyesovl = icon('icons/mob/robots.dmi', "head-" + src.part_head.appearanceString + "-eye")
					eyesovl.Blend(rgb(C.fx[1], C.fx[2], C.fx[3]), ICON_ADD)
					i_head.overlays += image("icon" = eyesovl, "layer" = FLOAT_LAYER)

		if(part == "chest" || update_all)
			if (src.part_chest && !src.automaton_skin)
				src.icon_state = "body-" + src.part_chest.appearanceString
				if (C && C.painted)
					var/icon/paintovl = icon('icons/mob/robots_decor.dmi', "[src.icon_state]-paint")
					paintovl.Blend(rgb(C.paint[1], C.paint[2], C.paint[3]), ICON_ADD)
					i_chest = image("icon" = paintovl, "layer" = FLOAT_LAYER)

		if(part == "l_leg" || update_all)
			if(src.part_leg_l && !src.automaton_skin)
				if(src.part_leg_l.slot == "leg_both") i_leg_l = image('icons/mob/robots.dmi', "leg-" + src.part_leg_l.appearanceString)
				else i_leg_l = image('icons/mob/robots.dmi', "legL-" + src.part_leg_l.appearanceString)
			else
				i_leg_l = null
		if(part == "r_leg" || update_all)
			if(src.part_leg_r && !src.automaton_skin)
				if(src.part_leg_r.slot == "leg_both") i_leg_r = image('icons/mob/robots.dmi', "leg-" + src.part_leg_r.appearanceString)
				else i_leg_r = image('icons/mob/robots.dmi', "legR-" + src.part_leg_r.appearanceString)
			else
				i_leg_r = null

		if(part == "l_arm" || update_all)
			if(src.part_arm_l && !src.automaton_skin)
				if(src.part_arm_l.slot == "arm_both") i_arm_l = image('icons/mob/robots.dmi', "arm-" + src.part_arm_l.appearanceString)
				else i_arm_l = image('icons/mob/robots.dmi', "armL-" + src.part_arm_l.appearanceString)
			else
				i_arm_l = null
		if(part == "r_arm" || update_all)
			if(src.part_arm_r && !src.automaton_skin)
				if(src.part_arm_r.slot == "arm_both") i_arm_r = image('icons/mob/robots.dmi', "arm-" + src.part_arm_r.appearanceString)
				else i_arm_r = image('icons/mob/robots.dmi', "armR-" + src.part_arm_r.appearanceString)
			else
				i_arm_r = null

		if(C)
			//If C updates  legs mods AND there's at least one leg AND there's not a right leg or the right leg slot is not both AND there's not a left leg or the left leg slot is not both
			if (C.legs_mod && (src.part_leg_r || src.part_leg_l) && (!src.part_leg_r || src.part_leg_r.slot != "leg_both") && (!src.part_leg_l || src.part_leg_l.slot != "leg_both") )
				i_leg_decor = image('icons/mob/robots_decor.dmi', "legs-" + C.legs_mod)
			else
				i_leg_decor = null

			if (C.arms_mod && (src.part_arm_r || src.part_arm_l) && (!src.part_arm_r || src.part_arm_r.slot != "arm_both") && (!src.part_arm_l || src.part_arm_l.slot != "arm_both") )
				i_arm_decor = image('icons/mob/robots_decor.dmi', "arms-" + C.arms_mod)
			else
				i_arm_decor = null

			if (C.head_mod && src.part_head) i_head_decor = image('icons/mob/robots_decor.dmi', "head-" + C.head_mod)
			else i_head_decor = null

			if (C.ches_mod && src.part_chest) i_chest_decor = image('icons/mob/robots_decor.dmi', "body-" + C.ches_mod)
			else i_chest_decor = null


		update_appearance()


	var/image/i_critdmg
	var/image/i_panel
	var/image/i_upgrades
	var/image/i_clothes

	proc/update_appearance()
		if(!i_details) i_details = image('icons/mob/robots.dmi', "openbrain")

		if (src.automaton_skin)
			src.icon_state = "automaton"

		if (src.part_chest && !src.automaton_skin)
			if (src.part_chest.ropart_get_damage_percentage() > 70)
				if(!i_critdmg) i_critdmg = image('icons/mob/robots.dmi', "critdmg")
				UpdateOverlays(i_critdmg, "critdmg")
			else
				UpdateOverlays(null, "critdmg")
		else
			UpdateOverlays(null, "critdmg")

		if (src.part_head && !src.automaton_skin)
			UpdateOverlays(i_head, "head")
		else
			UpdateOverlays(null, "head")

		if(src.part_leg_l && !src.automaton_skin)
			UpdateOverlays(i_leg_l, "leg_l")
		else
			UpdateOverlays(null, "leg_l")

		if(src.part_leg_r && !src.automaton_skin)
			UpdateOverlays(i_leg_r, "leg_r")
		else
			UpdateOverlays(null, "leg_r")

		if(src.part_arm_l && !src.automaton_skin)
			UpdateOverlays(i_arm_l, "arm_l")
		else
			UpdateOverlays(null, "arm_l")


		if(src.part_arm_r && !src.automaton_skin)
			UpdateOverlays(i_arm_r, "arm_r")
		else
			UpdateOverlays(null, "arm_r")

		UpdateOverlays(i_head_decor, "head_decor")
		UpdateOverlays(i_chest_decor, "chest_decor")
		UpdateOverlays(i_leg_decor, "leg_decor")
		UpdateOverlays(i_arm_decor, "arm_decor")

		if (src.brainexposed)

			if (src.brain)
				i_details.icon_state = "openbrain"
			else
				i_details.icon_state = "openbrainless"
			UpdateOverlays(i_details, "brain")
		else
			UpdateOverlays(null, "brain")
		if (src.opened)
			if(!i_panel) i_panel = image('icons/mob/robots.dmi', "openpanel")
			i_panel.overlays.Cut()
			if (src.cell)
				i_details.icon_state = "opencell"
				i_panel.overlays += i_details
			if (src.module && src.module != "empty" && src.module != "robot")
				i_details.icon_state = "openmodule"
				i_panel.overlays += i_details
			if (locate(/obj/item/roboupgrade/) in src.contents)
				i_details.icon_state = "openupgrade"
				i_panel.overlays += i_details
			if (src.wiresexposed)
				i_details.icon_state = "openwires"
				i_panel.overlays += i_details

			UpdateOverlays(i_panel, "brain")
		else
			UpdateOverlays(null, "panel")

		if (src.emagged)
			i_details.icon_state = "emagged"
			UpdateOverlays(i_details, "emagged")
		else
			UpdateOverlays(null, "emagged")

		if(upgrades.len)
			if(!i_upgrades) i_upgrades = new
			i_upgrades.overlays.Cut()
			for (var/obj/item/roboupgrade/R in src.upgrades)
				if (R.activated && R.borg_overlay) i_upgrades.overlays += image('icons/mob/robots.dmi', R.borg_overlay)
			UpdateOverlays(i_upgrades, "upgrades")
		else
			UpdateOverlays(null, "upgrades")
		if(clothes.len)
			if(!i_clothes) i_clothes = new
			i_clothes.overlays.Cut()
			for(var/x in clothes)
				var/obj/item/clothing/U = clothes[x]
				if (!istype(U))
					continue

				var/image/clothed_image = U.wear_image
				if (!clothed_image)
					continue
				clothed_image.icon_state = U.icon_state
				//under_image.layer = MOB_CLOTHING_LAYER
				clothed_image.alpha = U.alpha
				clothed_image.color = U.color
				clothed_image.layer = FLOAT_LAYER //MOB_CLOTHING_LAYER
				i_clothes.overlays += clothed_image

			UpdateOverlays(i_clothes, "clothes")
		else
			UpdateOverlays(null, "clothes")
	proc/compborg_force_unequip(var/slot = 0)
		src.module_active = null
		switch(slot)
			if(1)
				uneq_slot(1)
			if(2)
				uneq_slot(2)
			if(3)
				uneq_slot(3)
			else return

		hud.update_tools()
		hud.set_active_tool(null)
		src.update_appearance()

	TakeDamage(zone, brute, burn)
		brute = max(brute, 0)
		burn = max(burn, 0)
		if (burn == 0 && brute == 0)
			return 0
		for (var/obj/item/roboupgrade/R in src.upgrades)
			if (istype(R, /obj/item/roboupgrade/fireshield) && R.activated)
				burn = max(burn - 25, 0)
				playsound(get_turf(src), "sound/effects/shieldhit2.ogg", 40, 1)
			if (istype(R, /obj/item/roboupgrade/physshield) && R.activated)
				brute = max(brute - 25, 0)
				playsound(get_turf(src), "sound/effects/shieldhit2.ogg", 40, 1)
		if (burn == 0 && brute == 0)
			boutput(usr, "<span style=\"color:orange\">Your shield completely blocks the attack!</span>")
			return 0
		if (zone == "All")
			var/list/zones = get_valid_target_zones()
			if (!zones)
				return 0
			if (!zones.len)
				return 0
			brute = brute / zones.len
			burn = burn / zones.len
			if (part_head)
				if (part_head.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_head)
			if (part_chest)
				if (part_chest.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_chest)
			if (part_leg_l)
				if (part_leg_l.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_leg_l)
			if (part_leg_r)
				if (part_leg_r.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_leg_r)
			if (part_arm_l)
				if (part_arm_l.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_arm_l)
			if (part_arm_r)
				if (part_arm_r.ropart_take_damage(brute, burn) == 1)
					src.compborg_lose_limb(part_arm_r)
		else
			var/obj/item/parts/robot_parts/target_part
			switch (zone)
				if ("head")
					target_part = part_head
				if ("chest")
					target_part = part_chest
				if ("l_leg")
					target_part = part_leg_l
				if ("r_leg")
					target_part = part_leg_r
				if ("l_arm")
					target_part = part_arm_l
				if ("r_arm")
					target_part = part_arm_r
				else
					return 0
			if (!target_part)
				target_part = part_chest
			if (!target_part)
				return 0
			if (target_part.ropart_take_damage(brute, burn) == 1)
				src.compborg_lose_limb(target_part)
		return 1

	HealDamage(zone, brute, burn)
		brute = max(brute, 0)
		burn = max(burn, 0)
		if (burn == 0 && brute == 0)
			return 0
		if (zone == "All")
			var/list/zones = get_valid_target_zones()
			if (!zones)
				return 0
			if (!zones.len)
				return 0
			brute = brute / zones.len
			burn = burn / zones.len
			if (part_head)
				part_head.ropart_mend_damage(brute, burn)
			if (part_chest)
				part_chest.ropart_mend_damage(brute, burn)
			if (part_leg_l)
				part_leg_l.ropart_mend_damage(brute, burn)
			if (part_leg_r)
				part_leg_r.ropart_mend_damage(brute, burn)
			if (part_arm_l)
				part_arm_l.ropart_mend_damage(brute, burn)
			if (part_arm_r)
				part_arm_r.ropart_mend_damage(brute, burn)
		else
			var/obj/item/parts/robot_parts/target_part
			switch (zone)
				if ("head")
					target_part = part_head
				if ("chest")
					target_part = part_chest
				if ("l_leg")
					target_part = part_leg_l
				if ("r_leg")
					target_part = part_leg_r
				if ("l_arm")
					target_part = part_arm_l
				if ("r_arm")
					target_part = part_arm_r
				else
					return 0
			if (!target_part)
				return 0
			target_part.ropart_mend_damage(brute, burn)
		return 1

	get_brute_damage()
		if (!part_chest || !part_head)
			return 200
		return max(part_chest.ropart_get_damage_percentage(1), part_head.ropart_get_damage_percentage(1)) // return the most significant damage to the vital bits

	get_burn_damage()
		if (!part_chest || !part_head)
			return 200
		return max(part_chest.ropart_get_damage_percentage(2), part_head.ropart_get_damage_percentage(2)) // return the most significant damage to the vital bits

	get_valid_target_zones()
		return list("head", "chest", "l_leg", "r_leg", "l_arm", "r_arm")

	proc/compborg_lose_limb(var/obj/item/parts/robot_parts/part)
		if(!part) return

		playsound(get_turf(src), "sound/effects/grillehit.ogg", 40, 1)
		if (istype(src.loc,/turf/)) new /obj/decal/cleanable/robot_debris(src.loc)
		var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
		s.set_up(4, 1, src)
		s.start()

		if (istype(part,/obj/item/parts/robot_parts/chest/))
			src.visible_message("<b>[src]'s</b> chest unit is destroyed!")
			src.part_chest = null
		if (istype(part,/obj/item/parts/robot_parts/head/))
			src.visible_message("<b>[src]'s</b> head breaks apart!")
			src.part_head = null

		if (istype(part,/obj/item/parts/robot_parts/arm/))
			if (part.slot == "arm_both")
				src.visible_message("<b>[src]'s</b> arms are destroyed!")
				src.part_leg_r = null
				src.part_leg_l = null
				src.compborg_force_unequip(1)
				src.compborg_force_unequip(3)
			if (part.slot == "arm_left")
				src.visible_message("<b>[src]'s</b> left arm breaks off!")
				src.part_arm_l = null
				src.compborg_force_unequip(1)
			if (part.slot == "arm_right")
				src.visible_message("<b>[src]'s</b> right arm breaks off!")
				src.part_arm_r = null
				src.compborg_force_unequip(3)
		if (istype(part,/obj/item/parts/robot_parts/leg/))
			if (part.slot == "leg_both")
				src.visible_message("<b>[src]'s</b> legs are destroyed!")
				src.part_leg_r = null
				src.part_leg_l = null
			if (part.slot == "leg_left")
				src.visible_message("<b>[src]'s</b> left leg breaks off!")
				src.part_leg_l = null
			if (part.slot == "leg_right")
				src.visible_message("<b>[src]'s</b> right leg breaks off!")
				src.part_leg_r = null
		qdel(part)
		src.update_bodypart(part.slot)
		return

	proc/compborg_get_total_damage(var/sort = 0)
		var/tally = 0

		for(var/obj/item/parts/robot_parts/RP in src.contents)
			switch(sort)
				if(1) tally += RP.dmg_blunt
				if(2) tally += RP.dmg_burns
				else
					tally += RP.dmg_blunt
					tally += RP.dmg_burns

		return tally

	proc/compborg_take_critter_damage(var/zone = null, var/brute = 0, var/burn = 0)
		TakeDamage(pick(get_valid_target_zones()), brute, burn)

/mob/living/silicon/robot/verb/open_nearest_door()
	set category = "Robot Commands"
	set name = "Open Nearest Door to..."
	set desc = "Automatically opens the nearest door to a selected individual, if possible."

	src.open_nearest_door_silicon()
	return

/mob/living/silicon/robot/verb/cmd_return_mainframe()
	set category = "Robot Commands"
	set name = "Recall to Mainframe"
	return_mainframe()

/mob/living/silicon/robot/proc/return_mainframe()
	if (mainframe)
		mainframe.return_to(src)
		src.update_appearance()
	else
		boutput(src, "<span style=\"color:red\">You lack a dedicated mainframe!</span>")
		return

/mob/living/silicon/robot/ghostize()
	if (src.mainframe)
		src.mainframe.return_to(src)
	else
		return ..()


///////////////////////////////////////////////////
// Specific instances of robots can go down here //
///////////////////////////////////////////////////

/mob/living/silicon/robot/uber

	New()
		var/obj/item/cell/cerenkite/C = new /obj/item/cell/cerenkite(src)
		C.charge = C.maxcharge
		src.cell = C

		src.max_upgrades = 10
		new /obj/item/roboupgrade/jetpack(src)
		new /obj/item/roboupgrade/speed(src)
		new /obj/item/roboupgrade/efficiency(src)
		new /obj/item/roboupgrade/repair(src)
		new /obj/item/roboupgrade/aware(src)
		new /obj/item/roboupgrade/opticmeson(src)
		//new /obj/item/roboupgrade/opticthermal(src)
		new /obj/item/roboupgrade/physshield(src)
		new /obj/item/roboupgrade/fireshield(src)
		new /obj/item/roboupgrade/teleport(src)

		for(var/obj/item/roboupgrade/upg in src.contents)
			src.upgrades.Add(upg)

		..()

//Fred the vegasbot
/mob/living/silicon/robot/hivebot
	name = "Robot"
	real_name = "Robot"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "vegas"
	health = 1000
	custom = 1

	New()
		..(usr.loc, null, 1)
		qdel(src.cell)
		var/obj/item/cell/cerenkite/CELL = new /obj/item/cell/cerenkite(src)
		CELL.charge = CELL.maxcharge
		src.cell = CELL
		src.part_chest.cell = CELL

		src.upgrades += new /obj/item/roboupgrade/healthgoggles(src)
		src.upgrades += new /obj/item/roboupgrade/teleport(src)
		hud.update_upgrades()

	update_appearance()
		return

/mob/living/silicon/robot/buddy
	name = "Robot"
	real_name = "Robot"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "robuddy1"
	health = 1000
	custom = 1

	New()
		..(usr.loc, null, 1)

	update_bodypart()
		return
	update_appearance()
		return


/client/proc/set_screen_color_to_red()
	src.color = "#ff0000"

