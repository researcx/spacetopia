// Condiments

/obj/item/reagent_containers/food/snacks/condiment
	name = "condiment"
	desc = "you shouldnt be able to see this"
	icon = 'icons/obj/foodNdrink/food_ingredient.dmi'
	amount = 1
	heal_amt = 0

	heal(var/mob/M)
		boutput(M, "<span style=\"color:red\">It's just not good enough on its own...</span>")

	afterattack(atom/target, mob/user, flag)
		if (istype(target, /obj/item/reagent_containers/food/snacks/))
			user.visible_message("<span style=\"color:orange\">[user] adds [src] to [target].</span>", "<span style=\"color:orange\">You add [src] to [target].</span>")
			if (src.reagents)
				src.reagents.trans_to(target, 100)
			qdel (src)
		else return

/obj/item/reagent_containers/food/snacks/condiment/ironfilings
	name = "iron filings"
	desc = "You probably shouldn't eat these."
	icon_state = "ironfilings"
	heal_amt = 0
	amount = 1

/obj/item/reagent_containers/food/snacks/condiment/ketchup
	name = "ketchup"
	desc = "Pure�d tomatoes as a sauce."
	icon_state = "ketchup"
	initial_volume = 30

	New()
		..()
		reagents.add_reagent("ketchup", 20)

/obj/item/reagent_containers/food/snacks/condiment/syrup
	name = "maple syrup"
	desc = "Made with real artificial maple syrup!"
	icon_state = "syrup"

/obj/item/reagent_containers/food/snacks/condiment/mayo
	name = "mayonnaise"
	desc = "The subject of many a tiresome innuendo."
	icon_state = "cookie_light"

/obj/item/reagent_containers/food/snacks/condiment/hotsauce
	name = "hot sauce"
	desc = "Dangerously spicy!"
	icon_state = "hot_sauce"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("capsaicin", 100)

/obj/item/reagent_containers/food/snacks/condiment/coldsauce
	name = "cold sauce"
	desc = "This isn't very hot at all!"
	icon_state = "cold_sauce"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("cryostylane", 100)

/obj/item/reagent_containers/food/snacks/condiment/hotsauce/ghostchilisauce
	name = "incredibly hot sauce"
	desc = "Extraordinarily spicy!"
	icon_state = "hot_sauce"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("ghostchilijuice", 50)

/obj/item/reagent_containers/food/snacks/condiment/syndisauce
	name = "syndicate sauce"
	desc = "Traitorous tang."
	icon_state = "cold_sauce"
	initial_volume = 100

	New()
		..()
		reagents.add_reagent("amanitin", 50)

/obj/item/reagent_containers/food/snacks/condiment/cream
	name = "cream"
	desc = "Not related to any kind of crop."
	icon_state = "cookie_light"
	food_color = "#F8F8F8"

/obj/item/reagent_containers/food/snacks/condiment/custard
	name = "custard"
	desc = "A perennial favourite of clowns."
	icon_state = "custard"
	needspoon = 1
	amount = 2
	heal_amt = 3

/obj/item/reagent_containers/food/snacks/condiment/chocchips
	name = "chocolate chips"
	desc = "Mmm! Little bits of chocolate! Or rabbit droppings. Either or."
	icon_state = "chocchips"
	amount = 5
	heal_amt = 1
	initial_volume = 10

	New()
		..()
		reagents.add_reagent("chocolate", 10)

	afterattack(atom/target, mob/user, flag)
		if (istype(target, /obj/item/reagent_containers/food/snacks/) && src.reagents) //Wire: fix for Cannot execute null.trans to()
			user.visible_message("<span style=\"color:orange\">[user] sprinkles [src] onto [target].</span>", "<span style=\"color:orange\">You sprinkle [src] onto [target].</span>")
			src.reagents.trans_to(target, 20)
			qdel (src)
		else return

/obj/item/shaker
	name = "shaker"
	desc = "A little bottle for shaking things onto other things."
	icon = 'icons/obj/food.dmi'
	icon_state = "shaker"
	flags = FPRINT | TABLEPASS
	w_class = 2.0
	g_amt = 10
	var/stuff = null
	var/shakes = 0
	var/myVerb = "shake"

	afterattack(atom/A, mob/user as mob)
		if (istype(A, /obj/item/reagent_containers/food))
			A.reagents.add_reagent("[src.stuff]", 2)
			src.shakes ++
			user.show_text("You put some [src.stuff] onto [A].")
		else
			return ..()

	attack(mob/M as mob, mob/user as mob)
		if (src.shakes >= 15)
			user.show_text("[src] is empty!", "red")
			return
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if ((H.head && H.head.c_flags & COVERSEYES) || (H.wear_mask && H.wear_mask.c_flags & COVERSEYES) || (H.glasses && H.glasses.c_flags & COVERSEYES))
				H.tri_message("<span style=\"color:red\"><b>[user]</b> uselessly [myVerb]s some [src.stuff] onto [H]'s headgear!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You uselessly [myVerb]" : "[user] uselessly [myVerb]s"] some [src.stuff] onto your headgear! Okay then.</span>",\
				user, "<span style=\"color:red\">You uselessly [myVerb] some [src.stuff] onto [user == H ? "your" : "[H]'s"] headgear![user == H ? " Okay then." : null]</span>")
				src.shakes ++
				return
			else if (src.stuff == "salt")
				H.tri_message("<span style=\"color:red\"><b>[user]</b> [myVerb]s something into [H]'s eyes!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You [myVerb]" : "[user] [myVerb]s"] some salt into your eyes! <B>FUCK!</B></span>",\
				user, "<span style=\"color:red\">You [myVerb] some salt into [user == H ? "your" : "[H]'s"] eyes![user == H ? " <B>FUCK!</B>" : null]</span>")
				H.emote("scream")
				random_brute_damage(user, 1)
				src.shakes ++
				return
			else if (src.stuff == "pepper")
				H.tri_message("<span style=\"color:red\"><b>[user]</b> [myVerb]s something onto [H]'s nose!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You [myVerb]" : "[user] [myVerb]s"] some pepper onto your nose! <B>Why?!</B></span>",\
				user, "<span style=\"color:red\">You [myVerb] some pepper onto [user == H ? "your" : "[H]'s"] nose![user == H ? " <B>Why?!</B>" : null]</span>")
				H.emote("sneeze")
				src.shakes ++
				for (var/i = 1, i <= 30, i++)
					spawn(50*i)
						if (H && prob(20)) //Wire: Fix for Cannot execute null.emote().
							H.emote("sneeze")
				return
			else
				H.tri_message("<span style=\"color:red\"><b>[user]</b> [myVerb]s some [src.stuff] at [H]'s head!</span>",\
				H, "<span style=\"color:red\">[H == user ? "You [myVerb]" : "[user] [myVerb]s"] some [src.stuff] at your head! Fuck!</span>",\
				user, "<span style=\"color:red\">You [myVerb] some [src.stuff] at [user == H ? "your" : "[H]'s"] head![user == H ? " Fuck!" : null]</span>")
				src.shakes ++
				return
		else
			return ..()

	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/reagent_containers/))
			if (W.reagents.has_reagent("[src.stuff]") && W.reagents.get_reagent_amount("[src.stuff]") >= 15)
				user.show_text("You refill [src].", "blue")
				W.reagents.remove_reagent("[src.stuff]", 15)
				src.shakes = 0
				return
			else
				user.show_text("There isn't enough [src.stuff] in here to refill [src]!", "red")
				return
		else
			return ..()

	salt
		name = "salt shaker"
		desc = "A little bottle for shaking things onto other things. It has some salt in it."
		icon_state = "shaker-salt"
		stuff = "salt"

	pepper
		name = "pepper shaker"
		desc = "A little bottle for shaking things onto other things. It has some pepper in it."
		icon_state = "shaker-pepper"
		stuff = "pepper"

	ketchup
		name = "ketchup bottle"
		desc = "A little bottle for putting condiments on stuff. It has some ketchup in it."
		icon_state = "bottle-ketchup"
		stuff = "ketchup"
		myVerb = "squirt"

	mustard
		name = "mustard bottle"
		desc = "A little bottle for putting condiments on stuff. It has some mustard in it."
		icon_state = "bottle-mustard"
		stuff = "mustard"
		myVerb = "squirt"

