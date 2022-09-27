/mob/living/silicon/hive_mainframe
	name = "Robot Mainframe"
	voice_name = "synthesized voice"
	icon = 'icons/mob/hivebot.dmi'
	icon_state = "hive_main"
	health = 200
	var/health_max = 200
	robot_talk_understand = 2

	anchored = 1
	var/online = 1
	var/mob/living/silicon/hivebot = null
	var/hivebot_name = null
	var/force_mind = 0

/mob/living/silicon/hive_mainframe/New()
	. = ..()
	Namepick()

/mob/living/silicon/hive_mainframe/Life(datum/controller/process/mobs/parent)
	if (..(parent))
		return 1
	if (src.stat == 2)
		return
	else
		src.updatehealth()

		if (src.health <= 0)
			death()
			return

	if(src.force_mind)
		if(!src.mind)
			if(src.client)
				src.mind = new
				src.mind.key = src.key
				src.mind.current = src
				ticker.minds += src.mind
		src.force_mind = 0

	update_icons_if_needed()

/mob/living/silicon/hive_mainframe/death(gibbed)
	src.stat = 2
	src.canmove = 0
	vision.set_color_mod("#ffffff") // reset any blindness
	src.sight |= SEE_TURFS
	src.sight |= SEE_MOBS
	src.sight |= SEE_OBJS
	src.see_in_dark = SEE_DARK_FULL
	src.see_invisible = 2
	src.lying = 1
	src.icon_state = "hive_main-crash"

	var/tod = time2text(world.realtime,"hh:mm:ss") //weasellos time of death patch
	mind.store_memory("Time of death: [tod]", 0)


	return ..(gibbed)


/mob/living/silicon/hive_mainframe/say_understands(var/other)
	if (istype(other, /mob/living/carbon/human) && (!other:mutantrace || !other:mutantrace.exclusive_language))
		return 1
	if (istype(other, /mob/living/silicon/robot))
		return 1
	if (istype(other, /mob/living/silicon/hivebot))
		return 1
	if (istype(other, /mob/living/silicon/ai))
		return 1
	return ..()

/mob/living/silicon/hive_mainframe/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return "queries, \"[text]\"";
	else if (ending == "!")
		return "declares, \"[copytext(text, 1, length(text))]\"";

	return "states, \"[text]\"";


/mob/living/silicon/hive_mainframe/proc/return_to(var/mob/user)
	if(user.mind)
		user.mind.transfer_to(src)
		spawn(20)
			if (user)
				user:shell = 1
				user:real_name = "Robot [pick(rand(1, 999))]"
				user:name = user:real_name


		return

/mob/living/silicon/hive_mainframe/verb/cmd_deploy_to()
	set category = "Mainframe Commands"
	set name = "Deploy to shell."
	deploy_to()

/mob/living/silicon/hive_mainframe/verb/deploy_to()

	if(usr.stat == 2)
		boutput(usr, "You can't deploy because you are dead!")
		return

	var/list/bodies = new/list()

	for(var/mob/living/silicon/hivebot/H in mobs)
		if(H.z == src.z)
			if(H.shell)
				if(!H.stat)
					bodies += H

	var/target_shell = input(usr, "Which body to control?") as null|anything in bodies

	if (!target_shell)
		return

	else if(src.mind)
		spawn(30)
			target_shell:mainframe = src
			target_shell:dependent = 1
			target_shell:real_name = src.name
			target_shell:name = target_shell:real_name
		src.mind.transfer_to(target_shell)
		return


/client/proc/MainframeMove(n,direct,var/mob/living/silicon/hive_mainframe/user)
	return

/mob/living/silicon/hive_mainframe/Login()
	..()
	update_clothing()
	return



/mob/living/silicon/hive_mainframe/proc/Namepick()
	var/randomname = pick(ai_names)
	var/newname = input(src,"You are the a Mainframe Unit. Would you like to change your name to something else?", "Name change",randomname) as text

	if (length(newname) == 0)
		newname = randomname

	if (newname)
		if (length(newname) >= 26)
			newname = copytext(newname, 1, 26)
		newname = replacetext(newname, ">", "'")
		src.real_name = newname
		src.name = newname