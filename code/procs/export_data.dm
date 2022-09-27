///// FOR EXPORTING DATA TO A SERVER /////
var/global/stat_server = ""
var/global/server_token = "flying cars"

// Called in world.dm at new()
/proc/round_start_data()
	set background = 1

	var/message[] = new()
	message["token"] = md5(server_token)
	message["round_name"] = url_encode(station_name())
	message["round_server"]  = "[(world.port % 1000) / 100]"
	message["round_status"] = "start"

//	world.Export("[stat_server][list2params(message)]")

// Called in gameticker.dm at the end of the round.
/proc/round_end_data(var/reason)
	set background = 1

	var/message[] = new()
	message["token"] = md5(server_token)
	message["round_server"]  = "[(world.port % 1000) / 100]"
	message["round_status"] = "end"
	message["end_reason"] = reason
	message["game_type"] = ticker && ticker.mode ? ticker.mode.name : "pre"

//	world.Export("[stat_server][list2params(message)]")