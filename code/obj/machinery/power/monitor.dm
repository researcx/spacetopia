// the power monitoring computer
// for the moment, just report the status of all APCs in the same powernet

/obj/machinery/power/monitor
	name = "Power Monitoring Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"
	density = 1
	anchored = 1
	desc = "Shows the power usage of the station."
	var/window_tag = "powcomp"

/obj/machinery/power/monitor/attack_ai(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/power/monitor/proc/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.machine = null
			user << browse(null, "window=[window_tag]")
			return

	user.machine = src
	var/t = "[css_interfaces]<TT><B>Power Monitoring</B><HR>"

	if(!powernet)
		t += "<span style=\"color:red\">No connection</span>"
	else

		var/list/L = list()
		for(var/obj/machinery/power/terminal/term in powernet.nodes)
			if(istype(term.master, /obj/machinery/power/apc))
				var/obj/machinery/power/apc/A = term.master
				L += A

		t += "<PRE>Total power: [engineering_notation(powernet.avail)]W<BR>Total load:  [engineering_notation(powernet.viewload)]W<BR>"

		t += "<FONT SIZE=-1>"

		if(L.len > 0)

			t += "Area                           Eqp./Lgt./Env.  Load   Cell  | Area                           Eqp./Lgt./Env.  Load   Cell<HR>"

			var/list/S = list(" Off","AOff","  On", " AOn")
			var/list/chg = list("N","C","F")

			var/do_newline = 0
			for(var/obj/machinery/power/apc/A in L)

				t += copytext(add_tspace(A.area.name, 30), 1, 30)
				t += " [S[A.equipment+1]] [S[A.lighting+1]] [S[A.environ+1]] [add_lspace(A.lastused_total, 6)]  [A.cell ? "[add_lspace(round(A.cell.percent()), 3)]% [chg[A.charging+1]]" : "  N/C"][do_newline ? "<BR>" : " | "]"
				do_newline = !do_newline

		t += "</FONT></PRE>"

	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A></TT>"

	user << browse(t, "window=[window_tag];size=840x700")
	onclose(user, window_tag)

/obj/machinery/power/monitor/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=[window_tag]")
		usr.machine = null
		return

/obj/machinery/power/monitor/process()
	if(!(stat & (NOPOWER|BROKEN)) )
		use_power(250)

	src.updateDialog()

/obj/machinery/power/monitor/power_change()

	if(stat & BROKEN)
		icon_state = "broken"
	else
		if( powered() )
			icon_state = initial(icon_state)
			stat &= ~NOPOWER
		else
			spawn(rand(0, 15))
				src.icon_state = "c_unpowered"
				stat |= NOPOWER

// tweaked version to hook up to the engine->smes powernet and show SMES usage stats and power produced
/obj/machinery/power/monitor/smes
	name = "SMES Monitoring Computer"
	icon = 'icons/obj/computer.dmi'
	icon_state = "power"
	density = 1
	anchored = 1
	desc = "Shows the SMES usage and power produced by the engine."
	window_tag = "smespowcomp"

/obj/machinery/power/monitor/smes/interact(mob/user)

	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.machine = null
			user << browse(null, "window=[window_tag]")
			return


	user.machine = src
	var/t = "[css_interfaces]<TT><B>Engine and SMES Monitoring</B><HR>"


	if(!powernet)
		t += "<span style=\"color:red\">No connection</span>"
	else

		var/list/L = list()
		for(var/obj/machinery/power/terminal/term in powernet.nodes)
			if(istype(term.master, /obj/machinery/power/smes))
				var/obj/machinery/power/smes/A = term.master
				L += A
			else if(istype(term.master,/obj/machinery/power/pt_laser))
				var/obj/machinery/power/pt_laser/P = term.master
				L += P

		t += "<PRE>Engine Output: [engineering_notation(powernet.avail)]W<BR>SMES/PTL Draw:     [engineering_notation(powernet.viewload)]W<BR>"

		t += "<FONT SIZE=-1>"

		if(L.len > 0)

			t += "Area                   Stored Power | Charging |   Input |  Output | Active | Load<HR>"

			for(var/obj/machinery/power/smes/A in L)
				var/area/place = get_area(A)
				t += copytext(add_tspace(place.name, 30), 1, 30)

				t += "[add_lspace(round(100.0*A.charge/A.capacity, 0.1), 5)]% |      [A.charging ? "Yes" : " No"] | [add_lspace(A.chargelevel,7)] | [add_lspace(A.output,7)] |    [A.online ? "Yes" : " No"] | [A.loaddemand]<BR>"

			for(var/obj/machinery/power/pt_laser/P in L)
				var/area/place = get_area(P)
				t += copytext(add_tspace(place.name, 30), 1, 30)

				t += "[add_lspace(round(100.0*P.charge/P.output, 0.1), 5)]% |      [P.charging ? "Yes" : " No"] | [add_lspace(P.chargelevel,7)] | [add_lspace(P.output,7)] |    [P.online ? "Yes" : " No"] | N/A<BR>"

		t += "</FONT></PRE>"

	t += "<BR><HR><A href='?src=\ref[src];close=1'>Close</A></TT>"

	user << browse(t, "window=[window_tag];size=660x400")
	onclose(user, window_tag)