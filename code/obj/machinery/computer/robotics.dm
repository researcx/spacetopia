/obj/machinery/computer/robotics
	name = "Robotics Control"
	icon = 'icons/obj/computer.dmi'
	icon_state = "robotics"
	req_access = list(access_robotics)
	req_access_txt = "29"
	desc = "A computer that allows an authorized user to have an overview of the cyborgs on the station."
	power_usage = 500

	var/id = 0.0
	var/perma = 0


/obj/machinery/computer/robotics/attackby(I as obj, user as mob)
	if(istype(I, /obj/item/screwdriver))
		if (perma)
			boutput(user, "<span style=\"color:red\">The screws are all weird safety-bit types! You can't turn them!</span>")
			return
		playsound(src.loc, "sound/items/Screwdriver.ogg", 50, 1)
		if(do_after(user, 20))
			if (src.stat & BROKEN)
				boutput(user, "<span style=\"color:orange\">The broken glass falls out.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				new /obj/item/raw_material/shard/glass( src.loc )
				var/obj/item/circuitboard/robotics/M = new /obj/item/circuitboard/robotics( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				M.id = src.id
				A.circuit = M
				A.state = 3
				A.icon_state = "3"
				A.anchored = 1
				qdel(src)
			else
				boutput(user, "<span style=\"color:orange\">You disconnect the monitor.</span>")
				var/obj/computerframe/A = new /obj/computerframe( src.loc )
				if(src.material) A.setMaterial(src.material)
				var/obj/item/circuitboard/robotics/M = new /obj/item/circuitboard/robotics( A )
				for (var/obj/C in src)
					C.set_loc(src.loc)
				M.id = src.id
				A.circuit = M
				A.state = 4
				A.icon_state = "4"
				A.anchored = 1
				qdel(src)

	else
		src.attack_hand(user)
	return

/obj/machinery/computer/robotics/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/robotics/process()
	..()
	if(stat & (NOPOWER|BROKEN))
		return
	use_power(250)
	src.updateDialog()
	return


/obj/machinery/computer/robotics/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.machine = src
	var/dat = "Located AI Units<BR><BR>"
	for(var/mob/living/silicon/ai/A in mobs)
		dat += "[A.name] |"
		if(A.stat)
			dat += "ERROR: Not Responding!<BR>"
		else
			dat += "Operating Normally<BR>"

		if(!isrobot(user)&&!ishivebot(user))
			//if(!A.weapon_lock)
				//dat += "<A href='?src=\ref[src];lock=1;ai=\ref[A]'>Emergency Lockout AI *Swipe ID*</A><BR>"
			//else
				//dat += "Time left:[A.weaponlock_time] | "
				//dat += "<A href='?src=\ref[src];lock=2;ai=\ref[A]'>Cancel Lockout</A><BR>"

			if(!A.killswitch)
				dat += "<A href='?src=\ref[src];gib=1;ai=\ref[A]'>Kill Switch AI *Swipe ID*</A><BR>"
			else
				dat += "Time left:[A.killswitch_time]"
				if (!isAI(user))
					dat += " | <A href='?src=\ref[src];gib=2;ai=\ref[A]'>Cancel</A>"
				dat += "<BR>"

		dat += "<BR> Connected Cyborgs<BR>"
		dat += " *------------------------------------------------*<BR>"

		for(var/mob/living/silicon/robot/R in A:connected_robots)
			dat += "[R.name] |"
			if(R.stat)
				dat += " Not Responding |"
			else
				dat += " Operating Normally |"
			if(R.cell)
				dat += " Battery Installed ([R.cell.charge]/[R.cell.maxcharge]) |"
			else
				dat += " No Cell Installed |"
			if(R.module)
				dat += " Module Installed ([R.module.name]) |"
			else
				dat += " No Module Installed |"
			dat += "<BR>"
			if(istype(user,/mob/living/silicon/ai))
				if(user == A)
					if(!R.weapon_lock)
						dat += "<A href='?src=\ref[src];lock=1;bot=\ref[R]'>Lockdown Bot</A><BR>"
					else
						dat += "Time left:[R.weaponlock_time] | "
						dat += "<A href='?src=\ref[src];lock=2;bot=\ref[R]'>Cancel Lockdown</A><BR>"
			else if(!isrobot(user)&&!ishivebot(user))
				if(!R.killswitch)
					dat += "<A href='?src=\ref[src];gib=1;bot=\ref[R]'>Kill Switch *Swipe ID*</A><BR>"
				else
					dat += "Time left:[R.killswitch_time] | "
					dat += "<A href='?src=\ref[src];gib=2;bot=\ref[R]'>Cancel</A><BR>"
			dat += "*----------*<BR>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/robotics/Topic(href, href_list)
	if(..())
		return
	if ((usr.contents.Find(src) || (in_range(src, usr) && istype(src.loc, /turf))) || (istype(usr, /mob/living/silicon)))
		usr.machine = src

	var/mob/living/silicon/robot/R = locate(href_list["bot"])
	var/mob/living/silicon/ai/A = locate(href_list["ai"])

	if (href_list["gib"])
		switch(href_list["gib"])
			if("1")
				var/obj/item/card/id/I = usr.equipped()
				if (istype(I))
					if(src.check_access(I))
						if(istype(R))
							if(R.client)
								message_admins("<span style=\"color:red\">[key_name(usr)] has activated the robot self destruct on [key_name(R)].</span>")
								logTheThing("combat", usr, R, "has activated the robot self destruct on %target%")
								boutput(R, "<span style=\"color:red\"><b>Killswitch process activated.</b></span>")
							R.killswitch = 1
							R.killswitch_time = 60

						else if(istype(A))
							if(A.client)
								message_admins("<span style=\"color:red\">[key_name(usr)] has activated the AI self destruct on [key_name(A)].</span>")
								logTheThing("combat", usr, A, "has activated the AI self destruct on %target%")
								boutput(A, "<span style=\"color:red\"><b>AI Killswitch process activated.</b></span>")
								boutput(A, "<span style=\"color:red\"><b>Killswitch will engage in 60 seconds.</b></span>") // more like 180 really but whatever
							A.killswitch = 1
							A.killswitch_time = 60

					else
						boutput(usr, "<span style=\"color:red\">Access Denied.</span>")

			if("2")
				if(istype(R))
					R.killswitch_time = 60
					R.killswitch = 0
					if(R.client)
						message_admins("<span style=\"color:red\">[key_name(usr)] has stopped the robot self destruct on [key_name(R, 1, 1)].</span>")
						logTheThing("combat", usr, R, "has stopped the robot self destruct on %target%.")
						boutput(R, "<span style=\"color:orange\"><b>Killswitch process deactivated.</b></span>")
				else if(istype(A))
					A.killswitch_time = 60
					A.killswitch = 0
					if(A.client)
						message_admins("<span style=\"color:red\">[key_name(usr)] has stopped the AI self destruct on [key_name(A, 1, 1)].</span>")
						logTheThing("combat", usr, A, "has stopped the AI self destruct on %target%.")
						boutput(A, "<span style=\"color:orange\"><b>Killswitch process deactivated.</b></span>")


	if (href_list["lock"])
		switch(href_list["lock"])
			if("1")
				if(istype(R))
					if(R.client)
						if (R.emagged)
							boutput(R, "<span style=\"color:orange\"><b>Weapon Lock signal blocked!</b></span>")
							return
						boutput(R, "<span style=\"color:red\"><b>Weapon Lock activated!</b></span>")
					R.weapon_lock = 1
					R.weaponlock_time = 120
					R.uneq_active()
					logTheThing("combat", usr, R, "has activated %target%'s weapon lock (120 seconds).")
					for (var/obj/item/roboupgrade/X in R.contents)
						if (X.activated)
							X.activated = 0
							boutput(R, "<b><span style=\"color:red\">[X] was shut down by the Weapon Lock!</span></b>")
						if (istype(X, /obj/item/roboupgrade/jetpack))
							R.jetpack = 0
							R.ion_trail = null
				else if(istype(A))
					var/obj/item/card/id/I = usr.equipped()
					if (istype(I))
						if(src.check_access(I))
							if(A.client)
								boutput(A, "<span style=\"color:red\"><b>Emergency lockout activated!</b></span>")
								A.weapon_lock = 1
								A.weaponlock_time = 120
								logTheThing("combat", usr, A, "has activated %target%'s weapon lock (120 seconds).")
					else
						boutput(usr, "<span style=\"color:red\">Access Denied.</span>")

			if("2")
				if(istype(R))
					if(R.emagged) return
					if(R.client)
						boutput(R, "Weapon Lock deactivated.")
					R.weapon_lock = 0
					R.weaponlock_time = 120
					logTheThing("combat", usr, R, "has deactivated %target%'s weapon lock.")

				else if(istype(A))
					if(A.client)
						boutput(A, "Emergency lockout deactivated.")
					A.weapon_lock = 0
					A.weaponlock_time = 120
					logTheThing("combat", usr, A, "has deactivated %target%'s weapon lock.")

	src.updateUsrDialog()
	return
