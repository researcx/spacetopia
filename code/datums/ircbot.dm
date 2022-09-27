/*********************************
Procs for handling ircbot connectivity and data transfer
*********************************/


var/global/datum/ircbot/ircbot = new /datum/ircbot()

/datum/ircbot
	var/loaded = 0
	var/loadTries = 0
	var/list/queue = list()
	var/debugging = 0
	var/interface = "http://cdn.spacetopia.pw/bot/status.php?"
	var/iface = ""
	var/apikey = "dicks"
	New()
		if (!src.load())
			spawn(10)
				if (!src.loaded)
					src.load()

	proc
		//Load the config variables necessary for connections
		load()
			if (config)
				src.loaded = 1
				return 1
			else
				loadTries++
				if (loadTries >= 5)
					logTheThing("debug", null, null, "<b>IRCBOT:</b> Reached 5 failed config load attempts")
					logTheThing("diary", null, null, "<b>IRCBOT:</b> Reached 5 failed config load attempts", "debug")
				return 0

		//Shortcut proc for event-type exports
		event(type, data)
			if (!type) return 0
			var/list/eventArgs = list("type" = type)
			if (data) eventArgs["data"] = data
			return src.export("event", eventArgs)


		//Send a message to an irc bot! Yay!
		export(iface, args)
			if (src.debugging)
				src.logDebug("Export called with <b>iface:</b> [iface]. <b>args:</b> [list2params(args)]. <b>src.interface:</b> [src.interface]. <b>src.loaded:</b> [src.loaded]")

			if (!config || !src.loaded)
				src.queue += list(list("iface" = iface, "args" = args))

				if (src.debugging)
					src.logDebug("Export, message queued due to unloaded config")

				spawn(10)
					if (!src.loaded)
						src.load()
				return "queued"
			else
				if (config.env == "dev") return 0
				args = (args == null ? list() : args)
				args["server_name"] = (config.server_name ? dd_replacetext(config.server_name, "#", "") : null)
				args["server"] = (world.port % 1000) / 100
				args["api_key"] = (src.apikey ? src.apikey : null)

				if (src.debugging)
					src.logDebug("Export, final args: [list2params(args)]. Final route: [src.interface][iface]=1&[list2params(args)]")

				var/http[] = world.Export("[src.interface][iface]=1&[list2params(args)]")
				if (!http || !http["CONTENT"])
					logTheThing("debug", null, null, "<b>IRCBOT:</b> No return data from export. <b>iface:</b> [iface]. <b>args</b> [list2params(args)]")
					return 0

				var/content = file2text(http["CONTENT"])

				if (src.debugging)
					src.logDebug("Export, returned data: [content]")


		//Format the response to an irc request juuuuust right
		response(args)
			if (src.debugging)
				src.logDebug("Response called with args: [list2params(args)]")

			args = (args == null ? list() : args)
			args["api_key"] = (src.apikey ? src.apikey : null)

			if (config && config.server_name)
				args["server_name"] = dd_replacetext(config.server_name, "#", "")
				args["server"] = dd_replacetext(config.server_name, "#", "") //TEMP FOR BACKWARD COMPAT WITH SHITFORMANT

			if (src.debugging)
				src.logDebug("Response, final args: [list2params(args)]")

			return list2params(args)


		toggleDebug(client/C)
			if (!C) return 0
			src.debugging = !src.debugging
			out(C, "IRCBot Debugging [(src.debugging ? "Enabled" : "Disabled")]")
			if (src.debugging)
				var/log = "Debugging Enabled. Datum variables are: "
				for (var/x = 1, x <= src.vars.len, x++)
					var/theVar = src.vars[x]
					if (theVar == "vars") continue
					var/contents
					if (islist(src.vars[theVar]))
						contents = list2params(src.vars[theVar])
					else
						contents = src.vars[theVar]
					log += "<b>[theVar]:</b> [contents] "
				src.logDebug(log)
			return 1


		logDebug(log)
			if (!log) return 0
			logTheThing("debug", null, null, "<b>IRCBOT //DEBUGGING:</b> [log]")
			return 1


/client/proc/toggleIrcbotDebug()
	set name = "Toggle IRCBot Debug"
	set desc = "Enables in-depth logging of all IRC Bot exports and returns"
	set category = "Admin"

	admin_only

	ircbot.toggleDebug(src)
	return 1
