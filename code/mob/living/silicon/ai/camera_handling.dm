// Double clicking turfs to move to nearest camera

/turf/proc/move_camera_by_click()
	if (usr.stat || !isAI(usr))
		return ..()
	//try to find the closest working camera in the same area, switch to it

	var/area/A = get_area(src)
	if (A && A.type == /area || usr:tracker.tracking) return //lol @ dumping you at the mining magnet every fucking time. (or interrupting a track, wow rude)

	var/best_dist = INFINITY //infinity
	var/best_cam = null

	for(var/obj/machinery/camera/C in A)
		if(usr:network != C.network)
			continue	//	different network (syndicate)
		if(C.z != usr.z)
			continue	//	different viewing plane
		if(!C.status)
			continue	//	ignore disabled cameras
		var/dist = get_dist(src, C)
		if(dist < best_dist)
			best_dist = dist
			best_cam = C

	if(!best_cam)
		return ..()
	//usr:cameraFollow = null
	usr:tracker.cease_track()
	usr:switchCamera(best_cam)

/mob/living/silicon/ai/proc/ai_camera_list()
	set category = "AI Commands"
	set name = "Show Camera List"

	if(usr.stat == 2)
		boutput(usr, "You can't track with camera because you are dead!")
		return

	attack_ai(src)

#define SORT "* Sort alphabetically..."

/mob/living/silicon/ai/proc/ai_camera_track()
	set category = "AI Commands"
	set name = "Track With Camera"
	if(usr.stat == 2)
		boutput(usr, "You can't track with camera because you are dead!")
		return

	var/list/creatures = get_mobs_trackable_by_AI()

	var/target_name = input(usr, "Which creature should you track?") as null|anything in creatures

	//sort alphabetically if user so chooses
	if (target_name == SORT)
		creatures.Remove(SORT)

		creatures = sortList(creatures)

		/* lol bubblesort FU
		for(var/i = 1; i <= creatures.len; i++)
			for(var/j = i+1; j <= creatures.len; j++)
				if(sorttext(creatures[i], creatures[j]) == -1)
					creatures.Swap(i, j)
		*/

		//redisplay sorted list
		target_name = input(usr, "Which creature should you track?") as null|anything in creatures

	if (!target_name)
		//usr:cameraFollow = null
		src.tracker.cease_track()
		return

	var/mob/target = creatures[target_name]

	ai_actual_track(target)
#undef SORT

/mob/living/silicon/ai/proc/ai_actual_track(mob/target as mob)
	if (isnull(target) || !ismob(target))
		return

	src.tracker.begin_track(target)

/proc/camera_sort(var/list/L, var/start=1, var/end=-1)
	if(!L || !L.len) return //Fucka you
	if(end == -1) end = L.len	//Called without start / end parameters
	if( start < end)
		var/obj/machinery/camera/C
		var/obj/machinery/camera/P

		var/pivot = start + round(abs(end - start) / 2 )
		P = L[pivot]
		L.Swap(end, pivot)
		pivot = start
		if (!istype(P)) CRASH("Fuck you, this list does not contain only cameras!")

		for(var/i = start; i < end; i++)
			C = L[i]
			if (!istype(C)) CRASH("Fuck you, this list does not contain only cameras!")

			//Okay, sort on c_tag_order then c_tag
			if(C.c_tag_order != P.c_tag_order)
				if(C.c_tag_order < P.c_tag_order)
					L.Swap(i, pivot)
					pivot++
			else
				if(sorttext(C.c_tag, P.c_tag) > 0)
					L.Swap(i, pivot)
					pivot++

		L.Swap(pivot, end)

		L = .(L, start, pivot - 1)
		L = .(L, pivot + 1, end)

	return L

/mob/living/silicon/ai/attack_ai(var/mob/user as mob)
	if (user != src)
		return

	if (stat == 2 || !src.classic_move)
		return

	user.machine = src

	var/list/L = list()
	for (var/obj/machinery/camera/C in machines)
		L.Add(C)

	L = camera_sort(L)

	var/list/D = list()
	var/counter = 1
	D["Cancel"] = "Cancel"
	for (var/obj/machinery/camera/C in L)
		if (C.network == src.network)
			var/T = text("[][]", C.c_tag, (C.status ? null : " (Deactivated)"))
			if(D[T])
				D["[T] #[counter++]"] = C
			else
				D[T] = C
				counter = 1

	var/t = input(user, "Which camera should you change to?") as null|anything in D

	if (!t || t == "Cancel")
		//src.cameraFollow = null
		src.tracker.cease_track()
		src.switchCamera(null)
		return 0

	var/obj/machinery/camera/C = D[t]

	switchCamera(C)

	return


/datum/ai_camera_tracker
	var/mob/tracking = null
	var/mob/living/silicon/ai/owner = null

	var/last_track = 0	//When did we do the last tracking attempt?
	var/delay = 10		//How long should we wait between attempts?

	var/success_delay = 5	//How long between refreshes if we succeeded in tracking someone?
	var/fail_delay = 50		// Same but in case we failed

	New(var/mob/living/silicon/ai/A)
		owner = A
		global.tracking_list += src

	disposing()
		owner = null
		tracking = null
		global.tracking_list -= src

	proc/begin_track(mob/target as mob)
		if(!owner || !target)
			return

		tracking = target
		if(!owner.machine)
			owner.machine = owner

		process() //Process now!!!

	proc/cease_track()
		tracking = null
		delay = success_delay

	proc/process()
		if(!tracking || !owner || ( ( (last_track + delay) > world.timeofday ) && (world.timeofday > last_track) ) )
			return


		var/failedToTrack = 0
		if (!can_track(tracking))
			failedToTrack = 1

		if(!failedToTrack) //We don't have a premature failure
			failedToTrack = 1 //Assume failure
			for(var/obj/machinery/camera/C in range(7, tracking))
				if(C.network == owner.network && C.status) //The goodest camera
					failedToTrack = 0
					owner.switchCamera(C)
					break
		/*
		else
			sleep(rand(0,1)) //Hey it went real fast this time! Bet it's a syndie
		*/

		if (failedToTrack)
			owner.show_text("Target is not on or near any active cameras on the station. We'll check again in 5 seconds (unless you use the cancel-camera verb).")
			delay = fail_delay
		else
			delay = success_delay

		last_track = world.timeofday

	proc/can_track(mob/target as mob)
		//Allow tracking of cyborgs, however
		//Track autofails if:
		//Target is wearing a syndicate ID
		//Target is inside a dummy
		//Target is not at a turf
		return (issilicon(target) && istype(target.loc, /turf) ) \
				|| !((istype(target, /mob/living/carbon/human) \
				&& istype(target:wear_id, /obj/item/card/id/syndicate)) \
				|| (istype(target:wear_id, /obj/item/device/pda2) && target:wear_id:ID_card && istype(target:wear_id:ID_card, /obj/item/card/id/syndicate)) \
				||  !istype(target.loc, /turf))
