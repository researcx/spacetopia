
/* ==================================================== */
/* -------------------- Fuel Tanks -------------------- */
/* ==================================================== */

// Why is this a drinking bottle now? Well, I want the same set of functionality (drag & drop, transference)
// without the C&P code a separate obj class would require. You can't use drinking bottles in beaker
// assemblies and the like in case you're worried about the availability of 400 units beakers (Convair880).
/obj/item/reagent_containers/food/drinks/fueltank
	name = "Fuel Tank"
	desc = "A specialized anti-static tank for holding flammable compounds"
	icon = 'icons/obj/items.dmi'
	icon_state = "bottlefuel"
	amount_per_transfer_from_this = 25
	incompatible_with_chem_dispensers = 1
	flags = FPRINT | TABLEPASS | OPENCONTAINER
	rc_flags = RC_SCALE
	initial_volume = 400

	New()
		..()
		reagents.add_reagent("fuel", 400)

/obj/item/reagent_containers/food/drinks/fueltank/empty
	New()
		..()
		var/datum/reagents/R = new/datum/reagents(400)
		reagents = R
		R.my_atom = src