
/mob/living/proc/become_gold_statue() // taken form machoman.dm
	var/obj/overlay/goldman = new /obj/overlay(get_turf(src))
	src.pixel_x = 0
	src.pixel_y = 0
	src.set_loc(goldman)
	goldman.name = "golden statue of [src.name]"
	goldman.desc = src.desc
	goldman.anchored = 0
	goldman.density = 1
	goldman.layer = MOB_LAYER
	goldman.dir = src.dir

	var/ist = "body_f"
	if (src.gender == "male")
		ist = "body_m"
	var/icon/composite = icon('icons/mob/human.dmi', ist, null, 1)
	for (var/O in src.overlays)
		var/image/I = O
		composite.Blend(icon(I.icon, I.icon_state, null, 1), ICON_OVERLAY)
	composite.ColorTone( rgb(255,215,0) ) // gold
	goldman.icon = composite
	src.take_toxin_damage(9999)
	src.ghostize()

/obj/artifact/wish_granter
	name = "artifact wish granter"
	associated_datum = /datum/artifact/wish_granter

/datum/artifact/wish_granter
	associated_object = /obj/artifact/wish_granter
	rarity_class = 4
	validtypes = list("wizard","eldritch")
	validtriggers = list(/datum/artifact_trigger/force,/datum/artifact_trigger/electric,/datum/artifact_trigger/heat,
	/datum/artifact_trigger/radiation,/datum/artifact_trigger/cold)
	activ_text = "begins glowing with an enticing light!"
	deact_text = "falls dark and quiet."
	react_xray = list(666,666,666,11,"NONE")
	var/list/wish_granted = list()
	var/evil = 0

	New()
		..()
		if (prob(50))
			evil = 1

	effect_touch(var/obj/O,var/mob/living/user)
		if (..())
			return
		if (!istype(user,/mob/living/))
			return
		if (user.key in wish_granted)
			boutput(user, "<b>[O]</b> is silent.")
			return
		boutput(user, "<b>[O]</b> resonates, \"<big>I SHALL GRANT YOU ONE WISH...</big>\"")

		var/list/wishes = list("I wish to become rich!","I wish for great power!")

		var/wish = input("Make a wish?","[O]") as null|anything in wishes
		if (!wish)
			boutput(user, "You say nothing.")
			boutput(user, "<b>[O]</b> resonates, \"<big>YOU MAY RETURN LATER...</big>\"")
			return

		wish_granted += user.key
		user.say(wish)
		sleep(5)
		boutput(user, "<b>[O]</b> resonates, \"<big>SO BE IT...</big>\"")
		playsound(O, "sound/effects/gong_rumble.ogg", 40, 1)
		O.visible_message("<span style=\"color:red\"><b>[O]</b> begins to charge up...</span>")
		sleep(30)
		if (prob(2))
			evil = !evil

		if (evil)
			switch(wish)
				if("I wish to become rich!")
					O.visible_message("<span style=\"color:red\"><b>[O]</b> envelops [user] in a golden light!</span>")
					playsound(user, "sound/weapons/flashbang.ogg", 50, 1)
					for(var/mob/N in viewers(user, null))
						N.flash(30)
						if(N.client)
							shake_camera(N, 6, 4)
					user.desc = "A statue of someone very wealthy"
					user.become_gold_statue()

				if("I wish for great power!")
					O.visible_message("<span style=\"color:red\"><b>[O] discharges a massive bolt of electricity!</b></span>")
					playsound(user, "sound/effects/elec_bigzap.ogg", 40, 1)
					var/list/affected = DrawLine(O,user,/obj/line_obj/elec,'icons/obj/projectiles.dmi',"WholeLghtn",1,1,"HalfStartLghtn","HalfEndLghtn",OBJ_LAYER,1,PreloadedIcon='icons/effects/LghtLine.dmi')
					for(var/obj/OB in affected)
						spawn(6)
							pool(OB)
					user.elecgib()
		else
			switch(wish)
				if("I wish to become rich!")
					O.visible_message("<span style=\"color:red\">A ton of money falls out of thin air! Woah!</span>")
					for(var/turf/T in range(user,3))
						if (T.density)
							continue
						new /obj/item/spacecash/million(T)

				if("I wish for great power!")
					O.visible_message("<span style=\"color:red\"><b>[O]</b> envelops [user] in a brilliant light!</span>")
					if (ishuman(user))
						var/mob/living/carbon/human/H = user
						if (H.bioHolder)
							H.bioHolder.RandomEffect("good")
							H.bioHolder.RandomEffect("good")
							H.bioHolder.RandomEffect("good")
					else if (istype(user,/mob/living/silicon/robot))
						var/mob/living/silicon/robot/R = user
						if (istype(R.cell))
							R.cell.genrate = 100
							R.cell.maxcharge = 1000000
							R.cell.charge = R.cell.maxcharge