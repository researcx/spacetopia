/datum/plant/fungus
	name = "Fungus"
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#224400"
	crop = /obj/item/reagent_containers/food/snacks/mushroom
	nothirst = 1
	starthealth = 20
	growtime = 30
	harvtime = 250
	harvests = 10
	endurance = 40
	cropsize = 3
	force_seed_on_harvest = 1
	vending = 2
	genome = 30
	assoc_reagents = list("space_fungus")
	mutations = list(/datum/plantmutation/fungus/amanita,/datum/plantmutation/fungus/psilocybin)

/datum/plant/lasher
	name = "Lasher"
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#00FFFF"
	cropsize = 3
	nothirst = 1
	starthealth = 45
	growtime = 50
	harvtime = 100
	harvestable = 0
	endurance = 50
	isgrass = 1
	special_proc = 1
	attacked_proc = 1
	harvested_proc = 1
	vending = 2
	genome = 5
	mutations = list(/datum/plantmutation/lasher/berries)

	HYPspecial_proc(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.growtime + DNA.growtime) && prob(33))
			for (var/mob/living/M in range(1,POT))
				if (POT.health > P.starthealth / 2)
					random_brute_damage(M, 2)
					if (prob(20)) M.weakened += 3

				if (POT.health <= P.starthealth / 2) POT.visible_message("<span style=\"color:red\"><b>[POT.name]</b> weakly slaps [M] with a vine!</span>")
				else POT.visible_message("<span style=\"color:red\"><b>[POT.name]</b> slashes [M] with thorny vines!</span>")

	HYPattacked_proc(var/obj/machinery/plantpot/POT,var/mob/user,var/obj/item/W)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth < (P.growtime + DNA.growtime)) return 0
		// It's not big enough to be violent yet, so nothing happens

		POT.visible_message("<span style=\"color:red\"><b>[POT.name]</b> violently retaliates against [user.name]!</span>")
		random_brute_damage(user, 3)
		if (W && prob(50))
			boutput(user, "<span style=\"color:red\">The lasher grabs and smashes your [W]!</span>")
			W.dropped()
			qdel(W)
		return 1

	HYPharvested_proc(var/obj/machinery/plantpot/POT,var/mob/user)
		..()
		if (.) return
		if (POT.health > src.starthealth / 2)
			boutput(user, "<span style=\"color:red\">The lasher flails at you violently! You might need to weaken it first...</span>")
			return 1
		else return 0

/datum/plant/creeper
	name = "Creeper"
	unique_seed = /obj/item/seed/creeper
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#CC00FF"
	nothirst = 1
	starthealth = 30
	growtime = 30
	harvtime = 100
	harvestable = 0
	endurance = 40
	isgrass = 1
	special_proc = 1
	vending = 2
	genome = 8

	HYPspecial_proc(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.growtime + DNA.growtime) && POT.health > P.starthealth / 2 && prob(33))
			for (var/obj/machinery/plantpot/C in range(1,POT))
				var/datum/plant/growing = C.current
				if (!C.dead && C.current && !istype(growing,/datum/plant/crystal) && !istype(growing,/datum/plant/creeper)) C.health -= 10
				else if (C.dead) C.HYPdestroyplant()
				else if (!C.current)
					var/obj/item/seed/creeper/WS = new(src)
					C.HYPnewplant(WS)
					sleep(5)
					qdel(WS)
					break

/datum/plant/radweed
	name = "Radweed"
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#55CC55"
	nothirst = 1
	starthealth = 40
	growtime = 140
	harvtime = 200
	harvestable = 0
	endurance = 80
	special_proc = 1
	vending = 2
	genome = 40
	assoc_reagents = list("radium")
	mutations = list(/datum/plantmutation/radweed/redweed,/datum/plantmutation/radweed/safeweed)

	HYPspecial_proc(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth > (P.harvtime + DNA.harvtime) && prob(10))
			var/obj/overlay/B = new /obj/overlay( POT.loc )
			B.icon = 'icons/obj/hydroponics/hydromisc.dmi'
			B.icon_state = "radpulse"
			B.name = "radioactive pulse"
			B.anchored = 1
			B.density = 0
			B.layer = 5 // TODO What layer should this be on?
			spawn(20)
				qdel(B)
			var/radstrength = 5
			var/radrange = 1
			switch (POT.health)
				if (21 to 129)
					radstrength = 15
				if (130 to 159)
					radstrength = 25
					radrange = 2
				if (160 to INFINITY)
					radstrength = 50
					radrange = 3
			for (var/mob/living/carbon/M in range(radrange,POT))
				M.irradiate(radstrength)
			for (var/obj/machinery/plantpot/C in range(radrange,POT))
				var/datum/plant/growing = C.current
				if (POT.health <= P.starthealth / 2) break
				if (istype(growing,/datum/plant/radweed)) continue
				if (growing) C.HYPmutateplant(radrange * 2)
				if (growing) C.HYPdamageplant("radiation",rand(0,radrange * 2))

/datum/plant/slurrypod
	name = "Slurrypod"
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#004400"
	crop = /obj/item/reagent_containers/food/snacks/plant/slurryfruit
	nothirst = 1
	starthealth = 25
	growtime = 30
	harvtime = 60
	harvests = 1
	cropsize = 3
	endurance = 30
	special_proc = 1
	vending = 2
	genome = 45
	var/exploding = 0
	assoc_reagents = list("toxic_slurry")
	mutations = list(/datum/plantmutation/slurrypod/omega)

	HYPinfusionP(var/obj/item/seed/S,var/reagent)
		..()
		var/datum/plantgenes/DNA = S.plantgenes
		switch(reagent)
			if ("toxic_slurry","gvomit","gcheese")
				DNA.endurance += rand(4,8)
				S.seeddamage = 0
			if ("charcoal")
				S.seeddamage = 100

	HYPspecial_proc(var/obj/machinery/plantpot/POT)
		..()
		if (.) return
		var/datum/plant/P = POT.current
		var/datum/plantgenes/DNA = POT.plantgenes

		if (POT.growth >= (P.harvtime + DNA.harvtime + 50) && prob(10) && !src.exploding)
			src.exploding = 1
			POT.visible_message("<span style=\"color:red\"><b>[POT]</b> begins to bubble and expand!</span>")
			playsound(POT.loc, "sound/effects/bubbles.ogg", 50, 1)

			spawn(50)
				POT.visible_message("<span style=\"color:red\"><b>[POT]</b> bursts, sending toxic goop everywhere!</span>")
				playsound(POT.loc, "sound/effects/splat.ogg", 50, 1)

				for (var/mob/living/carbon/human/M in view(3,POT))
					if(istype(M.wear_suit, /obj/item/clothing/suit/bio_suit) && istype(M.head, /obj/item/clothing/head/bio_hood))
						boutput(M, "<span style=\"color:orange\">You are splashed by toxic goop, but your biosuit protects you!</span>")
						continue
					boutput(M, "<span style=\"color:red\">You are splashed by toxic goop!</span>")
					M.reagents.add_reagent("toxic_slurry", rand(5,20))
				for (var/obj/machinery/plantpot/C in view(3,POT)) C.reagents.add_reagent("toxic_slurry", rand(5,10))

				POT.HYPdestroyplant()
				return

/datum/plant/grass
	name = "Grass"
	growthmode = "weed"
	category = "Miscellaneous"
	seedcolor = "#00CC00"
	crop = /obj/item/seed/grass
	unique_seed = /obj/item/seed/grass
	isgrass = 1
	nothirst = 1
	starthealth = 5
	growtime = 15
	harvtime = 50
	harvests = 1
	cropsize = 8
	endurance = 10
	vending = 2
	genome = 4