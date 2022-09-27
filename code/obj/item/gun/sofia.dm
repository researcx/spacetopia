/* cell definition */

/obj/item/cell/weapon
	name="weapon power system"
	desc="This power system needs to be recharged at a recharging station."
	maxcharge = 1000
	specialicon = 1
	icon='icons/obj/ammo.dmi'
	icon_state="power_cell"

/obj/item/cell/weapon/charged
	charge = 1000

/obj/item/cell/weapon/self_charge
	name = "self-charging weapon power system"
	desc = "This power system takes its energy from being combined with a battery to recharge the capacitors."
	icon_state = "erebcell"
	maxcharge = 1000
	genrate = 20
	specialicon = 1
	icon='icons/obj/ammo.dmi'
	icon_state="recharger_cell"

/obj/item/cell/weapon/self_charge/charged
	charge = 100


/obj/item/cell/weapon/New()
	update_icon()

/obj/item/cell/weapon/proc/update_icon()
	overlays = null
	var/ratio = src.charge / src.maxcharge
	ratio = round(ratio, 0.20) * 100
	switch(ratio)
		if(20)
			overlays += "cell_1/5"
		if(40)
			overlays += "cell_2/5"
		if(60)
			overlays += "cell_3/5"
		if(80)
			overlays += "cell_4/5"
		if(100)
			overlays += "cell_5/5"
	return

/obj/item/cell/weapon/proc(var/obj/item/gun/energy_base/E)
		if(!istype(E.cell,/obj/item/cell/weapon)) return 0

		var/obj/item/cell/weapon/temp = E.cell

		var/mob/living/M = src.loc

		if(!istype(M) || src != M.equipped()) return 0

		M.u_equip(src) // Fixed an instance of item teleportation here (Convair880).
		src.set_loc(E)
		E.cell = src

		M.put_in_hand_or_drop(temp)
		src.add_fingerprint(M)

		temp.update_icon()
		src.update_icon()
		E.update_icon()
		return 1

/* base inheritence definitions for guns */

/obj/item/gun/energy_base // new energy weapons wip, fuck the old ones, seriously
	name = "energy weapon"
	icon = 'icons/obj/gun.dmi'
	item_state = "gun"
	m_amt = 2000
	g_amt = 1000
	mats = 16
	add_residue = 0 // Does this gun add gunshot residue when fired? Energy guns shouldn't.
	var/rechargeable = 0
	var/obj/item/cell/weapon/cell = null
	var/power_cost = 250

	New()
		cell = new/obj/item/cell/weapon/charged
		..()

	disposing()
		..()

	examine()
		set src in usr
		if(src.cell)
			if(src.cell.charge < 250)
				src.desc = "The weapon's power system is at [src.cell:percent()]%. The weapon does not have enough charge to fire again."
			else
				src.desc = "The weapon's power system is at [src.cell:percent()]%. This means the weapon can be fired [src.cell.charge / src.power_cost] more times."
		else
			src.desc = "There is no cell loaded!"
		..()
		return

	update_icon()
		return 0

	emp_act()
		if (src.cell && istype(src.cell))
			src.cell.use(INFINITY)
			src.update_icon()
		return

	process()
		if (!src.cell)
			return
		if (src.cell.charge == src.cell.maxcharge) // Keep them in the loop, as we might fire the gun later (Convair880).
			return

		src.update_icon()
		return

	update_icon()
		icon_state = "taser[src.cell.charge / src.power_cost]"

	canshoot()
		if(src.cell && src.cell:charge && src.current_projectile)
			if(src.cell:charge >= src.current_projectile:cost)
				return 1
		return 0

	process_ammo(var/mob/user)
		if(src.cell && src.current_projectile)
			if(src.cell.charge >= power_cost)
				src.cell:use(power_cost)
				return 1
			else
				user.show_text(user, "<span style=\"color:red\">[src] seems to be out of charge.</span>")
				return 0
		else
			return 0

	attackby(obj/item/b as obj, mob/user as mob)
		if(istype(b, /obj/item/cell/weapon))
			if(src.cell)
				b:swap(src)
				src.update_icon()
				user.visible_message("<span style=\"color:red\">[user] swaps [src]'s power system.</span>")
			else
				src.cell = b
				src.update_icon()
				user.visible_message("<span style=\"color:red\">[user] puts a power system into [src].</span>")
		else
			user.show_text("The [b] is not compatible with the [src].", "red")
			..()

	attack_hand(mob/user as mob)
		if ((user.r_hand == src || user.l_hand == src) && src.cell)
			if (src.cell&& src.cell.genrate < 1)
				var/obj/item/cell/weapon/W = src.cell
				user.put_in_hand_or_drop(W)
				del(src.cell)
				update_icon()
				src.add_fingerprint(user)
		else
			return ..()
		return


/* taser gun definition */

/obj/item/gun/energy_base/taser
	name = "taser gun"
	icon_state = "taser"
	force = 1.0
	desc = "A weapon that produces a self-propelled energized plasma bolt." // wow actual grounds in reality

	New()
		current_projectile = new/datum/projectile/energy_bolt
		projectiles = list(current_projectile,new/datum/projectile/energy_bolt/burst)
		..()

	update_icon()
		if(cell)
			var/ratio = min(1, src.cell.charge / src.cell.maxcharge)
			ratio = round(ratio, 0.25) * 100
			src.icon_state = "taser[ratio]"
			return