
/*
    replacetext(haystack, needle, replace)

        Replaces all occurrences of needle in haystack (case-insensitive)
        with replace value.

    replaceText(haystack, needle, replace)

        Replaces all occurrences of needle in haystack (case-sensitive)
        with replace value.
*/

var/list/vowels_lower = list("a","e","i","o","u")
var/list/vowels_upper = list("A","E","I","O","U")
var/list/consonants_lower = list("b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z")
var/list/consonants_upper = list("B","C","D","F","G","H","J","K","L","M","N","P","Q","R","S","T","V","W","X","Y","Z")
var/list/symbols = list("!","?",".",",","'","\"","@","#","$","%","^","&","*","+","-","=","_","(",")","<",">","\[","\]",":",";")
var/list/numbers = list("0","1","2","3","4","5","6","7","8","9")

var/list/stinkDescs = list("nasty","unpleasant","foul","horrible","rotten","unholy",
	"repulsive","noxious","putrid","gross","unsavory","fetid","pungent","vulgar")
var/list/stinkTypes = list("smell","stink","odor","reek","stench","miasma")
var/list/stinkExclamations = list("Ugh","Good lord","Good grief","Christ","Fuck","Eww")
var/list/stinkThings = list("garbage can","trash heap","cesspool","toilet","pile of poo",
	"butt","skunk","outhouse","corpse","fart","devil")
var/list/stinkVerbs = list("took a shit","died","farted","threw up","wiped its ass")
var/list/stinkThingies = list("ass","taint","armpit","excretions","leftovers")

/proc/stinkString()
	// i am five - ISN
	switch (rand(1,4))
		if (1)
			return "[pick(stinkExclamations)], there's a \a [pick(stinkDescs)] [pick(stinkTypes)] in here..."
		if (2)
			return "[pick(stinkExclamations)], there's a \a [pick(stinkDescs)] [pick(stinkTypes)] in here..."
		if (3)
			return "[pick(stinkExclamations)], it smells like \a [pick(stinkThings)] [pick(stinkVerbs)] in here!"
		else
			return "[pick(stinkExclamations)], it smells like \a [pick(stinkThings)]'s [pick(stinkThingies)] in here!"

//For fuck's sake.
/*
/proc/bubblesort(list/L)
	var i, j
	for(i=L.len, i>0, i--)
		for(j=1, j<i, j++)
			if(L[j] > L[j+1])
				L.Swap(j, j+1)
	return L
*/
/proc/get_local_apc(O)
	var/turf/T = get_turf(O)
	if (!T)
		return null
	var/area/A = T.loc

	if (A.type == /area)
		// dont search space for an apc
		return null

	for (var/obj/machinery/power/apc/APC in A.contents)
		if (!(APC.stat & BROKEN))
			return APC

	// Lots and lots of APCs use area strings to make the blowout random event possible.
	for (var/obj/machinery/power/apc/APC2 in machines)
		var/area/A2 = null
		if (!isnull(APC2.areastring))
			A2 = get_area_name(APC2.areastring)
			if (!isnull(A2) && istype(A2) && A == A2 && !(APC2.stat & BROKEN))
				return APC2

	return null

/proc/get_area(atom/A)
	if (!istype(A))
		return
	for(A, A && !isarea(A), A=A.loc)
	return A

/proc/get_area_name(N) //get area by it's name

	for(var/area/A in world)
		if(A.name == N)
			return A
	return 0

/proc/get_area_by_type(var/type_path)
	if (!ispath(type_path))
		return null

	for (var/area/A in world)
		if (A.type == type_path)
			return A

	return null

/proc/in_range(atom/source, atom/user)
	if(bounds_dist(source, user) == 0 || get_dist(source, user) <= 1) // fucking byond
		return 1
	else if (source in bible_contents && locate(/obj/item/storage/bible) in range(1, user)) // whoever added the global bibles, fuck you
		return 1
	else
		if (iscarbon(user))
			var/mob/living/carbon/C = user
			if (C.bioHolder.HasEffect("telekinesis") && get_dist(source, user) <= 7) //You can only reach stuff within your screen.
				var/X = source:x
				var/Y = source:y
				var/Z = source:z
				if (isrestrictedz(Z) || isrestrictedz(user:z))
					boutput(user, "<span style=\"color:red\">Your telekinetic powers don't seem to work here.</span>")
					return 0
				spawn(0)
					//I really shouldnt put this here but i dont have a better idea
					var/obj/overlay/O = new /obj/overlay ( locate(X,Y,Z) )
					O.name = "sparkles"
					O.anchored = 1
					O.density = 0
					O.layer = FLY_LAYER
					O.dir = pick(cardinal)
					O.icon = 'icons/effects/effects.dmi'
					O.icon_state = "nothing"
					flick("empdisable",O)
					spawn(5)
						qdel(O)

				return 1

	return 0 //not in range and not telekinetic


var/obj/item/dummy/click_dummy = new
/proc/test_click(turf/from, turf/target)
	for (var/atom/A in from)
		if (A.flags & ON_BORDER)
			if (!A.CheckExit(click_dummy, target))
				return 0
	for (var/atom/A in target)
		if (A.flags & ON_BORDER)
			if (!A.CanPass(click_dummy, from, 1, 0))
				return 0
	return 1

/proc/can_reach(mob/user, atom/target)
	if (target in bible_contents)
		target = locate(/obj/item/storage/bible) in range(1, user) // fuck bibles
		if (!target)
			return 0
	var/turf/UT = get_turf(user)
	var/turf/TT = get_turf(target)
	if (TT)
		var/obj/cover/C = locate() in TT
		if (C && target != C)
			return 0
	if (UT && TT != UT)
		var/obj/cover/C = locate() in UT
		if (C && target != C)
			return 0
	if (isturf(user.loc))
		if (!in_range(target, user))
			return 0
		var/T1 = get_turf(user)
		var/T2 = get_turf(target)
		if (T1 == T2)
			return 1
		else
			if (!click_dummy)
				click_dummy = new

			var/dir = get_dir(T1, T2)
			if (dir & (dir-1))
				var/dir1, dir2
				switch (dir)
					if (NORTHEAST)
						dir1 = NORTH
						dir2 = EAST
					if (NORTHWEST)
						dir1 = NORTH
						dir2 = WEST
					if (SOUTHEAST)
						dir1 = SOUTH
						dir2 = EAST
					if (SOUTHWEST)
						dir1 = SOUTH
						dir2 = WEST
				var/D1 = get_step(T1, dir1)
				var/D2 = get_step(T1, dir2)

				if (test_click(T1, D1))
					if ((target.flags & ON_BORDER) || test_click(D1, T2))
						return 1
				if (test_click(T1, D2))
					if ((target.flags & ON_BORDER) || test_click(D2, T2))
						return 1
			else
				return (target.flags & ON_BORDER) || test_click(T1, T2)
	else if (isobj(target) || ismob(target))
		var/atom/L = target.loc
		while (L && !isturf(L))
			if (L == user)
				return 1
			L = L.loc
	return 0

/proc/AutoUpdateAI(obj/subject)
	if (subject!=null)
		for(var/mob/living/silicon/ai/M in mobs)
			if ((M.client && M.machine == subject))
				subject.attack_ai(M)

/proc/get_viewing_AIs(center = null, distance = world.view)
	. = list()

	for (var/mob/living/silicon/ai/theAI in mobs)
		if (istype(theAI.current) && (theAI.current in view(center, distance)) )
			. += theAI

//Kinda sorta like viewers but includes observers. In theory.
/proc/observersviewers(var/Dist=world.view, var/Center=usr)
	var/list/viewMobs = viewers(Dist, Center)

	for(var/mob/dead/target_observer/M in observers)
		if(!M.client) continue
		if(M.target in view(Dist, Center) || M.target == Center)
			viewMobs += M

	return viewMobs

/proc/AIviewers(Depth=world.view,Center=usr)
	if (istype(Depth, /atom))
		var/newDepth = isnum(Center) ? Center : world.view
		Center = Depth
		Depth = newDepth

	return viewers(Depth, Center) + get_viewing_AIs(Center, Depth)

//A unique network ID for devices that could use one
/proc/format_net_id(var/refstring)
	if(!refstring)
		return
	. = copytext(refstring,4,(length(refstring)))
	. = add_zero(., 8)


//A little wrapper around format_net_id to account for non-null tag values
/proc/generate_net_id(var/atom/the_atom)
	if(!the_atom) return
	var/tag_holder = the_atom.tag
	the_atom.tag = null //So we generate from internal ref id
	. = format_net_id("\ref[the_atom]")
	the_atom.tag = tag_holder

/proc/can_act(var/mob/M, var/include_cuffs = 1)
	if(include_cuffs) if(M.handcuffed) return 0
	if(M.stunned) return 0
	if(M.weakened) return 0
	if(M.paralysis) return 0
	if(M.stat) return 0
	return 1

#define CLUWNE_NOISE_DELAY 50

/proc/process_accents(var/mob/living/carbon/human/H, var/message)
	if (!H || !istext(message))
		return

	if (H.bioHolder)
		var/datum/bioEffect/speech/S = null
		for(var/X in H.bioHolder.effects)
			S = H.bioHolder.GetEffect(X)
			if (istype(S,/datum/bioEffect/speech/))
				message = S.OnSpeak(message)

	if (iscluwne(H))
		message = honk(message)
		if (world.time >= (H.last_cluwne_noise + CLUWNE_NOISE_DELAY))
			playsound(get_turf(H), pick("sound/voice/cluwnelaugh1.ogg","sound/voice/cluwnelaugh2.ogg","sound/voice/cluwnelaugh3.ogg"), 70, 0, 0, H.get_age_pitch())
			H.last_cluwne_noise = world.time

	if ((H.reagents && H.reagents.get_reagent_amount("ethanol") > 30 && H.stat != 2) || H.traitHolder.hasTrait("alcoholic"))
		if((H.reagents.get_reagent_amount("ethanol") > 125 && prob(20)))
			message = say_superdrunk(message)
		else
			message = say_drunk(message)

	var/datum/ailment_data/disease/berserker = H.find_ailment_by_type(/datum/ailment/disease/berserker/)
	if (istype(berserker,/datum/ailment_data/disease/) && berserker.stage > 1)
		if (prob(10))
			message = say_furious(message)
		message = replacetext(message, ".", "!")
		message = replacetext(message, ",", "!")
		message = replacetext(message, "?", "!")
		message = uppertext(message)
		var/addexc = rand(2,6)
		while (addexc > 0)
			message += "!"
			--addexc

	if(H.bioHolder && H.bioHolder.genetic_stability < 50)
		if (prob(40))
			message = say_gurgle(message)

	if(H.mutantrace && H.stat != 2)
		message = H.mutantrace.say_filter(message)

#ifdef CANADADAY
	if (prob(30)) message = replacetext(message, "?", " Eh?")
#endif

	return message


/proc/can_see(var/atom/source, var/atom/target, var/length=5) // I couldnt be arsed to do actual raycasting :I This is horribly inaccurate.
	var/turf/current = get_turf(source)
	var/turf/target_turf = get_turf(target)
	var/steps = 0

	while(current != target_turf)
		if(steps > length) return 0
		if(!current) return 0
		if(current.opacity) return 0
		for(var/atom/A in current)
			if(A.opacity) return 0
		current = get_step_towards(current, target_turf)
		steps++

	return 1


/mob/proc/get_equipped_items()
	. = list()

	if(src.back) . += src.back
	if(src.ears) . += src.ears
	if(src.wear_mask) . += src.wear_mask
	if(src.l_hand) . += src.l_hand
	if(src.r_hand) . += src.r_hand

/proc/get_step_towards2(var/atom/ref , var/atom/trg)
	var/base_dir = get_dir(ref, get_step_towards(ref,trg))
	var/turf/temp = get_step_towards(ref,trg)

	if(is_blocked_turf(temp))
		var/dir_alt1 = turn(base_dir, 90)
		var/dir_alt2 = turn(base_dir, -90)
		var/turf/turf_last1 = temp
		var/turf/turf_last2 = temp
		var/free_tile = null
		var/breakpoint = 0

		while(!free_tile && breakpoint < 10)
			if(!is_blocked_turf(turf_last1))
				free_tile = turf_last1
				break
			if(!is_blocked_turf(turf_last2))
				free_tile = turf_last2
				break
			turf_last1 = get_step(turf_last1,dir_alt1)
			turf_last2 = get_step(turf_last2,dir_alt2)
			breakpoint++

		if(!free_tile) return get_step(ref, base_dir)
		else return get_step_towards(ref,free_tile)

	else return get_step(ref, base_dir)

/proc/get_areas(var/areatype)
	//Takes: Area type as text string or as typepath OR an instance of the area.
	//Returns: A list of all areas of that type in the world.
	//Notes: Simple!
	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = new/list()

	for(var/area/R in world)
		if(istype(R, areatype))
			. += R

/proc/get_area_turfs(var/areatype, var/floors_only)
	//Takes: Area type as text string or as typepath OR an instance of the area.
	//Returns: A list of all turfs in areas of that type of that type in the world.
	//Notes: Simple!

	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = new/list()
	var/list/areas = get_areas(areatype)
	for(var/area/R in areas)
		for(var/turf/T in R)
			if(floors_only && is_blocked_turf(T))
				continue
			. += T

/proc/get_area_all_atoms(var/areatype)
	//Takes: Area type as text string or as typepath OR an instance of the area.
	//Returns: A list of all atoms	(objs, turfs, mobs) in areas of that type of that type in the world.
	//Notes: Simple!

	if(!areatype) return null
	if(istext(areatype)) areatype = text2path(areatype)
	if(isarea(areatype))
		var/area/areatemp = areatype
		areatype = areatemp.type

	. = new/list()
	var/list/areas = get_areas(areatype)
	for(var/area/R in areas)
		for(var/atom/A in R)
			. += A

/datum/coords //Simple datum for storing coordinates.
	var/x_pos = null
	var/y_pos = null
	var/z_pos = null


/datum/color	//Simple datum for RGBA colours
			  	// used as an alternative to rgb() proc
			  	// for ease of access to components
	var/r = null	// all stored as 0-255
	var/g = null
	var/b = null
	var/a = null

	New(_r,_g,_b,_a=255)
		r = _r
		g = _g
		b = _b
		a = _a

	// return in #RRGGBB hex form
	proc/to_rgb()
		return rgb(r,g,b)

	// return in #RRGGBBAA hex form
	proc/to_rgba()
		return rgb(r,g,b,a)


/area/proc/move_contents_to(var/area/A, var/turftoleave=null)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.

	var/testmove = 0


//	if(prob(5)) testmove = 1

	if(!A || !src) return 0

	var/list/turfs_src = get_area_turfs(src.type)
	var/list/turfs_trg = get_area_turfs(A.type)

	var/src_min_x = 0
	var/src_min_y = 0
	for (var/turf/T in turfs_src)
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y

	//DEBUG("src_min_x = [src_min_x], src_min_y = [src_min_y]")
	var/trg_min_x = 0
	var/trg_min_y = 0
	for (var/turf/T in turfs_trg)
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y

	//DEBUG("trg_min_x = [src_min_x], trg_min_y = [src_min_y]")

	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

	var/list/fromupdate = new/list()
	var/list/toupdate = new/list()

	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state

					var/turf/X
					if(testmove) X = new T.type(get_step(B,pick(cardinal))) //remove this
					else X = new T.type (B)
					X.dir = old_dir1
					X.icon_state = old_icon_state1

					for(var/obj/O in T)
						if (!istype(O, /obj) || istype(O, /obj/forcefield)) continue
						O.set_loc(X)
					for(var/mob/M in T)
						//DEBUG("Moving mob [M] from [T] to [X].")
						if(!istype(M,/mob)) continue
						M.set_loc(X)

					var/area/AR = X.loc

					if(AR.RL_Lighting)
						X.opacity = !X.opacity
						X.RL_SetOpacity(!X.opacity)

					toupdate += X

					if(turftoleave)
						var/turf/ttl = new turftoleave(T)

						var/area/AR2 = ttl.loc

						if(AR2.RL_Lighting)
							ttl.opacity = !ttl.opacity
							ttl.RL_SetOpacity(!ttl.opacity)

						fromupdate += ttl

					else
						T.ReplaceWithSpace()

					refined_src -= T
					refined_trg -= B
					continue moving

	var/list/doors = new/list()

	if(toupdate.len)
		for(var/turf/simulated/T1 in toupdate)
			for(var/obj/machinery/door/D2 in T1)
				doors += D2
			if(T1.parent)
				air_master.queue_update_group(T1.parent)
			else
				air_master.queue_update_tile(T1)

	if(fromupdate.len)
		for(var/turf/simulated/T2 in fromupdate)
			for(var/obj/machinery/door/D2 in T2)
				doors += D2
			if(T2.parent)
				air_master.queue_update_group(T2.parent)
			else
				air_master.queue_update_tile(T2)

	for(var/obj/O in doors)
		O:update_nearby_tiles(1)



// return description of how full a container is
proc/get_fullness(var/percent)

	if(percent == 0)
		return "empty"
	if(percent < 2)
		return "nearly empty"
	if(percent < 24)
		return "less than a quarter full"
	if(percent < 26)
		return "a quarter full"
	if(percent < 37)
		return "more than a quarter full"
	if(percent < 49)
		return "less than half full"
	if(percent < 51)
		return "half full"
	if(percent < 62)
		return "more than half full"
	if(percent < 74)
		return "less than three-quarters full"
	if(percent < 76)
		return "three-quarters full"
	if(percent < 97)
		return "more than three-quarters full"
	if(percent < 99.5)
		return "nearly full"
	return "full"

// return description of transparency/opaqueness

proc/get_opaqueness(var/trans)	// 0=transparent, 255=fully opaque
	if(trans < 25)
		return "clear"
	if(trans < 60)
		return  "transparent"
	if(trans< 150)
		return "mostly transparent"
	if(trans <200)
		return "dense"
	return "opaque"

proc/LoadSavefile(name)
	. = new/savefile(name)