/*
//reagent_container bit flags
#define RC_SCALE 	1		// has a graduated scale, so total reagent volume can be read directly
#define RC_VISIBLE	2		// reagent is visible inside, so color can be described
#define RC_FULLNESS 4		// can estimate fullness of container
#define RC_SPECTRO	8		// spectroscopic glasses can analyse contents
*/
/* ================================================================== */
/* -------------------- Reagent Container Parent -------------------- */
/* ================================================================== */

// for some reason this very important parent item of a fucking thousand other things was planted down on line 700
// I AM SCREAMING A LOT IN REAL LIFE ABOUT THIS CURRENTLY
/obj/item/reagent_containers
	name = "Container"
	desc = "..."
	icon = 'icons/obj/chemical.dmi'
	icon_state = null
	w_class = 1
	flags = FPRINT | TABLEPASS | SUPPRESSATTACK
	var/rc_flags = RC_VISIBLE | RC_FULLNESS | RC_SPECTRO
	var/amount_per_transfer_from_this = 5
	var/initial_volume = 50
	var/incompatible_with_chem_dispensers = 0
	move_triggered = 1

	move_trigger(var/mob/M, kindof)
		if (..() && reagents)
			reagents.move_trigger(M, kindof)

	proc/ensure_reagent_holder()
		if (!src.reagents)
			var/datum/reagents/R = new /datum/reagents(initial_volume)
			src.reagents = R
			R.my_atom = src

	New()
		..()
		ensure_reagent_holder()

	attack_self(mob/user as mob)
		return
	attack(mob/M as mob, mob/user as mob, def_zone)
		return
	attackby(obj/item/I as obj, mob/user as mob)
		if (reagents)
			reagents.physical_shock(I.force)
		return
	afterattack(obj/target, mob/user , flag)
		return

	get_desc(dist, mob/user)
		if (dist > 2)
			return
		if (!reagents)
			return
		. = "<br><span style=\"color:orange\">[reagents.get_description(user,rc_flags)]</span>"
		return

	MouseDrop(atom/over_object as obj)
		// First filter out everything we don't want to refill or empty quickly.
		if (!istype(over_object, /obj/item/reagent_containers/glass) && !istype(over_object, /obj/item/reagent_containers/food/drinks) && !istype(over_object, /obj/reagent_dispensers) && !istype(over_object, /obj/item/spraybottle) && !istype(over_object, /obj/machinery/plantpot) && !istype(over_object, /obj/mopbucket))
			return ..()

		if (!istype(src, /obj/item/reagent_containers/glass) && !istype(src, /obj/item/reagent_containers/food/drinks))
			return ..()

		if (get_dist(usr, src) > 1 || get_dist(usr, over_object) > 1)
			boutput(usr, "<span style=\"color:red\">That's too far!</span>")
			return

		src.transfer_all_reagents(over_object, usr)

/* ====================================================== */
/* -------------------- Glass Parent -------------------- */
/* ====================================================== */

/obj/item/reagent_containers/glass
	name = " "
	desc = " "
	icon = 'icons/obj/chemical.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	var/splash_all_contents = 1
	flags = FPRINT | TABLEPASS | OPENCONTAINER | SUPPRESSATTACK

	afterattack(obj/target, mob/user , flag)

		if (ismob(target))
			if (!src.reagents.total_volume)
				boutput(user, "<span style=\"color:red\">Your [src.name] is empty!</span>")
				return
			var/mob/living/T = target
			var/obj/item/reagent_containers/glass/G = null

			if (istype(T,/mob/living/carbon/human/))
				var/mob/living/carbon/human/H = T
				if (H.hand == 1)
					if (istype(H.l_hand,/obj/item/reagent_containers/glass/)) G = H.l_hand
				else
					if (istype(H.r_hand,/obj/item/reagent_containers/glass/)) G = H.r_hand
			else if (istype(T,/mob/living/silicon/robot/))
				var/mob/living/silicon/robot/R = T
				if (istype(R.module_active,/obj/item/reagent_containers/glass/)) G = R.module_active

			if (G && user.a_intent == "help" && T.a_intent == "help" && user != T)
				if (G.reagents.total_volume >= G.reagents.maximum_volume)
					boutput(user, "<span style=\"color:red\">[T.name]'s [G.name] is already full!</span>")
					boutput(T, "<span style=\"color:red\"><B>[user.name]</B> offers you [src.name], but your [G.name] is already full.</span>")
					return
				src.reagents.trans_to(G, src.amount_per_transfer_from_this)
				user.visible_message("<b>[user.name]</b> pours some of the [src.name] into [T.name]'s [G.name].")
				return
			else
				if (src.splash_all_contents)
					boutput(user, "<span style=\"color:orange\">You splash all of the solution onto [target].</span>")
					target.visible_message("<span style=\"color:red\"><b>[user.name]</b> splashes the [src.name]'s contents onto [target.name]!</span>")
				else
					boutput(user, "<span style=\"color:orange\">You apply [src.amount_per_transfer_from_this] units of the solution to [target].</span>")
					target.visible_message("<span style=\"color:red\"><b>[user.name]</b> applies some of the [src.name]'s contents to [target.name].</span>")
				var/mob/living/MOB = target
				logTheThing("combat", user, MOB, "splashes [src] onto %target% [log_reagents(src)] at [log_loc(MOB)].") // Added location (Convair880).
				if (src.splash_all_contents)
					src.reagents.reaction(target,TOUCH)
				else
					src.reagents.reaction(target, TOUCH, src.amount_per_transfer_from_this)
				spawn(5)
					if (src.splash_all_contents) src.reagents.clear_reagents()
					else src.reagents.remove_any(src.amount_per_transfer_from_this)
				return

		else if (istype(target, /obj/reagent_dispensers) || (target.is_open_container() == -1 && target.reagents)) //A dispenser. Transfer FROM it TO us.

			if (!target.reagents.total_volume && target.reagents)
				boutput(user, "<span style=\"color:red\">[target] is empty.</span>")
				return

			if (reagents.total_volume >= reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			var/transferamt = src.reagents.maximum_volume - src.reagents.total_volume
			var/trans = target.reagents.trans_to(src, transferamt)
			boutput(user, "<span style=\"color:orange\">You fill [src] with [trans] units of the contents of [target].</span>")

		else if (target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
			if (!reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[src] is empty.</span>")
				return

			if (target.reagents.total_volume >= target.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[target] is full.</span>")
				return

			logTheThing("combat", user, null, "transfers chemicals from [src] [log_reagents(src)] to [target] at [log_loc(user)].") // Added reagents (Convair880).
			var/trans = src.reagents.trans_to(target, 10)
			boutput(user, "<span style=\"color:orange\">You transfer [trans] units of the solution to [target].</span>")

		else if (istype(target, /obj/item/sponge)) // dump contents onto it
			if (!reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[src] is empty.</span>")
				return

			if (target.reagents.total_volume >= target.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[target] is full.</span>")
				return

			logTheThing("combat", user, null, "transfers chemicals from [src] [log_reagents(src)] to [target] at [log_loc(user)].")
			var/trans = src.reagents.trans_to(target, 10)
			boutput(user, "<span style=\"color:orange\">You dump [trans] units of the solution to [target].</span>")

		else if (reagents.total_volume)

			if (isobj(target)) //Have to do this in 2 lines because byond is shit.
				if (target:flags & NOSPLASH) return

			boutput(user, "<span style=\"color:orange\">You [src.splash_all_contents ? "splash all of" : "apply [amount_per_transfer_from_this] units of"] the solution onto [target].</span>")
			logTheThing("combat", user, target, "splashes [src] onto %target% [log_reagents(src)] at [log_loc(user)].") // Added location (Convair880).
			if (src.splash_all_contents) src.reagents.reaction(target,TOUCH)
			else src.reagents.reaction(target, TOUCH, src.amount_per_transfer_from_this)
			spawn(5)
				if (src.splash_all_contents) src.reagents.clear_reagents()
				else src.reagents.remove_any(src.amount_per_transfer_from_this)
			return

	attackby(obj/item/I as obj, mob/user as mob)
		/*if (istype(I, /obj/item/reagent_containers/pill))

			if (!I.reagents || !I.reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[src] is empty.</span>")
				return

			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:orange\">You dissolve the [I] in [src].</span>")

			I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)

		else */if (istype(I, /obj/item/reagent_containers/food/snacks/ingredient/egg))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:orange\">You crack [I] into [src].</span>")

			I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)

		else if (istype(I, /obj/item/paper))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:orange\">You rip up the [I] into tiny pieces and sprinkle it into [src].</span>")

			I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)

		else if (istype(I, /obj/item/reagent_containers/food/snacks/breadloaf))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:orange\">You shove the [I] into [src].</span>")

			I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)

		else if (istype(I, /obj/item/reagent_containers/food/snacks/breadslice))
			if (src.reagents.total_volume >= src.reagents.maximum_volume)
				boutput(user, "<span style=\"color:red\">[src] is full.</span>")
				return

			boutput(user, "<span style=\"color:orange\">You shove the [I] into [src].</span>")

			I.reagents.trans_to(src, I.reagents.total_volume)
			qdel(I)

		else if (istype(I, /obj/item/scalpel) || istype(I, /obj/item/circular_saw) || istype(I, /obj/item/surgical_spoon))
			if (src.reagents && I.reagents)
				I:Poisoner = user
				src.reagents.trans_to(I, 5)
				logTheThing("combat", user, null, "poisoned [I] [log_reagents(I)] with reagents from [src] [log_reagents(src)] at [log_loc(user)].") // Added location (Convair880).
				user.visible_message("<span style=\"color:red\"><b>[user]</b> dips the blade of [I] into [src]!</span>")
				return
		else
			..()
		return

	attack_self(mob/user as mob)
		if (src.splash_all_contents)
			boutput(user, "<span style=\"color:orange\">You tighten your grip on the [src].</span>")
			src.splash_all_contents = 0
		else
			boutput(user, "<span style=\"color:orange\">You loosen your grip on the [src].</span>")
			src.splash_all_contents = 1
		return

	proc/smash()
		playsound(src.loc, pick('sound/effects/Glassbr1.ogg','sound/effects/Glassbr2.ogg','sound/effects/Glassbr3.ogg'), 100, 1)
		new /obj/item/raw_material/shard/glass(src.loc)
		var/turf/U = src.loc
		src.reagents.reaction(U)
		qdel(src)

	on_spin_emote(var/mob/living/carbon/human/user as mob)
		if (src.is_open_container() && src.reagents && src.reagents.total_volume > 0)
			user.visible_message("<span style=\"color:red\"><b>[user] spills the contents of [src] all over [him_or_her(user)]self!</b></span>")
			src.reagents.reaction(get_turf(user), TOUCH)
			src.reagents.clear_reagents()

	is_open_container()
		return 1

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	amount_per_transfer_from_this = 10
	initial_volume = 30
	flags = FPRINT | OPENCONTAINER | SUPPRESSATTACK
	rc_flags = RC_FULLNESS | RC_VISIBLE | RC_SPECTRO

	attackby(var/obj/D, mob/user as mob)
		if (istype(D, /obj/item/device/prox_sensor))
			var/obj/item/bucket_sensor/B = new /obj/item/bucket_sensor
			user.u_equip(D)
			user.put_in_hand_or_drop(B)
			user.show_text("You add the sensor to the bucket")
			qdel(D)
			qdel(src)

		else if (istype(D, /obj/item/mop))
			if (src.reagents.total_volume >= 2)
				src.reagents.trans_to(D, 2)
				user.show_text("You wet the mop", "blue")
				playsound(src.loc, 'sound/effects/slosh.ogg', 25, 1)
			else
				user.show_text("Out of water!", "blue")
		else if (istype(D, /obj/item/wirecutters))
			if (src.reagents.total_volume)
				user.show_text("<b>You start cutting [src], causing it to spill!</b>", "red")
				src.reagents.reaction(get_turf(src))
			else
				user.show_text("You start cutting [src].")
			if (!do_mob(user, src))
				user.show_text("<b>You were interrupted!</b>", "red")
				return
			user.show_text("You cut eyeholes into [src].")
			var/obj/item/clothing/head/helmet/bucket/B = new /obj/item/clothing/head/helmet/bucket(src.loc)
			user.put_in_hand_or_drop(B)
			qdel(src)
		else
			return ..()

/obj/item/reagent_containers/glass/dispenser
	name = "reagent glass"
	desc = "A reagent glass."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	initial_volume = 50
	amount_per_transfer_from_this = 10
	rc_flags = RC_SCALE | RC_VISIBLE | RC_SPECTRO
	flags = FPRINT | TABLEPASS | OPENCONTAINER | SUPPRESSATTACK

/obj/item/reagent_containers/glass/large
	name = "large reagent glass"
	desc = "A large reagent glass."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beakerlarge"
	item_state = "beaker"
	rc_flags = RC_SCALE | RC_VISIBLE | RC_SPECTRO
	amount_per_transfer_from_this = 10
	flags = FPRINT | TABLEPASS | OPENCONTAINER | SUPPRESSATTACK

/obj/item/reagent_containers/glass/dispenser/surfactant
	name = "reagent glass (surfactant)"
	icon_state = "liquid"

	New()
		..()
		reagents.add_reagent("fluorosurfactant", 20)
