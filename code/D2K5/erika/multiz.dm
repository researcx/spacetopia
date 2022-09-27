/obj/multiz
	icon = 'icons/d2k5/multiz.dmi'
	density = 0
	opacity = 0
	anchored = 1
	var/istop = 1

	CanPass(obj/mover, turf/source, height, airflow)
		return airflow || !density

/obj/multiz/proc/targetZ()
	return src.z + (istop ? 1 : -1)

/obj/multiz/ladder
	icon_state = "ladderdown"
	name = "ladder"
	desc = "A Ladder.  You climb up and down it."

/obj/multiz/ladder/New()
	..()
	if (!istop)
		icon_state = "ladderup"
	else
		icon_state = "ladderdown"

/obj/multiz/ladder/attackby(var/W, var/mob/M)
	return attack_hand(M)

/obj/multiz/ladder/attack_hand(var/mob/M)
	M.Move(locate(src.x, src.y, targetZ()))

//Stairs.  var/dir on all four component objects should be the dir you'd walk from top to bottom
/obj/multiz/stairs
	name = "Stairs"
	desc = "Stairs.  You walk up and down them."
	icon_state = "ramptop"

/obj/multiz/stairs/New()
	icon_state = istop ^ istype(src, /obj/multiz/stairs/active) ? "ramptop" : "rampbottom"

/obj/multiz/stairs/enter/bottom
	istop = 0

/obj/multiz/stairs/active
	density = 1

/obj/multiz/stairs/active/Bumped(var/atom/movable/M)
	if(istype(src, /obj/multiz/stairs/active/bottom) && !locate(/obj/multiz/stairs/enter) in M.loc)
		return //If on bottom, only let them go up stairs if they've moved to the entry tile first.
	//If it's the top, they can fall down just fine.
	if(ismob(M) && M:client)
		M:client.moving = 1
	M.Move(locate(src.x, src.y, targetZ()))
	if (ismob(M) && M:client)
		M:client.moving = 0

/obj/multiz/stairs/active/Click()
	if(!istype(usr,/mob/dead/observer))
		return ..()
	usr.client.moving = 1
	usr.Move(locate(src.x, src.y, targetZ()))
	usr.client.moving = 0

/obj/multiz/stairs/active/bottom
	istop = 0
	opacity = 1


/obj/multiz/lift
	name = "Lift"
	icon = 'icons/d2k5/lifts.dmi'
	icon_state = "lift_open"
	pixel_y = 18
	pixel_x = 1
	var/tplevel = 1
	var/tplocations = list("Floor 0", "Floor 1", "Floor 2", "Floor 3")
	var/lift_top
	var/lift_door_closing
	var/lift_door_opening

/obj/multiz/lift/New()
	lift_top = image("icon" = 'icons/d2k5/lifts.dmi', "icon_state" = "lift_top", "layer" = src.layer + 1)
	lift_door_closing = image("icon" = 'icons/d2k5/lifts.dmi', "icon_state" = "lift_door_closing", "layer" = src.layer + 2)
	lift_door_opening = image("icon" = 'icons/d2k5/lifts.dmi', "icon_state" = "lift_door_opening", "layer" = src.layer + 2)

/obj/multiz/lift/attack_hand(mob/user as mob)
	var/tplocation = input(user, "Please select a floor:", "Lift") as null|anything in tplocations

	if (tplocation)
		icon_state = "lift"
		user.loc = src
		user.pixel_y = 4
		user.pixel_x = -1


		src.overlays += user
		src.overlays += lift_top

		src.UpdateOverlays(src.lift_door_closing, "doorstate")

		sleep(15)

		src.overlays -= user
		src.overlays -= lift_top
		src.overlays -= lift_door_closing

		src.UpdateOverlays(src.lift_door_opening, "doorstate")

		icon_state = "lift_open"

		user.pixel_y = 0
		user.pixel_x = 0

		if(tplocation == "Floor 0")
			tplevel = 1

		if(tplocation == "Floor 1")
			tplevel = 2

		if(tplocation == "Floor 2")
			tplevel = 3

		if(tplocation == "Floor 3")
			tplevel = 4

		user.dir = 2
		user.loc = get_turf(src)
		user.Move(locate(user.x, user.y, tplevel))
