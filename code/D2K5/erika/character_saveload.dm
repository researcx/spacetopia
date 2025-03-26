/mob/verb/savechar()
	set name = "SAVE CHARACTER"

	var/profile = input(src, "Select which character to load:", "Character Manager")  as null|anything in list("1","2","3")
	if(profile)
		if(istype(usr, /mob/living))
			var/savefile = "data/player_saves/[copytext(src.ckey, 1, 2)]/[src.ckey]-char[profile].sav"

			world.log << "Saving: 1"

			usr.client = null
			usr.last_client = null

			var/savefile/F = new(savefile)
			F << usr

			world.log << "Saving: 2"

/client/verb/loadchar()
	set name = "LOAD CHARACTER"

	var/profile = input(src, "Select which character to load:", "Character Manager")  as null|anything in list("1","2","3")
	if(profile)
		if(istype(mob, /mob/living))
			var/savefile = "data/player_saves/[copytext(src.ckey, 1, 2)]/[src.ckey]-char[profile].sav"

			world.log << "Loading: 1"

			if(fexists(savefile))
				var/savefile/F = new(savefile)
				F["mob"] >> src
				mob.loc = F["Character"]

				world.log << "Loading: 2"

client/New()
	var/client_file = "data/player_saves/[copytext(src.ckey, 1, 2)]/[src.ckey]-char1.sav"
	world.log << "Loading: 1"
	if(fexists(client_file))
		world.log << "Loading: 2"
		var/savefile/F = new(client_file) //open it as a savefile
		F >> usr  //read the player's mob

		world.log << "Loading: 3"

	..()