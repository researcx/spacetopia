/obj/item/pen/sleepypen
	desc = "It's a normal black ink pen with a sharp point."
	flags = FPRINT | ONBELT | TABLEPASS | NOSPLASH | OPENCONTAINER
	var/amount_per_transfer = 50
	var/destroyed = 0

	New()
		..()
		var/datum/reagents/R = new/datum/reagents(100)
		reagents = R
		R.my_atom = src
		R.add_reagent("sonambutril", 100)
		return

	attack_self(mob/user)
		if (src.destroyed)
			return

		user.machine = src
		var/dat = ""
		dat += "Injection amount: <A href='?src=\ref[src];change_amt=1'>[amount_per_transfer == -1 ? "ALL" : amount_per_transfer]</A><BR><BR>"

		if (src.reagents.total_volume)
			dat += "Contains: <BR>"
			for (var/current_id in reagents.reagent_list)
				var/datum/reagent/current_reagent = reagents.reagent_list[current_id]
				dat += " - [current_reagent.volume] [current_reagent.name]<BR>"
			dat += "<A href='?src=\ref[src];dump_cont=1'>Dump contents</A><BR>"

		dat += "<A href='?src=\ref[src];self_destruct=1'>Remove needle</A><BR>"

		user << browse("<TITLE>Injection Settings</TITLE><BR>[dat]", "window=sleepypen;size=350x250")
		onclose(user, "sleepypen")
		return

	attack(mob/M, mob/user as mob)
		if (!ismob(M))
			return

		if (src.destroyed)
			return ..()

		if (src.reagents.total_volume)
			if (!M.reagents || (M.reagents && M.reagents.is_full()))
				boutput(user, "<span style=\"color:red\">[M] cannot absorb any chemicals.</span>")
				return

			boutput(user, "<span style=\"color:red\">You stab [M] with the pen.</span>")
			logTheThing("combat", user, M, "stabs %target% with the sleepy pen [log_reagents(src)] at [log_loc(user)].")
			src.reagents.trans_to(M, (amount_per_transfer == -1 ? src.reagents.total_volume : amount_per_transfer))

		else
			boutput(user, "<span style=\"color:red\">The sleepy pen is empty.</span>")
		return

	Topic(href, href_list)
		..()

		if (usr != src.loc || destroyed)
			return

		if (href_list["dump_cont"])
			src.reagents.clear_reagents()

		if (href_list["change_amt"])
			var/amt = input(usr,"Select:","Amount", src.amount_per_transfer) in list("ALL",1,2,3,4,5,8,10,15,20,25,30,40,50)
			if (amt == "ALL")
				src.amount_per_transfer = -1
			else
				src.amount_per_transfer = amt

		if (href_list["self_destruct"])
			src.desc = "It's a normal black ink pen."
			src.destroyed = 1

		updateUsrDialog()
		attack_self(usr)