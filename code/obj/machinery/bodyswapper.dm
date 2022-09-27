//////////////////////////////
//The amazing bodyswappitron
////////////////////////////

/obj/machinery/bodyswapper
	name = "complicated contraption"
	desc = "A big machine with lots of buttons and dials on it. Looks kinda dangerous."
	density = 1
	anchored = 1

	icon = 'icons/obj/machines/mindswap.dmi'
	icon_state = "mindswap"

	var/obj/stool/chair/e_chair/chair1 = null
	var/obj/stool/chair/e_chair/chair2 = null

	var/used = 0
	var/do_not_break = 0 //Set to one to have the thing regain usability on reboot


	var/active = 0
	var/activating = 0
	var/operating = 0

	var/remain_active = 0
	var/remain_active_max = 400

	var/boot_duration = 150
	var/loop_duration = 11.8

	var/list/icon/overlays_list = list()

	New()
		..()
		spawn(5)
			update_chairs()

		overlays_list["cables"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-cables")

		overlays_list["topcable"] =  new /image('icons/obj/machines/mindswap.dmi', "mindswap-topcable")

		overlays_list["lscreen0"] = new/image('icons/obj/machines/mindswap.dmi', "mindswap-screenY")
		overlays_list["lscreen1"] = new/image('icons/obj/machines/mindswap.dmi', "mindswap-screenY-bright")

		overlays_list["rscreen0"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-screenT")
		overlays_list["rscreen1"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-screenT-bright")

		overlays_list["mainindicator_off"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-off")
		overlays_list["mainindicator"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial")
		overlays_list["mainindicator_on"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-on")

		overlays_list["l_dial_idle"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-L-idle")
		overlays_list["l_dial_0"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-L-on")
		overlays_list["l_dial_1"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-L-jitter")

		overlays_list["r_dial_idle"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-R-idle")
		overlays_list["r_dial_0"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-R-on")
		overlays_list["r_dial_1"] = new /image('icons/obj/machines/mindswap.dmi', "mindswap-dial-R-jitter")

		update_icons()

	attack_hand(mob/user)
		..()

		display_ui(user)

	attack_ai(mob/user)
		attack_hand(user)


	proc/update_icons()
		//src.overlays.Cut()

		UpdateOverlays(overlays_list["cables"], "cables")
		UpdateOverlays(overlays_list["topcable"], "topcable")

		if(active || activating > 1)
			UpdateOverlays(overlays_list["mainindicator[active ? "_on" : null]"], "main_ind")
		else
			UpdateOverlays(null, "main_ind")

		if(active)
			UpdateOverlays(overlays_list["lscreen[operating]"], "lscreen")
			UpdateOverlays(overlays_list["rscreen[operating]"], "rscreen")

			if(chair1 && chair1.buckled_guy)
				UpdateOverlays(overlays_list["l_dial_[operating]"], "l_dial")
			else
				UpdateOverlays(overlays_list["l_dial_idle"], "l_dial")

			if(chair2 && chair2.buckled_guy)
				UpdateOverlays(overlays_list["r_dial_[operating]"], "r_dial")
			else
				UpdateOverlays(overlays_list["r_dial_idle"], "r_dial")

		else if(activating)
			ClearSpecificOverlays("l_dial", "r_dial")
			if(activating >= 2)
				UpdateOverlays(overlays_list["lscreen[operating]"], "lscreen")
			else
				UpdateOverlays(null, "lscreen")

			if(activating >= 3)
				UpdateOverlays(overlays_list["rscreen[operating]"], "rscreen")
			else
				UpdateOverlays(null, "rscreen")

		else
			ClearSpecificOverlays("lscreen", "rscreen", "l_dial", "r_dial", "main_ind")

	proc/display_ui(var/mob/user)
		var/T
		user.machine = src
		if(active)
			if(!used)
				T = {"<h1>Control Panel</h1><hr>
					<h3>System Status: <font color=green>[operating ? "Operating" : "Active"]</font></h3>
					<A HREF='?src=\ref[src];shutdown=1'>Shut down</A>
					<h3>Device Interfaces</h3>
					<table border=1><tr>
						<th>Interface #1<td><B>[chair1 ? "<font color=green>Connected</font>" : "<font color=red>Disconnected</font>"]</B><tr>
						<th>Interface #2<td><B>[chair2 ? "<font color=green>Connected</font>" : "<font color=red>Disconnected</font>"]</B><tr>
					</table>
					<A HREF='?src=\ref[src];refresh_chair_connection=1'>Re-establish</A>
					<h3>Mental Interfaces</h3>
					<table border=1><tr>
						<th>Interface #1<td><B>[chair1 && chair1.buckled_guy ? "<font color=green>Connected</font>" : "<font color=red>Disconnected</font>"]</B><tr>
						<th>Interface #2<td><B>[chair2 && chair2.buckled_guy ? "<font color=green>Connected</font>" : "<font color=red>Disconnected</font>"]</B><tr>
					</table>
					<A HREF='?src=\ref[src];refresh_mind_connection=1'>Re-establish</A><BR><BR>
					<A HREF='?src=\ref[src];execute_swap=1'><B><font bold=5 size=7>Activate</font></B></A>"}

			else
				T = {"<body bgcolor=#000000>
					<font color=#FFFFFF>
					<h1>Control Panel</h1><hr>
					<h3>System Status: <font color=red>ERROR</font></h3>
					<A HREF='?src=\ref[src];shutdown=1'>Shut down</A>
					<h3>Device Interfaces</h3>
					<table border=1><tr>
						<th><font color=#FFFFFF>Interface #1</font><td><B><font color=red>ERROR!</font></B><tr>
						<th><font color=#FFFFFF>Interface #2</font><td><B><font color=red>ERROR!</font></B><tr>
					</table>
					<A HREF='?src=\ref[src];refresh_chair_connection=1'>ERROR</A>
					<h3>Mental Interfaces</h3>
					<table border=1><tr>
						<th><font color=#FFFFFF>Interface #1</font><td><B><font color=red>ERROR!</font></B><tr>
						<th><font color=#FFFFFF>Interface #2</font><td><B><font color=red>ERROR!</font></B><tr>
					</table>
					<A HREF='?src=\ref[src];refresh_mind_connection=1'>ERROR</A><BR><BR>

					<A HREF='?src=\ref[src];execute_swap=1'><B><font bold=5 size=7>ERROR</font></B></A>
					</font>
					</body>
					"}
		else
			T = {"<h1>Control Panel</h1><hr>
				<h3>System Status: <font color=red>[activating ? "BOOTING" : "OFFLINE"]</font></h3>
				<A HREF='?src=\ref[src];bootup=1'>Boot</A>
				<h3>Device Interfaces</h3>
				<table border=1><tr>
					<th>Interface #1<td><B>OFFLINE</B><tr>
					<th>Interface #2<td><B>OFFLINE</B><tr>
				</table>
				<U>Re-establish</U>
				<h3>Mental Interfaces</h3>
				<table border=1><tr>
					<th>Interface #1<td><B>OFFLINE</B><tr>
					<th>Interface #2<td><B>OFFLINE</B><tr>
				</table>
				<U>Re-establish</U><BR><BR>
				<U><B><font bold=5 size=7>Activate</font></B></U>"}

		user << browse(T, "window=bodyswapper;size=300x600;can_resize=1")
		onclose(user, "bodyswapper")

	Topic(href, href_list[])
		..()

		if(href_list["shutdown"])
			remain_active = 0
		else if(href_list["bootup"])
			activate()
			src.updateUsrDialog()
		else if(!used)
			if(href_list["refresh_chair_connection"])
				update_chairs()
				src.updateUsrDialog()

			else if(href_list["refresh_mind_connection"])
				src.updateUsrDialog() //lol cheats
				update_icons()

			else if(href_list["execute_swap"])
				do_swap()
				src.updateUsrDialog()
		else
			usr.show_text("The controls seem unresponsive...", "red")


	proc/activate()
		if(activating) return
		activating = 1
		src.updateUsrDialog()
		playsound(src.loc, "sound/machines/computerboot_pc_start.ogg", 50, 0)

		sleep(boot_duration / 2)
		activating = 2
		update_icons()

		sleep(boot_duration / 4)
		activating = 3
		update_icons()

		sleep(boot_duration / 4)
		active = 1
		activating = 0
		update_icons()

		remain_active = remain_active_max

		make_some_noise()
		if(do_not_break)
			used = 0
			loop_duration = initial(loop_duration)

		src.updateUsrDialog()

	proc/make_some_noise()
		do
			playsound(src.loc, "sound/machines/computerboot_pc_loop.ogg", 50, 0)
			sleep(loop_duration)
		while(active && !activating && remain_active-- > 0) //So it will shut itself down after a while

		if(remain_active <= 0)
			src.visible_message("<span style=\"color:red\">You hear a quiet click as \the [src] deactivates itself.</span>")
			deactivate()



	proc/deactivate()
		if(!active || activating || operating) return
		activating = 1
		playsound(src.loc, "sound/machines/computerboot_pc_end.ogg", 50, 0)
		sleep(20)
		activating = 0
		active = 0
		update_icons()

		src.updateUsrDialog()


	proc/update_chairs()
		if(!chair1) chair1 = locate(/obj/stool/chair/e_chair, get_step(src, WEST))
		if(!chair2) chair2 = locate(/obj/stool/chair/e_chair, get_step(src, EAST))

		if(chair1 && !chair1.on) chair1.toggle_active()
		if(chair2 && !chair2.on) chair2.toggle_active()
		update_icons()

	proc/can_operate()
		return chair1 && ishuman(chair1.buckled_guy) && !chair1.buckled_guy:on_chair && chair2 && ishuman(chair2.buckled_guy) && !chair2.buckled_guy:on_chair

	proc/do_swap()

		var/success = 1
		if(!operating && !used)

			operating = 1


			update_chairs()
			if(can_operate()) //We have what we need
				remain_active += 200 //So it won't switch itself off on us
				update_icons()

				//We're not going to allow you to unbuckle during the process
				chair1.allow_unbuckle = 0
				chair2.allow_unbuckle = 0

				var/mob/living/carbon/human/A = chair1.buckled_guy
				var/mob/living/carbon/human/B = chair2.buckled_guy

				playsound(src.loc, 'sound/machines/modem.ogg', 75, 1)

				A.emote("scream")
				A.weakened += 5
				A.show_text("<B>IT HURTS!</B>", "red")
				A.shock(src, 75000, ignore_gloves=1)

				B.emote("scream")
				B.weakened += 5
				B.show_text("<B>IT HURTS!</B>", "red")
				B.shock(src, 75000, ignore_gloves=1)
				spawn(50)
					playsound(src.loc, 'sound/machines/modem.ogg', 100, 1)
					A.show_text("<B>You feel your mind slipping...</B>", "red")
					A.drowsyness = max(A.drowsyness, 10)
					B.show_text("<B>You feel your mind slipping...</B>", "red")
					B.drowsyness = max(B.drowsyness, 10)

				sleep(100)
				playsound(src.loc,'sound/effects/elec_bzzz.ogg', 60, 1)
				if(A && B && can_operate()) //We're all here, still
					A.emote("faint")
					A.paralysis = max(A.paralysis,25)
					A.shock(src, 750000, ignore_gloves=1)

					B.emote("faint")
					B.paralysis = max(B.paralysis,25)
					A.shock(src, 750000, ignore_gloves=1)

					if(A.mind)
						A.mind.swap_with(B)
					else if(B.mind) //Just in case A is mindless, try from B's side
						B.mind.swap_with(A)
					else
						success = 0

				else if(!can_operate()) //Someone was being clever during the process
					spawn(0)
						if(A)
							playsound(A.loc, 'sound/effects/robogib.ogg', 70, 1)
							A.show_text("<B>The residual energy from the machine suddenly rips you apart!</B>", "red")
							A.shock(src, 7500000, ignore_gloves=1)
							if(A) A.vaporize() //Still standing, you fuck?
						if(B)
							playsound(B.loc, 'sound/effects/robogib.ogg', 70, 1)
							B.show_text("<B>The residual energy from the machine suddenly rips you apart!</B>", "red")
							B.shock(src, 7500000, ignore_gloves=1)
							if(B) B.vaporize() //Still standing, you fuck?

				//Time to die

				//We're now going to allow you to unbuckle

				if(chair1) chair1.allow_unbuckle = 1
				if(chair2) chair2.allow_unbuckle = 1
			else //Failure.
				success = 0

			if(success)
				playsound(src.loc, 'sound/effects/electric_shock.ogg', 50,1)
				src.visible_message("<span style=\"color:red\">\The [src] emits a loud crackling sound and the smell of ozone fills the air!</span>")
				loop_duration = 7 //Something is amiss oh no!
				remain_active = min(remain_active, 100)
				remain_active_max = 100
				used = 1
			else
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50,1)
				src.visible_message("<span style=\"color:red\">\The [src] emits a whirring and clicking noise followed by an angry beep!</span>")

		spawn(50)
			operating = 0
			update_icons()