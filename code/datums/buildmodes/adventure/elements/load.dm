/datum/puzzlewizard/load
	name = "EXPERIMENTAL: Load saved design"
	var/savename
	var/pasting = 0

	initialize()
		//savename = input("Save file name", "Save file name", "save") as text
		boutput(usr, "<span style=\"color:orange\">Left click the bottom left corner of the area to fill with the saved structure. </span>")

	build_click(var/mob/user, var/datum/buildmode_holder/holder, var/list/pa, var/atom/object)
		if (pa.Find("left"))
			var/turf/T = get_turf(object)
			if (pa.Find("ctrl"))
				finished = 1
				return
			if (T)
				if (fexists("adventure/ADV_LOAD_[usr.client.ckey]"))
					fdel("adventure/ADV_LOAD_[usr.client.ckey]")
				if (pasting)
					boutput(usr, "<span style=\"color:red\">Already loading.</span>")
					return
				pasting = 1
				var/datum/puzzlewizard/load/this = src
				src = null
				var/target = input("Select the saved adventure zone to load.", "Saved zone upload", null) as null|file

				// fuck you you fucking useless piece of goddamn shit go away fuck you fuck shit bollocks
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck duck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				// fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck fuck
				if (!target)
					return
				var/savefile/F = new /savefile("adventure/ADV_LOAD_[usr.client.ckey]")
				// fuck you
				F.dir.len = 0
				// and fuck you too
				F.eof = -1
				// and ESPECIALLY YOU.
				F << null
				F.ImportText("/", file2text(target))
				if (!F)
					boutput(usr, "<span style=\"color:red\">Import failed.</span>")
					pasting = 0
					return
				var/basex = T.x
				var/basey = T.y
				var/w
				var/h
				var/cz = T.z
				var/paster = usr.client.ckey
				F["w"] >> w
				F["h"] >> h
				var/version
				F["version"] >> version
				if (!version)
					version = 1
				if (!w || !h)
					boutput(usr, "<span style=\"color:red\">Size error: [w]x[h]</span>")
					return
				if (T.z == 0)
					boutput(usr, "<span style=\"color:red\">Spatial error: cannot paste onto Z 0 (how the actual fuck did you manage to get this error???)</span>")
					return
				if (!locate(basex + w, basey + h, T.z))
					boutput(usr, "<span style=\"color:red\">Spatial error: the pasted area ([w]x[h]) will not fit on the map.</span>")
				if (alert("This action will paste an area of [w]x[h]. Are you sure you wish to proceed?",, "Yes", "No") == "No")
					this.pasting = 0
					boutput(usr, "<span style=\"color:red\">Aborting paste.</span>")
					return
				message_admins("[key_name(usr)] initiated loading an adventure (size: [w]x[h], estimated pasting duration: [w*h/10] seconds).")
				boutput(usr, "<span style=\"color:orange\">Beginning paste. DO NOT TOUCH THE AFFECTED AREA. Or do. Something might go wrong. I don't know. Who cares.</span>")
				var/datum/sandbox/sandbox = new /datum/sandbox()
				sandbox.context["version"] = version
				spawn(0)
					var/workgroup_size = 3
					var/workgroup_curr = 0
					var/list/PP = list()
					for (var/cy = basey, cy < basey + h, cy++)
						var/rely = cy - basey
						for (var/cx = basex, cx < basex + w, cx++)
							var/relx = cx - basex
							var/base = "[relx].[rely]"
							var/ttype
							var/turf/Q
							if (version < 2)
								F["[base].TURF"] >> ttype
								Q = new ttype(locate(cx, cy, cz))
								F["[base].TURF.dir"] >> Q.dir
							else
								F["[base].TURF.type"] >> ttype
								Q = new ttype(locate(cx, cy, cz))
								Q.deserialize(F, "[base].TURF", sandbox)
							F["[base].TURF.tag"] >> Q.tag
							if (!Q.dir)
								Q.dir = SOUTH
							new /area/adventure(Q)
							var/objc
							F["[base].OBJC"] >> objc
							for (var/objid = 0, objid < objc, objid++)
								var/objt
								var/obj/O
								F["[base].OBJ.[objid].type"] >> objt
								O = new objt()
								O.loc = Q
								O.flags |= ISADVENTURE
								var/result = O:deserialize(F, "[base].OBJ.[objid]", sandbox)
								if (!istype(O, /obj/critter))
									if (result & DESERIALIZE_NEED_POSTPROCESS)
										PP += O
							blink(Q)
							workgroup_curr++
							if (workgroup_curr >= workgroup_size)
								sleep(1)
					for (var/obj/O in PP)
						O:deserialize_postprocess()
					if (this)
						this.pasting = 0
					if (usr && usr.client)
						boutput(usr, "<span style=\"color:orange\">Pasting finished. Fixing lights.</span>")
						if (fexists("ADV_LOAD_[usr.client.ckey]"))
							fdel("ADV_LOAD_[usr.client.ckey]")
					message_admins("Adventure/loader: loading initiated by [paster] is finalizing.")
					del F

					//Post-processing loop
					for (var/turf/R in block(locate(basex, basey, cz), locate(basex + w - 1, basey + h - 1, cz)))
						R.RL_Reset()
						R.tag = null
						blink(R)
						for (var/atom/A in R.contents)
							A.tag = null
						workgroup_curr++
						if (workgroup_curr >= workgroup_size)
							sleep(1)
					message_admins("Adventure/loader: loading initiated by [paster] is complete.")