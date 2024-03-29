/obj/abcuMarker
	name = "ABCU Marker"
	desc = "Denotes a valid tile."
	icon = 'icons/obj/objects.dmi'
	name = "Building marker (valid)"
	icon_state = "bmarker"
	anchored = 1
	density = 0
	layer = TURF_LAYER

/obj/abcuMarker/red
	name = "ABCU Marker"
	desc = "Denotes an invalid tile."
	icon = 'icons/obj/objects.dmi'
	name = "Building marker (invalid)"
	icon_state = "bmarkerred"
	anchored = 1
	density = 0
	layer = TURF_LAYER

/obj/machinery/abcu
	icon = 'icons/obj/objects.dmi'
	icon_state = "builder"
	name = "Automated Blueprint Construction Unit (ABC-U)"
	desc = "This fine piece of machinery can construct entire rooms from blueprints."
	density = 1
	opacity = 0
	anchored = 0

	var/invalidCount = 0

	var/obj/item/blueprint/currentBp = null
	var/locked = 0
	var/building = 0

	var/off_x = 0
	var/off_y = 0

	var/list/markers = new/list()

	New()
		..()
		UnsubscribeProcess()

	attack_ai(mob/user)
		boutput(user, "<span style=\"color:red\">This machine is not linked to your network.</span>")
		return

	attackby(obj/item/W as obj, mob/user as mob)
		if(istype(W, /obj/item/blueprint))
			if(currentBp)
				boutput(user, "<span style=\"color:red\">Theres already a blueprint in the machine.</span>")
				return
			else
				boutput(user, "<span style=\"color:orange\">You insert the blueprint into the machine.</span>")
				user.drop_item()
				W.set_loc(src)
				currentBp = W
				return
		else if (istype(W, /obj/item/sheet))
			boutput(user, "<span style=\"color:orange\">You insert the sheet into the machine.</span>")
			user.drop_item()
			W.set_loc(src)
			return
		return

	attack_hand(mob/user as mob)
		if(building)
			boutput(user, "<span style=\"color:red\">The machine is currently constructing something. Best not touch it until it's done.</span>")
			return

		var/list/options = list(locked ? "Unlock":"Lock", "Begin Building", "Dump Materials", "Check Materials" ,currentBp ? "Eject Blueprint":null)
		var/input = input(usr,"Select option:","Option") in options
		switch(input)
			if("Unlock")
				if(!locked || building) return
				boutput(user, "<span style=\"color:orange\">The machine unlocks and shuts down.</span>")
				deactivate()

			if("Lock")
				if(locked || building) return
				if(!currentBp)
					boutput(user, "<span style=\"color:red\">The machine requires a blueprint before it can be locked</span>")
					return
				boutput(user, "<span style=\"color:orange\">The machine locks into place and begins humming softly.</span>")
				activate()

			if("Begin Building")
				if(building) return
				if(!locked)
					boutput(user, "<span style=\"color:red\">The machine must be locked into place before activating it.</span>")
					return
				if(!currentBp)
					boutput(user, "<span style=\"color:red\">The machine requires a blueprint before it can build anything.</span>")
					return
				build()

			if("Eject Blueprint")
				if(building) return
				if(locked)
					boutput(user, "<span style=\"color:red\">Can not eject blueprint while machine is locked.</span>")
					return
				currentBp.set_loc(src.loc)
				currentBp = null

			if("Dump Materials")
				if(building) return
				for(var/obj/o in src)
					if(o == currentBp) continue
					o.set_loc(src.loc)

			if("Check Materials")
				if(building) return
				var/metal_cnt = 0
				var/glass_cnt = 0

				for(var/obj/O in src)
					if(O == currentBp) continue
					if(istype(O, /obj/item/sheet))
						var/obj/item/sheet/S = O
						if (S.material)
							if (S.material.material_flags & MATERIAL_METAL)
								metal_cnt += S.amount
							if (S.material.material_flags & MATERIAL_CRYSTAL)
								glass_cnt += S.amount

				boutput(user, "<span style=\"color:orange\">Currently loaded :</span>")
				boutput(user, "<span style=\"color:orange\">[metal_cnt] of [currentBp ? currentBp.req_metal : "-"] required metal</span>")
				boutput(user, "<span style=\"color:orange\">[glass_cnt] of [currentBp ? currentBp.req_glass : "-"] required glass</span>")
		return

	proc/deactivate()
		for(var/obj/O in markers)
			qdel(O)
		locked = 0
		anchored = 0
		return

	proc/activate()
		locked = 1
		anchored = 1
		invalidCount = 0
		for(var/datum/tileinfo/T in currentBp.roominfo)
			var/turf/pos = locate(text2num(T.posx) + src.x,text2num(T.posy) + src.y, src.z)
			var/obj/abcuMarker/O = null

			if(istype(pos, /turf/space))
				O = new/obj/abcuMarker(pos)
			else
				O = new/obj/abcuMarker/red(pos)
				invalidCount++

			markers.Add(O)
		boutput(usr, "<span style=\"color:orange\">Building this will require [currentBp.req_metal] metal and [currentBp.req_glass] glass sheets.</span>")
		return

	proc/build()
		var/metal_cnt = 0
		var/glass_cnt = 0

		if(invalidCount)
			boutput(usr, "<span style=\"color:red\">The machine can not build on anything but empty space. Check for red markers.</span>")
			return

		for(var/obj/O in src)
			if(O == currentBp) continue
			if(istype(O, /obj/item/sheet))
				var/obj/item/sheet/S = O
				if (S.material)
					if (S.material.material_flags & MATERIAL_METAL)
						metal_cnt += S.amount
					if (S.material.material_flags & MATERIAL_CRYSTAL)
						glass_cnt += S.amount

		if(metal_cnt < currentBp.req_metal || glass_cnt < currentBp.req_glass)
			boutput(usr, "<span style=\"color:red\">The machine buzzes in protest. Seems like it doesn't have enough material to work with.</span>")
			return

		boutput(usr, "<span style=\"color:orange\">The machine starts to buzz and vibrate.</span>")

		building = 1
		icon_state = "builder1"

		spawn(0)

			for(var/datum/tileinfo/T in currentBp.roominfo)
				var/turf/pos = locate(text2num(T.posx) + src.x,text2num(T.posy) + src.y, src.z)

				var/obj/overlay/V = new/obj/overlay(pos)
				V.icon = 'icons/obj/objects.dmi'
				V.icon_state = "buildeffect"
				V.name = "energy"
				V.anchored = 1
				V.density = 0
				V.layer = EFFECTS_LAYER_BASE

				sleep(15)

				qdel(V)

				for(var/obj/O in markers)
					if(O.loc == pos)
						qdel(O)
						break

				for(var/datum/objectinfo/O in T.objects)
					if(O.objecttype == null) continue
					var/atom/A = new O.objecttype(pos)
					A.dir = O.direction
					A.layer = O.layer
					A.pixel_x = O.px
					A.pixel_y = O.py

				if(T.tiletype != null)
					var/turf/newTile = new T.tiletype(pos)
					newTile.icon_state = T.state
					newTile.dir = T.direction

			for(var/obj/J in src)
				qdel(J)

			building = 0
			icon_state = "builder"
			makepowernets()
			qdel(src) //Blah

		return

/datum/objectinfo
	var/objecttype = null
	var/direction = 0
	var/layer = 0
	var/px = 0
	var/py = 0

/datum/tileinfo
	var/list/objects = new/list()
	var/state = ""
	var/direction = 0
	var/tiletype = null
	var/posx = 0
	var/posy = 0

/verb/adminCreateBlueprint()
	set name = "Create Blueprint"
	set desc = "Allows creation of blueprints of any user."
	set category = "Special Verbs"
	set hidden = 1

	var/list/bps = new/list()
	var/savefile/save = new/savefile("data/blueprints.dat")
	save.cd = "/"

	for(var/curr in save.dir)
		save.cd = "/[curr]"
		bps.Add("[curr];[save["roomname"]]")

	save.cd = "/"

	var/input = input(usr,"Select save:","Blueprints") in bps
	var/list/split = splittext(input, ";")
	var/key = split[1]

	if(save.dir.Find("[key]"))
		var/obj/item/blueprint/bp = new/obj/item/blueprint(get_turf(usr))

		save.cd = "/[key]"
		boutput(usr, "<span style=\"color:orange\">Printed Blueprint for '[save["roomname"]]'</span>")
		var/roomname = save["roomname"]
		bp.size_x = save["sizex"]
		bp.size_y = save["sizey"]

		for (var/A in save.dir)
			if(A == "sizex" || A == "sizey" || A == "roomname") continue
			save.cd = "/[key]/[A]"
			var/list/coords = splittext(A, ",")
			var/datum/tileinfo/tf = new/datum/tileinfo()
			tf.posx = coords[1]
			tf.posy = coords[2]
			tf.tiletype = save["type"]
			tf.state = save["state"]
			tf.direction = save["dir"]
			for (var/B in save.dir)
				if(B == "type" || B == "state") continue
				save.cd = "/[key]/[A]/[B]"
				var/datum/objectinfo/O = new/datum/objectinfo()
				O.objecttype = save["type"]
				O.direction = save["dir"]
				O.layer = save["layer"]
				O.px = save["pixelx"]
				O.py = save["pixely"]
				tf.objects.Add(O)
			bp.roominfo.Add(tf)
			bp.name = "Blueprint '[roomname]'"


/obj/item/blueprint
	name = "Blueprint"
	desc = "A blueprint used to quickly construct rooms."
	icon = 'icons/obj/device.dmi'

	icon_state = "blueprint"
	item_state = "sheet"

	var/req_metal = 0
	var/req_glass = 0

	var/size_x = 0
	var/size_y = 0

	var/list/roominfo = new/list()
/*
	attack_self(mob/user as mob)
		for(var/datum/tileinfo/T in roominfo)
			var/turf/pos = locate(text2num(T.posx) + user.x,text2num(T.posy) + user.y, user.z) //Change
			//boutput(world, "[pos.x]-[pos.y]-[pos.z] # [pos]")
			for(var/datum/objectinfo/O in T.objects)
				//boutput(world, newObjType + " - " + O.objecttype)
				if(O.objecttype == null) continue
				var/atom/A = new O.objecttype(pos)
				A.dir = O.direction
				A.layer = O.layer
				A.pixel_x = O.px
				A.pixel_y = O.py

			//boutput(world, newTilePath + " - " + T.tiletype)
			if(T.tiletype != null)
				var/turf/newTile = new T.tiletype(pos)
				newTile.icon_state = T.state

			//rebuild powernets etc.
*/

/obj/item/blueprint_marker
	name = "Blueprint Marker"
	desc = "A tool used to map rooms for the creation of blueprints."
	icon = 'icons/obj/device.dmi'

	icon_state = "blueprintmarker"
	item_state = "gun"

	flags = FPRINT | EXTRADELAY | TABLEPASS | CONDUCT
	w_class = 2.0

	var/prints_left = 5

	var/mob/using = null

	var/roomname = "NewRoom"
	var/list/roomList = new/list()

	var/list/permittedObjectTypes = list(\
	"/obj/closet", \
	"/obj/stool", \
	"/obj/grille", \
	"/obj/window", \
	"/obj/machinery/door", \
	"/obj/cable", \
	"/obj/table", \
	"/obj/rack", \
	"/obj/structure",
	"/obj/disposalpipe", \
	"/obj/machinery/vending", \
	"/obj/machinery/light", \
	"/obj/machinery/door_control", \
	"/obj/machinery/light_switch", \
	"/obj/machinery/camera", \
	"/obj/item/device/radio/intercom", \
	"/obj/machinery/firealarm", \
	"/obj/machinery/power/apc", \
	"/obj/machinery/alarm", \
	"/obj/machinery/power/terminal", \
	"/obj/machinery/disposal", \
	"/obj/machinery/gibber",
	"/obj/machinery/floorflusher",
	"/obj/machinery/driver_button", \
	"/obj/machinery/door_control",
	"/obj/machinery/disposal",
	"/obj/submachine/chef_oven",
	"/obj/submachine/chef_sink",
	"/obj/machinery/launcher_loader",
	"/obj/machinery/optable",
	"/obj/machinery/mass_driver", \
	"/obj/reagent_dispensers", \
	"/obj/machinery/manufacturer", \
	"/obj/machinery/sleeper", \
	"/obj/machinery/sleep_console", \
	"/obj/submachine/slot_machine", \
	"/obj/machinery/deep_fryer",
	"/obj/submachine/ATM", \
	"/obj/submachine/slot_machine",
	"/obj/submachine/ice_cream_dispenser",
	"/obj/machinery/portable_atmospherics", \
	"/obj/machinery/ai_status_display",
	"/obj/noticeboard",
	"/obj/securearea",
	"/obj/submachine/mixer",
	"/obj/submachine/foodprocessor"
	)

	var/list/permittedTileTypes = list("/turf/simulated")

	var/savefile/save = new/savefile("data/blueprints.dat")

	afterattack(atom/target as mob|obj|turf, mob/user as mob)
		if(get_dist(src,target) > 2) return

		if(!isturf(target)) target = get_turf(target)

		var/maxSize = 20

		var/minx = 100000000
		var/miny = 100000000

		var/maxx = 0
		var/maxy = 0

		var/permitted = 0
		for(var/p in permittedTileTypes)
			var/type = text2path(p)
			if(istype(target, type))
				permitted = 1
				break

		if(!permitted)
			boutput(user, "<span style=\"color:red\">Unsupported Tile type detected.</span>")
			return

		for(var/a in roomList)
			var/turf/t = a
			if(t.x < minx) minx = t.x
			if(t.y < miny) miny = t.y

			if(t.x > maxx) maxx = t.x
			if(t.y > maxy) maxy = t.y

		//Do stuff

		if(target.x < minx) minx = target.x
		if(target.y < miny) miny = target.y

		if(target.x > maxx) maxx = target.x
		if(target.y > maxy) maxy = target.y

		if(abs(minx - maxx) >= maxSize || abs(miny - maxy) >= maxSize)
			boutput(user, "<span style=\"color:red\">Tile exceeds maximum size of blueprint.</span>")
			return

		if(roomList.Find(target))
			if (using && using.client)
				using.client.images -= roomList[target]
			roomList.Remove(target)
		else
			roomList.Add(target)
			roomList[target] = image('icons/misc/old_or_unused.dmi',target,"tiletag", layer = EFFECTS_LAYER_BASE)
			updateOverlays()

		return

	New()

		return

	proc/removeOverlays()
		if (using && using.client)
			for(var/a in roomList)
				var/image/i = roomList[a]
				using.client.images -= i
		return

	proc/updateOverlays()
		if (using && using.client)
			removeOverlays()
			for(var/a in roomList)
				var/image/i = roomList[a]
				using.client.images += i
		return

	proc/saveMarked(var/name = "", var/applyWhitelist = 1)
		save.cd = "/"
		if(save.dir.Find("[usr.client.ckey]" + name))
			save.dir.Remove("[usr.client.ckey]" + name)
			save.dir.Add("[usr.client.ckey]" + name)
			save.cd = "/[usr.client.ckey]" + name
		else
			save.dir.Add("[usr.client.ckey]" + name)
			save.cd = "/[usr.client.ckey]" + name

		var/minx = 100000000
		var/miny = 100000000

		var/maxx = 0
		var/maxy = 0

		for(var/a in roomList)
			var/turf/t = a
			if(t.x < minx) minx = t.x
			if(t.y < miny) miny = t.y

			if(t.x > maxx) maxx = t.x
			if(t.y > maxy) maxy = t.y

		var/sizex = (maxx - minx) + 1
		var/sizey = (maxy - miny) + 1

		save["sizex"] << sizex
		save["sizey"] << sizey
		save["roomname"] << roomname

		for(var/atom/curr in roomList)
			var/posx = (curr.x - minx)
			var/posy = (curr.y - miny)

			save.cd = "/[usr.client.ckey]" + name
			save.dir.Add("[posx],[posy]")
			save.cd = "/[usr.client.ckey][name]/[posx],[posy]"
			save["type"] << curr.type
			save["dir"] << curr.dir
			save["state"] << curr.icon_state

			for(var/obj/o in curr)
				if (istype(o, /obj/disposalpipe/loafer)) // Sorry.
					continue
				var/permitted = 0
				for(var/p in permittedObjectTypes)
					var/type = text2path(p)
					if(istype(o, type))
						permitted = 1
						break
				if(permitted || !applyWhitelist)
					var/id = "\ref[o]"
					save.cd = "/[usr.client.ckey][name]/[posx],[posy]"
					while(save.dir.Find(id))
						id = id + "I"
					save.dir.Add("[id]")
					save.cd = "/[usr.client.ckey][name]/[posx],[posy]/[id]"
					save["dir"] << o.dir
					save["type"] << o.type
					save["layer"] << o.layer
					save["pixelx"] << o.pixel_x
					save["pixely"] << o.pixel_y
		return

	proc/printSaved(var/name = "")
		save.cd = "/"
		if(save.dir.Find("[usr.client.ckey]" + name))
			var/obj/item/blueprint/bp = new/obj/item/blueprint(get_turf(src))
			prints_left--

			save.cd = "/[usr.client.ckey]" + name
			boutput(usr, "<span style=\"color:orange\">Printed Blueprint for '[save["roomname"]]'</span>")
			var/roomname = save["roomname"]
			bp.size_x = save["sizex"]
			bp.size_y = save["sizey"]

			for (var/A in save.dir)
				if(A == "sizex" || A == "sizey" || A == "roomname") continue
				save.cd = "/[usr.client.ckey][name]/[A]"
				var/list/coords = splittext(A, ",")
				var/datum/tileinfo/tf = new/datum/tileinfo()
				tf.posx = coords[1]
				tf.posy = coords[2]
				tf.tiletype = save["type"]
				tf.state = save["state"]
				tf.direction = save["dir"]
				bp.req_metal += 1.0
				bp.req_glass += 0.5
				for (var/B in save.dir)
					if(B == "type" || B == "state") continue
					save.cd = "/[usr.client.ckey][name]/[A]/[B]"
					var/datum/objectinfo/O = new/datum/objectinfo()
					O.objecttype = save["type"]
					O.direction = save["dir"]
					O.layer = save["layer"]
					O.px = save["pixelx"]
					O.py = save["pixely"]
					bp.req_metal += 0.9
					bp.req_glass += 1.5
					tf.objects.Add(O)
				bp.roominfo.Add(tf)
				bp.name = "Blueprint '[roomname]'"
				bp.req_metal = round(bp.req_metal)
				bp.req_glass = round(bp.req_glass)
			return
		else
			boutput(usr, "<span style=\"color:red\">No blueprint found for user.</span>")
			return

	attack_self(mob/user as mob)
		var/list/options = list("Reset", "Set Blueprint Name", "Print Saved Blueprint", "Save Blueprint", "Information")
		var/input = input(usr,"Select option:","Option") in options

		switch(input)
			if("Reset")
				boutput(user, "<span style=\"color:orange\">Resetting ...</span>")
				removeOverlays()
				roomList.Cut()

			if("Set Blueprint Name")
				roomname = copytext(strip_html(input(user,"Set Blueprint Name:","Setup",roomname) as text), 1, 257)
				boutput(user, "<span style=\"color:orange\">Name set to '[roomname]'</span>")

			//if("Create Clone Blueprint")
			//	saveMarked("_temp", 1)
			//	printSaved("_temp")
			//	return

			if("Print Saved Blueprint")
				if(prints_left <= 0)
					boutput(user, "<span style=\"color:red\">Out of energy.</span>")
					return
				printSaved()
				return

			if("Save Blueprint")
				saveMarked()
				return

			if("Information")
				var/message = "<span style=\"color:orange\">Blueprint Marker Tool Usage Information:</span><br><br>"
				message += "<span style=\"color:orange\">Reset: Resets the tools and clears all marked areas.</span><br>"
				message += "<span style=\"color:orange\">Set Blueprint Name: Allows you to set the name that will appear on the blueprint.</span><br>"
				//message += "<span style=\"color:orange\">Create Clone Blueprint: Creates a blueprint for an exact copy of the marked area. This type of blueprint can not be saved and costs slightly more to build.</span><br>"
				message += "<span style=\"color:orange\">Print Saved Blueprint: Prints a previously saved blueprint.</span><br>"
				message += "<span style=\"color:orange\">Save Blueprint: Saves a blueprint of the marked area to the server. This type of blueprint can be saved but it can not save all types of objects.</span>"
				boutput(user, message)
				return

		return

	dropped(mob/user as mob)
		removeOverlays()
		using = null
		return

	pickup(mob/user)
		using = user
		updateOverlays()
		return

	equipped(var/mob/user, var/slot)
		using = user
		updateOverlays()
		return