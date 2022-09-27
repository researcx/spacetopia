/*
CONTAINS:
BANANA PEEL
BIKE HORN
HARMONICA
VUVUZELA

*/

/obj/item/bananapeel
	name = "Banana Peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = 1.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	stamina_damage = 5
	stamina_cost = 5
	stamina_crit_chance = 5
	var/mob/living/carbon/human/last_touched

/obj/item/bananapeel/attack_hand(var/mob/user)
	last_touched = user
	..()

/obj/item/bananapeel/HasEntered(AM as mob|obj)
	if(istype(src.loc, /turf/space))
		return
	if (iscarbon(AM))
		var/mob/M =	AM
		if (!M.can_slip())
			return
		M.pulling = null
		boutput(M, "<span style=\"color:orange\">You slipped on the banana peel!</span>")
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (H.sims)
				H.sims.affectMotive("fun", -10)
				if (H == last_touched)
					H.sims.affectMotive("fun", -10)
		if (istype(last_touched) && (last_touched in viewers(src)) && last_touched != M)
			if (last_touched.sims)
				last_touched.sims.affectMotive("fun", 10)
		playsound(src.loc, "sound/misc/slip.ogg", 50, 1, -3)
		if(M.bioHolder.HasEffect("clumsy"))
			M.stunned = 8
			M.weakened = 5
		else
			M.weakened = 2

/obj/item/bikehorn
	name = "Bike Horn"
	desc = "A horn off of a bicycle."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "bike_horn"
	item_state = "bike_horn"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0
	var/sound_horn = 'sound/items/bikehorn.ogg'
	stamina_damage = 5
	stamina_cost = 5
	var/volume = 50
	var/randomized_pitch = 1
	var/spam_timer = 20

	dramatic
		name = "Dramatic Bike Horn"
		desc = "SHIT FUCKING PISS COCK IT'S SO RAW"
		sound_horn = 'sound/effects/dramatic.ogg'
		volume = 100
		randomized_pitch = 0
		spam_timer = 30
		mats = 2

/obj/item/bikehorn/attackby(obj/item/W as obj, mob/user as mob)
	if (!istype(W, /obj/item/parts/robot_parts/arm/))
		..()
		return
	else
		var/obj/machinery/bot/duckbot/D = new /obj/machinery/bot/duckbot
		var/icon/new_icon = icon('icons/obj/aibots.dmi', "duckbot")
		D.icon = new_icon
		D.eggs = rand(2,5) // LAY EGG IS TRUE!!!
		boutput(user, "<span style=\"color:orange\">You add the arm to the horn.</span>")
		D.set_loc(get_turf(user))
		qdel(W)
		qdel(src)

/obj/item/bikehorn/dramatic/attackby(obj/item/W as obj, mob/user as mob)
	if (!istype(W, /obj/item/parts/robot_parts/arm/))
		..()
		return
	else
		var/obj/machinery/bot/chefbot/D = new /obj/machinery/bot/chefbot
		//var/icon/new_icon = icon('icons/obj/aibots.dmi', "duckbot")
		boutput(user, "<span style=\"color:orange\">You add the arm to the horn.</span>")
		D.set_loc(get_turf(user))
		qdel(W)
		qdel(src)

/obj/item/bikehorn/attack_self(mob/user as mob)
	if (spam_flag == 0)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		spam_flag = 1
		if (narrator_mode)
			src.sound_horn = 'sound/vox/honk.ogg'
		playsound(get_turf(src), sound_horn, volume, randomized_pitch)
		src.add_fingerprint(user)
		spawn(spam_timer)
			spam_flag = 0
	return

/obj/item/bikehorn/is_detonator_attachment()
	return 1

/obj/item/bikehorn/detonator_act(event, var/obj/item/assembly/detonator/det)
	switch (event)
		if ("pulse")
			playsound(det.attachedTo.loc, 'sound/items/bikehorn.ogg', 50, 1)
		if ("cut")
			det.attachedTo.visible_message("<span class='bold' style='color: #B7410E;'>The honking stops.</span>")
			det.attachments.Remove(src)
		if ("process")
			var/times = rand(1,5)
			for (var/i = 1, i <= times, i++)
				spawn(4*i)
					playsound(det.attachedTo.loc, 'sound/items/bikehorn.ogg', 50, 1)
		if ("prime")
			for (var/i = 1, i < 15, i++)
				spawn(3*i)
					playsound(det.attachedTo.loc, 'sound/items/bikehorn.ogg', 500, 1)


/obj/item/harmonica
	name = "harmonica"
	desc = "A cheap pocket instrument, good for helping time to pass."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "harmonica"
	item_state = "r_shoes"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0
	var/list/sounds_harmonica = list('sound/items/harmonica1.ogg', 'sound/items/harmonica2.ogg', 'sound/items/harmonica3.ogg')
	stamina_damage = 2
	stamina_cost = 2

/obj/item/harmonica/attack_self(mob/user as mob)
	if (spam_flag == 0)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		spam_flag = 1
		user.visible_message("<B>[user]</B> plays a [pick("delightful", "chilling", "upbeat")] tune with \his harmonica!")
		playsound(src.loc, pick(src.sounds_harmonica), 50, 1)
		for(var/obj/critter/dog/george/G in range(user,6))
			if(prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/whistle
	name = "whistle"
	desc = "A whistle. Good for getting attention."
	icon = 'icons/obj/instruments.dmi'
	icon_state = "whistle"
	item_state = "r_shoes"
	throwforce = 3
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0
	var/sound_whistle = list('sound/items/whistle.ogg')
	stamina_damage = 2
	stamina_cost = 2

/obj/item/whistle/attack_self(mob/user as mob)
	if (spam_flag == 0)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		spam_flag = 1
		user.visible_message("<span style=\"color:red\"><B>[user]</B> blows [src]!</span>")
		playsound(src.loc, src.sound_whistle, 35, 1)
		for(var/obj/critter/dog/george/G in range(user,6))
			if(prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/whistle/suicide(var/mob/user as mob)
	user.visible_message("<span style=\"color:red\"><b>[user] swallows the [src.name]. \He begins to choke, the [src.name] sounding shrilly!</b></span>")
	user.take_oxygen_deprivation(175)
	user.updatehealth()

	//fuck it that'll do
	var/whistlesound = src.sound_whistle //so we can still use it when the whistle is deleted
	playsound(user.loc, whistlesound, 35, 1)
	spawn(20)
		if(prob(50))
			playsound(user.loc, whistlesound, 35, 1)
	spawn(40)
		if(prob(50))
			playsound(user.loc, whistlesound, 35, 1)
	spawn(60)
		if(prob(50))
			playsound(user.loc, whistlesound, 35, 1)
	spawn(80)
		if(prob(50))
			playsound(user.loc, whistlesound, 35, 1)
	spawn(100)
		if(prob(50))
			playsound(user.loc, whistlesound, 35, 1)
		if (user)
			user.suiciding = 0
	qdel(src)
	return 1

/obj/item/vuvuzela
	name = "vuvuzela"
	desc = "A loud horn made popular at soccer games-BZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
	icon = 'icons/obj/instruments.dmi'
	icon_state = "vuvuzela"
	item_state = "bike_horn"
	throwforce = 3
	var/spam_flag = 0
	var/sound_vuvuzela = 'sound/items/vuvuzela.ogg'
	stamina_damage = 6
	stamina_cost = 6
	stamina_crit_chance = 1

/obj/item/vuvuzela/attack_self(mob/user as mob)
	if (spam_flag == 0)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 5)
		spam_flag = 1
		for (var/mob/M in hearers(user, null))
			var/ED = max(0, rand(0, 2) - get_dist(user, M))
			M.take_ear_damage(ED)
			boutput(M, text("<FONT size=[] color='red'>BZZZZZZZZZZZZZZZZZZZ!</FONT>", max(0, ED)))
		playsound(src.loc, src.sound_vuvuzela, 80, 1)
		for(var/obj/critter/dog/george/G in range(user,6))
			if(prob(60))
				G.howl()
		src.add_fingerprint(user)
		spawn(35)
			spam_flag = 0
	return

/obj/item/vuvuzela/is_detonator_attachment()
	return 1

/obj/item/vuvuzela/detonator_act(event, var/obj/item/assembly/detonator/det)
	switch (event)
		if ("pulse")
			playsound(det.attachedTo.loc, "sound/items/vuvuzela.ogg", 50, 1)
		if ("cut")
			det.attachedTo.visible_message("<span class='bold' style='color: #B7410E;'>The buzzing stops.</span>")
			det.attachments.Remove(src)
		if ("process")
			if (prob(45))
				var/times = rand(1,5)
				for (var/i = 1, i <= times, i++)
					spawn(4*i)
						playsound(det.attachedTo.loc, "sound/items/vuvuzela.ogg", 50, 1)
		if ("prime")
			for (var/i = 1, i < 15, i++)
				spawn(4*i)
					playsound(det.attachedTo.loc, "sound/items/vuvuzela.ogg", 500, 1)