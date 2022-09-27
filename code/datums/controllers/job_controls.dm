var/datum/job_controller/job_controls

/datum/job_controller/
	var/list/staple_jobs = list()
	var/list/special_jobs = list()
	var/allow_special_jobs = 1 // hopefully this doesn't break anything!!
	var/datum/job/job_creator = null

	New()
		..()
		if (derelict_mode)
			src.staple_jobs = list(new /datum/job/command/captain/derelict {limit = 1;name = "NT-SO Commander";} (),
			new /datum/job/command/head_of_security/derelict {limit = 1; name = "NT-SO Special Operative";} (),
			new /datum/job/command/chief_engineer/derelict {limit = 1; name = "Salvage Chief";} (),
			new /datum/job/security/security_officer/derelict {limit = 6; name = "NT-SO Officer";} (),
			new /datum/job/research/medical_doctor/derelict {limit = 6; name = "Salvage Medic";} (),
			new /datum/job/engineering/engineer/derelict {limit = 6; name = "Salvage Engineer";} (),
			new /datum/job/civilian/staff_assistant (),
			new /datum/job/civilian/chef (),
			new /datum/job/civilian/barman (),
			new /datum/job/civilian/chaplain ())

		else
			for (var/A in typesof(/datum/job/command)) src.staple_jobs += new A(src)
			for (var/A in typesof(/datum/job/security)) src.staple_jobs += new A(src)
			for (var/A in typesof(/datum/job/research)) src.staple_jobs += new A(src)
			for (var/A in typesof(/datum/job/engineering)) src.staple_jobs += new A(src)
			for (var/A in typesof(/datum/job/civilian)) src.staple_jobs += new A(src)
			for (var/A in typesof(/datum/job/special)) src.special_jobs += new A(src)
		job_creator = new /datum/job/created(src)
		//Add special daily variety job
		var/variety_job_path = text2path("/datum/job/daily/[lowertext(time2text(world.realtime,"Day"))]")
		if (variety_job_path)
			src.staple_jobs += new variety_job_path(src)

		for (var/datum/job/J in src.staple_jobs)
			// Cull any of those nasty null jobs from the category heads
			if (!J.name)
				src.staple_jobs -= J
		for (var/datum/job/J in src.special_jobs)
			if (!J.name)
				src.special_jobs -= J

	proc/job_config()
		var/dat = "<html><body><title>Job Controller</title>"
		dat += "<b><u>Job Controls</u></b><HR>"
		dat += "<b>Command & Security Jobs</b><BR>"
		for(var/datum/job/command/JOB in src.staple_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		for(var/datum/job/security/JOB in src.staple_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		dat += "<BR>"
		dat += "<b>Research Jobs</b><BR>"
		for(var/datum/job/research/JOB in src.staple_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		dat += "<BR>"
		dat += "<b>Engineering Jobs</b><BR>"
		for(var/datum/job/engineering/JOB in src.staple_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		dat += "<BR>"
		dat += "<b>Civilian Jobs</b><BR>"
		for(var/datum/job/civilian/JOB in src.staple_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		dat += "<BR>"
		dat += "<b>Special Jobs</b><BR>"
		for(var/datum/job/special/JOB in src.special_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A><BR>"
		for(var/datum/job/created/JOB in src.special_jobs)
			dat += "<a href='byond://?src=\ref[src];AlterCap=\ref[JOB]'>[JOB.name]: [countJob("[JOB.name]")]/[JOB.limit]</A>"
			dat += " <a href='byond://?src=\ref[src];RemoveJob=\ref[JOB]'>(Remove)</A><BR>"
		dat += "<BR>"
		if (src.allow_special_jobs)
			dat += "<A href='?src=\ref[src];SpecialToggle=1'>Special Jobs Enabled</A><BR>"
		else
			dat += "<A href='?src=\ref[src];SpecialToggle=1'>Special Jobs Disabled</A><BR>"
		dat += "<A href='?src=\ref[src];JobCreator=1'>Create New Job</A>"
		dat += "</body></html>"

		usr << browse(dat,"window=jobconfig;size=300x600")

	proc/job_creator()
		var/dat = "<html><body><title>Job Creation</title>"
		dat += "<b><u>Job Creator</u></b><HR>"

		dat += "<A href='?src=\ref[src];EditName=1'>Job Name:</A> [src.job_creator.name]<br>"
		dat += "<A href='?src=\ref[src];EditWages=1'>Wages Per Payday:</A> [src.job_creator.wages]<br>"
		dat += "<A href='?src=\ref[src];EditLimit=1'>Job Limit:</A> [src.job_creator.limit]<br>"
		dat += "<A href='?src=\ref[src];EditMob=1'>Mob Type:</A> [src.job_creator.mob_type]<br>"
		if (ispath(src.job_creator.mob_type, /mob/living/carbon/human))
			dat += "<A href='?src=\ref[src];EditHeadgear=1'>Starting Headgear:</A> [src.job_creator.slot_head]<br>"
			dat += "<A href='?src=\ref[src];EditMask=1'>Starting Mask:</A>  [src.job_creator.slot_mask]<br>"
			dat += "<A href='?src=\ref[src];EditHeadset=1'>Starting Headset:</A> [src.job_creator.slot_ears]<br>"
			dat += "<A href='?src=\ref[src];EditGlasses=1'>Starting Glasses:</A> [src.job_creator.slot_eyes]<br>"
			dat += "<A href='?src=\ref[src];EditOvercoat=1'>Starting Overcoat:</A> [src.job_creator.slot_suit]<br>"
			dat += "<A href='?src=\ref[src];EditJumpsuit=1'>Starting Jumpsuit:</A> [src.job_creator.slot_jump]<br>"
			dat += "<A href='?src=\ref[src];EditIDCard=1'>Starting ID Card:</A> [src.job_creator.slot_card]<br>"
			dat += "<A href='?src=\ref[src];EditGloves=1'>Starting Gloves:</A> [src.job_creator.slot_glov]<br>"
			dat += "<A href='?src=\ref[src];EditShoes=1'>Starting Shoes:</A> [src.job_creator.slot_foot]<br>"
			dat += "<A href='?src=\ref[src];EditBack=1'>Starting Back Item:</A> [src.job_creator.slot_back]<br>"
			dat += "<A href='?src=\ref[src];EditBelt=1'>Starting Belt Item:</A> [src.job_creator.slot_belt]<br>"
			dat += "<A href='?src=\ref[src];EditPock1=1'>Starting 1st Pocket Item:</A> [src.job_creator.slot_poc1]<br>"
			dat += "<A href='?src=\ref[src];EditPock2=1'>Starting 2nd Pocket Item:</A> [src.job_creator.slot_poc2]<br>"
			dat += "<A href='?src=\ref[src];EditLhand=1'>Starting Left Hand Item:</A> [src.job_creator.slot_lhan]<br>"
			dat += "<A href='?src=\ref[src];EditRhand=1'>Starting Right Hand Item:</A> [src.job_creator.slot_rhan]<br>"
			dat += "<A href='?src=\ref[src];GetAccess=1'>Access Permissions:</A><br>"
			for(var/X in src.job_creator.access)
				dat += "[X], "
		dat += "<BR>"
		dat += "<A href='?src=\ref[src];CreateJob=1'><b>Create Job</b></A>"
		dat += "</body></html>"

		usr << browse(dat,"window=jobcreator;size=500x600")

	Topic(href, href_list[])
		// JOB CONFIG COMMANDS
		if(href_list["AlterCap"])
			var/list/alljobs = src.staple_jobs | src.special_jobs
			var/datum/job/JOB = locate(href_list["AlterCap"]) in alljobs
			var/newcap = input("Choose the new cap.","Job Cap Config") as num
			JOB.limit = newcap
			message_admins("Admin [key_name(usr)] altered [JOB.name] job cap to [newcap]")
			logTheThing("admin", usr, null, "altered [JOB.name] job cap to [newcap]")
			logTheThing("diary", usr, null, "altered [JOB.name] job cap to [newcap]", "admin")
			src.job_config()

		if(href_list["RemoveJob"])
			var/list/alljobs = src.staple_jobs | src.special_jobs
			var/datum/job/JOB = locate(href_list["RemoveJob"]) in alljobs
			if (!istype(JOB,/datum/job/created/))
				boutput(usr, "<span style=\"color:red\"><b>Removing integral jobs is not allowed. Bad for business, y'know.</b></span>")
				return
			message_admins("Admin [key_name(usr)] removed special job [JOB.name]")
			logTheThing("admin", usr, null, "removed special job [JOB.name]")
			logTheThing("diary", usr, null, "removed special job [JOB.name]", "admin")
			src.special_jobs -= JOB
			src.job_config()

		if(href_list["SpecialToggle"])
			src.allow_special_jobs = !src.allow_special_jobs
			message_admins("Admin [key_name(usr)] toggled Special Jobs [src.allow_special_jobs ? "On" : "Off"]")
			logTheThing("admin", usr, null, "toggled Special Jobs [src.allow_special_jobs ? "On" : "Off"]")
			logTheThing("diary", usr, null, "toggled Special Jobs [src.allow_special_jobs ? "On" : "Off"]", "admin")
			src.job_config()

		if(href_list["JobCreator"])
			src.job_creator()

		// JOB CREATOR COMMANDS

		// I tweaked this section a little so you can actual search for certain items.
		// Scrolling through a list of ~2600 items wasn't exactly great (Convair880).

		if(href_list["EditName"])
			var/picker = input("What is this job's name?","Job Creator")
			src.job_creator.name = picker
			src.job_creator()

		if(href_list["EditWages"])
			var/picker = input("How much does this job get paid each payday?","Job Creator") as num
			src.job_creator.wages = picker
			src.job_creator()

		if(href_list["EditLimit"])
			var/picker = input("How many of this job can there be on the station?","Job Creator") as num
			src.job_creator.limit = picker
			src.job_creator()

		if(href_list["EditMob"])
			var/list/L = list()
			var/search_for = input(usr, "Search for mob (or leave blank for complete list)", "Select mob") as null|text
			if (search_for)
				for (var/R in typesof(/mob))
					if (findtext("[R]", search_for)) L += R
			else
				L = typesof(/mob)

			var/picker = null
			if (L.len == 1)
				picker = L[1]
			else if (L.len > 1)
				picker = input(usr,"Select mob:","Job Creator",null) as null|anything in L
			else
				usr.show_text("No mob matching that name", "red")
				return

			src.job_creator.mob_type = picker
			src.job_creator()

		if(href_list["EditHeadgear"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_head = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for headgear (or leave blank for complete list)", "Select headgear") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/head))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/head)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select headgear:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No headgear matching that name", "red")
						return

					src.job_creator.slot_head = picker

			src.job_creator()

		if(href_list["EditMask"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_mask = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for mask (or leave blank for complete list)", "Select mask") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/mask))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/mask)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select mask:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No mask matching that name", "red")
						return

					src.job_creator.slot_mask = picker

			src.job_creator()

		if(href_list["EditHeadset"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_ears = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for headset (or leave blank for complete list)", "Select headset") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/device/radio/headset))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/device/radio/headset)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select headset:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No headset matching that name", "red")
						return

					src.job_creator.slot_ears = picker

			src.job_creator()

		if(href_list["EditGlasses"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_eyes = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for glasses (or leave blank for complete list)", "Select glasses") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/glasses))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/glasses)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select glasses:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No glasses matching that name", "red")
						return

					src.job_creator.slot_eyes = picker

			src.job_creator()

		if(href_list["EditOvercoat"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_suit = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for exosuit (or leave blank for complete list)", "Select exosuit") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/suit))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/suit)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select exosuit:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No exosuit matching that name", "red")
						return

					src.job_creator.slot_suit = picker

			src.job_creator()

		if(href_list["EditJumpsuit"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_jump = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for jumpsuit (or leave blank for complete list)", "Select jumpsuit") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/under))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/under)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select jumpsuit:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No jumpsuit matching that name", "red")
						return

					src.job_creator.slot_jump = picker

			src.job_creator()

		if(href_list["EditIDCard"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_card = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for ID card (or leave blank for complete list)", "Select ID card") as null|text
					if (search_for)
						for (var/R in (typesof(/obj/item/card) - list(/obj/item/card/emag, /obj/item/card/emag/fake)))
							if (findtext("[R]", search_for)) L += R
					else
						// These cards can't be worn on the ID slot and they're not compatible with the
						// job controller because they don't support access lists (Convair880).
						L = (typesof(/obj/item/card) - list(/obj/item/card/emag, /obj/item/card/emag/fake))

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select ID card:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No ID card matching that name", "red")
						return

					src.job_creator.slot_card = picker

			src.job_creator()

		if(href_list["EditGloves"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_glov = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for gloves (or leave blank for complete list)", "Select gloves") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/gloves))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/gloves)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select gloves:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No gloves matching that name", "red")
						return

					src.job_creator.slot_glov = picker

			src.job_creator()

		if(href_list["EditShoes"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_foot = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for shoes (or leave blank for complete list)", "Select shoes") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/clothing/shoes))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/clothing/shoes)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select shoes:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No shoes matching that name", "red")
						return

					src.job_creator.slot_foot = picker

			src.job_creator()

		if(href_list["EditBack"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_back = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for backslot item (or leave blank for complete list)", "Select backslot item") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select backslot item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No backslot item matching that name", "red")
						return

					// I wish there would be a better way to filter this stuff, typesof() just doesn't cut it.
					// I suppose this is still slightly more elegant than the fixed (and outdated) list that
					// used to be here. Anway, the job controller will not spawn unsuitable items (Convair880).
					if (picker)
						var/obj/item/check = new picker
						if (!(check.flags & ONBACK))
							usr.show_text("This item cannot be worn on the back slot.", "red")
							qdel(check)
							return
						qdel(check)

					src.job_creator.slot_back = picker

			src.job_creator()

		if(href_list["EditBelt"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_belt = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for beltslot item (or leave blank for complete list)", "Select beltslot item") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select beltslot item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No beltslot item matching that name", "red")
						return

					// Ditto (Convair880).
					if (picker)
						var/obj/item/check = new picker
						if (!(check.flags & ONBELT))
							usr.show_text("This item cannot be worn on the belt slot.", "red")
							qdel(check)
							return
						qdel(check)

					src.job_creator.slot_belt = picker

			src.job_creator()

		if(href_list["EditPock1"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_poc1 = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for item (or leave blank for complete list)", "Select pocket #1") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No item matching that name", "red")
						return

					// Ditto (Convair880).
					if (picker)
						var/obj/item/check = new picker
						if (check.w_class > 2)
							usr.show_text("This item is too large to fit in a jumpsuit pocket.", "red")
							qdel(check)
							return
						qdel(check)

					src.job_creator.slot_poc1 = picker

			src.job_creator()

		if(href_list["EditPock2"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_poc2 = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for item (or leave blank for complete list)", "Select pocket #2") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No item matching that name", "red")
						return

					// Ditto (Convair880).
					if (picker)
						var/obj/item/check = new picker
						if (check.w_class > 2)
							usr.show_text("This item is too large to fit in a jumpsuit pocket.", "red")
							qdel(check)
							return
						qdel(check)

					src.job_creator.slot_poc2 = picker

			src.job_creator()

		if(href_list["EditLhand"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_lhan = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for item (or leave blank for complete list)", "Select left hand") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No item matching that name", "red")
						return

					src.job_creator.slot_lhan = picker

			src.job_creator()

		if(href_list["EditRhand"])
			switch(alert("Clear or reselect slotted item?","Job Creator","Clear","Reselect"))
				if("Clear")
					src.job_creator.slot_rhan = null

				if("Reselect")
					var/list/L = list()
					var/search_for = input(usr, "Search for item (or leave blank for complete list)", "Select right hand") as null|text
					if (search_for)
						for (var/R in typesof(/obj/item/))
							if (findtext("[R]", search_for)) L += R
					else
						L = typesof(/obj/item/)

					var/picker = null
					if (L.len == 1)
						picker = L[1]
					else if (L.len > 1)
						picker = input(usr,"Select item:","Job Creator",null) as null|anything in L
					else
						usr.show_text("No item matching that name", "red")
						return

					src.job_creator.slot_rhan = picker

			src.job_creator()

		if(href_list["GetAccess"])
			var/picker = input("Make this job's access comparable to which job?","Job Creator") in list("Captain","Head of Security",
			"Head of Personnel","Chief Engineer","Research Director","Security Officer","Detective","Geneticist","Roboticist","Scientist",
			"Medical Doctor","Quartermaster","Miner","Mechanic","Engineer","Chef","Barman","Botanist","Janitor","Chaplain","Civilian","No Access")
			src.job_creator.access = get_access(picker)
			src.job_creator()

		if(href_list["CreateJob"])
			var/datum/job/match_check = find_job_in_controller_by_string(src.job_creator.name)
			if (match_check)
				boutput(usr, "<span style=\"color:red\"><b>A job with this name already exists. It cannot be created.</b></span>")
				return
			else
				var/datum/job/created/JOB = new /datum/job/created(src)
				src.special_jobs += JOB
				JOB.name = src.job_creator.name
				JOB.wages = src.job_creator.wages
				JOB.limit = src.job_creator.limit
				JOB.mob_type = src.job_creator.mob_type
				JOB.slot_head = src.job_creator.slot_head
				JOB.slot_mask = src.job_creator.slot_mask
				JOB.slot_ears = src.job_creator.slot_ears
				JOB.slot_eyes = src.job_creator.slot_eyes
				JOB.slot_glov = src.job_creator.slot_glov
				JOB.slot_foot = src.job_creator.slot_foot
				JOB.slot_card = src.job_creator.slot_card
				JOB.slot_jump = src.job_creator.slot_jump
				JOB.slot_suit = src.job_creator.slot_suit
				JOB.slot_back = src.job_creator.slot_back
				JOB.slot_belt = src.job_creator.slot_belt
				JOB.slot_poc1 = src.job_creator.slot_poc1
				JOB.slot_poc2 = src.job_creator.slot_poc2
				JOB.slot_lhan = src.job_creator.slot_lhan
				JOB.slot_rhan = src.job_creator.slot_rhan
				JOB.access = JOB.access | src.job_creator.access
				message_admins("Admin [key_name(usr)] created special job [JOB.name]")
				logTheThing("admin", usr, null, "created special job [JOB.name]")
				logTheThing("diary", usr, null, "created special job [JOB.name]", "admin")
			src.job_creator()

/proc/find_job_in_controller_by_string(var/string,var/staple_only = 0)
	if (!string || !istext(string))
		logTheThing("debug", null, null, "<b>Job Controller:</b> Attempt to find job with bad string in controller detected")
		return null
	var/list/excluded_strings = list("Special Respawn","Custom Names","Everything Except Assistant",
	"Engineering Department","Security Department","Heads of Staff")
	if (string in excluded_strings)
		return null
	for (var/datum/job/J in job_controls.staple_jobs)
		if (J.name == string)
			return J
	if (!staple_only)
		for (var/datum/job/J in job_controls.special_jobs)
			if (J.name == string)
				return J
	logTheThing("debug", null, null, "<b>Job Controller:</b> Attempt to find job by string \"[string]\" in controller failed")
	return null

/proc/find_job_in_controller_by_path(var/path)
	if (!path || !ispath(path) || !istype(path,/datum/job/))
		logTheThing("debug", null, null, "<b>Job Controller:</b> Attempt to find job with bad path in controller detected")
		return null
	for (var/datum/job/J in job_controls.staple_jobs)
		if (J.type == path)
			return J
	for (var/datum/job/J in job_controls.special_jobs)
		if (J.type == path)
			return J
	logTheThing("debug", null, null, "<b>Job Controller:</b> Attempt to find job by path \"[path]\" in controller failed")
	return null

/client/proc/cmd_job_controls()
	set category = "Debug"
	set name = "Job Controls"
	set hidden=1

	if (job_controls == null) boutput(src, "UH OH! Shit's broken as fuck!")
	else src.debug_variables(job_controls)