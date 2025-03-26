/datum/controller/process/delete_queue

	var/tmp/hard_deletions = 0
	var/tmp/soft_deletions = 0

	var/tmp/amount_per_process = MIN_DELETE_CHUNK_SIZE

	setup()
		name = "DeleteQueue"
		schedule_interval = 5
		tick_allowance = 25

	doWork()

		if(!global.delete_queue)
			boutput(world, "Error: there is no delete queue!")
			return

		if(global.delete_queue.isEmpty())
			return

		var/list/trash_can = delete_queue.dequeueMany(amount_per_process)

		for(var/A in trash_can)
			var/datum/D = locate(A)

			if (!istype(D) || !D.qdeled)
				src.soft_deletions++
				continue

			src.hard_deletions++

			var/time = world.timeofday
			var/tick = world.tick_usage
			var/ticktime = world.time
			var/type = D.type

			global.hard_deletions["[type]"]++

			del(D) // GTFO.

			tick = (world.tick_usage-tick+((world.time-ticktime)/world.tick_lag*100))
			time = world.timeofday - time

			if (!time && (tick * world.tick_lag) > 1)
				time = (tick * world.tick_lag) / 100

			if (time > 5)
				amount_per_process -= 10

			if (time < 5)
				amount_per_process += 10

			scheck()


	tickDetail()
		var/stats = "<b>Detailed trash can statistics:</b><br>"

		stats += "hard_deletions: [hard_deletions]<br>"
		stats += "soft_deletions: [soft_deletions]<br>"
		stats += "amount_per_process: [amount_per_process]<br>"
		stats += "Hard Deletions: <br>"

		for(var/A in global.hard_deletions)
			stats += "[global.hard_deletions[A]]:[A]<br>"

		boutput(usr, stats)