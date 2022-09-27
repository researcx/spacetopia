/obj/item/clothing/head/wig
	name = "toup�e"
	desc = "You can't tell the difference, Honest!"
	icon_state= "wig"

/obj/item/clothing/head/bald_cap
	name = "bald cap"
	desc = "You can't tell the difference, Honest!"
	icon_state= "baldcap"
	item_state= "baldcap"

/obj/item/scissors
	name = "Scissors"
	desc = "Used to cut hair. Make sure you aim at the head, where the hair is."
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "scissors"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 10.0
	w_class = 1.0
	hit_type = DAMAGE_STAB
	hitsound = 'sound/effects/bloody_stab.ogg'
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	g_amt = 5000

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
		blood_slash(user, 25)
		user.TakeDamage("head", 150, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/item/razor_blade
	name = "Razor Blade"
	desc = "Used to cut facial hair"
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "razorblade"
	flags = FPRINT | TABLEPASS | CONDUCT
	force = 10.0
	w_class = 1.0
	hit_type = DAMAGE_CUT
	hitsound = 'sound/weapons/slashcut.ogg'
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	m_amt = 10000
	g_amt = 5000

	suicide(var/mob/user as mob)
		user.visible_message("<span style=\"color:red\"><b>[user] slashes \his own throat with [src]!</b></span>")
		blood_slash(user, 25)
		user.TakeDamage("head", 150, 0)
		user.updatehealth()
		spawn(100)
			if (user)
				user.suiciding = 0
		return 1

/obj/item/dye_bottle
	name = "Hair Dye Bottle"
	desc = "Used to dye hair a different color. Seems to be made of tough, unshatterable plastic."
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "dye-e"
	flags = FPRINT | TABLEPASS
	//Default Colors
	var/customization_first_color = "#FFFFFF"
	var/empty = 1

/obj/item/reagent_containers/food/drinks/hairgrowth
	name = "EZ-Hairgrowth"
	desc = "The #1 hair growth product on the market! WARNING: Some side effects may occur."
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "tonic1"
	New()
		var/datum/reagents/R = new/datum/reagents(50)
		reagents = R
		R.my_atom = src
		R.add_reagent("hairgrownium", 40)

	on_reagent_change()
		src.icon_state = "tonic[src.reagents.total_volume ? "1" : "0"]"

/obj/stool/barber_chair
	name = "Barber Chair"
	desc = "Chair where hair can be cut"
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "barberchair"
	anchored = 1

/obj/barber_pole
	name = "Barber Pole"
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "pole"
	density = 1
	anchored = 1
	desc = "Barber poles historically were signage used to convey that the barber would perform services such as blood letting and other medical procedures, with the red representing blood, and the white representing the bandaging. In America, long after the time when blood-letting was offered, a third colour was added to bring it in line with the colours of their national flag. This one is in space."

///////////////////////////////////////////
///////////Barber Chair Code///////////////
///////////////////////////////////////////
/obj/stool/barber_chair/MouseDrop_T(mob/M as mob, mob/user as mob)
	if (!ticker)
		boutput(user, "You can't buckle anyone in before the game starts.")
		return
	if ((!( iscarbon(M) ) || get_dist(src, user) > 1 || M.loc != src.loc || user.restrained() || usr.stat))
		return
	if (M == usr)
		user.visible_message("<span style=\"color:orange\">[M] buckles in!</span>", "<span style=\"color:orange\">You buckle yourself in.</span>")
	else
		user.visible_message("<span style=\"color:orange\">[M] is buckled in by [user].</span>", "<span style=\"color:orange\">You buckle in [M].</span>")
	M.anchored = 1
	M.buckled = src
	M.set_loc(src.loc)
	src.add_fingerprint(user)
	return

/obj/stool/barber_chair/attack_hand(mob/user as mob)
	for(var/mob/M in src.loc)
		if (M.buckled)
			if (M != user)
				user.visible_message("<span style=\"color:orange\">[M] is unbuckled by [user].</span>", "<span style=\"color:orange\">You unbuckle [M].</span>")
			else
				user.visible_message("<span style=\"color:orange\">[M] unbuckles.</span>", "<span style=\"color:orange\">You unbuckle.</span>")
			M.anchored = 0
			M.buckled = null
			src.add_fingerprint(user)
	return

/obj/stool/barber_chair/ex_act(severity)
	for(var/mob/M in src.loc)
		if(M.buckled == src)
			M.buckled = null
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
	return

/obj/stool/barber_chair/blob_act(var/power)
	if(prob(power * 2.5))
		for(var/mob/M in src.loc)
			if(M.buckled == src)
				M.buckled = null
		qdel(src)
/*
/obj/stool/barber_chair/verb/rotate()
	set src in oview(1)
	set category = "Local"

	src.dir = turn(src.dir, 90)
	if (src.dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER
	return
*/
///////////////////////////////////////////////////
//////Hair Dye Bottle Code					///////
///////////////////////////////////////////////////
/obj/item/dye_bottle/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(!istype(M,/mob/living/carbon/human))	return
	if(user.zone_sel.selecting != "head" || user.a_intent != "help")
		..()
		return
	if(src.empty)
		boutput(user, "<span style=\"color:red\">Bottle is empty!</span>")
	else //if(istype(M.buckled, /obj/stool/barber_chair))
		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.c_flags & COVERSEYES) || (H.wear_mask && H.wear_mask.c_flags & COVERSEYES)))
			// you can't stab someone in the eyes wearing a mask!
			boutput(user, "<span style=\"color:orange\">You're going to need to remove that mask/helmet first.</span>")
			return
		/*
		var/turf/T = M.loc
		var/turf/TM = user.loc
		boutput(user, "<span style=\"color:orange\">You begin dying [M]'s hair.</span>")
		boutput(M, "<span style=\"color:orange\">[user] begins dying your hair.</span>")
		sleep(30)
		if(M.loc == T && TM.loc == user.loc  && (user.equipped() == src || istype(user, /mob/living/silicon)))
			return
		*/
		boutput(user, "<span style=\"color:orange\">You dye [M]'s hair.</span>")
		boutput(M, "<span style=\"color:orange\">[user] dyes your hair.</span>")
		M.bioHolder.mobAppearance.customization_first_color = src.customization_first_color
		M.bioHolder.mobAppearance.customization_second_color = src.customization_first_color
		M.set_face_icon_dirty()
		M.set_body_icon_dirty()
		M.update_clothing()
		src.empty = 1
		src.icon_state= "dye-e"
	//else
	//	boutput(user, "<span style=\"color:red\">They need to be in a barber chair!</span>")

/////////////////////////////////////////////////////
//////Scissors Code								/////
////////////////////////////////////////////////////
/obj/item/scissors/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if (src.remove_bandage(M, user))
		return

	if(user.zone_sel.selecting != "head" || user.a_intent != "help")
		..()
		return

	if (user == M)
		boutput(user, "<span style=\"color:red\">You can't cut your own hair!</span>")
		return


	if(istype(M.buckled, /obj/stool/barber_chair))

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.c_flags & COVERSEYES) || (H.wear_mask && H.wear_mask.c_flags & COVERSEYES) || (H.glasses && H.glasses.c_flags & COVERSEYES)))
			// you can't stab someone in the eyes wearing a mask!
			boutput(user, "<span style=\"color:orange\">You're going to need to remove that mask/helmet/glasses first.</span>")
			return

		if(M.bioHolder.mobAppearance.customization_first == "None")
			boutput(user, "<span style=\"color:red\">There is nothing to cut!</span>")
			return

		var/new_style = input(user, "Please select style", "Style")  as null|anything in customization_styles

		if (new_style)
			if(M.bioHolder.mobAppearance.customization_first == "Balding" && new_style != "None")
				boutput(user, "<span style=\"color:red\">Not enough hair!</span>")
				return

		if(!new_style)
			return

		var/turf/T = M.loc
		var/turf/TM = user.loc
		boutput(user, "<span style=\"color:orange\">You begin cutting [M]'s hair.</span>")
		boutput(M, "<span style=\"color:orange\">[user] begins cutting your hair.</span>")
		playsound(src.loc, "sound/items/Scissor.ogg", 100, 1)
		sleep(70)
		if(M.loc == T && TM.loc == user.loc  && (user.equipped() == src || istype(user, /mob/living/silicon)))
			return

		if (new_style == "None")
			var/obj/item/I = M.create_wig()
			I.set_loc(user.loc)

		M.bioHolder.mobAppearance.customization_first = new_style
		boutput(M, "<span style=\"color:orange\">[user] cuts your hair.</span>")
		boutput(user, "<span style=\"color:orange\">you cut [M]'s hair.</span>")

		M.cust_one_state = customization_styles[new_style]
		M.set_clothing_icon_dirty() // why the fuck is hair updated in clothing

//////////////////////////////////////////////////////////
////Razor Blade										/////
/////////////////////////////////////////////////////////
/obj/item/razor_blade/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	if(scalpel_surgery(M,user)) return

	if(user.zone_sel.selecting != "head" || user.a_intent != "help")
		..()
		return

	if( istype(M, /mob/living/silicon))
		boutput(user, "<span style=\"color:red\">Shave a robot? Shave a robot!?? SHAVE A ROBOT?!?!??</span>")
		return

	if(M.cust_two_state == "wiz")
		if (user == M)
			boutput(user, "<span style=\"color:red\">No!!! This is the worst idea you've ever had!</span>")
			return
		src.visible_message("<span style=\"color:red\"><b>[user]</b> quickly shaves off [M]'s beard!</span>")
		M.bioHolder.AddEffect("arcane_shame", timeleft = 120)
		M.bioHolder.mobAppearance.customization_second = "None"
		M.cust_two_state = "None"
		M.set_face_icon_dirty()
		M.emote("cry")
		return

	if(istype(M.buckled, /obj/stool/barber_chair))

		var/mob/living/carbon/human/H = M
		if(istype(M, /mob/living/carbon/human) && ((H.head && H.head.c_flags & COVERSEYES) || (H.wear_mask && H.wear_mask.c_flags & COVERSEYES) || (H.glasses && H.glasses.c_flags & COVERSEYES)))
			// you can't stab someone in the eyes wearing a mask!
			boutput(user, "<span style=\"color:orange\">You're going to need to remove that mask/helmet/glasses first.</span>")
			return


		if(M.bioHolder.mobAppearance.customization_second == "None")
			boutput(user, "<span style=\"color:red\">There is nothing to shave!</span>")
			return

		var/new_style = input(user, "Please select facial style", "Facial Style")  as null|anything in customization_styles

		if (new_style)
			var/list/mustaches =list("Watson", "Chaplin", "Selleck", "Van Dyke", "Hogan")
			var/list/beards  = list("Neckbeard", "Elvis", "Abe", "Chinstrap", "Hipster", "Wizard")
			var/list/full = list("Goatee", "Full Beard", "Long Beard")

			if((new_style in full) && (!(M.bioHolder.mobAppearance.customization_second in full)))
				boutput(user, "<span style=\"color:red\">[M] doesn't have enough facial hair!</span>")
				return

			if((new_style in beards) && (M.bioHolder.mobAppearance.customization_second in mustaches))
				boutput(user, "<span style=\"color:red\">[M] doesn't have a beard!</span>")
				return

			if((new_style in mustaches) && (M.bioHolder.mobAppearance.customization_second in beards))
				boutput(user, "<span style=\"color:red\">[M] doesn't have a mustache!</span>")
				return

		var/turf/T = M.loc
		var/turf/TM = user.loc
		boutput(user, "<span style=\"color:orange\">You begin shaving [M].</span>")
		boutput(M, "<span style=\"color:orange\">[user] begins shaving you.</span>")
		//playsound(src.loc, "Scissor.ogg", 100, 1)
		sleep(70)
		if(M.loc == T && TM.loc == user.loc  && (user.equipped() == src || istype(user, /mob/living/silicon)))
			return


		M.bioHolder.mobAppearance.customization_second = new_style
		boutput(M, "<span style=\"color:orange\">[user] shaves your face</span>")
		boutput(user, "<span style=\"color:orange\">You shave [M]'s face.</span>")

		M.cust_two_state = customization_styles[new_style]
		M.set_face_icon_dirty()

//////////////////////////////////////////////////////////////////
/////Dye Bottle Dispenser									/////
/////////////////////////////////////////////////////////////////
/obj/machinery/hair_dye_dispenser
	name = "Hair Dye Mixer 3000"
	desc = "Mixes hair dye for whatever color you want"
	icon = 'icons/obj/barber_shop.dmi'
	icon_state = "dyedispenser"
	density = 1
	anchored = 1.0
	mats = 15

	var/obj/item/dye_bottle/bottle = null

	New()
		..()
		UnsubscribeProcess()

	ex_act(severity)
		switch(severity)
			if(1.0)
				//SN src = null
				qdel(src)
				return
			if(2.0)
				if (prob(50))
					//SN src = null
					qdel(src)
					return
			else
		return

	blob_act(var/power)
		if (prob(power * 1.25))
			qdel(src)

	meteorhit()
		qdel(src)
		return

	process()
		return

	attack_ai(mob/user as mob)
		return src.attack_hand(user)

	attack_hand(mob/user as mob)
		if(stat & BROKEN)
			return
		user.machine = src

		var/dat = "[css_interfaces]<TT><B>Dye Bottle Dispenser Unit</B><BR><HR><BR>"

		if(src.bottle)
			dat += {"Dye Bottle Loaded<br><A href='?src=\ref[src];eject=1'>Eject</A><BR><BR><BR>Dye Color:<BR>"}

			if(!src.bottle.empty)
				dat += "<A href='?src=\ref[src];emptyb=1'>Empty Dye Bottle</A><BR>"
			else
				dat += {"<A href='?src=\ref[src];fillb=1'>Fill Dye Bottle</A>"}
		else
			dat += "No Dye Bottle Loaded<BR>"

		user << browse(dat, "window=dye_dispenser;size=293x315")
		onclose(user, "dye_dispenser")
		return

	attackby(obj/item/W, mob/user as mob)
		if(istype(W, /obj/item/dye_bottle))
			if(src.bottle)
				boutput(user, "<span style=\"color:orange\">The dispenser already has a dye bottle in it.</span>")
			else
				boutput(user, "<span style=\"color:orange\">You insert the dye bottle into the dispenser.</span>")
				if(W)
					user.drop_item(W)
					W.set_loc(src)
					src.bottle = W
			return
		..()
		return


	Topic(href, href_list)
		if(stat & BROKEN)
			return
		if(usr.stat || usr.restrained())
			return
		if (istype(usr, /mob/living/silicon/ai))
			boutput(usr, "<span style=\"color:red\">You are unable to dispense anything, since the controls are physical levers which don't go through any other kind of input.</span>")
			return

		if ((usr.contents.Find(src) || ((get_dist(src, usr) <= 1) && istype(src.loc, /turf))))
			usr.machine = src

			if (href_list["eject"])
				if(src.bottle)
					src.bottle.set_loc(src.loc)
					src.bottle = null

			if(href_list["fillb"])
				if(src.bottle)
					var/new_dye = input(usr, "Please select hair color.", "Dye Color") as color
					if(new_dye)
						bottle.customization_first_color = new_dye
						bottle.empty = 0
						bottle.icon_state = "dye-f"
					src.updateDialog()
			if(href_list["emptyb"])
				if(src.bottle)
					bottle.empty = 1
					bottle.icon_state = "dye-e"
				src.updateDialog()

			src.add_fingerprint(usr)
			for(var/mob/M in viewers(1, src))
				if ((M.client && M.machine == src))
					src.attack_hand(M)
		else
			usr << browse(null, "window=dye_dispenser")
			return
		return
