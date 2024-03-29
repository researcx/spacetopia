
/* =============================================== */
/* -------------------- Pills -------------------- */
/* =============================================== */

/obj/item/reagent_containers/pill
	name = "pill"
	desc = "a pill."
	icon = 'icons/obj/pills.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_medical.dmi'
	icon_state = "pill1"
	item_state = "pill"
	rc_flags = RC_SPECTRO		// only spectroscopic analysis
	var/random_icon = 0

	New()
		..()
		init()

	pooled(var/pooltype)
		src.set_loc(locate(1, 1, 1)) // Get them out of mob.contents.
		..()
		return

	unpooled(var/poolname)
		init()
		..(poolname)

	proc/init()
		reagents = new/datum/reagents(100)
		reagents.my_atom = src
		if (src.random_icon)
			src.create_random_icon()

	attackby(obj/item/W as obj, mob/user as mob)
		return

	attack_self(mob/user as mob)
		return

	attack(mob/M as mob, mob/user as mob, def_zone)
		if (!src.reagents || !src.reagents.total_volume)
			user.show_text("[src] doesn't contain any reagents.", "red")
			return

		if (iscarbon(M) || iscritter(M))
			if (M == user)
				boutput(M, "<span style=\"color:orange\">You swallow [src].</span>")
			else
				user.visible_message("<span style=\"color:red\">[user] attempts to force [M] to swallow [src].</span>")
				logTheThing("combat", user, M, "tries to force-feed a pill [log_reagents(src)] to %target% at [log_loc(user)].")

				if (!do_mob(user, M))
					if (user && ismob(user))
						user.show_text("You were interrupted!", "red")
					return
				if (!src.reagents || !src.reagents.total_volume)
					user.show_text("[src] doesn't contain any reagents.", "red")
					return
				user.visible_message("<span style=\"color:red\">[user] forces [M] to swallow [src].</span>")

			logTheThing("combat", user, M, "[user == M ? "swallows" : "makes %target% swallow"] a pill [log_reagents(src)] at [log_loc(user)].")
			if (reagents.total_volume)
				reagents.reaction(M, INGEST)
				sleep(1)
				reagents.trans_to(M, reagents.total_volume)
			user.u_equip(src)
			pool(src)
			return 1

		return 0

	attackby(obj/item/I as obj, mob/user as mob)
		return

	proc/create_random_icon()
		src.icon_state = "pill[rand(1,20)]"
		return

	afterattack(var/atom/target, mob/user, flag)
		if (!isobj(target))
			return ..()
		if (target.is_open_container() && target.reagents)
			if (!src.reagents || !src.reagents.total_volume)
				boutput(user, "<span style=\"color:red\">[src] doesn't contain any reagents.</span>")
				return
			if (target.reagents.is_full())
				boutput(user, "<span style=\"color:red\">[target] is full!</span>")
				return

			if (istype(target, /obj/item/pen/sleepypen))
				boutput(user, "<span style=\"color:orange\">You cram the pill into the [target.name]. Elegant.</span>")
			else
				user.visible_message("<span style=\"color:red\">[user] puts something in [target].</span>",\
				"<span style=\"color:green\">You dissolve [src] in [target].</span>")

			logTheThing("combat", user, null, "dissolves a pill [log_reagents(src)] in [target] at [log_loc(user)].")
			reagents.trans_to(target, src.reagents.total_volume)
			user.u_equip(src)
			pool(src)
			return
		else
			return ..()

/* =================================================== */
/* -------------------- Sub-Types -------------------- */
/* =================================================== */

/obj/item/reagent_containers/pill/uranium
	name = "Uranium nugget"
	init()
		..()
		reagents.clear_reagents()
		reagents.add_reagent("uranium", rand(4,6))

/obj/item/reagent_containers/pill/antitox
	name = "anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("charcoal", 50)

/obj/item/reagent_containers/pill/calomel
	name = "calomel pill"
	desc = "Can be used to purge impurities, but is highly toxic itself."
	icon_state = "pill3"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("calomel", 15)

/obj/item/reagent_containers/pill/tox
	name = "cyanide pill"
	desc = "Highly lethal."
	icon_state = "pill5"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("cyanide", 50)

/obj/item/reagent_containers/pill/stox
	name = "morphine pill"
	desc = "Used to treat severe pain. Highly addictive."
	icon_state = "pill8"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("morphine", 30)

/obj/item/reagent_containers/pill/salicylic_acid
	name = "analgesic pill"
	desc = "Commonly used to treat moderate pain and fevers."
	icon_state = "pill4"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("salicylic_acid", 20)

/obj/item/reagent_containers/pill/silver_sulfadiazine
	name = "silver sulfadiazine pill" //wtf
	desc = "Used to treat burns, but it's not meant to be ingested. Welp."
	icon_state = "pill11"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("silver_sulfadiazine", 30)

/obj/item/reagent_containers/pill/epinephrine
	name = "epinephrine pill"
	desc = "Used to stabilize patients in crisis."
	icon_state = "pill20"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("epinephrine", 10)

/obj/item/reagent_containers/pill/salbutamol
	name = "salbutamol pill"
	desc = "Used to treat respiratory distress."
	icon_state = "pill16"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("salbutamol", 20)

/obj/item/reagent_containers/pill/mutadone
	name = "mutadone pill"
	desc = "Used to cure genetic abnormalities."
	icon_state = "pill18"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("mutadone", 20)

/obj/item/reagent_containers/pill/mannitol
	name = "mannitol pill"
	desc = "Used to treat cranial swelling."
	icon_state = "pill19"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("mannitol", 20)

/obj/item/reagent_containers/pill/antirad
	name = "potassium iodide pill"
	desc = "Used to treat radiation poisoning."
	icon_state = "pill9"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("anti_rad", 20)

/obj/item/reagent_containers/pill/hairgrownium
	name = "\improper EZ-Hairgrowth pill"
	desc = "The #1 hair growth product on the market! WARNING: Some side effects may occur."
	icon_state = "pill6"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("hairgrownium", 5)

// drugs 420 all day

/obj/item/reagent_containers/pill/methamphetamine
	name = "methamphetamine pill"
	desc = "Methamphetamine is a highly effective and dangerous stimulant drug."
	icon_state = "pill9"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("methamphetamine", 10)

/obj/item/reagent_containers/pill/crank
	name = "crank pill"
	desc = "A cheap and dirty stimulant drug, commonly used by space biker gangs."
	icon_state = "pill4"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("crank", 10)

/obj/item/reagent_containers/pill/bathsalts
	name = "bath salts pill"
	desc = "Sometimes packaged as a refreshing bathwater additive, these crystals are definitely not for human consumption."
	icon_state = "pill1"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("bathsalts", 10)

/obj/item/reagent_containers/pill/catdrugs
	name = "cat drugs pill"
	desc = "Uhhh..."
	icon_state = "pill5"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("catdrugs", 10)

/var/list/CYBERPUNK_drug_prefixes = strings("chemistry_tools.txt", "CYBERPUNK_drug_prefixes")
/var/list/CYBERPUNK_drug_suffixes = strings("chemistry_tools.txt", "CYBERPUNK_drug_suffixes")
/var/list/CYBERPUNK_drug_primaries = strings("chemistry_tools.txt", "CYBERPUNK_drug_primaries")
/var/list/CYBERPUNK_drug_adulterants = strings("chemistry_tools.txt", "CYBERPUNK_drug_adulterants")
/var/list/CYBERPUNK_drug_adulterants_safe = strings("chemistry_tools.txt", "CYBERPUNK_drug_adulterants_safe")

/obj/item/reagent_containers/pill/cyberpunk
	name = "cyberpunk pill"
	desc = "A cocktail of illicit designer drugs, who knows what might be in here."
	initial_volume = 100
	random_icon = 1

	New()
		..()
		name = "[pick(CYBERPUNK_drug_prefixes)] [pick(CYBERPUNK_drug_suffixes)]"

		var/primaries = rand(1,3)
		var/adulterants = rand(2,4)

		while(primaries > 0)
			primaries--
			reagents.add_reagent(pick(CYBERPUNK_drug_primaries), 6)
		while(adulterants > 0)
			adulterants--
			reagents.add_reagent(pick(CYBERPUNK_drug_adulterants), 3)

/obj/item/reagent_containers/pill/vr
	icon = 'icons/effects/VR.dmi'

/obj/item/reagent_containers/pill/vr/mannitol
	name = "mannitol pill"
	desc = "Used to treat cranial swelling."
	icon_state = "pill1"

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("mannitol", 20)

/obj/item/reagent_containers/pill/vr/antitox
	name = "anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill2"

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("charcoal", 50)

/obj/item/reagent_containers/pill/vr/salicylic_acid
	name = "analgesic pill"
	desc = "Commonly used to treat moderate pain and fevers."
	icon_state = "pill3"

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("salicylic_acid", 20)

/obj/item/reagent_containers/pill/vr/salbutamol
	name = "salbutamol pill"
	desc = "Used to treat respiratory distress."
	icon_state = "pill4"

	New()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("salbutamol", 20)
