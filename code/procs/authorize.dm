//D2K5's Spacetopia Player API

//The API variable can be found inside the client of every mob, it is a list/array.
//It is populated upon running the authorize() or spacetopia_authorize() proc.

//Possible API Replies:
//	api["username"] - returns users spacetopia username
//	api["real_name"] - returns character real name
//	api["gender"] - returns character gender
//	api["bio"] - returns character bio
//	api["age"] - returns character age
//	api["ckey"] - returns users ckey
//	api["balance"] - returns users bank balance (in text, convert this to int yourself if you need to)
//	api["isgold"] - checks whether a user is gold (returns true or false)
//	api["isbanned"] - checks whether a user is banned (returns true or false)
//	api["isvalid"] - checks whether a user is validated (returns true or false)

/client/proc/authorize()
	set name = "Authorize"

	var/list/text = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[src.ckey]&format=text")
	if(text)
		var/content = file2text(text["CONTENT"])
		var/savefile/apid = new
		apid.ImportText("/", content)
		apid.cd = "general"
		api["username"] = apid["username"]
		api["real_name"] = apid["real_name"]
		api["gender"] = apid["gender"]
		api["age"] = apid["age"]
		api["bio"] = apid["bio"]
		api["ckey"] = apid["ckey"]
		api["balance"] = apid["balance"]
		api["isgold"] = apid["isgold"]
		api["isbanned"] = apid["isbanned"]
		api["isvalid"] = apid["isvalid"]

		if (api["isbanned"] == "true")
			src.verbs -= /client/proc/authorize
			boutput(src, "<span style='color: red;'>This citizen is banned from Spacetopia.</span>")
			src.authed = 0

		if (api["isvalid"] == "false")
			src.verbs -= /client/proc/authorize
			boutput(src, "<span style='color: red;'>This citizen has not been validated yet.</span>")
			src.authed = 0
		else
			src.verbs -= /client/proc/authorize
			boutput(src, "<span style='color: green;'>Citizenship verification successful.</span>")
			src.authed = 1

		if (src.authed != 1)
			src.verbs += /client/proc/authorize
			boutput(src, "<span style='color: red;'>Citizenship verification failed.</span>")
			src.authed = 0
	else
		boutput(src, "<span style='color: red;'>Citizenship verification failed.</span>")
		src.authed = 0

	if (admins.Find(src.ckey))
		boutput(src, "<span class='ooc adminooc'>You are an admin.</span>")
		if (!NT.Find(src.ckey))
			NT.Add(src.ckey)
			//src.mentor = 1
			return
		return

	if (NT.Find(src.ckey) || mentors.Find(src.ckey))
		src.mentor = 1
		src.mentor_authed = 1
		boutput(src, "<span class='ooc mentorooc'>You are a mentor!</span>")
		if (!src.holder)
			src.verbs += /client/proc/toggle_mentorhelps
		return


/client/proc/spacetopia_authorize()
	set name = "Authorize Citizenship"

	var/list/text = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[src.ckey]&format=text")
	if(text)
		var/content = file2text(text["CONTENT"])
		var/savefile/apid = new
		apid.ImportText("/", content)
		apid.cd = "general"
		api["username"] = apid["username"]
		api["real_name"] = apid["real_name"]
		api["gender"] = apid["gender"]
		api["bio"] = apid["bio"]
		api["age"] = apid["age"]
		api["ckey"] = apid["ckey"]
		api["balance"] = apid["balance"]
		api["isgold"] = apid["isgold"]
		api["isbanned"] = apid["isbanned"]
		api["isvalid"] = apid["isvalid"]

		if (api["isvalid"] == "false")
			src.authed = 0
		else
			src.authed = 1
	else
		src.authed = 0

	if (src.authed != 1)
		src.authed = 0

/client/proc/set_mentorhelp_visibility(var/set_as = null)
	if (!isnull(set_as))
		src.mentor = set_as
		src.see_mentor_pms = set_as
	else
		src.mentor = !(src.mentor)
		src.see_mentor_pms = src.mentor
	boutput(src, "<span class='ooc mentorooc'>You will [src.mentor ? "now" : "no longer"] see Mentorhelps [src.mentor ? "and" : "or"] show up as a Mentor.</span>")

/client/proc/toggle_mentorhelps()
	set name = "Toggle Mentorhelps"
	set category = "Toggles"
	set desc = "Show or hide mentorhelp messages. You will also no longer show up as a mentor in OOC and via the Who command if you disable mentorhelps."

	if (!src.mentor_authed && !src.holder)
		boutput(src, "<span style='color:red'>Only mentors may use this command.</span>")
		src.verbs -= /client/proc/toggle_mentorhelps // maybe?
		return

	src.set_mentorhelp_visibility()

/*
/proc/proxy_check(address)
	if(address)
	var/result = world.Export("http://cdn.spacetopia.pw/ss13/check_ip.php?ip=[address]")
	lowertext(result["STATUS"]) == "200 ok")
			var/using_proxy = text2num(file2text(result["CONTENT"]))
			if(using_proxy)
				return 1
	return 0
*/


//Usage: doTransaction(<ckey>,<amount>,<description>)
/datum/proc/doTransaction(ckey,amount,description)
	var/transactiondebug = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[ckey]&doTransaction&amount=[amount]&description=[description]&type=Spacetopia")
	if(!transactiondebug)
		return "no key found"
	var/acontent = file2text(transactiondebug["CONTENT"])
	var/acode = lowertext(acontent)
	if(acode == "done")
		world.log << "Transaction: [ckey] - Amount: [amount] Description: [description]"
		return 1
	else
		return 0

/datum/proc/getBalance(ckey)
	world.log << "Attemping getBalance: [ckey]"
	var/getcurrency = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[ckey]&getCurrency")
	if(!getcurrency)
		world.log << "#1 Failed getBalance: [ckey]"
		return 0
	var/currencycontent = file2text(getcurrency["CONTENT"])
	var/currency = lowertext(currencycontent)
	if(currency != "no key found")
		world.log << "Balance: [ckey] - Amount: [currency]"
		return currency
	else
		world.log << "#2 Failed getBalance: [ckey]"
		return 0