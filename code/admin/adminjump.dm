#include "macros.dm"

/client/proc/Jump(var/area/A in world)
	set desc = "Area to jump to"
	set category = "Admin"
	set name = "Jump"
	admin_only

	if(config.allow_admin_jump)
		if(theater)
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, usr.loc)
			smoke.start()
		var/list/turfs = get_area_turfs(A, 1)
		if (turfs && turfs.len)
			usr.set_loc(pick(turfs))
		else
			boutput(src, "Can't jump there, zero turfs in that area.")
			return
		if(theater)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, usr.loc)
			s.start()
			var/datum/effects/system/harmless_smoke_spread/smoke1 = new /datum/effects/system/harmless_smoke_spread()
			smoke1.set_up(5, 0, usr.loc)
			smoke1.start()
		logTheThing("admin", usr, null, "jumped to [A] ([showCoords(usr.x, usr.y, usr.z)])")
		logTheThing("diary", usr, null, "jumped to [A] ([showCoords(usr.x, usr.y, usr.z)])", "admin")
		message_admins("[key_name(usr)] jumped to [A] ([showCoords(usr.x, usr.y, usr.z)])")
	else
		alert("Admin jumping disabled")

/client/proc/jumptoturf(var/turf/T in world)
	set category = null
	set name = "Jump To Turf"
	admin_only
	if(config.allow_admin_jump)
		logTheThing("admin", usr, null, "jumped to [showCoords(T.x, T.y, T.z)] in [get_area(T)]")
		logTheThing("diary", usr, null, "jumped to [showCoords(T.x, T.y, T.z, 1)] in [get_area(T)]", "admin")
		message_admins("[key_name(usr)] jumped to [showCoords(T.x, T.y, T.z)] in [get_area(T)]")
		if(theater)
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, usr.loc)
			smoke.start()
		usr.set_loc(T)
		if(theater)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, usr.loc)
			s.start()
			var/datum/effects/system/harmless_smoke_spread/smoke1 = new /datum/effects/system/harmless_smoke_spread()
			smoke1.set_up(5, 0, usr.loc)
			smoke1.start()
	else
		alert("Admin jumping disabled")
	return

/client/proc/jtt(var/turf/T in world)
	set category = null
	set name = "JTT"
	set popup_menu = 0
	admin_only
	src.jumptoturf(T)

/client/proc/jumptomob(var/mob/M in world)
	set category = null
	set name = "Jump to Mob"
	set popup_menu = 1
	admin_only

	if(config.allow_admin_jump)
		logTheThing("admin", usr, M, "jumped to %target% ([showCoords(M.x, M.y, M.z)] in [get_area(M)])")
		logTheThing("diary", usr, M, "jumped to %target% ([showCoords(M.x, M.y, M.z)] in [get_area(M)])", "admin")
		message_admins("[key_name(usr)] jumped to [key_name(M)] ([showCoords(M.x, M.y, M.z)] in [get_area(M)])")
		if(theater)
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, usr.loc)
			smoke.start()
		usr.set_loc(get_turf(M))
		if(theater)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, usr.loc)
			s.start()
			var/datum/effects/system/harmless_smoke_spread/smoke1 = new /datum/effects/system/harmless_smoke_spread()
			smoke1.set_up(5, 0, usr.loc)
			smoke1.start()
	else
		alert("Admin jumping disabled")

/client/proc/jtm(var/mob/M in world)
	set category = null
	set name = "JTM"
	set popup_menu = 0
	admin_only
	src.jumptomob(M)

/client/proc/jumptokey(var/client/ckey in clients)
	set category = "Admin"
	set name = "Jump to Key"

	admin_only

	if(config.allow_admin_jump)
		var/mob/target
		if (!ckey)
			var/client/selection = input("Please, select a player!", "Admin Jumping", null, null) as null|anything in clients
			if(!selection)
				return
			target = selection.mob
		else
			target = ckey.mob
		logTheThing("admin", usr, target, "jumped to %target% ([showCoords(target.x, target.y, target.z)] in [get_area(target)])")
		logTheThing("diary", usr, target, "jumped to %target% ([showCoords(target.x, target.y, target.z)] in [get_area(target)])", "admin")
		message_admins("[key_name(usr)] jumped to [key_name(target)] ([showCoords(target.x, target.y, target.z)] in [get_area(target)])")
		if(theater)
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, usr.loc)
			smoke.start()
		usr.set_loc(target.loc)
		if(theater)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, usr.loc)
			s.start()
			var/datum/effects/system/harmless_smoke_spread/smoke1 = new /datum/effects/system/harmless_smoke_spread()
			smoke1.set_up(5, 0, usr.loc)
			smoke1.start()
	else
		alert("Admin jumping disabled")

/client/proc/jtk(var/client/ckey in clients)
	set category = null
	set name = "JTK"
	set popup_menu = 0
	admin_only
	src.jumptokey(ckey)

/client/proc/jumptocoord(var/x = 1 as num, var/y = 1 as num, var/z = 1 as num)
	set category = "Admin"
	set name = "Jump to Coord"
	set desc = "Jump to a coordinate in world (x, y, z)"

	admin_only

	if(config.allow_admin_jump)
		if (x > world.maxx || x < 1 || y > world.maxy || y < 1 || z > world.maxz || z < 1)
			alert("Invalid coordinates")
			return
		var/turf/turf = locate(x, y, z)
		if(theater)
			var/datum/effects/system/harmless_smoke_spread/smoke = new /datum/effects/system/harmless_smoke_spread()
			smoke.set_up(5, 0, usr.loc)
			smoke.start()
		usr.set_loc(turf)
		if(theater)
			var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
			s.set_up(5, 1, usr.loc)
			s.start()
			var/datum/effects/system/harmless_smoke_spread/smoke1 = new /datum/effects/system/harmless_smoke_spread()
			smoke1.set_up(5, 0, usr.loc)
			smoke1.start()
		logTheThing("admin", usr, null, "jumped to [showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)]")
		logTheThing("diary", usr, null, "jumped to [showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)]", "admin")
		message_admins("[key_name(usr)] jumped to [showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)]")
	else
		alert("Admin jumping disabled")

/client/proc/jtc(var/x = 1 as num, var/y = 1 as num, var/z = 1 as num)
	set category = null
	set name = "JTC"
	set popup_menu = 0
	admin_only
	src.jumptocoord(x, y, z)

/client/proc/Getmob(var/mob/M in world)
	set category = null
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set popup_menu = 0
	admin_only
	if(config.allow_admin_jump)
		logTheThing("admin", usr, M, "teleported %target% ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
		logTheThing("diary", usr, M, "teleported %target% ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
		message_admins("[key_name(usr)] teleported [key_name(M)] ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
		M.set_loc(get_turf(usr))
	else
		alert("Admin jumping disabled")

/client/proc/sendmob(var/mob/M in world, var/area/A in world)
	set category = null
	set name = "Send Mob"
	set popup_menu = 0
	admin_only
	if(config.allow_admin_jump)
		var/list/turfs = get_area_turfs(A)
		if (turfs == null || turfs.len == 0)
			boutput(src, "Unable to find any turf in that area.")
			return

		M.set_loc(pick(turfs))
		logTheThing("admin", usr, M, "sent %target% to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
		logTheThing("diary", usr, M, "sent %target% to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])", "admin")
		message_admins("[key_name(usr)] teleported [key_name(M)] to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
	else
		alert("Admin jumping disabled")

/client/proc/sendhmobs(var/area/A in world)
	set category = "Admin"
	set name = "Send all Human Mobs"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		for(var/mob/living/carbon/human/H in mobs)
			H.set_loc(pick(get_area_turfs(A)))

		logTheThing("admin", usr, null, "teleported all humans to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
		logTheThing("diary", usr, null, "teleported all humans to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])", "admin")
		message_admins("[key_name(usr)] teleported all humans to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
	else
		alert("Admin jumping disabled")

/client/proc/sendmobs(var/area/A in world)
	set category = "Admin"
	set name = "Send all Mobs"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		for(var/mob/living/M in mobs)
			M.set_loc(pick(get_area_turfs(A)))

		logTheThing("admin", usr, null, "teleported all mobs to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
		logTheThing("diary", usr, null, "teleported all mobs to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])", "admin")
		message_admins("[key_name(usr)] teleported all mobs to [A] ([showCoords(A.x, A.y, A.z)] in [get_area(A)])")
	else
		alert("Admin jumping disabled")

/client/proc/gethmobs()
	set category = "Admin"
	set name = "Get all Human Mobs"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		switch(alert("Are you sure?",,"Yes","No"))
			if("Yes")
				for(var/mob/living/carbon/human/H in mobs)
					H.set_loc(get_turf(usr))

				logTheThing("admin", usr, null, "teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
				logTheThing("diary", usr, null, "teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
				message_admins("[key_name(usr)] teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
			if("No")
				return
	else
		alert("Admin jumping disabled")

/client/proc/getmobs()
	set category = "Admin"
	set name = "Get all Mobs"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		switch(alert("Are you sure?",,"Yes","No"))
			if("Yes")
				for(var/mob/living/H in mobs)
					H.set_loc(get_turf(usr))

				logTheThing("admin", usr, null, "teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
				logTheThing("diary", usr, null, "teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
				message_admins("[key_name(usr)] teleported all humans to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
			if("No")
				return
	else
		alert("Admin jumping disabled")

/client/proc/gettraitors()
	set category = "Admin"
	set name = "Get all Traitors"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		switch(alert("Are you sure?",,"Yes","No"))
			if("Yes")
				for(var/mob/living/M in mobs)
					if(checktraitor(M))
						M.set_loc(get_turf(usr))

				logTheThing("admin", usr, null, "brought all traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
				logTheThing("diary", usr, null, "brought all traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
				message_admins("[key_name(usr)] teleported all traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
			if("No")
				return
	else
		alert("Admin jumping disabled")

/client/proc/getnontraitors()
	set category = "Special Verbs"
	set name = "Get all Non-Traitors"
	set hidden = 1
	admin_only
	if(config.allow_admin_jump)
		switch(alert("Are you sure?",,"Yes","No"))
			if("Yes")
				for(var/mob/living/M in mobs)
					if(checktraitor(M))
						continue
					M.set_loc(get_turf(usr))

				logTheThing("admin", usr, null, "brought all non-traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
				logTheThing("diary", usr, null, "brought all non-traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
				message_admins("[key_name(usr)] teleported all non-traitors to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
			if("No")
				return
	else
		alert("Admin jumping disabled")

/client/proc/cmd_admin_get_mobject(var/atom/target as mob|obj in world)
	set category = "Admin"
	set popup_menu = 1
	set name = "Get Thing"
	set desc = "Gets either a mob or an object, bringing it right to you! Wow!"
	admin_only

	if (config.allow_admin_jump)
		logTheThing("admin", usr, null, "teleported [target] to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
		logTheThing("diary", usr, null, "teleported [target] to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])", "admin")
		message_admins("[key_name(usr)] teleported [target] to themselves ([showCoords(usr.x, usr.y, usr.z)] in [get_area(usr)])")
		target:set_loc(get_turf(usr))
	else
		alert("Admin jumping disabled")
