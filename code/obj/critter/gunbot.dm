/obj/critter/gunbot
	name = "Robot"
	desc = "A Security Robot, something seems a bit off."
	icon = 'icons/mob/robots.dmi'
	icon_state = "syndibot"
	density = 1
	health = 50
	aggressive = 1
	defensive = 0
	wanderer = 1
	opensdoors = 1
	atkcarbon = 1
	atksilicon = 0
	atcritter = 1
	firevuln = 0.5
	brutevuln = 1
	is_syndicate = 1
	mats = 8

	seek_target()
		src.anchored = 0
		for (var/mob/living/C in hearers(src.seekrange,src))
			if (!src.alive) break
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (iscarbon(C) && src.atkcarbon) src.attack = 1
			if (istype(C, /mob/living/silicon/) && src.atksilicon) src.attack = 1

			if (src.attack)

				src.target = C
				src.oldtarget_name = C.name

				src.visible_message("<span style=\"color:red\"><b>[src]</b> fires at [src.target]!</span>")


				playsound(src.loc, "sound/weapons/Gunshot.ogg", 50, 1)
				var/tturf = get_turf(target)
				spawn(1)
					Shoot(tturf, src.loc, src)
				spawn(4)
					Shoot(tturf, src.loc, src)
				spawn(6)
					Shoot(tturf, src.loc, src)

				src.attack = 0
				return
			else continue

		if(!src.atcritter) return
		for (var/obj/critter/C in view(src.seekrange,src))
			if (!C.alive) break
			if (C.health < 0) continue
			if (C.name == src.attacker) src.attack = 1
			if (!istype(C, /obj/critter/gunbot)) src.attack = 1

			if (src.attack)

				src.target = C
				src.oldtarget_name = C.name

				src.visible_message("<span style=\"color:red\"><b>[src]</b> fires at [src.target]!</span>")

				playsound(src.loc, "sound/weapons/Gunshot.ogg", 50, 1)
				var/tturf = get_turf(target)
				spawn(1)
					Shoot(tturf, src.loc, src)
				spawn(4)
					Shoot(tturf, src.loc, src)
				spawn(6)
					Shoot(tturf, src.loc, src)

				src.attack = 0
				return
			else continue
		task = "thinking"

	CritterDeath()
		if (!src.alive) return
		..()
		var/turf/Ts = get_turf(src)
		var/obj/item/drop1 = pick(/obj/item/electronics/battery,/obj/item/electronics/board,/obj/item/electronics/buzzer,/obj/item/electronics/frame,/obj/item/electronics/resistor,/obj/item/electronics/screen,/obj/item/electronics/relay, /obj/item/parts/robot_parts/arm/left, /obj/item/parts/robot_parts/arm/right)
		var/obj/item/drop2 = pick(/obj/item/electronics/battery,/obj/item/electronics/board,/obj/item/electronics/buzzer,/obj/item/electronics/frame,/obj/item/electronics/resistor,/obj/item/electronics/screen,/obj/item/electronics/relay, /obj/item/parts/robot_parts/arm/left, /obj/item/parts/robot_parts/arm/right)

		new /obj/decal/cleanable/robot_debris(Ts)
		new drop1(Ts)
		new /obj/decal/cleanable/robot_debris(Ts)
		new drop2(Ts)
		new /obj/decal/cleanable/robot_debris(Ts)

		spawn()
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(3, 1, src)
			s.start()
			qdel(src)