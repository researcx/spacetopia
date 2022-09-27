/datum/targetable/predator/predator_trophycount
	name = "Check trophy value"
	desc = "Displays the combined value of all trophies in your possession."
	targeted = 0
	target_nodamage_check = 0
	max_range = 0
	cooldown = 0
	pointCost = 0
	when_stunned = 3
	not_when_handcuffed = 0
	predator_only = 0
	dont_lock_holder = 1
	ignore_holder_lock = 1

	cast(mob/target)
		if (!holder)
			return 1

		var/mob/living/M = holder.owner

		if (!M)
			return 1

		var/count = M.get_skull_value()

		if (count <= 0)
			boutput(M, __red("<b>Combined trophy value: 0</b>"))
		else
			boutput(M, __blue("<b>Combined trophy value: [count]</b>"))

		return 0