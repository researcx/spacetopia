/obj/machinery/portable_atmospherics
	name = "atmoalter"
	var/datum/gas_mixture/air_contents = null

	var/obj/machinery/atmospherics/portables_connector/connected_port
	var/obj/item/tank/holding

	var/volume = 0
	var/destroyed = 0

	var/maximum_pressure = 90*ONE_ATMOSPHERE

	var/init_connected = 0

	var/contained = 0

	onMaterialChanged()
		..()
		if(istype(src.material))
			maximum_pressure = max((90 + (((src.material.getProperty(PROP_TENSILE) + src.material.getProperty(PROP_COMPRESSIVE)) - 30) / 2)) * ONE_ATMOSPHERE, ONE_ATMOSPHERE * 2)
		return

	New()
		..()

		air_contents = unpool(/datum/gas_mixture)

		air_contents.volume = volume
		air_contents.temperature = T20C

		if(init_connected)
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				connect(possible_port)

		return 1

	process()
		if(contained) return
		if(!connected_port) //only react when pipe_network will ont it do it for you
			//Allow for reactions
			air_contents.react()

	disposing()
		if (air_contents)
			pool(air_contents)
			air_contents = null

		..()

	proc
		update_icon()
			return null

		connect(obj/machinery/atmospherics/portables_connector/new_port)
			//Make sure not already connected to something else
			if(connected_port || !new_port || new_port.connected_device)
				return 0

			//Make sure are close enough for a valid connection
			if(new_port.loc != loc)
				return 0

			//logTheThing("combat", usr, null, "attaches [src] to [new_port] at [showCoords(new_port.x, new_port.y, new_port.z)].")

			add_fingerprint(usr)

			//Perform the connection
			connected_port = new_port
			connected_port.connected_device = src
			connected_port.on = 1

			anchored = 1 //Prevent movement

			//Actually enforce the air sharing
			var/datum/pipe_network/network = connected_port.return_network(src)
			if(network && !network.gases.Find(air_contents))
				network.gases += air_contents

			return 1

		disconnect()
			if(!connected_port)
				return 0

			var/datum/pipe_network/network = connected_port.return_network(src)
			if(network)
				network.gases -= air_contents

			anchored = 0

			connected_port.connected_device = null
			connected_port = null

			return 1

/obj/machinery/portable_atmospherics/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/tank))
		if(!src.holding)
			boutput(user, "<span style=\"color:orange\">You attach the [W.name] to the the [src.name]</span>")
			user.drop_item()
			W.set_loc(src)
			src.holding = W
			update_icon()

	else if (istype(W, /obj/item/wrench))
		if(connected_port)
			logTheThing("station", user, null, "has disconnected \the [src] [log_atmos(src)] from the port at [log_loc(src)].")
			disconnect()
			boutput(user, "<span style=\"color:orange\">You disconnect [name] from the port.</span>")
			playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
			return
		else
			var/obj/machinery/atmospherics/portables_connector/possible_port = locate(/obj/machinery/atmospherics/portables_connector/) in loc
			if(possible_port)
				if(connect(possible_port))
					logTheThing("station", user, null, "has connected \the [src] [log_atmos(src)] to the port at [log_loc(src)].")
					boutput(user, "<span style=\"color:orange\">You connect [name] to the port.</span>")
					playsound(src.loc, "sound/items/Deconstruct.ogg", 50, 1)
					return
				else
					boutput(user, "<span style=\"color:orange\">[name] failed to connect to the port.</span>")
					return
			else
				boutput(user, "<span style=\"color:orange\">Nothing happens.</span>")
				return

	return