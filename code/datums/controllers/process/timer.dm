/**
 * timer.dm
 *
 * A basic system that allows developers to easily replace all spawn() calls with a
 * scheduler based timing system.
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Usage:	call_after(var/thing, var/proc_on_thing, var/time, var/unique = 0, ...)
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * thing				=	The object that needs to be called after a certain amount of time.
 * proc_on_thing		=	The proc on the previously mentioned object that needs to be called.
 * time					=	The amount of time in seconds after the do_after needs to call the thing.
 * unique				=	Setting this to "1" will prevent further do_after calls with the same set of parameters.
 * ...					=	A list of arguments.
 *
 * Returns the unique ID of the timer datum if the do_after call was successfully handled, or null when it failed to add it.
 *
 * Example:
 *
 * client/verb/womp()
 * 	set name = "WOMP! (Unique)"
 * 	set category = "Timer Debug"
 *
 * 	call_after(src, "womp", 1200, 1, "WOMP!")
 *
 * client/proc/womp(var/text)
 * 	boutput(world, text)
 *
 *
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * Usage:	remove_call_after(var/id)
 * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 * id					=	The ID of a previously created do_after call that needs to be removed from processing.
 *
 * Returns 1 on success.
 *
 * !! IMPORTANT NOTE !!
 *
 * This system is meant to be used for non-game-critical things, this controller will not function accurately
 * For high precision timers that are meant to run <= 1 second.
 *
 * !! IMPORTANT NOTE !!
 */

/datum/controller/process/timer

	setup()
		name = "Timers"
		schedule_interval = 5

	doWork()
		if(istype((global.timer_queue), /list) && length(global.timer_queue))

			for(var/A in global.timer_queue)
				var/datum/dynamicTimer/timer = A

				if(!timer.thing || is_deleted(timer.thing))
					qdel(timer)

				if(timer.time <= world.time)
					timer.run_timer()
					qdel(timer)

				scheck()


/datum/dynamicTimer
	var/id
	var/time
	var/hash
	var/thing
	var/proc_on_thing
	var/arguments_for_proc

	New()
		id = global.next_timer_id
		global.next_timer_id++

	disposing()
		global.timer_queue -= src
		global.timer_hashes -= src.hash
		..()

	proc/run_timer()
		set waitfor = 0
		call(thing, proc_on_thing)(arglist(arguments_for_proc))

/proc/call_after(var/thing, var/proc_on_thing, var/time, var/unique = 0, ...)

	if(!thing || !proc_on_thing || time <= 0)
		return

	var/datum/dynamicTimer/timer = new()
	timer.thing = thing
	timer.proc_on_thing = proc_on_thing
	timer.time = world.time + time
	timer.hash = jointext(args, ":")

	if(args.len > 4)
		timer.arguments_for_proc = args.Copy(5)

	if(unique)
		if(timer.hash in timer_hashes)
			qdel(timer)
			return 0

	timer_queue += timer
	timer_hashes += timer.hash

	return timer.id

/proc/remove_call_after(var/id)
	for(var/A in timer_queue)
		var/datum/dynamicTimer/timer = A
		if(timer.id == id)
			qdel(timer)
			return 1
	return 0