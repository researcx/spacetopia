/obj/machinery/fogmachine
	name = "FogMachine-3000"
	desc = "The FogMachine-3000 is guaranteed to suit all of your fog-filled needs. Just put the FogMaster FogFluid into the FogMachine-3000 Chemical Funnel Duct and then turn the FogMachine-3000. The FogMachine-3000 will cease to pump fog when the fluid resevoir is empty."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "fogmachine0"


	var/on = 0

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		return

	process()
		if(reagents.has_reagent("radium"))
			src.reagents.clear_reagents()
			src.visible_message("<span style=\"color:red\">The <B>[src]</B> makes an odd sound, and releases a puff of green steam.</span>")

		if(on == 1)
			if(reagents.reagent_list.len < 1 || reagents.total_volume < 1)
				on = 0
				icon_state = "fogmachine0"

				src.visible_message("<span style=\"color:red\">The <B>[src]</B> splutters to a halt.</span>")
				playsound(src, 'sound/machines/ding.ogg', 50, 1)
			else
				spawn(50)
					var/datum/chemical_reaction/smoke/S = new
					S.on_reaction(reagents)
					reagents.total_volume -= 5
					if (reagents.total_volume < 5)
						reagents.total_volume = 0
						reagents.clear_reagents()
					return
		else
			return



	attackby(var/obj/item/reagent_containers/C as obj, var/mob/user as mob)
		if(!istype(C, /obj/item/reagent_containers))
			return
		if(istype(C, /obj/item/reagent_containers/glass))
			if(C.reagents.reagent_list.len < 1)
				boutput(user, "[C] is empty.")
				return
			else
				boutput(user, "You pour the contents of [C] into the funnel.")


				for(var/current_id in C.reagents.reagent_list)
					var/datum/reagent/current_reagent = C.reagents.reagent_list[current_id]

					if(current_reagent.id == "radium")
						C.reagents.del_reagent("radium")
						boutput(user, "The [src] vapourizes the radium.")
					else
						reagents.add_reagent(current_id, 10, null, null, 1)

				C.reagents.clear_reagents()
				playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
				return
		else
			boutput(user, "You put [C] into the funnel.")

			for(var/current_id in C.reagents.reagent_list)
				var/datum/reagent/current_reagent = C.reagents.reagent_list[current_id]

				if(current_reagent.id == "radium")
					C.reagents.del_reagent("radium")
					boutput(user, "The [src] vapourizes the radium.")
				else
					reagents.add_reagent(current_id, 10, null, null, 1)

			qdel(C)
			playsound(src, 'sound/effects/pop.ogg', 50, 1)
			return


	attack_hand(mob/user as mob)
		if(on == 0)
			on = 1
			boutput(user, "<span style=\"color:orange\">You flip the switch on the FogMachine-3000 to the On position.</span>")
			playsound(src, 'sound/machines/click.ogg', 50, 1)
			return
		if(on == 1)
			on = 0
			playsound(src, 'sound/machines/click.ogg', 50, 1)
			boutput(user, "<span style=\"color:orange\">You flip the switch on the FogMachine-3000 to the Off position.</span>")
			return



/proc/honk(var/string)
	var/modded = ""
	var/list/text_tokens = splittext(string, " ")
	for(var/token in text_tokens)
		modded += "HONK "
	modded += "HONK!"
	if(prob(15))
		modded += " - HOOOOOONNNKKK!!!"

	return modded

/obj/machinery/bathtub
	name = "bathtub"
	desc = "Now, that looks cosy!"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "bathtub"
	flags = OPENCONTAINER
	var/static/image/fluid_icon = image("icon" = 'icons/obj/stationobjs.dmi', "icon_state" = "fluid_bathtub")
	var/static/image/fluid_icon_feet = image("icon" = 'icons/obj/stationobjs.dmi', "icon_state" = "fluid_bathtub_feet")
	var/static/image/bath_edge = image("icon" = 'icons/obj/stationobjs.dmi', "icon_state" = "bath_edge", "layer" = FLOAT_LAYER)
	var/mob/living/carbon/human/myuser = null

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(500)
		reagents = R
		R.my_atom = src
		return


	get_desc(dist, mob/user)
		if (dist > 2)
			return
		if (!reagents)
			return
		. += "<br><span style=\"color:orange\">[reagents.get_description(user,RC_FULLNESS|RC_VISIBLE|RC_SPECTRO)]</span>"
		return

	on_reagent_change()
		src.overlays = null

		if(reagents.total_volume)
			icon_state = "bathtub"

			src.overlays += fluid_icon

		if(src.myuser)
			src.overlays += src.myuser
			if(reagents.total_volume)
				src.overlays += fluid_icon_feet

		src.overlays += bath_edge

	attack_hand(mob/user as mob)
		if (src.myuser)
			boutput(user, "<span style=\"color:red\">You pull [src.myuser] out of the bath!</span>")
			src.eject_user()
		else
			boutput(user, "<span style=\"color:orange\">You pull the plug.</span>")
			src.reagents.clear_reagents()
			src.on_reagent_change()
			var/count = 0
			for (var/obj/O in src)
				count++
				qdel(O)
			if (count > 0)
				boutput(user, "<span style=\"color:red\">...and flush something down the drain. Damn!</span>")
		return

	proc/eject_user()
		if (src.myuser)
			src.myuser.pixel_y = 0
			src.myuser.set_loc(get_turf(src))
			src.myuser = null
			src.on_reagent_change()

			for (var/obj/O in src)
				O.set_loc(get_turf(src))
		return

	relaymove(mob/user as mob, dir)
		src.eject_user()
		boutput(user, "<span style=\"color:orange\">You get out of the bath.</span>")


	process()
		if (src.myuser)
			if(src.myuser.loc != src)
				src.myuser.pixel_y = 0
				src.myuser = null
				src.overlays = null
				on_reagent_change()

				return
			if(src.reagents.total_volume > 5)
				reagents.reaction(src.myuser, TOUCH)
				src.reagents.trans_to(src.myuser,5,1)
			else
				src.reagents.clear_reagents()
				on_reagent_change()

		return

	MouseDrop_T(mob/living/carbon/human/target, mob/user)
		if (src.myuser || !istype(target) || target.buckled || LinkBlocked(target.loc,src.loc) || get_dist(user, src) > 1 || get_dist(user, target) > 1 || user.paralysis || user.stunned || user.weakened || user.stat || istype(user, /mob/living/silicon/ai))
			return

		var/msg

		if(target == user && !user.stat)	// if drop self, then climbed in
			msg = "[user.name] climbs into [src]."
			boutput(user, "<span style=\"color:orange\">You climb into [src].</span>")

		else if(target != user && !user.restrained())
			msg = "[user.name] push [target.name] into the [src]!"
			boutput(user, "<span style=\"color:orange\">You push [target.name] into the [src]!</span>")

		else
			return

		target.set_loc(src)
		src.myuser = target
		src.myuser.pixel_y += 5
		src.on_reagent_change()

		for (var/mob/C in viewers(src))
			if(C == user)
				continue
			C.show_message(msg, 3)


		return

	is_open_container()
		return 1

/obj/item/clothing/head/apprentice
	proc/fantasia()
		if(ticker && ticker.mode && istype(ticker.mode, /datum/game_mode/wizard))
			for (var/obj/item/mop/M in orange(5,src))
				src.visible_message("<span style=\"color:red\">[src] begins to twitch and move!</span>")
				var/moveto = locate(M.x + rand(-1,1),M.y + rand(-1, 1),src.z)
				//make the mops move
				if (istype(moveto, /turf/simulated/floor) || istype(moveto, /turf/simulated/shuttle/floor) || istype(moveto, /turf/simulated/aprilfools/floor) || istype(moveto, /turf/unsimulated/floor) || istype(moveto, /turf/unsimulated/aprilfools)) step_towards(M, moveto)
				spawn(50)
					src.visible_message("<span style=\"color:orange\">Thankfully, [src] settles down.</span>")
		else
			for (var/obj/item/mop/M in orange(5,src))
				src.visible_message("<span style=\"color:red\">[src] begins to twitch and mov- oh. No. No it doesn't.</span>")

/obj/item/clothing/head/apprentice/equipped(var/mob/user, var/slot)
	boutput(user, "<span style=\"color:orange\">Your head tingles with magic! Or asbestos. Probably asbestos.</span>")
	src.fantasia()
	..()