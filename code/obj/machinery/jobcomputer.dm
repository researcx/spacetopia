/obj/machinery/computer/job
	name = "Job Computer"
	icon_state = "jobs"
	var/obj/item/card/id/scan = null
	var/obj/item/card/id/modify = null
	var/authenticated = 1
	var/mode = 0.0
	var/printing = null
	var/list/scan_access = null
	req_access = list(access_change_ids)
	desc = "A computer that allows users to choose their job."
	var/list/staple_jobs = list()

	New()
		for (var/A in typesof(/datum/job/command)) src.staple_jobs += new A(src)
		for (var/A in typesof(/datum/job/security)) src.staple_jobs += new A(src)
		for (var/A in typesof(/datum/job/research)) src.staple_jobs += new A(src)
		for (var/A in typesof(/datum/job/engineering)) src.staple_jobs += new A(src)
		for (var/A in typesof(/datum/job/civilian)) src.staple_jobs += new A(src)
		..()


/obj/machinery/computer/job/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/job/attack_hand(var/mob/user as mob)
	if(..())
		return

	user.machine = src
	var/dat
	if (!( ticker ))
		return
	var/header = "<b>Job Computer</b><br><i>Please insert your ID.</i><br>"

	var/target_name
	var/target_owner
	var/target_rank

	if(src.modify)
		target_name = src.modify.name
	else
		target_name = "--------"
	if(src.modify && src.modify.registered)
		target_owner = src.modify.registered
	else
		target_owner = "--------"
	if(src.modify && src.modify.assignment)
		target_rank = src.modify.assignment
	else
		target_rank = "Unassigned"


	header += "<br><a href='?src=\ref[src];modify=1'>[target_name]</a><br>"

	var/body
	//When both IDs are inserted
	if (src.authenticated && src.modify)
		body = "Registered: [target_owner]<br>"
		body += "Assignment: [replacetext(target_rank, " ", "&nbsp")]"

		body += "<br><br><b>Civilian:</b><br>"
		for(var/datum/job/civilian/JOB in src.staple_jobs)
			if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
				if((countJob("[JOB.name]") != JOB.limit))
					body += "<a href='?src=\ref[src];assign=[JOB]'>[JOB.name]</A> ([countJob("[JOB.name]")]/[JOB.limit])<br>"
				else
					body += "[JOB.name] ([countJob("[JOB.name]")]/[JOB.limit])<br>"
		body += "<br><b>Supply and Maintainence:</b><br>"
		for(var/datum/job/engineering/JOB in src.staple_jobs)
			if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
				if((countJob("[JOB.name]") != JOB.limit))
					body += "<a href='?src=\ref[src];assign=[JOB]'>[JOB.name]</A> ([countJob("[JOB.name]")]/[JOB.limit])<br>"
				else
					body += "[JOB.name] ([countJob("[JOB.name]")]/[JOB.limit])<br>"
		body += "<br><b>Research and Medical:</b><br>"
		for(var/datum/job/research/JOB in src.staple_jobs)
			if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
				//world.log << JOB
				//world.log << JOB.name
				if((countJob("[JOB.name]") != JOB.limit))
					body += "<a href='?src=\ref[src];assign=[JOB]'>[JOB.name]</A> ([countJob("[JOB.name]")]/[JOB.limit])<br>"
				else
					body += "[JOB.name] ([countJob("[JOB.name]")]/[JOB.limit])<br>"
		body += "<br><b>Security:</b><br>"
		for(var/datum/job/security/JOB in src.staple_jobs)
			if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
				if((countJob("[JOB.name]") != JOB.limit))
					body += "<a href='?src=\ref[src];assign=[JOB]'>[JOB.name]</A> ([countJob("[JOB.name]")]/[JOB.limit])<br>"
				else
					body += "[JOB.name] ([countJob("[JOB.name]")]/[JOB.limit])<br>"
		body += "<br><b>Command:</b><br>"
		for(var/datum/job/command/JOB in src.staple_jobs)
			if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
				if((countJob("[JOB.name]") != JOB.limit))
					body += "<a href='?src=\ref[src];assign=[JOB]'>[JOB.name]</A> ([countJob("[JOB.name]")]/[JOB.limit])<br>"
				else
					body += "[JOB.name] ([countJob("[JOB.name]")]/[JOB.limit])<br>"

		user.unlock_medal("Identity Theft", 1)

	else
		body = "<a href='?src=\ref[src];auth=1'>Log in</a>"
	dat = "[css_interfaces]<TT>[header][body]</tt>"
	user << browse(dat, "window=id_com;size=331x443")
	onclose(user, "id_com")
	return

/obj/machinery/computer/job/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	if (href_list["modify"])
		if (src.modify)
			src.modify.update_name()
			src.modify.set_loc(src.loc)
			src.modify = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/card/id))
				usr.drop_item()
				I.set_loc(src)
				src.modify = I
		src.authenticated = 1
		src.scan_access = null
	if (href_list["scan"])
		if (src.scan)
			src.scan.set_loc(src.loc)
			src.scan = null
		else
			var/obj/item/I = usr.equipped()
			if (istype(I, /obj/item/card/id))
				usr.drop_item()
				I.set_loc(src)
				src.scan = I
		src.authenticated = 1
		src.scan_access = null
	if (href_list["auth"])
		if ((!( src.authenticated ) && (src.scan || (issilicon(usr) && !isghostdrone(usr))) && (src.modify || src.mode)))
			if (src.check_access(src.scan))
				src.authenticated = 1
				src.scan_access = src.scan.access
		else if ((!( src.authenticated ) && (istype(usr, /mob/living/silicon))) && (!src.modify))
			boutput(usr, "You can't modify an ID without an ID inserted to modify. Once one is in the modify slot on the computer, you can log in.")
	if(href_list["access"] && href_list["allowed"])
		if(src.authenticated)
			var/access_type = text2num(href_list["access"])
			var/access_allowed = text2num(href_list["allowed"])
			if(access_type in get_all_accesses())
				src.modify.access -= access_type
				if(access_allowed == 1)
					src.modify.access += access_type

	if (href_list["assign"])
		if (src.authenticated && src.modify)
			var/t1 = href_list["assign"]

			//world.log << t1

			for(var/datum/job/JOB in src.staple_jobs)
				if(JOB.name == t1)
					//world.log << "[JOB.name] == [t1]"
					if((JOB.limit != 0) && JOB.selectable && (JOB.name != ""))
						//world.log << "[JOB.name] was selectable"
						if((countJob("[JOB.name]") != JOB.limit))
							//var/jobcount = countJob("[JOB.name]")
							//world.log << "[JOB.name] wasn't full"
							src.modify.access = get_access(t1)
							src.modify.assignment = t1
							//world.log << "[JOB.name] assignements is now [jobcount]"

	if (href_list["mode"])
		src.mode = text2num(href_list["mode"])
	if (href_list["print"])
		if (!( src.printing ))
			src.printing = 1
			sleep(50)
			var/obj/item/paper/P = new /obj/item/paper( src.loc )
			var/t1 = "<B>Crew Manifest:</B><BR>"
			for(var/datum/data/record/t in data_core.general)
				t1 += "<B>[t.fields["name"]]</B> - [t.fields["rank"]]<BR>"
			P.info = t1
			P.name = "paper- 'Crew Manifest'"
			src.printing = null
	if (href_list["mode"])
		src.authenticated = 1
		src.scan_access = null
		src.mode = text2num(href_list["mode"])
	if (href_list["colour"])
		if(src.modify && src.modify.icon_state != "gold" && src.modify.icon_state != "id_clown")
			var/newcolour = href_list["colour"]
			if (newcolour == "none")
				src.modify.icon_state = "id"
			if (newcolour == "blue")
				src.modify.icon_state = "id_civ"
			if (newcolour == "yellow")
				src.modify.icon_state = "id_eng"
			if (newcolour == "purple")
				src.modify.icon_state = "id_res"
			if (newcolour == "red")
				src.modify.icon_state = "id_sec"
			if (newcolour == "green")
				src.modify.icon_state = "id_com"
	if (src.modify)
		src.modify.name = "[src.modify.registered]'s ID Card ([src.modify.assignment])"
	src.updateUsrDialog()
	return

/obj/machinery/computer/job/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/screwdriver))
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:orange\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/card/M = new /obj/item/circuitboard/card( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:orange\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/card/M = new /obj/item/circuitboard/card( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)
	else if (istype(I, /obj/item/card/id))
		if (!src.modify)
			boutput(user, "<span style=\"color:orange\">You insert [I] into the job computer.</span>")
			user.drop_item()
			I.set_loc(src)
			src.modify = I
		src.updateUsrDialog()

	else
		src.attack_hand(user)
	return