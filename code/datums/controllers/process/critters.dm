// handles critters
datum/controller/process/critters
	var/tmp/list/detailed_count
	var/tmp/tick_counter
	var/tmp/list/critters

	setup()
		name = "Critter"
		schedule_interval = 16 // 1.6 seconds

		detailed_count = new
		src.critters = global.critters

	doWork()
		var/i
		for(var/datum/c in global.critters)
			c:process()
			if (!(i++ % 10))
				scheck()

		/*var/currentTick = ticks
		for(var/obj/critter in critters)
			tick_counter = world.timeofday

			critter:process()

			tick_counter = world.timeofday - tick_counter
			if (critter && tick_counter > 0)
				detailed_count["[critter.type]"] += tick_counter

			scheck(currentTick)*/

	tickDetail()
		if (detailed_count && detailed_count.len)
			var/stats = "<b>[name] ticks:</b>"
			var/count
			for (var/thing in detailed_count)
				count = detailed_count[thing]
				if (count > 4)
					stats += "[thing] used [count] ticks.<br>"
			boutput(usr, "<br>[stats]")