//CONTENTS:
//Mobile (On rails) AI
//The rails themselves (In here for now)
//The AI's rail drone (Also in here for now)


/mob/living/silicon/ai/mobile
	name = "AI"
	icon = 'icons/mob/mobile_ai.dmi'
	voice_name = "synthesized voice"
	icon_state = "ai"
	network = "SS13"
	pixel_y = 15
	layer = MOB_LAYER
	luminosity = 4
	announcearrival = 0
	classic_move = 0
	a_intent = "disarm" //So we don't get brohugged right off a rail.
	var/malf = 0
	var/mob/living/silicon/hivebot/drone/drone = null
	var/setup_charge_maximum = 1200

	New()
		..()

		src.cell = new /obj/item/cell(src)
		src.cell.maxcharge = setup_charge_maximum
		src.cell.charge = src.cell.maxcharge
		spawn(6)
			var/obj/overlay/U1 = new
			U1.icon = src.icon
			U1.icon_state = "aitrack"
			U1.pixel_y = -2
			src.underlays = list(U1)

			src.set_face()
		return

	Login()
		..()
		if (src.stat != 2)
			src.set_face()
		return

	Logout()

		if(src.drone)
			src.set_face("idle")
		else
			src.overlays.len = 0

		..()
		return

	attack_ai(mob/user as mob)
		if(user && (user == src.drone) && isdrone(user) )
			user:return_mainframe()

		return


	Bump(atom/movable/AM as mob|obj, yes)
		if ((!( yes ) || src.now_pushing))
			return
		src.now_pushing = 1

		if (isdrone(AM))
			var/mob/tmob = AM
			var/turf/oldloc = src.loc
			src.set_loc(tmob.loc)
			tmob.set_loc(oldloc)
			src.now_pushing = 0
			return

		src.now_pushing = 0
		spawn(0)
			..()
			if (!istype(AM, /atom/movable))
				return
			if (!src.now_pushing)
				src.now_pushing = 1
				if (!AM.anchored)
					var/t = get_dir(src, AM)
					step(AM, t)
				src.now_pushing = null
			return
		return

	Life(datum/controller/process/mobs/parent)
		if (..(parent))
			return 1
		var/turf/T = get_turf(src)

		if (src.stat == 2)
			return

		if (src.stat!=0)
			//src:cameraFollow = null
			src.tracker.cease_track()
			src:current = null
			src:machine = null

		src.updatehealth()


		if (src.health <= -100.0)
			death()
			return
		else if (src.health < 0)
			src.death_timer -= 1
		else
			src.death_timer = max(0,min(src.death_timer + 5,100))

		//var/stage = 0
		if (src.client)
			//stage = 1
			if (istype(src, /mob/living/silicon/ai))
				var/blind = 0
				//stage = 2
				var/area/loc = null
				if (istype(T, /turf))
					//stage = 3
					loc = T.loc
					if (istype(loc, /area))
						//stage = 4
						if (!loc.power_equip)
							//stage = 5
							blind = 1

				if (!blind)
					vision.set_color_mod("#ffffff")
					src.sight |= SEE_TURFS | SEE_MOBS | SEE_OBJS
					src.see_in_dark = SEE_DARK_FULL
					src.see_invisible = 2
				else
					vision.set_color_mod("#000000")
					src.sight = src.sight & ~(SEE_TURFS | SEE_MOBS | SEE_OBJS)
					src.see_in_dark = 0
					src.see_invisible = 0

					if ((!loc.power_equip) || istype(T, /turf/space))
						if (src:aiRestorePowerRoutine==0)
							src:aiRestorePowerRoutine = 1
							boutput(src, "You've lost power!")
							spawn(50)
								while ((src:aiRestorePowerRoutine!=0) && stat!=2)
									src.death_timer -= 1
									sleep(50)

		src.check_power()

	set_face(var/emotion)
		src.overlays.len = 0
		if(src.stat || src.malf)
			if(src.stat == 2)
				src.icon_state = "ai-crash"
			return

		if(!emotion)
			emotion = "neutral"

		src.overlays += image(src.icon, "aiface-[emotion]")
		return

	proc
		check_power()
			if(src.cell)
				var/area/A = get_area(src)
				if (A && A.powered(EQUIP) && !istype(src.loc, /turf/space))
					src.cell.give(5)
					src.stat = 0
					return
				else
					if (src.cell.charge <= 100)
						src.stat = 1
						src.cell.use(1)
					else
						src.cell.use(10)
						src.stat = 0

			else
				src.stat = 1
			return

//The AI's movement rails
/obj/rail
	name = "rail"
	desc = "A rail designed to convey specialized industrial equipment."
	icon = 'icons/mob/mobile_ai.dmi'
	icon_state = "intact"
	layer = AI_RAIL_LAYER
	anchored = 1
	var/bitdir = 0 //Valid direction bitflags

	New()
		..()
		setup_bitdir()
		return

	proc/setup_bitdir()
		if(dir in cardinal)
			bitdir = dir | turn(dir, 180)
		else
			bitdir = dir | turn(dir, 90)
		return

	junction
		name = "rail junction"
		icon_state = "junction"

		setup_bitdir()
			bitdir = dir | turn(dir,180) | turn(dir, 90)
			return

	cap
		icon_state = "cap"

		setup_bitdir()
			bitdir = turn(dir,180)
			return

//The Drone. Think of GERTY's various arms and what not. WIP.
/mob/living/silicon/hivebot/drone
	name = "Drone"
	icon = 'icons/mob/mobile_ai.dmi'
	icon_state = "drone"
	pixel_y = 15
	layer = MOB_LAYER
	anchored = 1

	New()
		..()
		spawn(6)
			var/obj/overlay/U1 = new
			U1.icon = src.icon
			U1.icon_state = "railtrack"
			U1.pixel_y = -2
			src.underlays = list(U1)
		return

	attack_ai(mob/user as mob)
		if(!isAI(user))
			return

		if(user == src || (src.mainframe && src.mainframe != user))
			return

		src.mainframe = user
		src.dependent = 1
		user:drone = src
		if(!user.mind) //How does this even happen?
			user.mind = new /datum/mind(user)
			ticker.minds += user.mind

		user.mind.transfer_to(src)
		return

	return_mainframe()
		if(!isAI(src.mainframe) || !src.mind)
			boutput(src, "<span style=\"color:red\">--Host System Error</span>")
			return 1

		src.mind.transfer_to(src.mainframe)
		var/mob/living/silicon/ai/mobile/ai = src.mainframe
		ai.drone = null
		src.mainframe = null
		src.dependent = 0
		return 0

	Bump(atom/movable/AM as mob|obj, yes)
		if ((!( yes ) || src.now_pushing))
			return
		src.now_pushing = 1
		if (isAI(AM) || isdrone(AM))
			var/mob/tmob = AM
			var/turf/oldloc = src.loc
			src.set_loc(tmob.loc)
			tmob.set_loc(oldloc)
			src.now_pushing = 0
			return

		src.now_pushing = 0
		spawn(0)
			..()
			if (!istype(AM, /atom/movable))
				return
			if (!src.now_pushing)
				src.now_pushing = 1
				if (!AM.anchored)
					var/t = get_dir(src, AM)
					step(AM, t)
				src.now_pushing = null
			return
		return
/* deprecated, see _macros.dm - drsingh
/proc/isdrone(var/mob/M)
	if (istype(M, /mob/living/silicon/hivebot/drone))
		return 1
	return 0
*/
/client/proc/DroneMove(n,direct,var/mob/living/silicon/hivebot/drone/user)
	if(!user) return

	if(!(direct in cardinal))
		return

	var/obj/rail/oldrail = locate() in user.loc
	var/obj/rail/railcheck = locate() in n
	if(!istype(railcheck) || (oldrail && !(oldrail.bitdir & direct)) )
		return

	var/flipdir = turn(direct, 180)
	if(!(railcheck.bitdir & flipdir))
		return

	src.move_delay = world.time + 3.5
	user.Move(n,direct)
	return