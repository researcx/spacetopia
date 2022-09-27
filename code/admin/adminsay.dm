#include "macros.dm"
/client/proc/cmd_admin_say(msg as text)
	set category = "Special Verbs"
	set name = "asay"
	set hidden = 1

	admin_only

	if (src.ismuted())
		return

	msg = copytext(sanitize(html_encode(msg)), 1, MAX_MESSAGE_LEN)
	logTheThing("admin", src, null, "ASAY: [msg]")
	logTheThing("diary", src, null, "ASAY: [msg]", "admin")

	if (!msg)
		return

	var/special
	if (src.holder.rank in list("Goat Fart", "Ayn Rand's Armpit"))
		special = "gfartadmin"
	message_admins("[key_name(src)]: <span class=\"adminMsgWrap [special]\">[msg]</span>", 1)

	var/ircmsg[] = new()
	ircmsg["key"] = src.key
	ircmsg["name"] = src.mob.real_name
	ircmsg["msg"] = html_decode(msg)
	ircbot.export("asay", ircmsg)

/client/proc/cmd_admin_forceallsay(msg as text)
	set category = "Special Verbs"
	set name = "forceallsay"
	set hidden = 1
	admin_only

	if (src.ismuted())
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	for(var/mob/living/M in mobs)
		if (ismob(M))
			var/speech = msg
			if(!speech)
				return
			M.say(speech)
			speech = copytext(sanitize(speech), 1, MAX_MESSAGE_LEN)

	logTheThing("admin", usr, null, "forced everyone to say: [msg]")
	logTheThing("diary", usr, null, "forced everyone to say: [msg]", "admin")
	message_admins("<span style=\"color:orange\">[key_name(usr)] forced everyone to say: [msg]</span>")

/client/proc/cmd_admin_murraysay(msg as text)
	set category = "Special Verbs"
	set  name = "murraysay"
	set hidden = 1

	admin_only

	if (src.ismuted())
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if (!msg)
		return

	for (var/obj/machinery/bot/guardbot/old/maybeMurray in machines)
		if (!dd_hasprefix(maybeMurray.name, "Murray"))
			continue

		maybeMurray.speak(msg)
		break

	logTheThing("admin", usr, null, "forced Murray to beep: [msg]")
	logTheThing("diary", usr, null, "forced Murray to beep: [msg]", "admin")
	message_admins("<span style=\"color:orange\">[key_name(usr)] forced Murray to beep: [msg]</span>")