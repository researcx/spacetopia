//List of verbs cluttering the popup menus
//ADD YOUR SHIT HERE IF YOU MAKE A NEW VERB THAT GOES ON RIGHT-CLICK OR YOU ARE LITERALLY HITLER (Aka marquesas jr)
//fixed that for you -marq
var/list/popup_verbs_to_toggle = list(\
/client/proc/addpathogens,\
/client/proc/addreagents,\
/client/proc/call_proc_atom,\
/client/proc/cmd_admin_check_reagents,\
/client/proc/cmd_admin_check_health,\
/client/proc/cmd_admin_get_mobject,\
/client/proc/admin_follow_mobject,\
/client/proc/cmd_admin_delete,\
/client/proc/debug_variables,\
/proc/possess,\
/client/proc/view_fingerprints,\
/client/proc/cmd_admin_pm,\
/client/proc/cmd_admin_gib,\
/client/proc/cmd_admin_rejuvenate,\
/client/proc/jumptomob,\
/client/proc/cmd_admin_playeropt,\
/client/proc/cmd_admin_subtle_message,\
/client/proc/view_save_data,\
/client/proc/cmd_admin_polymorph,\
/client/proc/sendmobs,\
/client/proc/sendhmobs,\
/verb/create_portal,\
/client/proc/jumptoturf,\
/client/proc/cmd_explosion,\
/client/proc/air_status,\
/client/proc/Jump,\
/client/proc/debug_check_possible_reactions,\
/client/proc/revive_critter,\
/client/proc/kill_critter,\
/client/proc/admin_smoke,\
/client/proc/admin_foam,\
/client/proc/cmd_swap_minds,\
/client/proc/cmd_admin_polymorph,\
/client/proc/cmd_add_to_screen,\
/client/proc/edit_module,\
/client/proc/modify_organs,\
/client/proc/generate_poster,\
/client/proc/modify_parts,\
/client/proc/cmd_boot,\
/client/proc/cmd_shame_cube,\
/client/proc/replace_with_explosive\
)

/client/proc/toggle_popup_verbs()
	set category = "Toggles"
	set name = "Toggle Popup Verbs"
	set desc = "Toggle verbs that appear on right-click"
	set hidden=1
	admin_only

	var/list/final_verblist

	//The main bunch
	for(var/I = 1,  I <= admin_verbs.len && I <= rank_to_level(src.holder.rank)+2, I++)
		final_verblist += popup_verbs_to_toggle & admin_verbs[I] //So you only toggle verbs at your level

	//The special A+ observer verbs
	if(rank_to_level(src.holder.rank) >= LEVEL_ADMIN)
		final_verblist |= special_admin_observing_verbs
		//And the special PA+ observer verbs why do we even use this? It's dumb imo
		if(rank_to_level(src.holder.rank) >= LEVEL_PA)
			final_verblist |= special_pa_observing_verbs

	if(final_verblist.len)
		if(!src.holder.popuptoggle)
			for(var/V in final_verblist)
				src.verbs -= V
		else
			for(var/V in final_verblist)
				src.verbs += V
		src.holder.popuptoggle = !src.holder.popuptoggle

		boutput(usr, "<span style=\"color:orange\">Toggled popup verbs [src.holder.popuptoggle?"off":"on"]!</span>")

	return

// if it's in Toggles (Server) it should be in here, ya dig?
var/list/server_toggles_tab_verbs = list(\
/client/proc/toggle_attack_messages,\
/client/proc/toggle_toggles,\
/client/proc/toggle_jobban_announcements,\
/client/proc/toggle_banlogin_announcements,\
/client/proc/toggle_literal_disarm,\
/datum/admins/proc/voteres,\
/datum/admins/proc/toggleooc,\
/datum/admins/proc/togglelooc,\
/datum/admins/proc/toggleoocdead,\
/datum/admins/proc/toggletraitorscaling,\
/datum/admins/proc/pcap,\
/datum/admins/proc/toggleenter,\
/datum/admins/proc/toggleAI,\
/datum/admins/proc/toggle_soundpref_override,\
/datum/admins/proc/toggle_respawns,\
/datum/admins/proc/adsound,\
/datum/admins/proc/adspawn,\
/datum/admins/proc/adrev,\
/datum/admins/proc/toggledeadchat,\
/datum/admins/proc/togglefarting,\
/datum/admins/proc/toggle_blood_system,\
/datum/admins/proc/toggle_bone_system,\
/datum/admins/proc/togglesuicide,\
/datum/admins/proc/togglethetoggles,\
/datum/admins/proc/toggleautoending,\
/datum/admins/proc/toggleaprilfools,\
/datum/admins/proc/togglemonkeyspeakhuman,\
/datum/admins/proc/togglelatetraitors,\
/datum/admins/proc/togglesoundwaiting,\
/datum/admins/proc/adjump,\
/datum/admins/proc/togglesimsmode,\
/client/proc/admin_toggle_nightmode,\
/client/proc/toggle_camera_network_reciprocity\
)

/client/proc/toggle_server_toggles_tab()
	set category = "Toggles"
	set name = "Toggle Server Toggles Tab"
	set desc = "Toggle all the crap in the Toggles (Server) tab so it should go away/show up.  in thoery."
	set hidden=1
	admin_only

	var/list/final_verblist

	//The main bunch
	for (var/I = 1,  I <= admin_verbs.len && I <= rank_to_level(src.holder.rank)+2, I++)
		final_verblist += server_toggles_tab_verbs & admin_verbs[I] //So you only toggle verbs at your level

	//The special A+ observer verbs
	if (rank_to_level(src.holder.rank) >= LEVEL_ADMIN)
		final_verblist |= special_admin_observing_verbs
		//And the special PA+ observer verbs why do we even use this? It's dumb imo
		if (rank_to_level(src.holder.rank) >= LEVEL_PA)
			final_verblist |= special_pa_observing_verbs

	if (final_verblist.len)
		if (!src.holder.servertoggles_toggle)
			for (var/V in final_verblist)
				src.verbs -= V
		else
			for (var/V in final_verblist)
				src.verbs += V
		src.holder.servertoggles_toggle = !src.holder.servertoggles_toggle

		boutput(usr, "<span style=\"color:orange\">Toggled Server Toggle tab [src.holder.servertoggles_toggle?"off":"on"]!</span>")

	return

/client/proc/toggle_extra_verbs()//Going to put some things in here that we dont need to see every single second when trying to play though atm only the add_r is in it
	set category = "Toggles"
	set name = "Toggle Extra Verbs"
	admin_only
	if (!src.holder.extratoggle)
		src.verbs -= /client/proc/addreagents
		src.verbs -= /client/proc/jobbans

		src.verbs -= /proc/possess
		src.verbs -= /client/proc/addreagents
		src.verbs -= /client/proc/cmd_admin_rejuvenate

		src.verbs -= /client/proc/main_loop_context
		src.verbs -= /client/proc/main_loop_tick_detail
		src.verbs -= /client/proc/ticklag

		src.holder.extratoggle = 1
		boutput(src, "Extra Toggled Off")
	else
		src.verbs += /client/proc/addreagents
		src.holder.extratoggle = 0
		boutput(src, "Extra Toggled On")
		src.verbs += /client/proc/addreagents
		src.verbs += /client/proc/jobbans


		src.verbs += /proc/possess
		src.verbs += /client/proc/addreagents
		src.verbs += /client/proc/cmd_admin_rejuvenate

		src.verbs += /client/proc/main_loop_context
		src.verbs += /client/proc/main_loop_tick_detail
		src.verbs += /client/proc/ticklag

var/global/IP_alerts = 1

/client/proc/toggle_ip_alerts()
	set category = "Toggles (Server)"
	set name = "Toggle IP Alerts"
	set desc = "Toggles the same-IP alerts"
	admin_only

	IP_alerts = !IP_alerts
	logTheThing("admin", usr, null, "has toggled same-IP alerts [(IP_alerts ? "On" : "Off")]")
	logTheThing("diary", usr, null, "has toggled same-IP alerts [(IP_alerts ? "On" : "Off")]", "admin")
	message_admins("[key_name(usr)] has toggled same-IP alerts [(IP_alerts ? "On" : "Off")]")

/client/proc/toggle_hearing_all_looc()
	set category = "Toggles"
	set name = "Toggle Hearing All LOOC"
	set desc = "Toggles the ability to hear all LOOC messages regardless of where you are"
	admin_only

	src.only_local_looc = !src.only_local_looc
	boutput(usr, "<span style=\"color:orange\">Toggled seeing all LOOC messages [src.only_local_looc ?"off":"on"]!</span>")

/client/proc/toggle_attack_messages()
	set category = "Toggles"
	set name = "Toggle Attack Alerts"
	set desc = "Toggles the after-join attack messages"
	admin_only

	src.holder.attacktoggle = !src.holder.attacktoggle
	boutput(usr, "<span style=\"color:orange\">Toggled attack log messages [src.holder.attacktoggle ?"on":"off"]!</span>")

/client/proc/toggle_hear_prayers()
	set category = "Toggles"
	set name = "Toggle Hearing Prayers"
	set desc = "Toggles if you can hear prayers or not"
	admin_only

	src.holder.hear_prayers = !src.holder.hear_prayers
	boutput(usr, "<span style=\"color:orange\">Toggled prayers [src.holder.hear_prayers ?"on":"off"]!</span>")

/client/proc/cmd_admin_playermode()
	set name = "Toggle Player mode"
	set category = "Toggles"
	set desc = "Disables most admin messages."

	admin_only

	if (player_mode)
		player_mode = 0
		player_mode_asay = 0
		player_mode_ahelp = 0
		player_mode_mhelp = 0
		boutput(usr, "<span style=\"color:orange\">Player mode now OFF.</span>")
	else
		var/choice = input(src, "ASAY = adminsay, AHELP = adminhelp, MHELP = mentorhelp", "Choose which messages to recieve") as null|anything in list("NONE", "ASAY, AHELP & MHELP", "ASAY & AHELP", "ASAY & MHELP", "AHELP & MHELP", "ASAY ONLY", "AHELP ONLY", "MHELP ONLY")
		if (choice == "NONE" || !choice)
			player_mode = 1
			player_mode_asay = 0
			player_mode_ahelp = 0
			player_mode_mhelp = 0
			boutput(usr, "<span style=\"color:orange\">Player mode now ON.</span>")
		switch (choice)
			if ("ASAY, AHELP & MHELP")
				player_mode = 1
				player_mode_asay = 1
				player_mode_ahelp = 1
				player_mode_mhelp = 1
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: ASAYs, AHELPs, MHELPs.</span>")
			if ("ASAY & AHELP")
				player_mode = 1
				player_mode_asay = 1
				player_mode_ahelp = 1
				player_mode_mhelp = 0
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: ASAYs, AHELPs.</span>")
			if ("ASAY & MHELP")
				player_mode = 1
				player_mode_asay = 1
				player_mode_ahelp = 0
				player_mode_mhelp = 1
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: ASAYs, MHELPs.</span>")
			if ("AHELP & MHELP")
				player_mode = 1
				player_mode_asay = 0
				player_mode_ahelp = 1
				player_mode_mhelp = 1
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: AHELPs, MHELPs.</span>")
			if ("ASAY ONLY")
				player_mode = 1
				player_mode_asay = 1
				player_mode_ahelp = 0
				player_mode_mhelp = 0
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: ASAYs.</span>")
			if ("AHELP ONLY")
				player_mode = 1
				player_mode_asay = 0
				player_mode_ahelp = 1
				player_mode_mhelp = 0
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: AHELPs.</span>")
			if ("MHELP ONLY")
				player_mode = 1
				player_mode_asay = 0
				player_mode_ahelp = 0
				player_mode_mhelp = 1
				boutput(usr, "<span style=\"color:orange\">Player mode now ON. You will recieve: MHELPs.</span>")

	logTheThing("admin", usr, null, "has set player mode to [(player_mode ? "On" : "Off")]")
	logTheThing("diary", usr, null, "has set player mode to [(player_mode ? "On" : "Off")]", "admin")
	message_admins("[key_name(usr)] has set player mode to [(player_mode ? "On" : "Off")]")

/client/proc/cmd_admin_djmode()
	set name = "Toggle DJ Mode"
	set category = "Toggles"
	set hidden=1
	set desc = "Toggles letting players know you're playing music or horrible wavs or whatever."

	admin_only

	if (djmode)
		djmode = 0
		boutput(usr, "<span style=\"color:orange\">DJ mode now OFF.</span>")
	else
		djmode = 1
		boutput(usr, "<span style=\"color:orange\">DJ mode now ON.</span>")

	logTheThing("admin", usr, null, "set their DJ mode to [(djmode ? "On" : "Off")]")
	logTheThing("diary", usr, null, "set their DJ mode to [(djmode ? "On" : "Off")]", "admin")
	message_admins("[key_name(usr)] set their DJ mode to [(djmode ? "On" : "Off")]")

/client/proc/cmd_admin_godmode(mob/M as mob in world)
	set category = "Toggles"
	set name = "Toggle Mob Godmode"
	set popup_menu = 0
	admin_only

	if (!istype(M, /mob/living))
		return
	M.nodamage = !(M.nodamage)
	boutput(usr, "<span style=\"color:orange\"><b>[M]'s godmode is now [usr.nodamage ? "ON" : "OFF"]</b></span>")

	logTheThing("admin", usr, M, "has toggled %target%'s nodamage to [(M.nodamage ? "On" : "Off")]")
	logTheThing("diary", usr, M, "has toggled %target%'s nodamage to [(M.nodamage ? "On" : "Off")]", "admin")
	message_admins("[key_name(usr)] has toggled [key_name(M)]'s nodamage to [(M.nodamage ? "On" : "Off")]")

/client/proc/cmd_admin_godmode_self()
	set category = "Toggles"
	set name = "Toggle Your Godmode"
	set popup_menu = 0
	admin_only

	if (!istype(usr, /mob/living))
		return
	usr.nodamage = !(usr.nodamage)
	boutput(usr, "<span style=\"color:orange\"><b>Your godmode is now [usr.nodamage ? "ON" : "OFF"]</b></span>")

	logTheThing("admin", usr, null, "has toggled their nodamage to [(usr.nodamage ? "On" : "Off")]")
	logTheThing("diary", usr, null, "has toggled their nodamage to [(usr.nodamage ? "On" : "Off")]", "admin")
	message_admins("[key_name(usr)] has toggled their nodamage to [(usr.nodamage ? "On" : "Off")]")

/client/var/flying = 0
/client/proc/noclip()
	set name = "Toggle Your Noclip"
	set category = "Toggles"
	set desc = "Fly through walls"

	if (!istype(usr, /mob/living))
		return

	usr.client.flying = !usr.client.flying
	boutput(usr, "You are [usr.client.flying ? "now" : "no longer"] flying")

/client/proc/toggle_atom_verbs() // I hate calling them "atom verbs" but wtf else should they be called, fuck
	set category = "Toggles"
	set name = "Toggle Atom Verbs"
	set hidden=1
	admin_only
	if(!src.holder.animtoggle)
		src.holder.animtoggle = 1
		boutput(src, "Atom Verbs Toggled Off")

		src.verbs -= /client/proc/cmd_atom_emergency_stop

		src.verbs -= /client/proc/cmd_emag_all
		src.verbs -= /client/proc/cmd_emag_type
		src.verbs -= /client/proc/cmd_emag_target

		src.verbs -= /client/proc/cmd_transmute_type

		src.verbs -= /client/proc/cmd_scale_all
		src.verbs -= /client/proc/cmd_scale_type
		src.verbs -= /client/proc/cmd_scale_target

		src.verbs -= /client/proc/cmd_rotate_all
		src.verbs -= /client/proc/cmd_rotate_type
		src.verbs -= /client/proc/cmd_rotate_target

		src.verbs -= /client/proc/cmd_spin_all
		src.verbs -= /client/proc/cmd_spin_type
		src.verbs -= /client/proc/cmd_spin_target

		src.verbs -= /client/proc/cmd_get_type

	else
		src.holder.animtoggle = 0
		boutput(src, "Atom Verbs Toggled On")

		if (src.holder.level >= LEVEL_SHITGUY)
			src.verbs += /client/proc/cmd_emag_all
			src.verbs += /client/proc/cmd_scale_all
			src.verbs += /client/proc/cmd_rotate_all
			src.verbs += /client/proc/cmd_spin_all

		src.verbs += /client/proc/cmd_atom_emergency_stop

		src.verbs += /client/proc/cmd_emag_type
		src.verbs += /client/proc/cmd_emag_target

		src.verbs += /client/proc/cmd_transmute_type

		src.verbs += /client/proc/cmd_scale_type
		src.verbs += /client/proc/cmd_scale_target

		src.verbs += /client/proc/cmd_rotate_type
		src.verbs += /client/proc/cmd_rotate_target

		src.verbs += /client/proc/cmd_spin_type
		src.verbs += /client/proc/cmd_spin_target

		src.verbs += /client/proc/cmd_get_type

/client/proc/toggle_view_range()
	set category = "Toggles"
	set name = "Toggle View Range"
	set desc = "switches between 1x and custom views"
	set hidden=1

	if(src.view == world.view)
		var/tempview = input("Select view radius (1-35):", "FUCK YE", 7) as num
		if(tempview < 1)
			boutput(src, "<span style=\"color:red\">Can't be less than 1 you jerk. Set to 1.</span>")
			tempview = 1
		if(tempview > 35)
			boutput(src, "<span style=\"color:red\">Can't be more than 35 you jerk. Set to 35.</span>")
			tempview = 35
		src.view = tempview
		usr.see_in_dark = tempview
	else
		src.view = world.view
		usr.see_in_dark = initial(usr.see_in_dark)

/client/proc/toggle_toggles()
	set category = "Toggles (Server)"
	set name = "Toggle Toggles"
	set desc = "Toggles toggles ON/OFF"
	set hidden=1
	if(!toggles_enabled && !(src.holder.rank in list("Host", "Coder")))
		alert("Toggles are disabled. Sorry, bro!")
		return
	toggles_enabled = !toggles_enabled
	logTheThing("admin", usr, null, "toggled Toggles to [toggles_enabled].")
	logTheThing("diary", usr, null, "toggled Toggles to [toggles_enabled].", "admin")
	message_admins("[key_name(usr)] toggled Toggles [toggles_enabled ? "on" : "off"].")

/client/proc/toggle_force_mixed_wraith()
	set category = "Debug"
	set name = "Toggle Force Wraith"
	set hidden=1
	set desc = "If turned on, a wraith will always appear in mixed or traitor, regardless of player count or probabilities."
	debug_mixed_forced_wraith = !debug_mixed_forced_wraith
	logTheThing("admin", usr, null, "toggled force mixed wraith [debug_mixed_forced_wraith ? "on" : "off"]")
	logTheThing("diary", usr, null, "toggled force mixed wraith [debug_mixed_forced_wraith ? "on" : "off"]")
	message_admins("[key_name(usr)] toggled force mixed wraith [debug_mixed_forced_wraith ? "on" : "off"]")

/client/proc/toggle_force_mixed_blob()
	set category = "Debug"
	set name = "Toggle Force Blob"
	set hidden=1
	set desc = "If turned on, a blob will always appear in mixed, regardless of player count or probabilities."
	debug_mixed_forced_blob = !debug_mixed_forced_blob
	logTheThing("admin", usr, null, "toggled force mixed blob [debug_mixed_forced_blob ? "on" : "off"]")
	logTheThing("diary", usr, null, "toggled force mixed blob [debug_mixed_forced_blob ? "on" : "off"]")
	message_admins("[key_name(usr)] toggled force mixed blob [debug_mixed_forced_blob ? "on" : "off"]")

/client/proc/toggle_jobban_announcements()
	set category = "Toggles (Server)"
	set name = "Toggle Jobban Alerts"
	set desc = "Toggles the announcement of job bans ON/OFF"
	if(!toggles_enabled && !(src.holder.rank in list("Host", "Coder", "Shit Person")))
		alert("Toggles are disabled. Sorry, bro!")
		return
	if (announce_jobbans == 1) announce_jobbans = 0
	else announce_jobbans = 1
	logTheThing("admin", usr, null, "toggled Jobban Alerts to [announce_jobbans].")
	logTheThing("diary", usr, null, "toggled Jobban Alerts to [announce_jobbans].", "admin")
	message_admins("[key_name(usr)] toggled Jobban Alerts [announce_jobbans ? "on" : "off"].")

/client/proc/toggle_banlogin_announcements()
	set category = "Toggles (Server)"
	set name = "Toggle Banlog Alerts"
	set desc = "Toggles the announcement of failed logins ON/OFF"
	admin_only
	if (announce_banlogin == 1) announce_banlogin = 0
	else announce_banlogin = 1
	logTheThing("admin", usr, null, "toggled Banned User Alerts to [announce_banlogin].")
	logTheThing("diary", usr, null, "toggled Banned User Alerts to [announce_banlogin].", "admin")
	message_admins("[key_name(usr)] toggled Banned User Alerts to [announce_banlogin ? "on" : "off"].")

/client/proc/toggle_literal_disarm()
	set category = "Toggles (Server)"
	set name = "Toggle Literal Disarm"
	set desc = "Toggles literal disarm intent ON/OFF"
	if(!toggles_enabled && !(src.holder.rank in list("Host", "Coder")))
		alert("Toggles are disabled. Sorry, bro!")
		return
	literal_disarm = !literal_disarm
	logTheThing("admin", usr, null, "toggled literal disarming to [literal_disarm].")
	logTheThing("diary", usr, null, "toggled literal disarming to [literal_disarm].", "admin")
	message_admins("[key_name(usr)] toggled literal disarming [literal_disarm ? "on" : "off"].")

/datum/admins/proc/voteres()
	set category = "Toggles (Server)"
	set name = "Toggle Voting"
	set desc="Toggles Votes"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	var/confirm = alert("What vote would you like to toggle?", "Vote", "Restart [config.allow_vote_restart ? "Off" : "On"]", "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Restart [config.allow_vote_restart ? "Off" : "On"]")
		config.allow_vote_restart = !config.allow_vote_restart
		boutput(world, "<b>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</b>.")
		logTheThing("admin", usr, null, "toggled restart voting to [config.allow_vote_restart ? "On" : "Off"]")
		logTheThing("diary", usr, null, "toggled restart voting to [config.allow_vote_restart ? "On" : "Off"]", "admin")

		if(config.allow_vote_restart)
			vote.nextvotetime = world.timeofday
	if(confirm == "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]")
		config.allow_vote_mode = !config.allow_vote_mode
		boutput(world, "<b>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</b>.")
		logTheThing("admin", usr, null, "toggled mode voting to [config.allow_vote_mode ? "On" : "Off"]")
		logTheThing("diary", usr, null, "toggled mode voting to [config.allow_vote_mode ? "On" : "Off"]", "admin")

		if(config.allow_vote_mode)
			vote.nextvotetime = world.timeofday

/datum/admins/proc/toggleooc()
	set category = "Toggles (Server)"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	ooc_allowed = !( ooc_allowed )
	boutput(world, "<B>The OOC channel has been globally [ooc_allowed ? "en" : "dis"]abled!</B>")
	logTheThing("admin", usr, null, "toggled OOC.")
	logTheThing("diary", usr, null, "toggled OOC.", "admin")
	message_admins("[key_name(usr)] toggled OOC.")

/datum/admins/proc/togglelooc()
	set category = "Toggles (Server)"
	set desc="Toggle dis bitch"
	set name="Toggle LOOC"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	looc_allowed = !( looc_allowed )
	boutput(world, "<B>The LOOC channel has been globally [looc_allowed ? "en" : "dis"]abled!</B>")
	logTheThing("admin", usr, null, "toggled LOOC.")
	logTheThing("diary", usr, null, "toggled LOOC.", "admin")
	message_admins("[key_name(usr)] toggled LOOC.")

/datum/admins/proc/toggleoocdead()
	set category = "Toggles (Server)"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	dooc_allowed = !( dooc_allowed )
	logTheThing("admin", usr, null, "toggled OOC.")
	logTheThing("diary", usr, null, "toggled OOC.", "admin")
	message_admins("[key_name(usr)] toggled Dead OOC.")

/datum/admins/proc/toggletraitorscaling()
	set category = "Toggles (Server)"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	traitor_scaling = !traitor_scaling
	logTheThing("admin", usr, null, "toggled Traitor Scaling to [traitor_scaling].")
	logTheThing("diary", usr, null, "toggled Traitor Scaling to [traitor_scaling].", "admin")
	message_admins("[key_name(usr)] toggled Traitor Scaling [traitor_scaling ? "on" : "off"].")

/datum/admins/proc/pcap()
	set category = "Toggles (Server)"
	set desc = "Toggle player cap"
	set name = "Toggle Player Cap"
	player_capa = !( player_capa )
	if (player_capa)
		boutput(world, "<B>The global player cap has been enabled at [player_cap] players.</B>")
	else
		boutput(world, "<B>The global player cap has been disabled.</B>")
	logTheThing("admin", usr, null, "toggled player cap to [player_cap].")
	logTheThing("diary", usr, null, "toggled player cap to [player_cap].", "admin")
	message_admins("[key_name(usr)] toggled the global player cap [player_cap ? "on" : "off"]")

/datum/admins/proc/toggleenter()
	set category = "Toggles (Server)"
	set desc="People can't enter"
	set name="Toggle Entering"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		boutput(world, "<B>You may no longer enter the game.</B>")
	else
		boutput(world, "<B>You may now enter the game.</B>")
	logTheThing("admin", usr, null, "toggled new player game entering.")
	logTheThing("diary", usr, null, "toggled new player game entering.", "admin")
	message_admins("<span style=\"color:orange\">[key_name(usr)] toggled new player game entering.</span>")
	world.update_status()

/datum/admins/proc/toggleAI()
	set category = "Toggles (Server)"
	set desc="People can't be AI"
	set name="Toggle AI"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		boutput(world, "<B>The AI job is no longer chooseable.</B>")
	else
		boutput(world, "<B>The AI job is chooseable now.</B>")
	logTheThing("admin", usr, null, "toggled AI allowed.")
	logTheThing("diary", usr, null, "toggled AI allowed.", "admin")
	world.update_status()

/datum/admins/proc/toggle_soundpref_override()
	set category = "Toggles (Server)"
	set desc = "Force people to hear admin-played sounds even if they have them disabled."
	set name = "Toggle SoundPref Override"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	soundpref_override = !( soundpref_override )
	logTheThing("admin", usr, null, "toggled Sound Preference Override [soundpref_override ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled Sound Preference Override [soundpref_override ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled Sound Preference Override [soundpref_override ? "on" : "off"]")

/datum/admins/proc/toggle_respawns()
	set category = "Toggles (Server)"
	set desc="Enable or disable the ability for all players to respawn"
	set name="Toggle Respawn"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	abandon_allowed = !( abandon_allowed )
	if (abandon_allowed)
		boutput(world, "<B>You may now respawn.</B>")
	else
		boutput(world, "<B>You may no longer respawn :(</B>")
	message_admins("<span style=\"color:orange\">[key_name(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].</span>")
	logTheThing("admin", usr, null, "toggled respawn to [abandon_allowed ? "On" : "Off"].")
	logTheThing("diary", usr, null, "toggled respawn to [abandon_allowed ? "On" : "Off"].", "admin")
	world.update_status()

/client/proc/toggle_pray()
	set category = "Toggles"
	set desc="Toggle Your Pray"
	set name="Toggle Local Pray"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	if(pray_l == 0)
		pray_l = 1
		boutput(usr, "Pray turned on")
	else
		pray_l = 0
		boutput(usr, "Pray turned off")
	message_admins("[key_name(usr)] toggled its Pray to [pray_l].")

/client/proc/toggle_theater()
	set category = "Toggles"
	set desc="Toggles Your Theatrical Jump"
	set name="Toggle Theatrical Jump"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	if(theater)
		theater = 0
	else
		theater = 1
	message_admins("[key_name(usr)] toggled its Theatrical Jump to [theater].")

/datum/admins/proc/adsound()
	set category = "Toggles (Server)"
	set desc="Toggle admin sound playing"
	set name="Toggle Sound Playing"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	config.allow_admin_sounds = !(config.allow_admin_sounds)
	message_admins("<span style=\"color:orange\">Toggled admin sound playing to [config.allow_admin_sounds].</span>")

/datum/admins/proc/adspawn()
	set category = "Toggles (Server)"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	message_admins("<span style=\"color:orange\">Toggled admin item spawning to [config.allow_admin_spawning].</span>")

/datum/admins/proc/adrev()
	set category = "Toggles (Server)"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	config.allow_admin_rev = !(config.allow_admin_rev)
	message_admins("<span style=\"color:orange\">Toggled reviving to [config.allow_admin_rev].</span>")

/datum/admins/proc/toggledeadchat()
	set category = "Toggles (Server)"
	set desc = "Toggle Deadchat on or off."
	set name = "Toggle Deadchat"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	deadchat_allowed = !( deadchat_allowed )
	if (deadchat_allowed)
		boutput(world, "<B>The Deadsay channel has been enabled.</B>")
	else
		boutput(world, "<B>The Deadsay channel has been disabled.</B>")
	logTheThing("admin", usr, null, "toggled Deadchat [deadchat_allowed ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled Deadchat [deadchat_allowed ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled Deadchat [deadchat_allowed ? "on" : "off"]")

/datum/admins/proc/togglefarting()
	set category = "Toggles (Server)"
	set desc = "Toggle Farting on or off."
	set name = "Toggle Farting"
	set hidden = 1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	farting_allowed = !( farting_allowed )
	if (farting_allowed)
		boutput(world, "<B>Farting has been enabled.</B>")
	else
		boutput(world, "<B>Farting has been disabled.</B>")
	logTheThing("admin", usr, null, "toggled Farting [farting_allowed ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled Farting [farting_allowed ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled Farting [farting_allowed ? "on" : "off"]")

/datum/admins/proc/toggle_blood_system()
	set category = "Toggles (Server)"
	set desc = "Toggle the blood system on or off."
	set name = "Toggle Blood System"
	if (!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	blood_system = !(blood_system)
	boutput(world, "<B>Blood system has been [blood_system ? "enabled" : "disabled"].</B>")
	logTheThing("admin", usr, null, "toggled the blood system [blood_system ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled the blood system [blood_system ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled the blood system [blood_system ? "on" : "off"]")

/datum/admins/proc/toggle_bone_system()
	set category = "Toggles (Server)"
	set desc = "Toggle the bone system on or off."
	set name = "Toggle Bone System"
	if (!toggles_enabled)
		alert("Toggles are disabled. Sorry, pal!")
		return
	bone_system = !(bone_system)
	boutput(world, "<B>Bone system has been [bone_system ? "enabled" : "disabled"].</B>")
	logTheThing("admin", usr, null, "toggled the bone system [bone_system ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled the bone system [bone_system ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled the bone system [bone_system ? "on" : "off"]")

/datum/admins/proc/togglesuicide()
	set category = "Toggles (Server)"
	set desc = "Allow/Disallow people to commit suicide."
	set name = "Toggle Suicide"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	suicide_allowed = !( suicide_allowed )
	logTheThing("admin", usr, null, "toggled Suicides [suicide_allowed ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled Suicides [suicide_allowed ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled Suicides [suicide_allowed ? "on" : "off"]")

/datum/admins/proc/togglethetoggles()
	set category = "Toggles (Server)"
	set desc = "Toggle All Toggles"
	set name = "Toggle All Toggles"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	ooc_allowed = !( ooc_allowed )
	dooc_allowed = !( dooc_allowed )
	player_capa = !( player_capa )
	enter_allowed = !( enter_allowed )
	config.allow_ai = !( config.allow_ai )
	soundpref_override = !( soundpref_override )
	abandon_allowed = !( abandon_allowed )
	config.allow_admin_jump = !(config.allow_admin_jump)
	config.allow_admin_sounds = !(config.allow_admin_sounds)
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	config.allow_admin_rev = !(config.allow_admin_rev)
	deadchat_allowed = !( deadchat_allowed )
	farting_allowed = !( farting_allowed )
	suicide_allowed = !( suicide_allowed )
	monkeysspeakhuman = !( monkeysspeakhuman )
	no_automatic_ending = !( no_automatic_ending )
	late_traitors = !( late_traitors )
	sound_waiting = !( sound_waiting )
	message_admins("[key_name(usr)] toggled OOC [ooc_allowed ? "on" : "off"], Dead OOC  [dooc_allowed ? "on" : "off"], Global Player Cap  [player_capa ? "on" : "off"], Entering [enter_allowed ? "on" : "off"],Playing as the AI [config.allow_ai ? "on" : "off"], Sound Preference override [soundpref_override ? "on" : "off"], Abandoning [abandon_allowed ? "on" : "off"], Admin Jumping [config.allow_admin_jump ? "on" : "off"], Admin sound playing [config.allow_admin_sounds ? "on" : "off"], Admin Spawning [config.allow_admin_spawning ? "on" : "off"], Admin Reviving [config.allow_admin_rev ? "on" : "off"], Deadchat [deadchat_allowed ? "on" : "off"], Farting [farting_allowed ? "on" : "off"], Blood system [blood_system ? "on" : "off"], Suicide [suicide_allowed ? "on" : "off"], Monkey/Human communication [monkeysspeakhuman ? "on" : "off"], Late Traitors [late_traitors ? "on" : "off"], and Sound Queuing [sound_waiting ? "on" : "off"]   ")

/client/proc/togglepersonaldeadchat()
	set category = "Toggles"
	set desc = "Toggle whether you can see deadchat or not"
	set name = "Toggle Your Deadchat"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	if(deadchatoff == 0)
		deadchatoff = 1
		boutput(usr, "<span style=\"color:orange\">No longer viewing deadchat.</span>")
	else
		deadchatoff = 0
		boutput(usr, "<span style=\"color:orange\">Now viewing deadchat.</span>")

/datum/admins/proc/toggleaprilfools()
	set category = "Toggles (Server)"
	set desc = "Toggle manual breathing and/or blinking."
	set name = "Toggle Manual Breathing/Blinking"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return

	var/priorbreathing = manualbreathing
	var/breathing = alert("Manual breathing mode?","Toggle","On","Off")
	if(breathing == "On")
		manualbreathing = 1
		if(priorbreathing != manualbreathing) boutput(world, "<B>You must now breathe manually using the *inhale and *exhale emotes!</B>")
	else
		manualbreathing = 0
		if(priorbreathing != manualbreathing) boutput(world, "<B>You no longer need to breathe manually!</B>")

	var/priorblinking = manualblinking
	var/blinking = alert("Manual blinking mode?","Toggle","On","Off")
	if(blinking == "On")
		manualblinking = 1
		if(priorblinking != manualblinking) boutput(world, "<B>You must now blink manually using the *closeeyes and *openeyes emotes!</B>")
	else
		manualblinking = 0
		if(priorblinking != manualblinking) boutput(world, "<B>You no longer need to blink manually!</B>")

	logTheThing("admin", usr, null, "turned manual breathing [manualbreathing ? "on" : "off"] and manual blinking [manualblinking ? "on" : "off"].")
	logTheThing("diary", usr, null, "turned manual breathing [manualbreathing ? "on" : "off"] and manual blinking [manualblinking ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] turned manual breathing [manualbreathing ? "on" : "off"] and manual blinking [manualblinking ? "on" : "off"].")

/datum/admins/proc/togglemonkeyspeakhuman()
	set category = "Toggles (Server)"
	set desc = "Toggle monkeys being able to speak human."
	set name = "Toggle Monkeys Speaking Human"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	monkeysspeakhuman = !( monkeysspeakhuman )
	if (monkeysspeakhuman)
		boutput(world, "<B>Monkeys can now speak to humans.</B>")
	else
		boutput(world, "<B>Monkeys can no longer speak to humans.</B>")
	logTheThing("admin", usr, null, "toggled Monkey/Human communication [monkeysspeakhuman ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled Monkey/Human communication [monkeysspeakhuman ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled Monkey/Human communication [monkeysspeakhuman ? "on" : "off"]")

/datum/admins/proc/toggleautoending()
	set category = "Toggles (Server)"
	set desc = "Toggle the round automatically ending in invasive round types."
	set name = "Toggle Automatic Round End"
	set hidden = 1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	no_automatic_ending = !( no_automatic_ending )
	logTheThing("admin", usr, null, "toggled Automatic Round End [no_automatic_ending ? "off" : "on"].")
	logTheThing("diary", usr, null, "toggled Automatic Round End [no_automatic_ending ? "off" : "on"].", "admin")
	message_admins("[key_name(usr)] toggled Automatic Round End [no_automatic_ending ? "off" : "on"]")

/datum/admins/proc/togglelatetraitors()
	set category = "Toggles (Server)"
	set desc = "Toggle late joiners spawning as antagonists if all starting antagonists are dead."
	set name = "Toggle Late Antagonists"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	late_traitors = !( late_traitors )
	logTheThing("admin", usr, null, "toggled late antagonists [late_traitors ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled late antagonists [late_traitors ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled late antagonists [late_traitors ? "on" : "off"]")

/datum/admins/proc/togglesoundwaiting()
	set category = "Toggles (Server)"
	set desc = "Toggle admin-played sounds waiting for previous sounds to finish before playing."
	set name = "Toggle Admin Sound Queue"
	set hidden=1
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	sound_waiting = !( sound_waiting )
	logTheThing("admin", usr, null, "toggled admin sound queue [sound_waiting ? "on" : "off"].")
	logTheThing("diary", usr, null, "toggled admin sound queue [sound_waiting ? "on" : "off"].", "admin")
	message_admins("[key_name(usr)] toggled admin sound queue [sound_waiting ? "on" : "off"]")

/datum/admins/proc/adjump()
	set category = "Toggles (Server)"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"

	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	config.allow_admin_jump = !(config.allow_admin_jump)
	message_admins("<span style=\"color:orange\">Toggled admin jumping to [config.allow_admin_jump].</span>")

/datum/admins/proc/togglesimsmode()
	set category = "Toggles (Server)"
	set desc="Enable sims mode for this round."
	set name = "Toggle Sims Mode"
	if(!toggles_enabled)
		alert("Toggles are disabled. Sorry, bro!")
		return
	global_sims_mode = !global_sims_mode
	message_admins("<span style=\"color:orange\">[key_name(usr)] toggled sims mode. [global_sims_mode ? "Oh, the humanity!" : "Phew, it's over."]</span>")
	for (var/mob/M in world)
		boutput(M, "<b>Motives have been globally [global_sims_mode ? "enabled" : "disabled"].</b>")
		if (ishuman(M))
			var/mob/living/carbon/human/H = M
			if (global_sims_mode && !H.sims)
				if (map_setting == "DESTINY")
					H.sims = new /datum/simsHolder/destiny(H)
				else
					H.sims = new /datum/simsHolder/human(H)
			else if (!global_sims_mode && H.sims)
				qdel(H.sims)
				H.sims = null
