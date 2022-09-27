/obj/fitness/speedbag
	name = "punching bag"
	desc = "A punching bag. Can you get to speed level 4???"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "punchingbag"
	anchored = 1
	layer = MOB_LAYER_BASE+1 // TODO LAYER
	var/list/hit_sounds = list('sound/weapons/genhit1.ogg', 'sound/weapons/genhit2.ogg', 'sound/weapons/genhit3.ogg',\
	'sound/weapons/punch1.ogg', 'sound/weapons/punch2.ogg', 'sound/weapons/punch3.ogg', 'sound/weapons/punch4.ogg')

	attack_hand(mob/user as mob)
		flick("[icon_state]2", src)
		playsound(src.loc, pick(src.hit_sounds), 25, 1, -1)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 2)
		if(hascall(user, "add_stam_mod_regen"))
			if(user:add_stam_mod_regen("fitness_bag", 1) )
				spawn(9000)
					if (user) //Wire: Fix for Cannot execute null.remove stam mod regen().
						user:remove_stam_mod_regen("fitness_bag")

	wizard
		icon_state = "punchingbagwizard"
		desc = "It has a picture of a weird wizard on it."

	syndie
		icon_state = "punchingbagsyndie"
		desc = "It has a picture of a mean ol' syndicate on it."

	captain
		icon_state = "punchingbagcaptain"
		desc = "It has a picture of a dumb looking station captain on it."

	clown
		name = "clown bop bag"
		desc = "A bop bag in the shape of a goofy clown."
		icon_state = "bopbag"

		attack_hand(mob/user as mob)
			flick("[icon_state]2", src)
			if (narrator_mode)
				playsound(src.loc, 'sound/vox/hit.ogg', 25, 1, -1)
				playsound(src.loc, 'sound/vox/honk.ogg', 50, 1, -1)
			else
				playsound(src.loc, pick(src.hit_sounds), 25, 1, -1)
				playsound(src.loc, 'sound/items/bikehorn.ogg', 50, 1, -1)

/obj/fitness/stacklifter
	name = "Weight Machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "fitnesslifter"
	density = 1
	anchored = 1
	var/in_use = 0

	attack_hand(mob/user as mob)
		if(in_use)
			boutput(user, "<span style=\"color:red\">Its already in use - wait a bit.</span>")
			return
		else
			in_use = 1
			icon_state = "fitnesslifter2"
			user.transforming = 1
			user.dir = SOUTH
			user.set_loc(src.loc)
			var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
			usr.visible_message(text("<span style=\"color:red\"><B>[usr] is [bragmessage]!</B></span>"))
			var/lifts = 0
			while (lifts++ < 6)
				if (user.loc != src.loc)
					break
				sleep(3)
				user.pixel_y = -2
				sleep(3)
				user.pixel_y = -4
				sleep(3)
				playsound(user, 'sound/effects/spring.ogg', 60, 1)

			playsound(user, 'sound/machines/click.ogg', 60, 1)
			in_use = 0
			user.transforming = 0
			user.pixel_y = 0
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				if (H.sims)
					H.sims.affectMotive("fun", 4)
			var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
			icon_state = "fitnesslifter"
			boutput(user, "<span style=\"color:orange\">[finishmessage]</span>")
			if(hascall(user, "add_stam_mod_regen"))
				if(user:add_stam_mod_regen("fitness_stack", 1) )
					spawn(9000)
						if (user) //Wire: Fix for Cannot execute null.remove stam mod regen().
							user:remove_stam_mod_regen("fitness_stack")

/obj/fitness/weightlifter
	name = "Weight Machine"
	desc = "Just looking at this thing makes you feel tired."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "fitnessweight"
	density = 1
	anchored = 1
	var/in_use = 0

	attack_hand(mob/user as mob)
		if(in_use)
			boutput(user, "<span style=\"color:red\">Its already in use - wait a bit.</span>")
			return
		else
			in_use = 1
			icon_state = "fitnessweight-c"
			user.transforming = 1
			user.dir = SOUTH
			user.set_loc(src.loc)
			var/obj/decal/W = new /obj/decal/
			W.icon = 'icons/obj/stationobjs.dmi'
			W.icon_state = "fitnessweight-w"
			W.loc = loc
			W.anchored = 1
			W.layer = MOB_LAYER_BASE+1
			var/bragmessage = pick("pushing it to the limit","going into overdrive","burning with determination","rising up to the challenge", "getting strong now","getting ripped")
			usr.visible_message(text("<span style=\"color:red\"><B>[usr] is [bragmessage]!</B></span>"))
			var/reps = 0
			user.pixel_y = 5
			while (reps++ < 6)
				if (user.loc != src.loc)
					break

				for (var/innerReps = max(reps, 1), innerReps > 0, innerReps--)
					sleep(3)
					user.pixel_y = (user.pixel_y == 3) ? 5 : 3

				playsound(user, 'sound/effects/spring.ogg', 60, 1)

			sleep(3)
			user.pixel_y = 2
			sleep(3)
			playsound(user, 'sound/machines/click.ogg', 60, 1)
			in_use = 0
			user.transforming = 0
			user.pixel_y = 0
			if (ishuman(user))
				var/mob/living/carbon/human/H = user
				if (H.sims)
					H.sims.affectMotive("fun", 4)
			var/finishmessage = pick("You feel stronger!","You feel like you can take on the world!","You feel robust!","You feel indestructible!")
			icon_state = "fitnessweight"
			qdel(W)
			boutput(user, "<span style=\"color:orange\">[finishmessage]</span>")
			if(hascall(user, "add_stam_mod_max"))
				if(user:add_stam_mod_max("fitness_weight", 10) )
					spawn(9000)
						if (user) //Wire: Fix for Cannot execute null.remove stam mod regen().
							user:remove_stam_mod_max("fitness_weight")

/obj/item/rubberduck
	name = "Rubber Duck"
	desc = "Awww, it squeaks!"
	icon = 'icons/obj/items.dmi'
	icon_state = "rubber_duck"
	item_state = "sponge"
	throwforce = 1
	w_class = 1.0
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0

/obj/item/rubberduck/attack_self(mob/user as mob)
	if (spam_flag == 0)
		if (ishuman(user))
			var/mob/living/carbon/human/H = user
			if (H.sims)
				H.sims.affectMotive("fun", 1)
		spam_flag = 1
		if (narrator_mode)
			playsound(src.loc, 'sound/vox/duct.ogg', 50, 1)
		else
			playsound(src.loc, 'sound/items/rubberduck.ogg', 50, 1)
		if(prob(1))
			user.drop_item()
			playsound(src.loc, 'sound/ambience/lavamoon_strange_fx1.ogg', 50, 1) // this is gonna spook some people!!
			var/wacka = 0
			while (wacka++ < 50)
				sleep(2)
				pixel_x = rand(-6,6)
				pixel_y = rand(-6,6)
				sleep(1)
				pixel_y = 0
				pixel_x = 0
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return
