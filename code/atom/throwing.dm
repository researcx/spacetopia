/atom/var/throw_count = 0	  //Counts up for tiles traveled in throw mode. Only resets for mobs.
/atom/var/throw_unlimited = 0 //Setting this to 1 before throwing will make the object behave as if in space.
/atom/var/throw_return = 0    //When 1 item will return like a boomerang.
/mob/var/gib_flag = 0 	      //Sorry about this.

/atom/movable/proc/hit_check()
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if (!src.throwing)
				break
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A)
				src.throwing = 0
			// **TODO: Better behaviour for windows
			// which are dense, but shouldn't always stop movement
			if(isobj(A))
				if(!A.CanPass(src, src.loc, 1.5))
					src.throw_impact(A)
					src.throwing = 0

/atom/proc/throw_begin(atom/target)
	return

/atom/proc/throw_impact(atom/hit_atom)

	if(src.material) src.material.triggerOnAttack(src, src, hit_atom)
	for(var/atom/A in hit_atom)
		if(A.material)
			A.material.triggerOnAttacked(A, src, hit_atom, src)

	if (reagents)
		reagents.physical_shock(7)

	if(iscarbon(hit_atom))
		var/mob/living/carbon/human/C = hit_atom //fuck you, monkeys

		if (!ismob(src))
			if (C.juggling())
				if (prob(40))
					C.visible_message("<span style=\"color:red\"><b>[C]<b> gets hit in the face by [src]!</span>")
					if (hasvar(src, "throwforce"))
						C.TakeDamage("head", src:throwforce, 0)
						if (ishuman(C) && C.job == "Clown")
							score_clownabuse++
				else
					if (prob(C.juggling.len * 5)) // might drop stuff while already juggling things
						C.drop_juggle()
					else
						C.add_juggle(src)
				return

		if(((C.in_throw_mode && C.a_intent == "help") || (C.client && C.client.check_key("shift"))) && !C.equipped())
			if((C.hand && (!C.limbs.l_arm)) || (!C.hand && (!C.limbs.r_arm)) || C.handcuffed || (prob(60) && C.bioHolder.HasEffect("clumsy")) || ismob(src))
				C.visible_message("<span style=\"color:red\">[C] has been hit by [src].</span>")
				// Added log_reagents() calls for drinking glasses. Also the location (Convair880).
				logTheThing("combat", C, null, "is struck by [src] [src.is_open_container() ? "[log_reagents(src)]" : ""] at [log_loc(C)].")
				if(src.vars.Find("throwforce"))
					random_brute_damage(C, src:throwforce)
					if (ishuman(C))
						if (C.job == "Clown")
							score_clownabuse++

			#ifdef DATALOGGER
				game_stats.Increment("violence")
			#endif

				if(src.vars.Find("throwforce") && src:throwforce >= 40)
					C.throw_at(get_edge_target_turf(C,get_dir(src, C)), 10, 1)
					C.stunned += 3

				if(ismob(src)) src:throw_impacted()

			else
				src.attack_hand(C)	// nice catch, hayes. don't ever fuckin do it again
				C.visible_message("<span style=\"color:red\">[C] catches the [src.name]!</span>")
				logTheThing("combat", C, null, "catches [src] [src.is_open_container() ? "[log_reagents(src)]" : ""] at [log_loc(C)].")
				C.throw_mode_off()
			#ifdef DATALOGGER
				game_stats.Increment("catches")
			#endif

		else //you're all thumbs!!!
			C.visible_message("<span style=\"color:red\">[C] has been hit by [src].</span>")
			logTheThing("combat", C, null, "is struck by [src] [src.is_open_container() ? "[log_reagents(src)]" : ""] at [log_loc(C)].")
			if(src.vars.Find("throwforce"))
				random_brute_damage(C, src:throwforce)
				if (istype(C, /mob/living/carbon/human))
					if (C.job == "Clown") score_clownabuse++

		#ifdef DATALOGGER
			game_stats.Increment("violence")
		#endif

			if(src.vars.Find("throwforce") && src:throwforce >= 40)
				C.throw_at(get_edge_target_turf(C,get_dir(src, C)), 10, 1)
				C.stunned += 3

			if(ismob(src)) src:throw_impacted()

	else if(issilicon(hit_atom))
		var/mob/living/silicon/S = hit_atom
		S.visible_message("<span style=\"color:red\">[S] has been hit by [src].</span>")
		logTheThing("combat", S, null, "is struck by [src] [src.is_open_container() ? "[log_reagents(src)]" : ""] at [log_loc(S)].")
		if(src.vars.Find("throwforce"))
			random_brute_damage(S, src:throwforce)

	#ifdef DATALOGGER
		game_stats.Increment("violence")
	#endif

		if(src.vars.Find("throwforce") && src:throwforce >= 40)
			S.throw_at(get_edge_target_turf(S,get_dir(src, S)), 10, 1)

		if(ismob(src)) src:throw_impacted()


	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored) step(O, src.dir)
		O.hitby(src)
		if(ismob(src)) src:throw_impacted()
		if(O && src.vars.Find("throwforce") && src:throwforce >= 40)
			if(!O.anchored && !O.throwing)
				O.throw_at(get_edge_target_turf(O,get_dir(src, O)), 10, 1)
			else if(src:throwforce >= 80 && !isrestrictedz(O.z))
				O.meteorhit(src)

	else if(isturf(hit_atom))
		var/turf/T = hit_atom
		if(T.density)
			//spawn(2) step(src, turn(src.dir, 180))
			if(ismob(src)) src:throw_impacted()
			/*if(istype(hit_atom, /turf/simulated/wall) && istype(src, /obj/item))
				var/turf/simulated/wall/W = hit_atom
				W.take_hit(src)*/
			if(src.vars.Find("throwforce") && src:throwforce >= 80)
				T.meteorhit(src)

/atom/movable/Bump(atom/O)
	if(src.throwing)
		src.throw_impact(O)
		src.throwing = 0
	..()

/atom/movable/proc/throw_at(atom/target, range, speed)
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target
	if (!target) return
	src.throwing = 1
	src.throw_begin(target)

	//Gotta do this in 4 steps or byond decides that the best way to interpolate between (0 and) 180 and 360 is to just flip the icon over, not turn it.
	if(!istype(src)) return

	var/matrix/transform_original = src.transform
	animate(src, transform = matrix(transform_original, 120, MATRIX_ROTATE | MATRIX_MODIFY), time = 8/3, loop = -1)
	animate(transform = matrix(transform_original, 120, MATRIX_ROTATE | MATRIX_MODIFY), time = 8/3, loop = -1)
	animate(transform = matrix(transform_original, 120, MATRIX_ROTATE | MATRIX_MODIFY), time = 8/3, loop = -1)

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)

	var/dx
	if (target.x > src.x)
		dx = EAST
	else
		dx = WEST

	var/dy
	if (target.y > src.y)
		dy = NORTH
	else
		dy = SOUTH

	var/dist_travelled = 0
	var/dist_since_sleep = 0

	if(dist_x > dist_y)
		var/error = dist_x/2 - dist_y
		while (target && ((((src.x < target.x && dx == EAST) || (src.x > target.x && dx == WEST)) && dist_travelled < range) || istype(src.loc, /turf/space) || src.throw_unlimited) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dy)
				if(!step || step == src.loc) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check()
				error += dist_x
				dist_travelled++
				src.throw_count++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dx)
				if(!step || step == src.loc) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check()
				error -= dist_y
				dist_travelled++
				src.throw_count++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
	else
		var/error = dist_y/2 - dist_x
		while (target && ((((src.y < target.y && dy == NORTH) || (src.y > target.y && dy == SOUTH)) && dist_travelled < range) || istype(src.loc, /turf/space) || src.throw_unlimited) && src.throwing && istype(src.loc, /turf))
			// only stop when we've gone the whole distance (or max throw range) and are on a non-space tile, or hit something, or hit the end of the map, or someone picks it up
			if(error < 0)
				var/atom/step = get_step(src, dx)
				if(!step || step == src.loc) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check()
				error += dist_y
				dist_travelled++
				src.throw_count++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)
			else
				var/atom/step = get_step(src, dy)
				if(!step || step == src.loc) // going off the edge of the map makes get_step return null, don't let things go off the edge
					break
				src.Move(step)
				hit_check()
				error -= dist_x
				dist_travelled++
				src.throw_count++
				dist_since_sleep++
				if(dist_since_sleep >= speed)
					dist_since_sleep = 0
					sleep(1)

	//done throwing, either because it hit something or it finished moving
	src.throw_unlimited = 0
	src.throwing = 0
	animate(src, transform = transform_original)

	//Wire note: Small fix stemming from pie science. Throw a pie at yourself! Whoa!
	if (target == usr)
		src.throw_impact(target)
		src.throwing = 0

	if(isobj(src)) src:throw_impact(get_turf(src))

	if(target != usr && src.throw_return) throw_at(usr, src.throw_range, src.throw_speed)
	//testing boomrang stuff
	//throw_at(atom/target, range, speed)//
	//if(target != usr) throw_at(usr, 10, 1)