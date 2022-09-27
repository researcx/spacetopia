
/* ==================================================== */
/* -------------------- Dispensers -------------------- */
/* ==================================================== */

/obj/reagent_dispensers
	name = "Dispenser"
	desc = "..."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	density = 1
	anchored = 0
	flags = FPRINT
	pressure_resistance = 2*ONE_ATMOSPHERE

	var/amount_per_transfer_from_this = 10

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/cargotele))
			W:cargoteleport(src, user)
		return

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(4000)
		reagents = R
		R.my_atom = src


	get_desc(dist, mob/user)
		if (dist <= 2 && reagents)
			. += "<br><span style=\"color:orange\">[reagents.get_description(user,RC_SCALE)]</span>"

	proc/smash()
		new /obj/effects/water(src.loc)
		qdel(src)

	ex_act(severity)
		switch(severity)
			if (1.0)
				qdel(src)
				return
			if (2.0)
				if (prob(50))
					smash()
					return
			if (3.0)
				if (prob(5))
					smash()
					return
			else
		return

	blob_act(var/power)
		if (prob(25))
			smash()

	temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
		..()
		if (reagents)
			for (var/i = 0, i < 9, i++) // ugly hack
				reagents.temperature_reagents(exposed_temperature, exposed_volume)

	MouseDrop(atom/over_object as obj)
		if (!istype(over_object, /obj/item/reagent_containers/glass) && !istype(over_object, /obj/item/reagent_containers/food/drinks) && !istype(over_object, /obj/item/spraybottle) && !istype(over_object, /obj/machinery/plantpot) && !istype(over_object, /obj/mopbucket))
			return ..()

		if (get_dist(usr, src) > 1 || get_dist(usr, over_object) > 1)
			boutput(usr, "<span style=\"color:red\">That's too far!</span>")
			return

		src.transfer_all_reagents(over_object, usr)

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/reagent_dispensers/ants
	name = "space ants"
	desc = "A bunch of space ants."
	icon = 'icons/effects/effects.dmi'
	icon_state = "spaceants"
	layer = MOB_LAYER
	density = 0
	anchored = 1
	amount_per_transfer_from_this = 5

	New()
		..()
		var/scale = (rand(2, 10) / 10) + (rand(0, 5) / 100)
		src.Scale(scale, scale)
		src.dir = pick(NORTH, SOUTH, EAST, WEST)
		reagents.add_reagent("ants",20)

	get_desc(dist, mob/user)
		return null

	attackby(obj/item/W as obj, mob/user as mob)
		..(W, user)
		spawn(10)
			if (src && src.reagents)
				if (src.reagents.total_volume <= 1)
					qdel(src)
		return

/obj/reagent_dispensers/spiders
	name = "spiders"
	desc = "A bunch of spiders."
	icon = 'icons/effects/effects.dmi'
	icon_state = "spaceants"
	layer = MOB_LAYER
	density = 0
	anchored = 1
	amount_per_transfer_from_this = 5
	color = "#160505"

	New()
		..()
		var/scale = (rand(2, 10) / 10) + (rand(0, 5) / 100)
		src.Scale(scale, scale)
		src.dir = pick(NORTH, SOUTH, EAST, WEST)
		src.pixel_x = rand(-8,8)
		src.pixel_y = rand(-8,8)
		reagents.add_reagent("spiders", 5)

	get_desc(dist, mob/user)
		return null

	attackby(obj/item/W as obj, mob/user as mob)
		..(W, user)
		spawn(10)
			if (src && src.reagents)
				if (src.reagents.total_volume <= 1)
					qdel(src)
		return

/obj/reagent_dispensers/foamtank
	name = "foamtank"
	desc = "A foamtank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "foamtank"
	amount_per_transfer_from_this = 25

	New()
		..()
		reagents.add_reagent("ff-foam",1000)

/obj/reagent_dispensers/watertank
	name = "watertank"
	desc = "A watertank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertank"
	amount_per_transfer_from_this = 25

	New()
		..()
		reagents.add_reagent("water",1000)

/obj/reagent_dispensers/watertank/big
	name = "high-capacity watertank"
	desc = "A specialised high-pressure water tank for holding large amounts of water."
	icon = 'icons/obj/objects.dmi'
	icon_state = "watertankbig"
	amount_per_transfer_from_this = 25

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(100000)
		reagents = R
		R.my_atom = src
		reagents.add_reagent("water",100000)

/obj/reagent_dispensers/watertank/fountain
	name = "water fountain"
	desc = "It's called a fountain, but it's not very decorative or interesting. You can get a drink from it, though."
	icon_state = "water_fountain1"
	anchored = 1
	var/cup_amount = 12

	get_desc(dist, mob/user) // this shit refused to show the parent get_desc() info even if I added a ..() so I'M JUST COPYING THE CODE NOW LIKE SOME KIND OF GIGANTIC ASSHOLE
		. += "There's [cup_amount] paper cup[s_es(src.cup_amount)] in [src]'s cup dispenser."
		if (dist <= 2 && reagents)
			. += "<br><span style=\"color:orange\">[reagents.get_description(user,RC_SCALE)]</span>"

	attack_hand(mob/user as mob)
		if (src.cup_amount <= 0)
			user.show_text("\The [src] doesn't have any cups left.", "red")
			return
		else
			src.visible_message("<b>[user]</b> grabs a paper cup from [src].",\
			"You grab a paper cup from [src].")
			src.cup_amount --
			var/obj/item/reagent_containers/food/drinks/paper_cup/P = new /obj/item/reagent_containers/food/drinks/paper_cup(src)
			user.put_in_hand_or_drop(P)
			if (src.cup_amount <= 0)
				src.icon_state = "water_fountain0"

/obj/reagent_dispensers/fueltank
	name = "fueltank"
	desc = "A fueltank"
	icon = 'icons/obj/objects.dmi'
	icon_state = "weldtank"
	amount_per_transfer_from_this = 25

	New()
		..()
		reagents.add_reagent("fuel",4000)

	suicide(var/mob/user as mob)
		if (!src.reagents.has_reagent("fuel",20))
			return 0
		user.visible_message("<span style=\"color:red\"><b>[user] drinks deeply from the [src.name]. \He then pulls out a match from somewhere, strikes it and swallows it!</b></span>")
		src.reagents.remove_any(20)
		playsound(src.loc, "sound/items/drink.ogg", 50, 1, -6)
		user.TakeDamage("chest", 0, 150)
		if (isliving(user))
			var/mob/living/L = user
			L.burning = 100
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/reagent_dispensers/heliumtank
	name = "heliumtank"
	desc = "A tank of helium."
	icon = 'icons/obj/objects.dmi'
	icon_state = "heliumtank"
	amount_per_transfer_from_this = 25

	New()
		..()
		reagents.add_reagent("helium",1000)

/obj/reagent_dispensers/beerkeg
	name = "beer keg"
	desc = "A beer keg"
	icon = 'icons/obj/objects.dmi'
	icon_state = "beertankTEMP"
	amount_per_transfer_from_this = 25

	New()
		..()
		reagents.add_reagent("beer",1000)

/obj/reagent_dispensers/compostbin
	name = "compost tank"
	desc = "A device that mulches up unwanted produce into usable fertiliser."
	icon = 'icons/obj/objects.dmi'
	icon_state = "compost"
	amount_per_transfer_from_this = 30

	New()
		..()

	get_desc(dist, mob/user)
		if (dist > 2)
			return
		if (!reagents)
			return
		. = "<br><span style=\"color:orange\">[reagents.get_description(user,RC_FULLNESS)]</span>"
		return

	attackby(obj/item/W as obj, mob/user as mob)
		var/load = 1
		if (istype(W,/obj/item/reagent_containers/food/snacks/plant/)) src.reagents.add_reagent("poo", 20)
		else if (istype(W,/obj/item/reagent_containers/food/snacks/mushroom/)) src.reagents.add_reagent("poo", 25)
		else if (istype(W,/obj/item/seed/)) src.reagents.add_reagent("poo", 2)
		else if (istype(W,/obj/item/plant/)) src.reagents.add_reagent("poo", 15)
		else load = 0

		if(load)
			boutput(user, "<span style=\"color:orange\">[src] mulches up [W].</span>")
			playsound(src.loc, "sound/effects/blobattack.ogg", 50, 1)
			user.u_equip(W)
			W.dropped()
			qdel( W )
			return
		else ..()

	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if (!istype(user,/mob/living/))
			boutput(user, "<span style=\"color:red\">Excuse me you are dead, get your gross dead hands off that!</span>")
			return
		if (get_dist(user,src) > 1)
			boutput(user, "<span style=\"color:red\">You need to move closer to [src] to do that.</span>")
			return
		if (get_dist(O,src) > 1 || get_dist(O,user) > 1)
			boutput(user, "<span style=\"color:red\">[O] is too far away to load into [src]!</span>")
			return
		if (istype(O, /obj/item/reagent_containers/food/snacks/plant/) || istype(O, /obj/item/reagent_containers/food/snacks/mushroom/) || istype(O, /obj/item/seed/) || istype(O, /obj/item/plant/))
			user.visible_message("<span style=\"color:orange\">[user] begins quickly stuffing [O] into [src]!</span>")
			var/itemtype = O.type
			var/staystill = user.loc
			for(var/obj/item/P in view(1,user))
				if (src.reagents.total_volume >= src.reagents.maximum_volume)
					boutput(user, "<span style=\"color:red\">[src] is full!</span>")
					break
				if (user.loc != staystill) break
				if (P.type != itemtype) continue
				var/amount = 20
				if (istype(P,/obj/item/reagent_containers/food/snacks/mushroom/))
					amount = 25
				else if (istype(P,/obj/item/seed/))
					amount = 2
				else if (istype(P,/obj/item/plant/))
					amount = 15
				playsound(src.loc, "sound/effects/blobattack.ogg", 50, 1)
				src.reagents.add_reagent("poo", amount)
				qdel( P )
				sleep(3)
			boutput(user, "<span style=\"color:orange\">You finish stuffing [O] into [src]!</span>")
		else ..()

/obj/reagent_dispensers/still
	name = "still"
	desc = "A piece of equipment for brewing alcoholic beverages."
	icon = 'icons/obj/objects.dmi'
	icon_state = "still"
	amount_per_transfer_from_this = 25

	// what was the point here exactly
	//New()
		//..()

	proc/brew(var/obj/item/W as obj)
		if (!W || !(istype(W,/obj/item/reagent_containers/food) || istype(W, /obj/item/plant)))
			return 0

		if (!W:brewable || !W:brew_result)
			return 0

		//var/brewed_name = null
		if (islist(W:brew_result) && W:brew_result:len)
			for (var/i in W:brew_result)
				//brewed_name += ", [reagent_id_to_name(i)]"
				src.reagents.add_reagent(i, 10)
			//brewed_name = copytext(brewed_name, 3)
		else
			src.reagents.add_reagent(W:brew_result, 20)
			//brewed_name = reagent_id_to_name(W:brew_result)

		src.visible_message("<span style=\"color:orange\">[src] brews up [W]!</span>")// into [brewed_name]!")
		//qdel(W)
		return 1

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W,/obj/item/reagent_containers/food) || istype(W, /obj/item/plant))
			var/load = 0
			if (src.brew(W))
				load = 1
			else
				load = 0

			if (load)
				user.u_equip(W)
				W.dropped()
				qdel(W)
				return
			else  ..()
		else ..()

	MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob)
		if (!isliving(user))
			user.show_text("It's probably a bit too late for you to drink your problems away.", "red")
			return
		if (get_dist(user,src) > 1)
			user.show_text("You need to move closer to [src] to do that.", "red")
			return
		if (get_dist(O,src) > 1 || get_dist(O,user) > 1)
			user.show_text("[O] is too far away to load into [src]!", "red")
			return

		if (istype(O, /obj/storage/crate/))
			user.visible_message("<span style=\"color:orange\">[user] loads [O]'s contents into [src]!</span>",\
			"<span style=\"color:orange\">You load [O]'s contents into [src]!</span>")
			var/amtload = 0
			for (var/obj/item/P in O.contents)
				if (src.reagents.is_full())
					user.show_text("[src] is full!", "red")
					break
				if (src.brew(P))
					amtload++
					qdel(P)
				else
					continue
			if (amtload)
				user.show_text("[amtload] items loaded from [O]!", "blue")
			else
				user.show_text("Nothing was loaded!", "red")
		else if (istype(O, /obj/item/reagent_containers/food) || istype(O, /obj/item/plant))
			user.visible_message("<span style=\"color:orange\"><b>[user]</b> begins quickly stuffing items into [src]!</span>",\
			"<span style=\"color:orange\">You begin quickly stuffing items into [src]!</span>")
			var/staystill = user.loc
			for (O in view(1,user))
				if (src.reagents.is_full())
					user.show_text("[src] is full!", "red")
					break
				if (user.loc != staystill)
					user.show_text("You were interrupted!", "red")
					break
				if (src.brew(O))
					qdel(O)
				else
					continue
			user.visible_message("<span style=\"color:orange\"><b>[user]</b> finishes stuffing items into [src].</span>",\
			"<span style=\"color:orange\">You finish stuffing items into [src].</span>")
		else
			return ..()