//DEFINES ETC

/obj/machinery/engine_laser_spawner
	name = "Engine Laser Emitter"
	desc = "This is what it is."
	icon = 'engine_stuff.dmi'
	icon_state = "engine_laser_spawner0"
	var/obj/beam/engine_laser/first = null
	var/id = 1
	var/state = 0.0
	var/energy = 0
	var/health = 100
	flags = FPRINT | TABLEPASS | CONDUCT
	m_amt = 150

/obj/beam/engine_laser
	name = "engine laser"
	icon = 'engine_stuff.dmi'
	icon_state = "engine_laser"
	var/obj/beam/engine_laser/next = null
	var/obj/machinery/engine_laser_spawner/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	var/energy = 20
	anchored = 1.0
	flags = TABLEPASS

/obj/beam/focused_laser
	name = "focused laser"
	icon = 'engine_stuff.dmi'
	icon_state = "focused_laser"
	var/obj/beam/focused_laser/next = null
	var/obj/machinery/focusing_mirror/master = null
	var/limit = null
	var/visible = 0.0
	var/left = null
	var/energy = 0
	anchored = 1.0
	flags = TABLEPASS

/obj/machinery/focusing_mirror
	name = "focusing mirror"
	icon = 'engine_stuff.dmi'
	icon_state = "focus_mirror"
	var/obj/beam/focused_laser/first = null
	var/b_number = 0
	var/energy = 0
	var/on = 1
	density = 0

/obj/machinery/computer/laser_computer
	name = "laser computer"
	icon = 'engine_stuff.dmi'
	icon_state = "laser_computer"
	var/id = 1
	var/list/emitters = list()
	var/pattern = "Single"
	var/started = 0


///////////////////////////////////////////////
// MIRROR STUFF
//////////////////////////////////////////////

/obj/machinery/focusing_mirror/proc/opp_dir(var/dir)
	if(dir == 1)
		return 2
	if(dir == 2)
		return 1
	if(dir == 3)
		return 4
	if(dir == 4)
		return 3
	if(dir == 5)
		return 8
	if(dir == 6)
		return 7
	if(dir == 7)
		return 6
	if(dir == 8)
		return 5

/obj/machinery/focusing_mirror/process()
	if(src.on && src.b_number)
		src.shoot()
		src.b_number = 0
		src.energy = 0
		return
	else
		qdel(src.first)



/obj/machinery/focusing_mirror/proc/shoot()
	if(!b_number)
		qdel(src.first)
		return null
	if(src.first)
		return
	var/obj/beam/focused_laser/I = new /obj/beam/focused_laser( (src.loc) )
	I.master = src
	I.density = 1
	I.dir = opp_dir(src.dir)
	I.energy = src.energy
	step(I, I.dir)
	if (I)
		I.dir = opp_dir(src.dir)
		I.density = 0
		src.first = I
		I.vis_spread(1)
		spawn( 0 )
			if (I)
				I.limit = 20
				I.process()
			return
	if (!( b_number ))
		qdel(src.first)
	src.b_number = 0
	return


/obj/machinery/focusing_mirror/proc/hit()
	return

/////////////////////////////////////////////
// MIRROR LASER BEAM STUFF
/////////////////////////////////////////////


/obj/beam/focused_laser/proc/hit()
	if (src.master)
		src.master.hit()
	qdel(src)
	return

/obj/beam/focused_laser/proc/vis_spread(v)
	src.visible = v
	spawn( 0 )
		if (src.next)
			src.next.vis_spread(v)
		return
	return

/obj/beam/focused_laser/proc/process()
	if ((src.loc.density || !( src.master )))
		qdel(src)
		return

	if (src.left > 0)
		src.left--
	if (src.left < 1)
		if (!( src.visible ))
			src.invisibility = 101
		else
			src.invisibility = 0
	else
		src.invisibility = 0

	var/obj/beam/focused_laser/I = new /obj/beam/focused_laser( src.loc )
	I.master = src.master
	//I.density = 1
	I.dir = src.dir
	I.energy = src.energy
	step(I, I.dir)

	if (I)
		if (!( src.next ) && I)
			I.dir = src.dir
			I.density = 0
			I.vis_spread(src.visible)
			src.next = I
			spawn( 0 )
				if ((I && src.limit > 0))
					I.limit = src.limit - 1
					I.process()
				return
		else
			if(I)
				qdel(I)
	else
		qdel(src.next)
	spawn( 10 )
		src.process()
		return
	return

/obj/beam/focused_laser/Bump()
	qdel(src)
	return

/obj/beam/focused_laser/Bumped()
	src.hit()
	return

/obj/beam/focused_laser/HasEntered(atom/movable/AM as mob|obj)
	if (istype(AM, /obj/beam))
		return
	spawn( 0 )
		src.hit()
		return
	return

/obj/beam/focused_laser/disposing()
	if (src.next)
		src.next.dispose()
		src.next = null
	..()
	return



/////////////////////////////////////////////
// ENGINE LASER BEAM STUFF
/////////////////////////////////////////////


/obj/beam/engine_laser/proc/hit()
	if (src.master)
		src.master.hit()
	qdel(src)
	return

/obj/beam/engine_laser/proc/vis_spread(v)
	src.visible = v
	spawn( 0 )
		if (src.next)
			src.next.vis_spread(v)
		return
	return

/obj/beam/engine_laser/proc/process()

	if ((src.loc.density || !( src.master )))
		qdel(src)
		return

	if (src.left > 0)
		src.left--
	if (src.left < 1)
		if (!( src.visible ))
			src.invisibility = 101
		else
			src.invisibility = 0
	else
		src.invisibility = 0

	var/obj/beam/engine_laser/I = new /obj/beam/engine_laser( src.loc )
	I.master = src.master
	//I.density = 1
	I.dir = src.dir
	I.energy = src.energy
	step(I, I.dir)

	if (I)
		for(var/obj/machinery/focusing_mirror/M in I.loc)
			if(I.dir != M.dir)
				M.b_number++
				M.energy += I.energy
			qdel(src.next)
			qdel(I)
			break
		if (!( src.next ) && I)
			I.dir = src.dir
			I.density = 0
			I.vis_spread(src.visible)
			src.next = I
			spawn( 0 )
				if ((I && src.limit > 0))
					I.limit = src.limit - 1
					I.process()
				return
		else
			if(I)
				qdel(I)
	else
		qdel(src.next)
	spawn( 10 )
		src.process()
		return
	return

/obj/beam/engine_laser/Bump()
	qdel(src)
	return

/obj/beam/engine_laser/Bumped()
	src.hit()
	return

/obj/beam/engine_laser/HasEntered(atom/movable/AM as mob|obj)
	if (istype(AM, /obj/beam))
		return
	spawn( 0 )
		src.hit()
		return
	return

/obj/beam/engine_laser/Del()
	if (src.next)
		src.next.dispose()
		src.next = null
	..()
	return


//////////////////////////////////////////
// LASER SPAWNER STUFF
//////////////////////////////////////////

/obj/machinery/engine_laser_spawner/proc/hit()
	return

/obj/machinery/engine_laser_spawner/process()
	if(!state)
		qdel(src.first)
		return null

	if ((!( src.first ) && (src.state && (istype(src.loc, /turf)))))
		var/obj/beam/engine_laser/I = new /obj/beam/engine_laser( (src.loc) )
		I.master = src
		I.density = 1
		I.dir = src.dir
		step(I, I.dir)
		if (I)
			I.dir = src.dir
			I.density = 0
			src.first = I
			I.vis_spread(1)
			spawn( 0 )
				if (I)
					I.limit = 20
					I.process()
				return
	if (!( src.state ))
		qdel(src.first)
	spawn(3)
		src.state = 0
	return

/obj/machinery/engine_laser_spawner/attack_hand()
	qdel(src.first)
	..()
	return

/obj/machinery/engine_laser_spawner/Move()
	var/t = src.dir
	..()
	src.dir = t
	qdel(src.first)
	return

/obj/machinery/engine_laser_spawner/verb/rotate()
	set src in usr

	src.dir = turn(src.dir, 45)
	return





//////////////////////////////////////////
// COMPUTER STUFF
//////////////////////////////////////////



/obj/machinery/computer/laser_computer/New()
	..()
	spawn(100)
		for(var/obj/machinery/engine_laser_spawner/M in machines)
			if(src.id == M.id)
				src.emitters += M

/obj/machinery/computer/laser_computer/attack_ai(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/laser_computer/attack_hand(mob/user)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/laser_computer/proc/interact(mob/user)
	user.machine = src
	var/polledemitters
	for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
		if(M.health < 20)
			polledemitters += "<FONT color = 'red'>"
		polledemitters += "<BR>[M]<FONT color = 'black'>"
		if(M.state)
			polledemitters += "<FONT color = 'red'> Firing<FONT color = 'black'>"
	var/dat = text({"<TT>
<TT><B><FONT color = 'blue'>Loaded Laser Emitter Control Computer</B></TT><BR><BR>
<B><FONT color = 'black'>Emitters: [polledemitters] </B><BR>
Test: []<BR>
Start Pattern: []<BR>
Stop Pattern: []<BR>
Firing Pattern: []"},
text("<A href='?src=\ref[];testfire=1'>Fire</A>", src),
text("<A href='?src=\ref[];realfire=1'>Fire</A>", src),
text("<A href='?src=\ref[];stop=1'>Stop</A>", src),
text("<A href='?src=\ref[];pattern=1'>[src.pattern]</A>", src))
	user << browse("<HEAD><TITLE>Laser Emitter Control Computer</TITLE>[css_interfaces]</head>[dat]", "window=lasercomputer")
	onclose(user, "lasercomputer")
	return

/obj/machinery/computer/laser_computer/Topic(href, href_list)
	boutput(world, "Topic, [href_list]")
	usr.machine = src
	if (href_list["testfire"])
		if(!src.started)
			src.testfire()
	if (href_list["realfire"])
		src.started = 1
		src.realfire()
	if (href_list["stop"])
		src.started = 0
	if (href_list["pattern"])
		if(src.pattern == "Single")
			src.pattern = "Double"
		else if(src.pattern == "Double")
			src.pattern = "Quad"
		else
			src.pattern = "Single"
	if (istype(src.loc, /mob))
		attack_hand(src.loc)
		return

/obj/machinery/computer/laser_computer/proc/testfire()
	spawn(0)
		if(src.pattern == "Single")
			for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
				M.state = 1
				sleep(30)
		else if(src.pattern == "Double")
			var/double = 0
			for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
				M.state = 1
				if(double)
					sleep(20)
					double = 0
				else
					double = 1
		else
			for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
				M.state = 1

/obj/machinery/computer/laser_computer/proc/realfire()
	spawn(0)
		while(src.started)
			if(src.pattern == "Single")
				for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
					M.state = 1
					sleep(30)
			else if(src.pattern == "Double")
				var/double = 0
				for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
					M.state = 1
					if(double)
						sleep(30)
						double = 0
					else
						double = 1
			else
				for(var/obj/machinery/engine_laser_spawner/M in src.emitters)
					M.state = 1
				sleep(30)


/obj/machinery/computer/laser_computer/process()
	spawn(2)
		src.updateDialog()

