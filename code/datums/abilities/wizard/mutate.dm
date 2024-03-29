/datum/targetable/spell/mutate
	name = "Empower"
	desc = "Temporarily superpowers your body and mind."
	icon_state = "mutate"
	targeted = 0
	cooldown = 400
	requires_robes = 1
	offensive = 1

	cast()
		if(!holder)
			return
		holder.owner.say("BIRUZ BENNAR")
		playsound(holder.owner.loc, "sound/voice/wizard/MutateLoud.ogg", 50, 0, -1)
		boutput(holder.owner, "<span style=\"color:orange\">Your mind and muscles are magically empowered!</span>")
		holder.owner.visible_message("<span style=\"color:red\">[holder.owner] glows with a POWERFUL aura!</span>")

		if (!holder.owner.bioHolder.HasEffect("hulk"))
			holder.owner.bioHolder.AddEffect("hulk")
		if (!holder.owner.bioHolder.HasEffect("telekinesis") && holder.owner.wizard_spellpower())
			holder.owner.bioHolder.AddEffect("telekinesis")
		var/SPtime = 150
		if (holder.owner.wizard_spellpower())
			SPtime = 300
		else
			boutput(holder.owner, "<span style=\"color:red\">Your spell doesn't last as long without a staff to focus it!</span>")
		spawn (SPtime)
			if (holder.owner.bioHolder.HasEffect("telekinesis"))
				holder.owner.bioHolder.RemoveEffect("telekinesis")
			if (holder.owner.bioHolder.HasEffect("hulk"))
				holder.owner.bioHolder.RemoveEffect("hulk")
