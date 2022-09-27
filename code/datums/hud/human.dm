
/datum/hud/human
	var/obj/screen/hud
		invtoggle
		belt
		storage1
		storage2
		id
		lhand
		rhand
		throwing
		intent
		mintent
		resist
		pulling
		resting

		health
		health_brute
		health_burn
		health_tox
		health_oxy
		bleeding
		stamina
		bodytemp
		oxygen
		fire
		toxin
		rad
		ability_toggle
	var/list/obj/screen/hud/inventory_bg = list()
	var/list/obj/item/inventory_items = list()
	var/show_inventory = 1
	var/current_ability_set = 1
	var/icon/icon_hud = 'icons/mob/hud_human_new.dmi'

	var/mob/living/carbon/human/master

	New(M)
		master = M

		spawn(0)
			var/icon/hud_style = hud_style_selection[get_hud_style(master)]
			if (isicon(hud_style))
				src.icon_hud = hud_style

			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_bg", "CENTER-5, SOUTH to CENTER+6, SOUTH", HUD_LAYER)
			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-5, SOUTH+1 to CENTER+6, SOUTH+1", HUD_LAYER, SOUTH)
			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-6, SOUTH+1", HUD_LAYER, SOUTHWEST)
			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER-6, SOUTH", HUD_LAYER, EAST)
			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+7, SOUTH+1", HUD_LAYER, SOUTHEAST)
			create_screen("", "", 'icons/mob/hud_common.dmi', "hotbar_side", "CENTER+7, SOUTH", HUD_LAYER, WEST)

			invtoggle = create_screen("invtoggle", "toggle inventory", src.icon_hud, "invtoggle", "CENTER-5, SOUTH", HUD_LAYER+1)
			belt = create_screen("belt", "belt", src.icon_hud, "belt", ui_belt, HUD_LAYER+1)
			storage1 = create_screen("storage1", "pocket", src.icon_hud, "pocket", ui_storage1, HUD_LAYER+1)
			storage2 = create_screen("storage2", "pocket", src.icon_hud, "pocket", ui_storage2, HUD_LAYER+1)
			id = create_screen("id", "ID", src.icon_hud, "id", ui_id, HUD_LAYER+1)
			lhand = create_screen("lhand", "left hand", src.icon_hud, "handl0", "CENTER, SOUTH", HUD_LAYER+1)
			rhand = create_screen("rhand", "right hand", src.icon_hud, "handr0", "CENTER+1, SOUTH", HUD_LAYER+1)
			throwing = create_screen("throw", "throw mode", src.icon_hud, "throw0", "CENTER+2, SOUTH", HUD_LAYER+1)
			intent = create_screen("intent", "action intent", src.icon_hud, "intent-help", "CENTER+3, SOUTH", HUD_LAYER+1)
			mintent = create_screen("mintent", "movement mode", src.icon_hud, "move-run", "CENTER+5, SOUTH", HUD_LAYER+1)
			resist = create_screen("resist", "resist", src.icon_hud, "resist", "CENTER+5, SOUTH", HUD_LAYER+1)
			pulling = create_screen("pull", "pulling", src.icon_hud, "pull0", "CENTER+6, SOUTH", HUD_LAYER+1)
			resting = create_screen("rest", "resting", src.icon_hud, "rest0", "CENTER+6, SOUTH", HUD_LAYER+1)

			inventory_bg += create_screen("socks", "socks", src.icon_hud, "socks", ui_socks, HUD_LAYER+1)
			inventory_bg += create_screen("underwear", "underwear", src.icon_hud, "underwear", ui_underwear, HUD_LAYER+1)
			inventory_bg += create_screen("shoes", "shoes", src.icon_hud, "shoes", ui_shoes, HUD_LAYER+1)
			inventory_bg += create_screen("gloves", "gloves", src.icon_hud, "gloves", ui_gloves, HUD_LAYER+1)
			inventory_bg += create_screen("back", "back", src.icon_hud, "back", ui_back, HUD_LAYER+1)
			inventory_bg += create_screen("under", "shirt", src.icon_hud, "center", ui_clothing, HUD_LAYER+1)
			inventory_bg += create_screen("bottom", "bottom", src.icon_hud, "bottom", ui_bottom, HUD_LAYER+1)
			inventory_bg += create_screen("suit", "suit", src.icon_hud, "armor", ui_suit, HUD_LAYER+1)
			inventory_bg += create_screen("glasses", "glasses", src.icon_hud, "glasses", ui_glasses, HUD_LAYER+1)
			inventory_bg += create_screen("ears", "ears", src.icon_hud, "ears", ui_ears, HUD_LAYER+1)
			inventory_bg += create_screen("mask", "mask", src.icon_hud, "mask", ui_mask, HUD_LAYER+1)
			inventory_bg += create_screen("head", "head", src.icon_hud, "hair", ui_head, HUD_LAYER+1)

			health = create_screen("health","Health", src.icon_hud, "health0", "EAST, NORTH", HUD_LAYER, tooltipTheme = "healthDam healthDam0")
			health.desc = "You feel fine."

			health_brute = create_screen("mbrute","Brute Damage", src.icon_hud, "blank", "EAST, NORTH", HUD_LAYER, tooltipTheme = "healthDam healthDam0")
			health_burn = create_screen("mburn","Burn Damage", src.icon_hud, "blank", "EAST, NORTH", HUD_LAYER, tooltipTheme = "healthDam healthDam0")
			health_tox = create_screen("mtox","Toxin Damage", src.icon_hud, "blank", "EAST, NORTH", HUD_LAYER, tooltipTheme = "healthDam healthDam0")
			health_oxy = create_screen("moxy","Oxygen Damage", src.icon_hud, "blank", "EAST, NORTH", HUD_LAYER, tooltipTheme = "healthDam healthDam0")

			bleeding = create_screen("bleeding","Bleed Warning", src.icon_hud, "blood0", "EAST, NORTH-1", HUD_LAYER, tooltipTheme = "healthDam healthDam0")
			bleeding.desc = "This indicator warns that you are currently bleeding. You will die if the situation is not remedied."

			stamina = create_screen("stamina","Stamina", src.icon_hud, "stamina", "EAST-1, NORTH", HUD_LAYER, tooltipTheme = "stamina")
			if (master.stamina_bar)
				stamina.desc = master.stamina_bar.getDesc(master)

			bodytemp = create_screen("bodytemp","Temperature", src.icon_hud, "temp0", "EAST-2, NORTH", HUD_LAYER, tooltipTheme = "tempInd tempInd0")
			bodytemp.desc = "The temperature feels fine."

			oxygen = create_screen("oxygen","Suffocation Warning", src.icon_hud, "oxy0", "EAST-3, NORTH", HUD_LAYER, tooltipTheme = "statusOxy")
			oxygen.desc = "This indicator warns that you are currently suffocating. You will take oxygen damage until the situation is remedied."

			fire = create_screen("fire","Fire Warning", src.icon_hud, "fire0", "EAST-4, NORTH", HUD_LAYER, tooltipTheme = "statusFire")
			fire.desc = "This indicator warns that you are either on fire, or too hot. You will take burn damage until the situation is remedied."

			toxin = create_screen("toxin","Toxic Warning",src.icon_hud, "toxin0", "EAST-5, NORTH", HUD_LAYER, tooltipTheme = "statusToxin")
			toxin.desc = "This indicator warns that you are poisoned. You will take toxic damage until the situation is remedied."

			rad = create_screen("rad","Radiation Warning", src.icon_hud, "rad0", "EAST-6, NORTH", HUD_LAYER, tooltipTheme = "statusRad")
			rad.desc = "This indicator warns that you are irradiated. You will take toxic and burn damage until the situation is remedied."

			ability_toggle = create_screen("ability", "Toggle Ability Hotbar", src.icon_hud, "ability-1", "CENTER-6, SOUTH", HUD_LAYER)

			update_hands()
			update_throwing()
			update_intent()
			update_mintent()
			update_pulling()
			update_resting()
			update_indicators()
			update_ability_hotbar()

	clicked(id, mob/user, list/params)
		switch (id)
			if ("invtoggle")
				var/obj/item/I = master.equipped()
				if (I)
					// this doesnt unequip the original item because that'd cause all the items to drop if you swapped your jumpsuit, I expect this to cause problems though
					// ^-- You don't say.
					#define autoequip_slot(slot, var_name) if (master.can_equip(I, master.slot) && !(master.var_name && master.var_name.cant_self_remove)) { master.u_equip(I); var/obj/item/C = master.var_name; if (C) { /*master.u_equip(C);*/ master.var_name = null; master.put_in_hand(C) } master.force_equip(I, master.slot); return }
					autoequip_slot(slot_shoes, shoes)
					autoequip_slot(slot_socks, socks)
					autoequip_slot(slot_underwear, underwear)
					autoequip_slot(slot_gloves, gloves)
					autoequip_slot(slot_wear_id, wear_id)
					autoequip_slot(slot_w_uniform, w_uniform)
					autoequip_slot(slot_wear_suit, wear_suit)
					autoequip_slot(slot_bottom, bottom)
					autoequip_slot(slot_glasses, glasses)
					autoequip_slot(slot_ears, ears)
					autoequip_slot(slot_wear_mask, wear_mask)
					autoequip_slot(slot_head, head)
					autoequip_slot(slot_belt, belt)
					autoequip_slot(slot_back, back)
					#undef autoequip_slot
					return

				show_inventory = !show_inventory
				if (show_inventory)
					for (var/obj/screen/hud/S in inventory_bg)
						src.add_screen(S)
					for (var/obj/O in inventory_items)
						src.add_object(O, HUD_LAYER+2)
				else
					for (var/obj/screen/hud/S in inventory_bg)
						src.remove_screen(S)
					for (var/obj/O in inventory_items)
						src.remove_object(O)

			if ("lhand")
				master.swap_hand(1)

			if ("rhand")
				master.swap_hand(0)

			if ("throw")
				var/icon_y = text2num(params["icon-y"])
				if (icon_y > 16 || master.in_throw_mode)
					master.toggle_throw_mode()
				else
					master.drop_item()

			if ("resist")
				master.resist()

			if ("intent")
				var/icon_x = text2num(params["icon-x"])
				var/icon_y = text2num(params["icon-y"])
				if (icon_x > 16)
					if (icon_y > 16)
						master.a_intent = INTENT_DISARM
					else
						master.a_intent = INTENT_HARM
				else
					if (icon_y > 16)
						master.a_intent = INTENT_HELP
					else
						master.a_intent = INTENT_GRAB
				src.update_intent()

			if ("mintent")
				if (master.m_intent == "run")
					master.m_intent = "walk"
				else
					master.m_intent = "run"
				out(master, "You are now [master.m_intent == "walk" ? "walking" : "running"]")
				src.update_mintent()

			if ("pull")
				master.pulling = null
				src.update_pulling()

			if ("rest")
				if (master.asleep)
					master.asleep = 0
				if(master.ai_active && !master.resting)
					master.show_text("You feel too restless to do that!", "red")
				else
					master.resting = !master.resting
				src.update_resting()

			if ("ability")
				switch(current_ability_set)
					if(1)
						current_ability_set = 2
						boutput(master, "Now viewing genetic powers hotbar.")
					else
						current_ability_set = 1
						boutput(master, "Now viewing standard hotbar.")

				ability_toggle.icon_state = "ability-[current_ability_set]"
				update_ability_hotbar()

			if ("health")
				if (master.stat == 2)
					out(master, "Seems like you've died. Bummer.")
					return
				var/health_state = ((master.health - master.fakeloss) / master.max_health) * 100
				var/class
				switch(health_state)
					if(100 to INFINITY)
						class = ""
					if(80 to 100)
						class = ""
					if(60 to 80)
						class = "alert"
					if(40 to 60)
						class = "alert"
					if(20 to 40)
						class = "alert bold"
					if(0 to 20)
						class = "alert bold"
					else
						class = "alert bold italic"

				out(master, "<span class='[class]'>[health.desc]</span>")

			if ("bodytemp")
				if(master.burning && !master.is_heat_resistant())
					boutput(master, "<span class='alert bold'>[bodytemp.desc]</span>")
					return

				out(master, bodytemp.desc)

			if ("stamina")
				out(master, "<span class='green'>[stamina.desc]</span>")

			if ("oxygen")
				out(master, "<span class='alert'>[oxygen.desc]</span>")

			if ("fire")
				out(master, "<span class='alert'>[fire.desc]</span>")

			if ("toxin")
				out(master, "<span class='alert'>[toxin.desc]</span>")

			if ("rad")
				out(master, "<span class='alert'>[rad.desc]</span>")

			if ("bleeding")
				out(master, "<span class='alert'>[bleeding.desc]</span>")


			#define clicked_slot(name, slot) if (name) { var/obj/item/W = master.get_slot(master.slot); if (W) { master.click(W, params) } else { var/obj/item/I = master.equipped(); if (!I || !master.can_equip(I, master.slot)) return; master.u_equip(I); master.force_equip(I, master.slot) } }
			clicked_slot("belt", slot_belt)
			clicked_slot("storage1", slot_l_store)
			clicked_slot("storage2", slot_r_store)
			clicked_slot("back", slot_back)
			clicked_slot("socks", slot_socks)
			clicked_slot("underwear", slot_underwear)
			clicked_slot("shoes", slot_shoes)
			clicked_slot("gloves", slot_gloves)
			clicked_slot("id", slot_wear_id)
			clicked_slot("under", slot_w_uniform)
			clicked_slot("suit", slot_wear_suit)
			clicked_slot("bottom", slot_bottom)
			clicked_slot("glasses", slot_glasses)
			clicked_slot("ears", slot_ears)
			clicked_slot("mask", slot_wear_mask)
			clicked_slot("head", slot_head)
			#undef clicked_slot

	proc/add_other_object(obj/item/I, loc) // this is stupid but necessary
		inventory_items += I
		if (show_inventory)
			src.add_object(I, HUD_LAYER+2, loc)
		else
			I.screen_loc = loc

	proc/remove_item(obj/item/I)
		inventory_items -= I
		remove_object(I)

	proc/update_hands()
		if (master.limbs && !master.limbs.l_arm)
			lhand.icon_state = "handl[master.hand]d"
		else
			lhand.icon_state = "handl[master.hand]"

		if (master.limbs && !master.limbs.r_arm)
			rhand.icon_state = "handr[!master.hand]d"
		else
			rhand.icon_state = "handr[!master.hand]"

	proc/update_throwing()
		if (!throwing) return 0
		throwing.icon_state = "throw[master.in_throw_mode]"

	proc/update_intent()
		if (!intent) return 0
		intent.icon_state = "intent-[master.a_intent]"

	proc/update_mintent()
		if (!mintent) return 0
		mintent.icon_state = "move-[master.m_intent]"

	proc/update_pulling()
		if (!pulling) return 0
		pulling.icon_state = "pull[!!master.pulling]"

	proc/update_resting()
		if (!resting) return 0
		resting.icon_state = "rest[master.resting]"

	proc/update_ability_hotbar()
		if (!master.client)
			return
		if(master.stat == 2)
			return

		for(var/obj/screen/ability/topBar/genetics/G in master.client.screen)
			master.client.screen -= G
		for(var/obj/screen/pseudo_overlay/PO in master.client.screen)
			master.client.screen -= PO
		for(var/obj/ability_button/B in master.client.screen)
			master.client.screen -= B
		var/pos_x = 1
		var/pos_y = 0

		if (current_ability_set == 1) // items + standard
			for(var/obj/ability_button/B2 in master.item_abilities)
				B2.screen_loc = "NORTH-[pos_y],[pos_x]"
				master.client.screen += B2
				pos_x++
				if(pos_x > 15)
					pos_x = 1
					pos_y++

			if (istype(master.loc,/obj/vehicle/))
				var/obj/vehicle/V = master.loc
				for(var/obj/ability_button/B2 in V.ability_buttons)
					B2.screen_loc = "NORTH-[pos_y],[pos_x]"
					master.client.screen += B2
					pos_x++
					if(pos_x > 15)
						pos_x = 1
						pos_y++

		if (current_ability_set == 2) // genetics
			var/datum/bioEffect/power/P
			for(var/ID in master.bioHolder.effects)
				P = master.bioHolder.GetEffect(ID)
				if (!istype(P, /datum/bioEffect/power/) || !istype(P.ability) || !istype(P.ability.object))
					continue
				var/datum/targetable/geneticsAbility/POWER = P.ability
				var/obj/screen/ability/topBar/genetics/BUTTON = POWER.object
				BUTTON.update_on_hud(pos_x,pos_y)

				pos_x++
				if(pos_x > 15)
					pos_x = 1
					pos_y++

	proc/update_indicators()
		update_health_indicator()
		update_blood_indicator()
		update_temp_indicator()

	proc/update_health_indicator()
		if (!health)
			return

		var/stage = 0
		if (master.mini_health_hud)
			health.icon_state = "blank"
			if (master.stat == 2 || master.fakedead)
				health_brute.icon_state = "mhealth7" // rip
				health_brute.tooltipTheme = "healthDam healthDam7"
				health_brute.name = "Health"
				health_brute.desc = "Seems like you've died. Bummer."
				health_burn.icon_state = "blank"
				health_tox.icon_state = "blank"
				health_oxy.icon_state = "blank"
				return

			var/brutedam = master.get_brute_damage()
			var/burndam = master.get_burn_damage()
			var/toxdam = master.get_toxin_damage()
			var/oxydam = master.get_oxygen_deprivation()

			switch (brutedam)
				if (-INFINITY to 0) // this goes the other way around from the normal health indicator since it's determined by how much of whatever damage you have
					stage = 0 // bright green
				if (1 to 15)
					stage = 1 // green
				if (16 to 30)
					stage = 2 // yellow
				if (31 to 45)
					stage = 3 // orange
				if (46 to 60)
					stage = 4 // dark orange
				if (61 to 75)
					stage = 5 // red
				if (76 to INFINITY)
					stage = 6 // crit

			health_brute.name = "Brute Damage"
			health_brute.icon_state = "mbrute[stage]"
			health_brute.tooltipTheme = "healthDam healthDam[stage]"

			switch (burndam)
				if (-INFINITY to 0)
					stage = 0 // bright green
				if (1 to 15)
					stage = 1 // green
				if (16 to 30)
					stage = 2 // yellow
				if (31 to 45)
					stage = 3 // orange
				if (46 to 60)
					stage = 4 // dark orange
				if (61 to 75)
					stage = 5 // red
				if (76 to INFINITY)
					stage = 6 // crit

			health_burn.name = "Burn Damage"
			health_burn.icon_state = "mburn[stage]"
			health_burn.tooltipTheme = "healthDam healthDam[stage]"

			switch (toxdam)
				if (-INFINITY to 0)
					stage = 0 // bright green
				if (1 to 15)
					stage = 1 // green
				if (16 to 30)
					stage = 2 // yellow
				if (31 to 45)
					stage = 3 // orange
				if (46 to 60)
					stage = 4 // dark orange
				if (61 to 75)
					stage = 5 // red
				if (76 to INFINITY)
					stage = 6 // crit

			health_tox.name = "Toxin Damage"
			health_tox.icon_state = "mtox[stage]"
			health_tox.tooltipTheme = "healthDam healthDam[stage]"

			switch (oxydam)
				if (-INFINITY to 0)
					stage = 0 // bright green
				if (1 to 15)
					stage = 1 // green
				if (16 to 30)
					stage = 2 // yellow
				if (31 to 45)
					stage = 3 // orange
				if (46 to 60)
					stage = 4 // dark orange
				if (61 to 75)
					stage = 5 // red
				if (76 to INFINITY)
					stage = 6 // crit

			health_oxy.name = "Oxygen Damage"
			health_oxy.icon_state = "moxy[stage]"
			health_oxy.tooltipTheme = "healthDam healthDam[stage]"

			// may as well let you see you're being irradiated if you can already see individual things like oxy/tox/burn/brute
			update_rad_indicator(master.radiation ? 1 : 0)

			return

		else
			health_brute.icon_state = "blank"
			health_burn.icon_state = "blank"
			health_tox.icon_state = "blank"
			health_oxy.icon_state = "blank"
			update_rad_indicator(0)

			if (master.stat == 2 || master.fakedead)
				health.icon_state = "health7" // dead
				health.tooltipTheme = "healthDam healthDam7"
				health.desc = "Seems like you've died. Bummer."
				return

			var/health_state = ((master.health - master.fakeloss) / master.max_health) * 100
			switch(health_state)
				if(100 to INFINITY)
					stage = 0 // green with green marker
					health.desc = "You feel fine."
				if(80 to 100)
					stage = 1 // green
					health.desc = "You feel a little dinged up, but you're doing okay."
				if(60 to 80)
					stage = 2 // yellow
					health.desc = "You feel a bit hurt. Seeking medical attention couldn't hurt."
				if(40 to 60)
					stage = 3 // orange
					health.desc = "You feel pretty bad. You should seek medical attention."
				if(20 to 40)
					stage = 4 // dark orange
					health.desc = "You feel horrible! You need medical attention as soon as possible."
				if(0 to 20)
					stage = 5 // red
					health.desc = "You feel like you're on death's door... you need help <em>now!</em>"
				else
					stage = 6 // crit
					health.desc = "You're pretty sure you're dying!"

			health.icon_state = "health[stage]"
			health.tooltipTheme = "healthDam healthDam[stage]"

	proc/update_blood_indicator()
		if (!bleeding || master.stat == 2)
			bleeding.icon_state = "blood0"
			bleeding.tooltipTheme = "healthDam healthDam0"
			return

		var/state = 0
		var/theme = 0
		switch (master.bleeding)
			if (-INFINITY to 0)
				state = 0 // blank
				theme = 0
			if (1 to 3)
				state = 1
				theme = 3
			if (4 to 6)
				state = 2
				theme = 4
			if (7 to INFINITY)
				state = 3
				theme = 6

		bleeding.icon_state = "blood[state]"
		bleeding.tooltipTheme = "healthDam healthDam[theme]"

	proc/update_temp_indicator()
		if (!bodytemp)
			return
		if(master.burning && !master.is_heat_resistant())
			bodytemp.icon_state = "tempF" // on fire
			bodytemp.tooltipTheme = "tempInd tempIndF"
			bodytemp.desc = "OH FUCK FIRE FIRE FIRE OH GOD FIRE AAAAAAA"
			return

		var/dev = master.get_temp_deviation()
		var/state
		switch(dev)
			if(4)
				state = 4 // burning up
				bodytemp.desc = "It's scorching hot!"
			if(3)
				state = 3 // far too hot
				bodytemp.desc = "It's too hot."
			if(2)
				state = 2 // too hot
				bodytemp.desc = "It's a bit warm, but nothing to worry about."
			if(1)
				state = 1 // warm but safe
				bodytemp.desc = "It feels a little warm."
			if(-1)
				state = -1 // cool but safe
				bodytemp.desc = "It feels a little cool."
			if(-2)
				state = -2 // too cold
				bodytemp.desc = "It's a little cold, but nothing to worry about."
			if(-3)
				state = -3 // far too cold
				bodytemp.desc = "It's too cold."
			if(-4)
				state = -4 // freezing
				bodytemp.desc = "It's absolutley freezing!"
			else
				state = 0 // 310 is optimal body temp
				bodytemp.desc = "The temperature feels fine."

		bodytemp.icon_state = "temp[state]"
		bodytemp.tooltipTheme = "tempInd tempInd[state]"

	proc/update_tox_indicator(var/status)
		if (!toxin)
			return
		toxin.icon_state = "tox[status]"

	proc/update_oxy_indicator(var/status)
		if (!oxygen)
			return
		oxygen.icon_state = "oxy[status]"

	proc/update_fire_indicator(var/status)
		if (!fire)
			return
		fire.icon_state = "fire[status]"

	proc/update_rad_indicator(var/status)
		if (!rad) // not rad :'(
			return
		rad.icon_state = "rad[status]"

	proc/change_hud_style(var/icon/new_file)
		if (new_file)
			src.icon_hud = new_file

			if (invtoggle) invtoggle.icon = new_file
			if (belt) belt.icon = new_file
			if (storage1) storage1.icon = new_file
			if (storage2) storage2.icon = new_file
			if (id) id.icon = new_file
			if (lhand) lhand.icon = new_file
			if (rhand) rhand.icon = new_file
			if (throwing) throwing.icon = new_file
			if (intent) intent.icon = new_file
			if (mintent) mintent.icon = new_file
			if (resist) resist.icon = new_file
			if (pulling) pulling.icon = new_file
			if (resting) resting.icon = new_file

			if (health) health.icon = new_file
			if (bleeding) bleeding.icon = new_file
			if (stamina) stamina.icon = new_file
			if (bodytemp) bodytemp.icon = new_file
			if (oxygen) oxygen.icon = new_file
			if (fire) fire.icon = new_file
			if (toxin) toxin.icon = new_file
			if (rad) rad.icon = new_file
			if (ability_toggle) ability_toggle.icon = new_file

			if (health_brute) health_brute.icon = new_file
			if (health_burn) health_burn.icon = new_file
			if (health_tox) health_tox.icon = new_file
			if (health_oxy) health_oxy.icon = new_file

			for (var/obj/screen/hud/H in inventory_bg)
				H.icon = new_file

			if (master.stamina_bar)
				master.stamina_bar.icon = new_file
