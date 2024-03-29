/datum/random_event/major/antagonist
	name = "Alien Invasion"
	required_elapsed_round_time = 16000 // 30m
	customization_available = 1
	announce_to_admins = 0 // Doing it manually.
	centcom_headline = "Biogenic Outbreak"
	centcom_message = "Aggressive macrocellular organism detected aboard the station. All personnel must contain the outbreak."
	message_delay = 3000 // 5m (+ ghost_confirmation_delay). Don't out them too early, blobs in particular need time to establish themselves.
	var/antagonist_type = "Blob"
	var/ghost_confirmation_delay = 1200 // 2 min to acknowledge or deny respawn offer.
	var/respawn_lock = 0
	var/admin_override = 0
#if defined(MAP_OVERRIDE_DESTINY)
	disabled = 1
#endif

	admin_call(var/source)
		if (..())
			return

		if (src.respawn_lock != 0)
			message_admins("Setup of previous alien invasion hasn't finished yet, aborting.")
			return

		var/type = input(usr, "Select antagonist type.", "Antagonists", "Blob") as null|anything in list("Blob", "Blob (AI)", "Wraith", "Wizard", "Werewolf", "Predator")
		if (!type)
			return
		else
			src.antagonist_type = type

		src.admin_override = 1
		src.event_effect(source)
		return

	event_effect(var/source)
		if (src.respawn_lock != 0)
			message_admins("Setup of previous alien invasion hasn't finished yet, aborting.")
			return

		// Admin-configured respawns seem to work out fine, so let's give automatic role selection a try.
		if (src.admin_override != 1)
			if (!source && (!ticker.mode || ticker.mode.latejoin_antag_compatible == 0 || late_traitors == 0))
				message_admins("Alien invasion (non-admin) is disabled in this game mode, aborting.")
				return

			switch (rand(1, 100))
				if (1 to 3)
					src.antagonist_type = "Werewolf"
				if (4 to 6)
					src.antagonist_type = "Predator"
				if (7 to 20)
					src.antagonist_type = "Wizard"
				if (21 to 34)
					src.antagonist_type = "Wraith"
				if (35 to 98)
					src.antagonist_type = "Blob"
				if (99 to 100)
					src.antagonist_type = "Blob (AI)"
				else
					src.antagonist_type = "Blob"

		switch (src.antagonist_type)
			if ("Blob", "Blob (AI)")
				src.centcom_headline = initial(src.centcom_headline) // Gotta reset this.
				src.centcom_message = initial(src.centcom_message)
			else
				src.centcom_headline = "Intruder Alert"
				src.centcom_message = "Our [pick("probes", "sensors", "listening devices", "informants", "well-informed sources")] indicate the presence of a hostile intruder aboard the station. Security level elevated."
		src.message_delay = src.message_delay + src.ghost_confirmation_delay

		message_admins("<span style=\"color:orange\">Setting up alien invasion event ([src.antagonist_type]). Source: [source ? "[source]" : "random"]</span>")
		logTheThing("admin", null, null, "Setting up alien invasion event ([src.antagonist_type]). Source: [source ? "[source]" : "random"]")

		// No need for a fancy setup here.
		if (src.antagonist_type == "Blob (AI)")
			var/BS = blobstart.len ? pick(blobstart) : null
			if (BS)
				new /mob/living/intangible/blob_overmind/ai(BS)
				message_admins("Alien invasion spawned an AI blob at [log_loc(BS)].")
				logTheThing("admin", null, null, "Alien invasion spawned an AI blob at [log_loc(BS)]. Source: [source ? "[source]" : "random"]")
				..() // Report spawn().
				src.post_event()
				return
			else
				message_admins("Couldn't spawn AI blob (no blobstart landmark found).")
				src.post_event()
				return

		// Don't lock up the event controller.
		spawn (0)
			if (src) src.do_event(source)

		return

	proc/do_event(var/source)
		if (!src || !istype(src, /datum/random_event/major/antagonist))
			return

		src.respawn_lock = 1

		// 1: alert | 2: alert (chatbox) | 3: alert acknowledged (chatbox) | 4: no longer eligible (chatbox) | 5: waited too long (chatbox)
		var/list/text_messages = list()
		text_messages.Add("Would you like to respawn as a random event antagonist? Your name will be added to the list of eligible candidates and may be selected at random by the game.") // Don't disclose which type it is. You know, metagaming.
		text_messages.Add("You are eligible to be respawned as a random event antagonist. You have [src.ghost_confirmation_delay / 10] seconds to respond to the offer.")
		text_messages.Add("You have been added to the list of eligible candidates. The game will pick a player soon. Good luck!")

		// The proc takes care of all the necessary work (job-banned etc checks, confirmation delay).
		message_admins("Sending offer to eligible ghosts. They have [src.ghost_confirmation_delay / 10] seconds to respond.")
		var/list/datum/mind/candidates = dead_player_list(1, src.ghost_confirmation_delay, text_messages)

		if (!islist(candidates) || candidates.len <= 0)
			message_admins("Couldn't set up alien invasion ([src.antagonist_type]); no eligible candidates found. Source: [source ? "[source]" : "random"]")
			logTheThing("admin", null, null, "Couldn't set up alien invasion ([src.antagonist_type]); no eligible candidates found. Source: [source ? "[source]" : "random"]")
			src.post_event()
			return

		// Check against player preferences.
		var/attempts = 0
		var/datum/mind/lucky_dude = null

		while (attempts < 4 && !(lucky_dude && istype(lucky_dude) && lucky_dude.current))
			lucky_dude = pick(candidates)
			attempts++
			if (lucky_dude.current.client.preferences)
				var/datum/preferences/P = lucky_dude.current.client.preferences
				switch (src.antagonist_type)
					if ("Blob")
						if (!P.be_blob)
							lucky_dude = null
					if ("Wraith")
						if (!P.be_wraith)
							lucky_dude = null
					if ("Wizard")
						if (!P.be_wizard)
							lucky_dude = null
					if ("Werewolf")
						if (!P.be_misc)
							lucky_dude = null
					if ("Predator")
						if (!P.be_misc)
							lucky_dude = null
			else
				lucky_dude = null

		if (!(lucky_dude && istype(lucky_dude) && lucky_dude.current))
			message_admins("Couldn't set up alien invasion ([src.antagonist_type]); candidate selection failed. Source: [source ? "[source]" : "random"]")
			logTheThing("admin", null, null, "Couldn't set up alien invasion ([src.antagonist_type]); candidate selection failed. Source: [source ? "[source]" : "random"]")
			src.post_event()
			return

		// Respawn and assign role.
		var/mob/M3
		if (!M3)
			M3 = lucky_dude.current
		else
			if (src.respawn_lock != 1) // Respawn might be in progress still.
				src.post_event()
			return

		// Shouldn't happen, will happen.
		if (lucky_dude.special_role)
			if (lucky_dude in ticker.mode.traitors)
				ticker.mode.traitors.Remove(lucky_dude)
			if (lucky_dude in ticker.mode.Agimmicks)
				ticker.mode.Agimmicks.Remove(lucky_dude)
			if (!lucky_dude.former_antagonist_roles.Find(lucky_dude.special_role))
				lucky_dude.former_antagonist_roles.Add(lucky_dude.special_role)
			if (!(lucky_dude in ticker.mode.former_antagonists))
				ticker.mode.former_antagonists.Add(lucky_dude)

		var/role = null
		var/objective_path = null
		var/send_to = 1 // 1: arrival shuttle | 2: wizard shuttle
		var/ASLoc = latejoin.len ? pick(latejoin) : null
		var/WSLoc = wizardstart.len ? pick(wizardstart) : null
		var/failed = 0

		switch (src.antagonist_type)
			if ("Blob")
				var/mob/living/intangible/blob_overmind/B = M3.make_blob()
				if (B && istype(B))
					M3 = B
					role = "blob"
					objective_path = /datum/objective_set/blob

					spawn(0)
						var/newname = input(B, "You are a Blob. Please choose a name for yourself, it will show in the form: <name> the Blob", "Name change") as text
						if (B && newname)
							if (length(newname) >= 26) newname = copytext(newname, 1, 26)
							newname = replacetext(newname, ">", "'") + " the Blob"
							B.real_name = newname
							B.name = newname

				else
					failed = 1

			if ("Wraith")
				var/mob/wraith/W = M3.make_wraith()
				if (W && istype(W))
					M3 = W
					role = "wraith"
					generate_wraith_objectives(lucky_dude)
				else
					failed = 1

			if ("Wizard")
				var/mob/living/carbon/human/R = M3.humanize()
				if (R && istype(R))
					M3 = R
					R.unequip_all(1)
					equip_wizard(R)
					send_to = 2
					role = "wizard"
					objective_path = pick(typesof(/datum/objective_set/traitor/easy))

					spawn (0)
						if (R.gender && R.gender == "female")
							R.real_name = pick(wiz_female)
						else
							R.real_name = pick(wiz_male)
						R.choose_name(3, "wizard")

				else
					failed = 1

			if ("Werewolf")
				var/mob/living/R2 = M3.humanize()
				if (R2 && istype(R2))
					M3 = R2
					R2.make_werewolf()
					role = "werewolf"
					objective_path = /datum/objective_set/werewolf
				else
					failed = 1

			if ("Predator")
				var/mob/living/R3 = M3.humanize()
				if (R3 && istype(R3))
					M3 = R3
					R3.make_predator()
					role = "predator"
					objective_path = /datum/objective_set/predator
				else
					failed = 1
			else
				failed = 1

		if (!ASLoc && !WSLoc)
			failed = 1

		if (failed != 0)
			message_admins("Couldn't set up alien invasion ([src.antagonist_type]); respawn failed. Source: [source ? "[source]" : "random"]")
			logTheThing("admin", null, null, "Couldn't set up alien invasion ([src.antagonist_type]); respawn failed. Source: [source ? "[source]" : "random"]")
			src.post_event()
			return

		lucky_dude.assigned_role = "MODE"
		lucky_dude.special_role = role
		lucky_dude.random_event_special_role = 1
		lucky_dude.dnr = 1
		if (!(lucky_dude in ticker.mode.Agimmicks))
			ticker.mode.Agimmicks.Add(lucky_dude)
		M3.antagonist_overlay_refresh(1, 0)

		if (!isnull(objective_path))
			if (ispath(objective_path, /datum/objective_set))
				new objective_path(lucky_dude)
			else if (ispath(objective_path, /datum/objective))
				ticker.mode.bestow_objective(lucky_dude, objective_path)

		var/i = 1
		for (var/datum/objective/Obj in lucky_dude.objectives)
			if (istype(Obj, /datum/objective/crew) || istype(Obj, /datum/objective/miscreant))
				continue
			boutput(M3, "<b>Objective #[i]</b>: [Obj.explanation_text]")
			i++

		switch (send_to)
			if (1)
				M3.set_loc(ASLoc)
			if (2)
				if (!WSLoc)
					M3.set_loc(ASLoc)
				else
					M3.set_loc(WSLoc)

		if (src.centcom_headline && src.centcom_message && random_events.announce_events)
			spawn (src.message_delay)
				command_alert("[src.centcom_message]", "[src.centcom_headline]")

		if (lucky_dude.current)
			lucky_dude.current.show_text("<h3>You have been respawned as a random event [src.antagonist_type].</h3>", "blue")
		message_admins("[lucky_dude.key] respawned as a random event [src.antagonist_type]. Source: [source ? "[source]" : "random"]")
		logTheThing("admin", lucky_dude.current, null, "respawned as a random event [src.antagonist_type]. Source: [source ? "[source]" : "random"]")
		src.post_event()
		return

	// Restore defaults.
	proc/post_event()
		if (!src || !istype(src, /datum/random_event/major/antagonist))
			return

		src.antagonist_type = initial(src.antagonist_type)
		src.respawn_lock = initial(src.respawn_lock)
		src.message_delay = initial(src.message_delay)
		src.admin_override = initial(src.admin_override)

		return