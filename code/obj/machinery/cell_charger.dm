/obj/machinery/cell_charger
	name = "cell charger"
	desc = "A charging unit for power cells."
	icon = 'icons/obj/power.dmi'
	icon_state = "ccharger0"
	var/obj/item/cell/charging = null
	var/chargerate = 250 // power per tick
	var/chargelevel = -1
	anchored = 1
	mats = 8
	power_usage = 50

/obj/machinery/cell_charger/attackby(obj/item/W, mob/user)
	if(stat & BROKEN)
		return

	if(istype(W, /obj/item/cell))
		if(charging)
			boutput(user, "There is already a cell in the charger.")
			return
		else
			user.drop_item()
			W.set_loc(src)
			charging = W
			user.visible_message("[user] inserts a cell into the charger.", "You insert a cell into the charger.")
			chargelevel = -1
		updateicon()

/obj/machinery/cell_charger/proc/updateicon()
	icon_state = "ccharger[charging ? 1 : 0]"

	if(charging && !(stat & (BROKEN|NOPOWER)) )

		var/newlevel = 	round( charging.percent() * 4.0 / 99 )
		//boutput(world, "nl: [newlevel]")

		if(chargelevel != newlevel)

			overlays = null
			overlays += image('icons/obj/power.dmi', "ccharger-o[newlevel]")

			chargelevel = newlevel
	else
		overlays = null

/obj/machinery/cell_charger/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & BROKEN)
		return

	if(charging)
		if(iscarbon(usr))
			user.put_in_hand_or_drop(charging)
		else
			charging.set_loc(src.loc)
		charging.add_fingerprint(user)
		charging.updateicon()
		src.charging = null
		user.visible_message("[user] removes the cell from the charger.", "You remove the cell from the charger.")
		chargelevel = -1
		updateicon()

/obj/machinery/cell_charger/process()
	if (stat & BROKEN)
		return
	if (charging)
		power_usage = 50 + src.chargerate / CELLRATE
	else
		power_usage = 50
	..()
	//boutput(world, "ccpt [charging] [stat]")
	if(!charging || (stat & NOPOWER) )
		src.updateicon()
		return

	var/added = charging.give(src.chargerate)
	use_power(added / CELLRATE)

	src.updateicon()