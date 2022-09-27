//Contains reagents related to eating or drinking.
datum
	reagent
		fooddrink/
			name = "food drink stuff"

		fooddrink/bilk
			name = "bilk"
			id = "bilk"
			fluid_r = 147
			fluid_g = 100
			fluid_b = 65
			transparency = 240
			taste = "vile"
			depletion_rate = 0.075
			description = "This appears to be beer mixed with milk."
			reagent_state = LIQUID
			value = 2
			thirst_value = 0.5

			on_mob_life(var/mob/M) //temp
				if(!M) M = holder.my_atom
				if(M.losebreath > 10)
					M.losebreath = max(10, M.losebreath-10)
				if(M.get_oxygen_deprivation() > 85)
					M.take_oxygen_deprivation(-10)
				if((M.health + M.losebreath) < 0)
					if(M.get_toxin_damage())
						M.take_toxin_damage(-1)
					M.HealDamage("All", 1, 1)
				M.updatehealth()
				..(M)
				return

		fooddrink/milk
			name = "milk"
			id = "milk"
			description = "An opaque white liquid produced by the mammary glands of mammals."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_b = 255
			fluid_g = 255
			transparency = 255
			thirst_value = 1.5

			on_mob_life(var/mob/M)
				if (!M)
					M = holder.my_atom
				if (M.get_toxin_damage() <= 25)
					M.take_toxin_damage(-1)
					M.updatehealth()
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("bladder", -0.75)
					if (bone_system)
						for (var/obj/item/organ/O in H.organs)
							if (O.bones)
								O.bones.repair_damage(1)
				if (M.reagents.has_reagent("capsaicin"))
					M.reagents.remove_reagent("capsaicin", 5)
				..(M)
				return

		fooddrink/milk/chocolate_milk
			name = "chocolate milk"
			id = "chocolate_milk"
			fluid_r = 133
			fluid_g = 67
			fluid_b = 44
			transparency = 255
			taste = "chocolatey"
			description = "Chocolate-flavored milk, tastes like being a kid again."
			reagent_state = LIQUID
			thirst_value = 0.75
			value = 3 // 1 2

		fooddrink/milk/strawberry_milk
			name = "strawberry milk"
			id = "strawberry_milk"
			fluid_r = 248
			fluid_g = 196
			fluid_b = 196
			transparency = 255
			taste = "like strawberries"
			description = "Strawberry-flavored milk, tastes like being a kid again."
			reagent_state = LIQUID
			thirst_value = 0.75
			value = 3 // 1 2

		fooddrink/alcoholic
			name = "alcoholic reagent parent"
			id = "alcoholic_parent"
			description = "You shouldn't be seeing this ingame. If you do, report it to a coder."
			reagent_state = LIQUID
			taste = "confusing"

			fluid_r = 133
			fluid_g = 64
			fluid_b = 27
			transparency = 190
			var/alch_strength = 1
			var/bladder_value = 1
			thirst_value = -1
			hygiene_value = -0.5

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.reagents.add_reagent("ethanol", alch_strength)
				M.reagents.remove_reagent(src, 1)
				var/mob/living/carbon/human/H = M
				if (istype(H))
					if (H.sims)
						H.sims.affectMotive("bladder", -bladder_value)
				..(M)
				return

		fooddrink/alcoholic/beer
			name = "beer"
			id = "beer"
			description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
			reagent_state = LIQUID
			taste = "hoppy"
			bladder_value = 2

			fluid_r = 133
			fluid_g = 64
			fluid_b = 27
			transparency = 190

			reaction_temperature(exposed_temperature, exposed_volume)
				if(exposed_temperature <= T0C + 7)
					name = "Chilled Beer"
					description = "A nice chilled beer. Perfect!"
					taste = "nicely cool and hoppy"
				else if (exposed_temperature > T0C + 30)
					name = "Warm Beer"
					description = "Warm Beer. Ughhh, this is disgusting."
					taste = "grossly warm and hoppy"
				else
					name = "Beer"
					description = initial(description)
					taste = initial(taste)

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				var/mytemp = holder.total_temperature
				src = null
				if(!volume_passed) return
				if(!ishuman(M)) return
				if(method == INGEST)
					if(mytemp <= T0C+7) //Nice & cold.
						if(M.get_toxin_damage())
							M.take_toxin_damage(-5)
							M.updatehealth()
						if (prob(25)) boutput(M, "<span style=\"color:orange\">Nice and cold! How refreshing!</span>")
					else if (mytemp > T0C + 30) //Warm & disgusting.
						M.emote("frown")
						boutput(M, "<span style=\"color:red\">This beer is all warm and nasty. Ugh.</span>")

		fooddrink/alcoholic/cider
			name = "cider"
			id = "cider"
			fluid_r = 8
			fluid_g = 65
			fluid_b = 7
			alch_strength = 2
			description = "An alcoholic beverage derived from apples."
			reagent_state = LIQUID
			thirst_value = -0.5

		fooddrink/alcoholic/mead
			name = "mead"
			id = "mead"
			fluid_r = 8
			fluid_g = 65
			fluid_b = 7
			alch_strength = 3
			description = "An alcoholic beverage derived from honey."
			reagent_state = LIQUID
			thirst_value = -0.5

		fooddrink/alcoholic/wine
			name = "wine"
			id = "wine"
			fluid_r = 161
			fluid_g = 71
			fluid_b = 231
			alch_strength = 3
			description = "An alcoholic beverage derived from grapes."
			reagent_state = LIQUID
			taste = "sweet"

		fooddrink/alcoholic/wine/white
			name = "white wine"
			id = "white_wine"
			fluid_r = 252
			fluid_g = 168
			fluid_b = 177

		fooddrink/alcoholic/champagne
			name = "champagne"
			id = "champagne"
			fluid_r = 251
			fluid_g = 140
			fluid_b = 108
			alch_strength = 1
			description = "A fizzy alcoholic beverage derived from grapes, made in Champagne, France."
			reagent_state = LIQUID
			taste = "sweet"
			thirst_value = -0.5

		fooddrink/alcoholic/rum
			name = "rum"
			id = "rum"
			fluid_r = 161
			fluid_g = 71
			fluid_b = 231
			alch_strength = 4
			description = "An alcoholic beverage derived from sugar."
			reagent_state = LIQUID

		fooddrink/alcoholic/vodka
			name = "vodka"
			id = "vodka"
			fluid_r = 0
			fluid_g = 0
			fluid_b = 255
			transparency = 20
			alch_strength = 4
			description = "A strong alcoholic beverage derived from potatoes."
			reagent_state = LIQUID
			taste = "smooth"

		fooddrink/alcoholic/bourbon
			name = "bourbon"
			id = "bourbon"
			fluid_r = 161
			fluid_g = 71
			fluid_b = 231
			alch_strength = 4
			description = "An alcoholic beverage derived from maize."
			reagent_state = LIQUID

		fooddrink/alcoholic/tequila
			name = "tequila"
			id = "tequila"
			fluid_r = 255
			fluid_g = 252
			fluid_b = 144
			alch_strength = 5
			description = "A somewhat notorious liquor made from agave. One tequila, two tequila, three tequila, floor."
			reagent_state = LIQUID

		fooddrink/alcoholic/boorbon
			name = "BOOrbon"
			id = "boorbon"
			fluid_r = 121
			fluid_g = 171
			fluid_b = 121
			alch_strength = 4
			description = "An alcoholic beverage derived from maize.  Also ghosts."
			taste = "spooky"

		fooddrink/alcoholic/beepskybeer
			name = "Beepskybr�u Security Schwarzbier"
			id = "beepskybeer"
			description = "A dark German beer, typically served with dark bread, cream cheese, and an intense appreciation for the law."
			reagent_state = LIQUID
			taste = "lawful"
			bladder_value = 2

			fluid_r = 61
			fluid_g = 57
			fluid_b = 56
			transparency = 200
			alch_strength = 4

			on_mob_life(var/mob/living/M)
				if (!M)
					M = holder.my_atom

				var/obj/vehicle/V = M.loc
				if (istype(V) && V.rider == M)
					boutput(M, "<b><font color=red face=System>DRUNK DRIVING IS A CRIME</font></b>")
					boutput(M, "<span style=\"color:red\">You feel a paralyzing shock in your lower torso!</span>")
					M << sound('sound/weapons/Egloves.ogg', repeat = 0, wait = 0, volume = 50, channel = 0)
					M.weakened = 10 //No hulk immunity when the stun is coming from inside your liver, ok .I
					M.stuttering = 10
					M.stunned = 10

					M.Virus_ShockCure(M, 33)
					M.shock_cyberheart(33)

					V.eject_rider(1,0)


				else if (istype(V, /obj/machinery/vehicle)) //if somebody adds /obj/item/vehicle, I'm killing myself.
					var/obj/machinery/vehicle/MV = V
					if (MV.pilot == M)
						boutput(M, "<b><font color=red face=System>DRUNK DRIVING IS A CRIME</font></b>")
						boutput(M, "<span style=\"color:red\">You feel a paralyzing shock in your lower torso!</span>")
						M << sound('sound/weapons/Egloves.ogg', repeat = 0, wait = 0, volume = 50, channel = 0)
						M.weakened = 10
						M.stuttering = 10
						M.stunned = 10

						M.Virus_ShockCure(M, 33)
						M.shock_cyberheart(33)

						MV.eject(M)

				..(M)
				return

		fooddrink/alcoholic/moonshine
			name = "moonshine"
			id = "moonshine"
			description = "An illegaly brewed and highly potent alcoholic beverage."
			reagent_state = LIQUID
			value = 5
			taste = "painfully strong"

			fluid_r = 165
			fluid_g = 65
			fluid_b = 30
			transparency = 190
			alch_strength = 10

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed) return
				if(!ishuman(M)) return
				if(method == INGEST)
					if(M.mind)
						if(M.mind.special_role == "traitor" && M.client)
							M.reagents.add_reagent("omnizine",10)
							M.reagents.del_reagent("moonshine")
							return

		fooddrink/alcoholic/bojack // Bar Contest Winner's Drink
			name = "Bo Jack Daniel's"
			id = "bojack"
			description = "A strong beverage. Drinking this will put hair on your chest. Maybe."
			reagent_state = LIQUID
			alch_strength = 5
			value = 2
			taste = "manly"

			fluid_r = 130
			fluid_g = 65
			fluid_b = 30
			transparency = 190
			on_mob_life(var/mob/target)
				if(!target) target = holder.my_atom
				var/mob/living/carbon/human/M = target
				if (!istype(M))
					return

				if (prob(8) && (M.gender == "male"))
					if (M.cust_two_state != "gt" && M.cust_two_state != "neckbeard" && M.cust_two_state != "fullbeard" && M.cust_two_state != "longbeard")
						M.cust_two_state = pick("gt","neckbeard","fullbeard","longbeard")
						M.set_face_icon_dirty()
						boutput(M, "<span style=\"color:orange\">You feel manly!</span>")

				if (prob(8))
					M.say(pick("God Jesus what the fuck.",\
					"It's just like, damn, man.",\
					"I remember playing the banana game at boarding school.",\
					"It's kinda hard knowing you've nothing to go home to except a crater.",\
					"The only good hug is a dead hug.",\
					"Tried to fart stealthily in class. Sharted. Why the hell do you think my suit is brown?",\
					"I remember my first holiday away from my parents. Costa Concordia, the ship was called.",\
					"Cry because it's over, don't smile because it happened.",\
					"They say when you are missing someone that they are probably feeling the same, but I don't think it's possible for you to miss me as much as I'm missing you right now.",\
					"Why do beautiful songs make you sad? Because they aren't true.",\
					"Tears are words that need to be written.",\
					"I'm lonely. And I'm lonely in some horribly deep way and for a flash of an instant, I can see just how lonely, and how deep this feeling runs. And it scares the shit out of me to be this lonely because it seems catastrophic.",\
					"Someday, we'll run into each other again, I know it. Maybe I'll be older and smarter and just plain better. If that happens, that's when I'll deserve you. But now, at this moment, you can't hook your boat to mine, because I'm liable to sink us both.",\
					"There you go...let it all slide out. Unhappiness can't stick in a person's soul when it's slick with tears.",\
					"I was in the biggest breakdown of my life when I stopped crying long enough to let the words of my epiphany really sink in. That whore, karma had finally made her way around and had just bitch-slapped me right across the face. The realization only made me cry harder.",\
					"I waste at least an hour every day lying in bed. Then I waste time pacing. I waste time thinking. I waste time being quiet and not saying anything because I'm afraid I'll stutter."))
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed) return
				if(method == INGEST)
					var/alch = volume_passed * 1.25
					M.reagents.add_reagent("ethanol", alch)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if (H.bioHolder && H.bioHolder.HasEffect("resist_alcohol"))
							return
						if (volume_passed + H.reagents.get_reagent_amount("bojack") > 10)

							boutput(M, "<span style=\"color:red\">Oh god, this stuff is far too manly to keep down...!</span>")
							spawn(pick(30,50,70))
								M.visible_message("<span style=\"color:red\">[M] pukes everywhere and passes out!</span>")
								playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
								new /obj/decal/cleanable/vomit(M.loc)
								M.reagents.del_reagent("bojack")
								M.paralysis += 10

		fooddrink/alcoholic/cocktail_screwdriver
			name = "Screwdriver"
			id = "screwdriver"
			description = "A tangy mixture of vodka and orange juice."
			reagent_state = LIQUID
			taste = "sweet"
			thirst_value = -0.25

			fluid_r = 252
			fluid_g = 163
			fluid_b = 30
			transparency = 190
			alch_strength = 4

		fooddrink/alcoholic/cocktail_bloodymary
			name = "Bloody Mary"
			id = "bloody_mary"
			description = "Mixed tomato juice and vodka."
			reagent_state = LIQUID
			taste = "spicy"
			thirst_value = -0.25

			fluid_r = 255
			fluid_g = 53
			fluid_b = 0
			transparency = 190
			alch_strength = 4

		fooddrink/alcoholic/cocktail_bloodyscary
			name = "Bloody Scary"
			id = "bloody_scary"
			description = "A mix of vodka and the blood of a terrible Other Thing."
			reagent_state = LIQUID
			taste = "scary"
			thirst_value = -1.5

			fluid_r = 255
			fluid_g = 53
			fluid_b = 0
			transparency = 200
			alch_strength = 5

		fooddrink/alcoholic/cocktail_suicider
			name = "Suicider"
			id = "suicider"
			description = "An unbelievably strong and potent variety of Cider."
			reagent_state = LIQUID
			taste = "strong"
			thirst_value = -2

			fluid_r = 255
			fluid_g = 53
			fluid_b = 0
			transparency = 190
			alch_strength = 15

		fooddrink/alcoholic/cocktail_grog
			name = "grog"
			id = "grog"
			description = "A highly caustic and nigh-undrinkable substance often associated with piracy."
			reagent_state = LIQUID
			taste = "seaworthy"
			thirst_value = -4
			bladder_value = 4

			fluid_r = 0
			fluid_g = 255
			fluid_b = 0
			transparency = 255
			alch_strength = 20

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if (prob(15))
					M.take_toxin_damage(1)
					M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				var/mob/living/carbon/human/H = M

				if (method == TOUCH)

					if (prob(75))
						M.TakeDamage("head", 25, 0, 0, DAMAGE_BLUNT) // this does brute for some reason, whateverrrr
						M.emote("scream")
						boutput(M, "<span style=\"color:red\">Your face has become disfigured!</span>")
						M.real_name = "Unknown"
						M.unlock_medal("Red Hood", 1)
					else
						M.TakeDamage("All", 5, 0, 0, DAMAGE_BLUNT)

				if(istype(H))
				//	if(H.reagents && H.reagents.has_reagent("super_hairgrownium")) //if this starts being abused i will change it, but only admins seem to use grog so fuck it
				//		H.visible_message("<span style=\"color:red\"><b>[H] explodes in a shower of gibs, hair and piracy!</b></span>","<span style=\"color:red\"><b>Oh god, too much hair!</b></span>")
				//		new /obj/item/clothing/glasses/eyepatch(get_turf(H))
				//		new /obj/item/clothing/mask/moustache(get_turf(H))
				//		H.gib()
				//		return
					if(H.cust_one_state != "dreads" || H.cust_two_state != "fullbeard")
						boutput(H, "<b>You feel more piratey! Arr!</b>")
						H.cust_one_state = "dreads"
						H.cust_two_state = "fullbeard"
						H.bioHolder.mobAppearance.customization_first = "Dreadlocks"
						H.bioHolder.mobAppearance.customization_second = "Full Beard"
						H.real_name = "Captain [H.real_name]"
						if (H.wear_id)
							if (istype(H.wear_id, /obj/item/card/id))
								H.wear_id:registered = H.real_name
								H.wear_id:name = "[H.real_name]'s ID ([H.wear_id:assignment])"
							else if (istype(H.wear_id, /obj/item/device/pda2) && H.wear_id:ID_card)
								H.wear_id:ID_card:registered = H.real_name
								H.wear_id:ID_card:name = "[H.real_name]'s ID ([H.wear_id:ID_card:assignment])"
						if(!istype(H.glasses, /obj/item/clothing/glasses/eyepatch))
							var/obj/item/old_glasses = H.glasses
							if(istype(old_glasses))
								H.u_equip(old_glasses)
								if(old_glasses)
									old_glasses.set_loc(H.loc)
									old_glasses.dropped(H)
									old_glasses.layer = initial(old_glasses.layer)
							else
								qdel(H.glasses)
							spawn(5)
								if (H)
									var/obj/item/clothing/glasses/eyepatch/E = new /obj/item/clothing/glasses/eyepatch(H)
									E.name = "Pirate Eyepatch"
									E.desc = "Arr!"
									H.equip_if_possible(E,H.slot_glasses)
						H.set_face_icon_dirty()
						H.set_body_icon_dirty()
				else
					random_brute_damage(M, 5)

			reaction_obj(var/obj/O, var/volume)
				if(istype(O,/obj/item) && prob(20))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in AIviewers(5, O))
						boutput(M, "<span style=\"color:red\">\the [O] melts.</span>")
					qdel(O)

		fooddrink/alcoholic/port
			name = "port"
			id = "port"
			description = "A fortified wine frequently implicated in spontaneous teleportation."
			fluid_r = 161
			fluid_g = 71
			fluid_b = 231
			alch_strength = 5
			description = "An alcoholic beverage derived from grapes."
			reagent_state = LIQUID
			taste = "moving"

			on_mob_life(var/mob/M)
				if (prob(15) && !isrestrictedz(M.z))
					var/telerange = 10
					var/datum/effects/system/spark_spread/s = unpool(/datum/effects/system/spark_spread)
					s.set_up(4, 1, M)
					s.start()
					var/list/randomturfs = new/list()
					for(var/turf/T in orange(M, telerange))
						if(istype(T, /turf/space) || T.density) continue
						randomturfs.Add(T)
					if (!randomturfs.len)
						..(M)
						return
					boutput(M, text("<span style=\"color:red\">You blink, and suddenly you're somewhere else!</span>"))
					playsound(M.loc, "sound/effects/mag_warp.ogg", 25, 1, -1)
					M.set_loc(pick(randomturfs))
				..(M)
				return

		fooddrink/alcoholic/gin
			name = "gin"
			id = "gin"
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 50
			alch_strength = 4
			description = "A strong alcoholic beverage that tastes heavily of juniper."
			reagent_state = LIQUID
			taste = "smooth"

		fooddrink/alcoholic/vermouth
			name = "vermouth"
			id = "vermouth"
			fluid_r = 161
			fluid_g = 71
			fluid_b = 231
			alch_strength = 4
			description = "A fortified wine with botanicals for flavor."
			reagent_state = LIQUID
			taste = "sweet"

		fooddrink/alcoholic/bitters
			name = "bitters"
			id = "bitters"
			fluid_r = 83
			fluid_g = 45
			fluid_b = 48
			alch_strength = 1
			description = "Extremely bitter extract used to flavor cocktails. Not recommended for consumption on its own."
			reagent_state = LIQUID
			taste = "bitter"

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M
				if(method == INGEST)
					boutput(M, "<span style=\"color:red\">Ugh! Why did you drink that?!</span>")
					M.stunned += 2
					M.weakened += 2
					if (prob(25))

						M.visible_message("<span style=\"color:red\">[M] horks all over \himself. Gross!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)


		fooddrink/alcoholic/whiskey_sour
			name = "Whiskey Sour"
			id = "whiskey_sour"
			fluid_r = 170
			fluid_g = 188
			fluid_b = 67
			alch_strength = 2
			description = "For the manly man who can't quite stomach straight liquor."
			reagent_state = LIQUID
			taste = "sour"

		fooddrink/alcoholic/daiquiri
			name = "Daiquiri"
			id = "daiquiri"
			fluid_r = 8
			fluid_g = 65
			fluid_b = 7
			alch_strength = 2
			description = "Rum with some lime juice and sugar."
			reagent_state = LIQUID
			taste = "sweet"
			thirst_value = 0.25

		fooddrink/alcoholic/martini
			name = "Martini"
			id = "martini"
			fluid_r = 238
			fluid_g = 238
			fluid_b = 238
			alch_strength = 3
			transparency = 190
			description = "Hastily slopped together, not stirred."
			reagent_state = LIQUID
			taste = "dry"
			thirst_value = -0.5

		fooddrink/alcoholic/v_martini
			name = "Vodka Martini"
			id = "v_martini"
			fluid_r = 238
			fluid_g = 238
			fluid_b = 238
			alch_strength = 3
			transparency = 190
			description = "From Russia with Love."
			reagent_state = LIQUID
			taste = "smooth and dry"
			thirst_value = -1

		fooddrink/alcoholic/Manhattan
			name = "Manhattan"
			id = "manhattan"
			fluid_r = 164
			fluid_g = 84
			fluid_b = 14
			alch_strength = 3
			description = "For the alcoholic who doesn't quite want to drink straight from the bottle yet."
			reagent_state = LIQUID
			thirst_value = -1.5

		fooddrink/alcoholic/libre
			name = "Space-Cuba Libre"
			id = "libre"
			fluid_r = 41
			fluid_g = 24
			fluid_b = 24
			alch_strength = 2
			description = "Made to celebrate the liberation of Space Cuba in 2028."
			reagent_state = LIQUID
			thirst_value = -1

		fooddrink/alcoholic/ginfizz
			name = "Gin Fizz"
			id = "ginfizz"
			fluid_r = 248
			fluid_g = 255
			fluid_b = 206
			alch_strength = 3
			description = "Don't question how it's fizzing without seltzer."
			reagent_state = LIQUID
			taste = "fizzy"

		fooddrink/alcoholic/gimlet
			name = "Gimlet"
			id = "gimlet"
			fluid_r = 222
			fluid_g = 255
			fluid_b = 206
			alch_strength = 3
			description = "So named because you're a tool if you drink it."
			reagent_state = LIQUID

		fooddrink/alcoholic/v_gimlet
			name = "Vodka Gimlet"
			id = "v_gimlet"
			fluid_r = 222
			fluid_g = 255
			fluid_b = 206
			alch_strength = 3
			description = "Trading pine cones for rubbing alcohol."
			reagent_state = LIQUID

		fooddrink/alcoholic/w_russian
			name = "White Russian"
			id = "w_russian"
			fluid_r = 244
			fluid_g = 244
			fluid_b = 244
			alch_strength = 3
			description = "Nice drink, Dude."
			reagent_state = LIQUID

		fooddrink/alcoholic/b_russian
			name = "Black Russian"
			id = "b_russian"
			fluid_r = 99
			fluid_g = 32
			fluid_b = 15
			alch_strength = 4
			description = "A vodka-infused coffee cocktail. Supposedly created in honor of a US Ambassador that no one remembers."
			reagent_state = LIQUID

		fooddrink/alcoholic/irishcoffee
			name = "Irish Coffee"
			id = "irishcoffee"
			fluid_r = 54
			fluid_g = 42
			fluid_b = 42
			alch_strength = 4
			description = "The breakfast of hung-over champions."
			reagent_state = LIQUID
			taste = ""
			thirst_value = -2

		fooddrink/alcoholic/cosmo
			name = "Cosmopolitan"
			id = "cosmo"
			fluid_r = 250
			fluid_g = 206
			fluid_b = 253
			alch_strength = 2
			description = "Well, at least it's not giving awful dating advice."
			reagent_state = LIQUID

		fooddrink/alcoholic/beach
			name = "Sex on the Beach"
			id = "beach"
			fluid_r = 227
			fluid_g = 121
			fluid_b = 98
			alch_strength = 1
			description = "Fun fact: the name of this cocktail was deemed a war crime in 2025."
			reagent_state = LIQUID
			taste = "sexy"

		fooddrink/alcoholic/gtonic
			name = "Gin and Tonic"
			id = "gtonic"
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 50
			alch_strength = 3
			description = "Once made to make bitter medication taste better, now drunk for its flavor."
			reagent_state = LIQUID
			thirst_value = -1.5

		fooddrink/alcoholic/vtonic
			name = "Vodka Tonic"
			id = "vtonic"
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 50
			alch_strength = 3
			description = "All the bitterness of a gin and tonic, now without any other flavor but alcohol burn!"
			reagent_state = LIQUID

/*		fooddrink/alcoholic/sonic
			name = "Gin and Sonic"
			id = "sonic"
			fluid_r = 0
			fluid_g = 0
			fluid_b = 255
			alch_strength = 6
			description = "GOTTA GET CRUNK FAST BUT LIQUOR TOO SLOW"
			reagent_state = LIQUID
			//decays into sugar/some sort of stimulant, maybe gives unique stimulant effect/messages, like bold red GOTTA GO FASTs? Makes you take damage when you run into a wall?
			taste = "FAST"
			thirst_value = -10
			bladder_value = 5

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.make_jittery(2)
				M.drowsyness = max(M.drowsyness-5, 0)
				if(prob(25))
					if(M.paralysis) M.paralysis--
					if(M.stunned) M.stunned--
					if(M.weakened) M.weakened--
				if(prob(8))
					M.reagents.add_reagent("methamphetamine", 1.2)
					var/speed_message = pick("Gotta go fast!", "Time to speed, keed!", "I feel a need for speed!", "Let's juice.", "Juice time.", "Way Past Cool!")
					if (prob(50))
						M.say( speed_message )
					else
						var/headersize = rand(1,4)
						boutput(M, "<span style=\"color:red\"><h[headersize]>[speed_message]</h[headersize]></span>")

					if (ishuman(M))
						var/mob/living/carbon/human/H = M
						if (H.shoes)
							H.shoes.icon_state = "red"
				..(M)
				return*/


		fooddrink/alcoholic/gpink
			name = "Pink Gin and Tonic"
			id = "gpink"
			fluid_r = 253
			fluid_g = 212
			fluid_b = 212
			alch_strength = 3
			description = "A gin and tonic for people who think the gin gets in the way."
			reagent_state = LIQUID

		fooddrink/alcoholic/eraser
			name = "Mind Eraser"
			id = "eraser"
			fluid_r = 90
			fluid_g = 61
			fluid_b =  61
			alch_strength = 8
			description = "Holy shit, you're getting a buzz just looking at this!"
			reagent_state = LIQUID

		//For laffs (http.//www.youtube.com/watch?v=ySq4O4sZj1w).
		fooddrink/alcoholic/dbreath
			name = "Dragon's Breath"
			id = "dbreath"
			fluid_r = 220
			fluid_g = 0
			fluid_b = 0
			alch_strength = 20
			description = "Possessing this stuff probably breaks the Geneva convention."
			reagent_state = LIQUID
			//lights drinker on fire, deals burn damage, when present in very large/overdose amounts (50+? 100+?) has a high chance of incinerating the drinker like ghostlier chili extract
			taste = "hot"

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if(method == INGEST && prob(20))
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.update_burning(30)
				return

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				//If the user drinks milk, they'll be fine.
				if(M.reagents.has_reagent("milk"))
					boutput(M, "<span style=\"color:orange\">The milk stops the burning. Ahhh.</span>")
					M.reagents.del_reagent("milk")
					M.reagents.del_reagent("dbreath")
				if(prob(8))
					boutput(M, "<span style=\"color:red\"><b>Oh god! Oh GODD!!</b></span>")
				if(prob(50))
					boutput(M, "<span style=\"color:red\">Your throat burns terribly!</span>")
					M.emote(pick("scream","cry","choke","gasp"))
					M.stunned++
				if(prob(8))
					boutput(M, "<span style=\"color:red\">Why!? WHY!?</span>")
				if(prob(8))
					boutput(M, "<span style=\"color:red\">ARGHHHH!</span>")
				if(prob(2 * volume))
					boutput(M, "<span style=\"color:red\"><b>OH GOD OH GOD PLEASE NO!!</b></span>")
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.set_burning(99)
					if(prob(50))
						spawn(20)
							//Roast up the player
							if (M)
								boutput(M, "<span style=\"color:red\"><b>IT BURNS!!!!</b></span>")
								sleep(2)
								M.visible_message("<span style=\"color:red\">[M] is consumed in flames!</span>")
								M.firegib()

				..(M)

		fooddrink/alcoholic/squeeze
			name = "squeeze"
			id = "squeeze"
			description = "Alcohol made from fuel. Do you really think you should drink this? I think you have a problem. Maybe you should talk to a doctor."
			reagent_state = LIQUID
			taste = "vile"

			fluid_r = 178
			fluid_g = 163
			fluid_b = 25
			transparency = 190
			alch_strength = 8
			depletion_rate = 0.4
			thirst_value = -3
			bladder_value = 2

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				if(method == INGEST)
					boutput(M, "<span style=\"color:red\">Drinking that was an awful idea!</span>")
					M.stunned += 2
					M.weakened += 2
					var/mob/living/L = M
					L.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1)
					if (prob(10))
						M.visible_message("<span style=\"color:red\">[M] horks all over \himself. Gross!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_toxin_damage(1)
				..(M)

/*		fooddrink/alcoholic/hunchback
			name = "Hunchback"
			id = "hunchback"
			fluid_r = 50
			fluid_g = 0
			fluid_b =  0
			alch_strength = 1
			description = "An alleged cocktail invented by a notorious scientist. Useful in a pinch as an impromptu purgative, or interrogation tool."
			reagent_state = LIQUID
			//Acts like ghetto calomel that can be made outside medbay, chance to give food poisoning, vomit constantly and explosively while racking up moderate toxin damage that has no/very low HP cap and burning out other chemicals in the body at a rate equal to/greater than calomel - more potent, more dangerous/weaponizable, alternate sleepypen fuel for barman

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				for(var/reagent_id in M.reagents.reagent_list)
					if(reagent_id != id)
						M.reagents.remove_reagent(reagent_id, 8)
				if(M.health > 10)
					M.take_toxin_damage(2)
					M.updatehealth()
				M.updatehealth()
				if(prob(20))
					M.visible_message("<span style=\"color:red\">[M] pukes all over \himself!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
				if(prob(10))
					var/mob/living/L = M
					L.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1)
				..(M)
				return*/

		fooddrink/alcoholic/madmen
			name = "Old Fashioned"
			id = "madmen"
			fluid_r = 240
			fluid_g = 185
			fluid_b =  19
			alch_strength = 3
			description = "The favorite drink of unfaithful, alcoholic executives in really nice suits."
			reagent_state = LIQUID

		fooddrink/alcoholic/planter
			name = "Planter's Punch"
			id = "planter"
			fluid_r = 255
			fluid_g = 175
			fluid_b = 0
			alch_strength = 3
			description = "A Drink then you'll have that's not bad - / At least, so they say in Jamaica!"
			reagent_state = LIQUID

		fooddrink/alcoholic/maitai
			name = "Mai Tai"
			id = "maitai"
			fluid_r = 231
			fluid_g = 107
			fluid_b = 25
			alch_strength = 3
			description = "Even in space, you can't escape Tiki drinks."
			reagent_state = LIQUID

		fooddrink/alcoholic/harlow
			name = "Jean Harlow"
			id = "harlow"
			fluid_r = 233
			fluid_g = 97
			fluid_b = 83
			alch_strength = 3
			description = "A.K.A. that one actress who would have played Fay Wray's part in King Kong if she hadn't died."
			reagent_state = LIQUID

		fooddrink/alcoholic/gchronic
			name = "Gin and Chronic"
			id = "gchronic"
			fluid_r = 162
			fluid_g = 255
			fluid_b = 0
			alch_strength = 4
			description = "DUUUUUUUUUUUUUUUUUUUUDE"
			reagent_state = LIQUID
			//Decays into ethanol and THC

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(10))
					M.reagents.add_reagent("THC", rand(1,10))
				..(M)
				return

		fooddrink/alcoholic/margarita
			name = "Margarita"
			id = "margarita"
			fluid_r = 183
			fluid_g = 242
			fluid_b = 81
			alch_strength = 4
			description = "Something something Jimmy Buffet something something dated references."
			reagent_state = LIQUID

		fooddrink/alcoholic/tequini
			name = "Tequini"
			id = "tequini"
			fluid_r = 251
			fluid_g = 255
			fluid_b = 193
			alch_strength = 4
			description = "You kinda want to punch whoever came up with this name."
			reagent_state = LIQUID

		fooddrink/alcoholic/pfire
			name = "Prairie Fire"
			id = "pfire"
			fluid_r = 184
			fluid_g = 44
			fluid_b = 44
			alch_strength = 5
			description = "The leading cause of flaming toilets across the galaxy."
			reagent_state = LIQUID
			//decays into large amounts of capsaicin and maybe histamines?

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(20))
					M.reagents.add_reagent("capsaicin", rand(10,20))
				if(prob(10))
					M.reagents.add_reagent("histamine", rand(1,5))
				..(M)
				return

		fooddrink/alcoholic/bull
			name = "Brave Bull"
			id = "bull"
			fluid_r = 60
			fluid_g = 42
			fluid_b = 45
			alch_strength = 5
			description = "Mmm, tastes like heart attacks."
			reagent_state = LIQUID

		fooddrink/alcoholic/longisland
			name = "Long Island Iced Tea"
			id = "longisland"
			fluid_r = 174
			fluid_g = 171
			fluid_b = 51
			alch_strength = 8
			description = "Preferred by housewives, raging alcoholics, and the rather large overlap between them."
			reagent_state = LIQUID

		fooddrink/alcoholic/longbeach
			name = "Long Beach Iced Tea"
			id = "longbeach"
			fluid_r = 229
			fluid_g = 54
			fluid_b = 77
			alch_strength = 8
			description = "For when you want a healthier glass of knocks-you-the-fuck-out."
			reagent_state = LIQUID

		fooddrink/alcoholic/pinacolada
			name = "Pi�a Colada"
			id = "pinacolada"
			fluid_r = 255
			fluid_g = 255
			fluid_b = 204
			alch_strength = 4
			description = "I don't really like being caught in the rain all that much, to be honest."
			reagent_state = LIQUID

		fooddrink/alcoholic/mimosa
			name = "Mimosa"
			id = "mimosa"
			fluid_r = 240
			fluid_g = 184
			fluid_b = 1
			alch_strength = 1
			description = "Not a flower, but a sweet cocktail typically served at formal functions."
			reagent_state = LIQUID

		fooddrink/alcoholic/french75
			name = "French 75"
			id = "french75"
			fluid_r = 194
			fluid_g = 147
			fluid_b = 41
			alch_strength = 7
			description = "A strong champagne cocktail."
			reagent_state = LIQUID

		fooddrink/alcoholic/negroni
			name = "Negroni"
			id = "negroni"
			fluid_r = 167
			fluid_g = 0
			fluid_b = 0
			alch_strength = 3
			description = "A sweet gin cocktail."
			reagent_state = LIQUID

		fooddrink/alcoholic/necroni
			name = "Necroni"
			id = "necroni"
			fluid_r = 152
			fluid_g = 171
			fluid_b = 0
			alch_strength = 6
			description = "A hellish cocktail that stinks of rotting garbage."
			reagent_state = LIQUID

/*		fooddrink/ectocooler
			name = "Ecto Cooler"
			id = "ectocooler"
			fluid_r = 105
			fluid_g =  255
			fluid_b = 0
			description = "Said to taste exactly like a proton beam. Considering anyone who's tried to taste a proton beam has lost their jaws, it's hard to say where this idea came from."
			reagent_state = LIQUID
			thirst_value = -1.5

			//decays into 1 VHFCS per unit for a real good time, and also lets you see ghosts

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.reagents.add_reagent("VHFCS", 1)
				if (prob(10))
					M.reagents.add_reagent("green_goop", 1)
				..(M)
				return*/

		fooddrink/refried_beans
			name = "refried beans"
			id = "refried_beans"
			description = "A dish made of mashed beans cooked with lard."
			reagent_state = LIQUID
			fluid_r = 104
			fluid_g = 68
			fluid_b = 53
			transparency = 255

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.nutrition++

				if(prob(10))
					M.emote("fart")
				..(M)

		fooddrink/death_spice
			name = "death spice"
			id = "death_spice"
			description = "Despite its name, this sweet-smelling black powder is completely harmless. Maybe."
			reagent_state = SOLID
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 255
			taste = "deadly"

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				var/odds = rand(1,1000000)
				if(odds == 1)
					M.visible_message("<span style=\"color:red\">[M] suddenly drops dead!</span>")
					M.death()
				..(M)
				return

		fooddrink/bread
			name = "bread"
			id = "bread"
			description = "Bread! Yep, bread."
			reagent_state = SOLID
			fluid_r = 156
			fluid_g = 80
			fluid_b = 19
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5 && !(locate(/obj/item/reagent_containers/food/snacks/breadslice) in T))
					new /obj/item/reagent_containers/food/snacks/breadslice(T)

		fooddrink/george_melonium
			name = "george melonium"
			id = "george_melonium"
			description = "A robust and mysterious substance."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 255
			fluid_b = 0
			transparency = 30

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M
				if(method == INGEST)
					switch(rand(1,5))
						if(1)
							boutput(M, "<span style=\"color:red\">What an explosive burst of flavor!</span>")
							var/turf/T = get_turf(M.loc)
							explosion(M, T, -1, -1, 1, 1)
						if(2)
							boutput(M, "<span style=\"color:red\">So juicy!</span>")
							M.reagents.add_reagent(pick("capsaicin","psilocybin","LSD","THC","ethanol","poo","omnizine","methamphetamine","haloperidol","mutagen","radium","acid","mercury","space_drugs","morphine"), rand(10,40))
						if(3)
							boutput(M, "<span style=\"color:orange\">How refreshing!</span>")
							M.HealDamage("All", 30, 30)
							M.take_toxin_damage(-30)
							M.take_oxygen_deprivation(-30)
							M.take_brain_damage(-30)
							if (ishuman(M))
								var/mob/living/carbon/human/H = M
								if (H.sims)
									H.sims.affectMotive("thirst", 10)
									H.sims.affectMotive("hunger", 10)
						if(4)
							boutput(M, "<span style=\"color:orange\">This flavor is out of this world!</span>")
							M.reagents.add_reagent("space_drugs", 30)
							M.reagents.add_reagent("THC", 30)
							M.reagents.add_reagent("LSD", 30)
							M.reagents.add_reagent("psilocybin", 30)
						if(5)
							boutput(M, "<span style=\"color:red\">What stunning texture!</span>")
							M.paralysis += 5
							M.stunned += 10
							M.weakened += 10
							M.stuttering += 20

		fooddrink/capsaicin
			name = "capsaicin"
			id = "capsaicin"
			description = "A potent irritant produced by pepper plants in the Capsicum genus."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 0
			fluid_b = 0
			transparency = 20
			taste = "hot"
			addiction_prob = 1 // heh
			//penetrates_skin = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if (holder.get_reagent_amount(src.id) >= 20)
					M.stuttering += rand(0,5)
					if(prob(10))
						M.emote(pick("choke","gasp","cough"))
						M.stunned++
						M.take_oxygen_deprivation(rand(0,10))
						M.bodytemperature += rand(5,20)
				M.stuttering += rand(0,2)
				M.bodytemperature += rand(0,3)
				if(prob(10))
					M.emote(pick("cough"))
					M.stunned++
				M.updatehealth()
				..(M)
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M

				if(method == INGEST)
					if (volume_passed > 10)
						if (volume_passed >= 80)
							boutput(M, "<span style=\"color:red\"><b>HOLY FUCK!!!!</b></span>")
							M.emote("scream")
							M.stuttering += 30
							M.weakened += 5
						else if (volume_passed >= 40 && volume_passed < 80)
							boutput(M, "<span style=\"color:red\">HOT!!!!</span>")
							M.emote("cough")
							M.stuttering += 15
						else if (volume_passed >= 11 && volume_passed < 40)
							boutput(M, "<span style=\"color:red\">Hot!</span>")
							M.stuttering += 5
					else boutput(M, "<span style=\"color:red\">Spicy!</span>")


				else if (method == TOUCH)
					if(iscarbon(M))
						if(!M.wear_mask)
							M.reagents.add_reagent("capsaicin",round(volume_passed/5))
							if(prob(50))
								M.emote("scream")
								boutput(M, "<span style=\"color:red\"><b>Your eyes hurt!</b></span>")
								M.take_eye_damage(1, 1)
							M.change_eye_blurry(3)
							M.stunned++
							M.change_misstep_chance(10)


		fooddrink/el_diablo
			name = "El Diablo chili"
			id = "el_diablo"
			description = "Rumored to be the tears of the devil himself."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 0
			fluid_b = 0
			transparency = 40
			taste = "hot"

			on_mob_life(var/mob/M)
				..(M)
				if(!M) M = holder.my_atom
				M.stuttering += rand(0,5)
				if(prob(25))
					M.emote(pick("choke","gasp"))
					M.take_oxygen_deprivation(rand(0,10))
					M.bodytemperature += rand(0,7)
				M.stuttering += rand(0,2)
				M.bodytemperature += rand(0,3)
				if(prob(10))
					M.emote(pick("cough"))
				M.updatehealth()
			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M

				if(method == INGEST)
					boutput(M, "<span style=\"color:red\"><b>HOLY FUCK!!!!</b></span>")
					M.emote("scream")
					M.stuttering += 30
					M.stunned += 10
					if (prob(20))
						if(istype(M, /mob/living))
							var/mob/living/L = M
							boutput(L, "<span style=\"color:red\">Oh christ too hot!!!!</span>")
							L.update_burning(25)

		fooddrink/space_cola
			name = "cola"
			id = "cola"
			description = "A refreshing beverage."
			reagent_state = LIQUID
			fluid_r = 66
			fluid_g = 33
			fluid_b = 33
			transparency = 190
			taste = "sugary"
			thirst_value = 0.75
			hygiene_value = -0.5

			on_mob_life(var/mob/M)
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("bladder", -1.25)
				M.drowsyness = max(0,M.drowsyness-5)
				M.bodytemperature = max(M.base_body_temp, M.bodytemperature-5)
				..(M)
				return

		fooddrink/cheese
			name = "cheese"
			id = "cheese"
			description = "Some cheese. Pour it out to make it solid."
			reagent_state = SOLID
			fluid_r = 255
			fluid_b = 0
			fluid_g = 255
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5 && !(locate(/obj/item/reagent_containers/food/snacks/ingredient/cheese) in T))
					new /obj/item/reagent_containers/food/snacks/ingredient/cheese(T)

			on_mob_life(var/mob/M)
				if(prob(3))
					M.reagents.add_reagent("cholesterol", rand(1,2))

		fooddrink/gcheese
			name = "weird cheese"
			id = "gcheese"
			description = "Hell, I don't even know if this IS cheese. Whatever it is, it ain't normal. If you want to, pour it out to make it solid."
			reagent_state = SOLID
			fluid_r = 80
			fluid_b = 0
			fluid_g = 255
			transparency = 255
			addiction_prob = 5 // hey man some people really like weird cheese
			taste = "weird"

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5 && !(locate(/obj/item/reagent_containers/food/snacks/ingredient/gcheese) in T))
					new /obj/item/reagent_containers/food/snacks/ingredient/gcheese(T)

			on_mob_life(var/mob/M)
				if(prob(5))
					M.reagents.add_reagent("cholesterol", rand(1,3))

		fooddrink/meat_slurry
			name = "meat slurry"
			id = "meat_slurry"
			description = "A paste comprised of highly-processed organic material. Uncomfortably similar to deviled ham spread."
			reagent_state = SOLID
			fluid_r = 235
			fluid_g = 215
			fluid_b = 215
			transparency = 255

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 5 && prob(10))
					if(!locate(/obj/decal/cleanable/blood/gibs) in T)
						playsound(T, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/blood/gibs(T)

			on_mob_life(var/mob/M)
				..(M) // call your parents  :(
				if(prob(4))
					M.reagents.add_reagent("cholesterol", rand(1,3))

		fooddrink/coffee
			name = "coffee"
			id = "coffee"
			description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
			reagent_state = LIQUID
			fluid_r = 39
			fluid_g = 28
			fluid_b = 16
			transparency = 245
			addiction_prob = 5
			var/remove_buff = 0
			thirst_value = -1

			pooled()
				..()
				remove_buff = 0

			on_add()
				if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 2)
				return

			on_remove()
				if(remove_buff)
					if(istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/M)
				..(M)
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("energy", 0.6)
						H.sims.affectMotive("bladder", -1.75)
				M.dizziness = max(0,M.dizziness-5)
				M.drowsyness = max(0,M.drowsyness-3)
				M.sleeping = 0
				M.bodytemperature = min(M.base_body_temp, M.bodytemperature+5)
				M.make_jittery(3)
				if(prob(50))
					if(M.paralysis) M.paralysis--
					if(M.stunned) M.stunned--
					if(M.weakened) M.weakened--

		fooddrink/coffee/energydrink
			name = "energy drink"
			id = "energydrink"
			description = "An energy drink is a liquid plastic with a high amount of caffeine."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 64
			transparency = 170
			overdose = 25
			addiction_prob = 8
			var/tickcounter = 0
			thirst_value = -3

			pooled()
				..()
				tickcounter = 0

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.sims)
						H.sims.affectMotive("bladder", -3.25)
				tickcounter++
				if (src.volume <= src.depletion_rate)
					if (tickcounter < 20)
						return
					else
						M.show_message("<span style=\"color:red\">You feel exhausted!</span>")
						M.drowsyness = tickcounter - 20
						M.dizziness = tickcounter - 20
					src.holder.del_reagent(id)
				else
					..(M)
					// basically, make it twice as effective
					if (prob(50))
						if(M.paralysis) M.paralysis--
						if(M.stunned) M.stunned--
						if(M.weakened) M.weakened--


			do_overdose(var/severity, var/mob/M)
				if (severity == 1 && prob(10))
					M.show_message("<span style=\"color:red\">Your heart feels like it wants to jump out of your chest.</span>")
				else if (ishuman(M) && ((severity == 2 && prob(3 + tickcounter / 25)) || (severity == 1 && prob(tickcounter / 50))))
					M:contract_disease(/datum/ailment/disease/heartfailure, null, null, 1)

		fooddrink/tea
			name = "tea"
			id = "tea"
			description = "An aromatic beverage derived from the leaves of the camellia sinensis plant."
			reagent_state = LIQUID
			fluid_r = 139
			fluid_g = 90
			fluid_b = 54
			transparency = 235
			thirst_value = 2

			reaction_temperature(exposed_temperature, exposed_volume) //Just an example.
				if (exposed_temperature <= T0C + 7)
					name = "iced tea"
					description = "Tea, but cold!"
				else if (exposed_temperature > (T0C + 40) )
					name = "hot tea"
					description = "A common way to enjoy tea."
				else
					name = "tea"
					description = initial(description)

			on_mob_life(var/mob/M)
				if (holder.has_reagent("toxin")) //Tea is good for you!!
					holder.remove_reagent("toxin", 1)
				if (holder.has_reagent("toxic_slurry"))
					holder.remove_reagent("toxic_slurry", 1)
				..(M)
				return

		fooddrink/honey_tea
			name = "tea"
			id = "honey_tea"
			description = "An aromatic beverage derived from the leaves of the camellia sinensis plant. There's a little bit of honey in it."
			reagent_state = LIQUID
			fluid_r = 145
			fluid_g = 97
			fluid_b = 52
			transparency = 232

			on_mob_life(var/mob/living/M)
				if (!M) M = holder.my_atom
				for (var/datum/ailment_data/disease/virus in M.ailments)
					if (prob(5) && istype(virus.master,/datum/ailment/disease/cold))
						M.cure_disease(virus)
					if (prob(3) && istype(virus.master,/datum/ailment/disease/flu))
						M.cure_disease(virus)
					if (prob(3) && istype(virus.master,/datum/ailment/disease/food_poisoning))
						M.cure_disease(virus)
				if (prob(11))
					M.show_text("You feel calm and relaxed.", "blue")
				..(M)
				return

		fooddrink/chocolate
			name = "chocolate"
			id = "chocolate"
			description = "Chocolate is a delightful product derived from the seeds of the theobroma cacao tree."
			reagent_state = LIQUID
			fluid_r = 39
			fluid_g = 28
			fluid_b = 16
			transparency = 245
			on_mob_life(var/mob/M)
				M.bodytemperature = min(M.base_body_temp, M.bodytemperature+5)
				M.reagents.add_reagent("sugar", 0.8)
				..(M)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if(volume >= 3)
					if(locate(/obj/item/reagent_containers/food/snacks/candy/chocolate) in T) return
					new /obj/item/reagent_containers/food/snacks/candy/chocolate(T)

		fooddrink/nectar
			name = "nectar"
			id = "nectar"
			description = "A sweet liquid produced by plants to attract pollinators."
			reagent_state = LIQUID
			fluid_r = 221
			fluid_g = 221
			fluid_b = 24
			transparency = 200

		fooddrink/honey
			name = "honey"
			id = "honey"
			description = "A sweet substance produced by bees through partial digestion.  Bee barf."
			reagent_state = LIQUID
			fluid_r = 206
			fluid_g = 206
			fluid_b = 19
			transparency = 240

			on_mob_life(var/mob/M)
				M.reagents.add_reagent("sugar",0.4)
				..(M)

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 5)
					if (locate(/obj/item/reagent_containers/food/snacks/ingredient/honey) in T)
						return

					new /obj/item/reagent_containers/food/snacks/ingredient/honey(T)

		fooddrink/royal_jelly
			name = "royal jelly"
			id = "royal_jelly"
			description = "A nutritive gel used to induce extended development in the larvae of greater domestic space-bees."
			reagent_state = LIQUID
			fluid_r = 153
			fluid_g = 0
			fluid_b = 102
			transparency = 200

			 //to-do. BEE MEN

		fooddrink/eggnog
			name = "egg nog"
			id = "eggnog"
			description = "A festive dairy drink made with beaten eggs."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 237
			fluid_b = 202
			transparency = 255

			on_mob_life(var/mob/M)
				M.reagents.add_reagent("sugar", 1.6)
				if (prob(5))
					M.nutrition++
				..(M)

		fooddrink/guacamole
			name = "guacamole"
			id = "guacamole"
			description = "A paste comprised primarily of avocado."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 123
			fluid_b = 28

		fooddrink/catonium
			name = "catonium"
			id = "catonium"
			description = "An herbal extract noted for its peculiar effect on felines."
			reagent_state = LIQUID

			reaction_obj(var/obj/O, var/volume)
				if (istype(O, /obj/critter/cat))
					var/obj/critter/cat/theCat = O
					theCat.catnip_effect()

		fooddrink/vanilla
			name = "vanilla"
			id = "vanilla"
			description = "An expensive spice of the new world. Combination with ice not recommended."
			reagent_state = LIQUID
			fluid_r = 253
			fluid_g = 248
			fluid_b = 244
			transparency = 245

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					if(M.bioHolder.HasAnyEffect(effectTypePower) && prob(4))
						M.bioHolder.RemoveAllEffects(effectTypePower)
						boutput(M, "You feel plain.")
				return

		fooddrink/chickensoup
			name = "chicken soup"
			id = "chickensoup"
			description = "An old household remedy for mild illnesses."
			reagent_state = LIQUID
			fluid_r = 180
			fluid_g = 180
			fluid_b = 0
			transparency = 255
			depletion_rate = 0.2
			on_mob_life(var/mob/living/M)
				if(!M) M = holder.my_atom
				for(var/datum/ailment_data/disease/virus in M.ailments)
					if(prob(10) && istype(virus.master,/datum/ailment/disease/cold))
						M.cure_disease(virus)
					if(prob(10) && istype(virus.master,/datum/ailment/disease/flu))
						M.cure_disease(virus)
					if(prob(10) && istype(virus.master,/datum/ailment/disease/food_poisoning))
						M.cure_disease(virus)
				..(M)
				return

		fooddrink/salt
			name = "salt"
			id = "salt"
			description = "Sodium chloride, common table salt."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 150
			overdose = 100
			value = 3 // 1c + 1c + 1c

			reaction_turf(var/turf/T, var/volume)
				src = null
				if (volume >= 10)
					if (!locate(/obj/decal/cleanable/saltpile) in T)
						new /obj/decal/cleanable/saltpile(T)

			do_overdose(var/severity, var/mob/M)
				if(!M) M = holder.my_atom
				if(!istype(M))
					return
				if(prob(70))
					M.take_brain_damage(1)
				..(M)
				return

		fooddrink/pepper
			name = "pepper"
			id = "pepper"
			description = "A common condiment."
			reagent_state = SOLID
			fluid_r = 25
			fluid_g = 10
			fluid_b = 10
			transparency = 255
			value = 3 // same as salt vOv

		fooddrink/ketchup
			name = "ketchup"
			id = "ketchup"
			description = "A condiment often used on hotdogs and sandwiches."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 0
			fluid_b = 0
			transparency = 255

		fooddrink/mustard
			name = "mustard"
			id = "mustard"
			description = "A condiment often used on hotdogs and sandwiches."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 0
			transparency = 255

		fooddrink/porktonium
			name = "porktonium"
			id = "porktonium"
			description = "A highly-radioactive pork byproduct first discovered in hotdogs."
			reagent_state = LIQUID
			fluid_r = 238
			fluid_b = 111
			fluid_g = 111
			transparency = 155
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(!holder.has_reagent(src.id,133))
					..(M)
					return
				if(prob(15))
					M.reagents.add_reagent("cholesterol", rand(1,3))
				if(prob(8))
					M.reagents.add_reagent("radium", 15)
					M.reagents.add_reagent("cyanide", 10)
				..(M)
				return

		fooddrink/mugwort
			name = "mugwort"
			id = "mugwort"
			description = "A rather bitter herb once thought to hold magical protective properties."
			reagent_state = SOLID
			fluid_r = 39
			fluid_g = 28
			fluid_b = 16
			transparency = 250

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed || method != INGEST)
					return
				if (!iswizard(M))
					return

				if(M.get_oxygen_deprivation() && prob(45))
					M.take_oxygen_deprivation(-1)
				if(M.get_toxin_damage() && prob(45))
					M.take_toxin_damage(-1)
				if(M.losebreath && prob(85))
					M.losebreath--
				if(prob(45))
					M.HealDamage("All", 6, 6)
				M.updatehealth()
				//M.UpdateDamageIcon()
				return

		fooddrink/grease
			name = "space-soybean oil"
			id = "grease"
			description = "An oil derived from extra-terrestrial soybeans."
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 150

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.nutrition++
				if(prob(10))
					M.reagents.add_reagent("cholesterol", rand(1,3))
				if(prob(8))
					M.reagents.add_reagent("porktonium", 5)
				..(M)

				return

		fooddrink/badgrease
			name = "partially hydrogenated space-soybean oil"
			id = "badgrease"
			description = "An oil derived from extra-terrestrial soybeans, with additional hydrogen atoms added to convert it into a saturated form."
			fluid_r = 220
			fluid_g = 220
			fluid_b = 220
			transparency = 175
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.nutrition++
				if(prob(15))
					M.reagents.add_reagent("cholesterol", rand(1,3))
				if(prob(8))
					M.reagents.add_reagent("porktonium", 5)

				if (holder.has_reagent(src.id,75))
					depletion_rate = 0.4
					if (prob(33))
						boutput(M, "<span style=\"color:red\">You feel horribly weak.</span>")
					if (prob(10))
						boutput(M, "<span style=\"color:red\">You cannot breathe!</span>")
						M.take_oxygen_deprivation(5)
					if (prob(5))
						boutput(M, "<span style=\"color:red\">You feel a sharp pain in your chest!</span>")
						M.take_oxygen_deprivation(25)
						M.stunned += 5
						M.paralysis = max(M.paralysis, 10)
					M.updatehealth()
				else
					depletion_rate = 0.2
				..(M)

				return

		fooddrink/cornstarch
			name = "corn starch"
			id = "cornstarch"
			description = "The powdered starch of maize, derived from the kernel's endosperm. Used as a thickener for gravies and puddings."
			reagent_state = SOLID
			fluid_r = 240
			fluid_g = 240
			fluid_b = 240
			transparency = 255

		fooddrink/cornsyrup
			name = "corn syrup"
			id = "cornsyrup"
			description = "A sweet syrup derived from corn starch that has had its starches converted into maltose and other sugars."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 240
			fluid_b = 240
			transparency = 100

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.reagents.add_reagent("sugar", 1.2)
				..(M)

		fooddrink/VHFCS
			name = "very-high-fructose corn syrup"
			id = "VHFCS"
			description = "An incredibly sweet syrup, created from corn syrup treated with enzymes to convert its sugars into fructose."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 240
			fluid_b = 240
			transparency = 100

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.reagents.add_reagent("sugar", 2.4)
				..(M)

		fooddrink/gravy
			name = "gravy"
			id = "gravy"
			description = "A savory sauce made from a simple meat-dripping roux and milk."
			reagent_state = LIQUID
			fluid_r = 182
			fluid_g = 100
			fluid_b = 26
			transparency = 250

		fooddrink/mashedpotatoes
			name = "mashed potatoes"
			id = "mashedpotatoes"
			description = "A starchy food paste made from boiled potatoes."
			reagent_state = SOLID
			fluid_r = 214
			fluid_g = 217
			fluid_b = 193
			transparency = 255

		fooddrink/msg
			name = "monosodium glutamate"
			id = "msg"
			description = "Monosodium Glutamate is a sodium salt known chiefly for its use as a controversial flavor enhancer."
			fluid_r = 245
			fluid_g = 245
			fluid_b = 245
			transparency = 255
			depletion_rate = 0.2


			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return
				if(method == INGEST)
					boutput(M, "<span style=\"color:orange\">That tasted amazing!</span>")

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(ishuman(M) && ((M.bioHolder.bloodType != "A+") || prob(5)))
					if (prob(10))
						M.take_toxin_damage(rand(2.4))
						M.updatehealth()
					if (prob(7))
						boutput(M, "<span style=\"color:red\">A horrible migraine overpowers you.</span>")
						M.stunned += rand(2,5)
				..(M)

		fooddrink/egg
			name = "egg"
			id = "egg"
			description = "A runny and viscous mixture of clear and yellow fluids."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 220
			fluid_b = 0
			transparency = 225
			pathogen_nutrition = list("water", "sugar", "sodium", "iron", "nitrogen")

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.nutrition++

				if(prob(8))
					M.emote("fart")

				if(prob(3))
					M.reagents.add_reagent("cholesterol", rand(1,2))
				..(M)

		fooddrink/beff
			name = "beff"
			id = "beff"
			description = "An advanced blend of mechanically-recovered meat and textured synthesized protein product notable for its unusual crystalline grain when sliced."
			reagent_state = SOLID
			fluid_r = 172
			fluid_g = 126
			fluid_b = 103
			transparency = 255

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(prob(5))
					M.reagents.add_reagent("cholesterol", rand(1,3))
				if(prob(8))
					M.reagents.add_reagent(pick("badgrease","toxic_slurry","synthflesh","bloodc","cornsyrup","porktonium"), depletion_rate*2)
				else if (prob(6))
					boutput(M, "<span style=\"color:red\">[pick("You feel ill.","Your stomach churns.","You feel queasy.","You feel sick.")]</span>")
					M.emote(pick("groan","moan"))
				..(M)

		fooddrink/enriched_msg //Hukhukhuk brings you another culinary war crime
			name = "Enriched MSG"
			id = "enriched_msg"
			description = "This highly illegal substance was only rumored to exist, it is the most flavorful substance known. It is believed that it causes such euphoria that the body begins to heal its own wounds, however no living creature can resist having seconds."
			reagent_state = SOLID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			addiction_prob = 100
			overdose = 25


			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return
				if(method == INGEST)
					var/datum/ailment/addiction/AD = M.addicted_to_reagent(src)
					if(!AD)
						boutput(M, "<B>THIS TASTES <font size=\"92\">~<font color=\"#FF0000\"> A<font color=\"#FF9900\"> M<font color=\"#FFff00\"> A<font color=\"#00FF00\"> Z<font color=\"#0000FF\"> I<font color=\"#FF00FF\"> N<font color=\"#660066\"> G<font color=\"#000000\"> ~ !</font></B>")

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				if(M.get_oxygen_deprivation())
					M.take_oxygen_deprivation(-1)
				if(M.get_toxin_damage())
					M.take_toxin_damage(-1)
				if(M:losebreath)
					M:losebreath--
				M:HealDamage("All", 3, 3)
				M:updatehealth()
				M:UpdateDamageIcon()
				..(M)
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1) //lesser
					M.stuttering += 1
					if(effect <= 1)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> suddenly starts salivating.</span>")
						M.emote("drool")
						M.change_misstep_chance(10)
						M.weakened = max(2, M.weakened)
					else if(effect <= 3)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> begins to reminisce about food.</span>")
						M.stunned = max(2, M.stunned)
					else if(effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> pouts and sniffles a bit.</span>")
					else if(effect <= 7)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> shakes uncontrollably.</span>")
						M.make_jittery(30)
				else if (severity == 2) // greater
					if(effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> enters a food coma!</span>")
						M.emote("faint")
						M.paralysis = max(4, M.paralysis)
					else if(effect <= 5)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> wants more delicious food!</span>")
						M.emote("scream")
						M.stunned = max(4, M.stunned)
					else if(effect <= 8)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> appears extremely depressed.</span>")
						M.emote("moan")
						M.change_misstep_chance(25)
						M.weakened = max(6, M.weakened)

		fooddrink/pepperoni //Hukhukhuk presents. pepperoni and acetone
			name = "pepperoni"
			id = "pepperoni"
			description = "An Italian-American variety of salami usually made from beef and pork"
			reagent_state = SOLID
			fluid_r = 172
			fluid_g = 126
			fluid_b = 103
			transparency = 255

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.wear_mask)
							boutput(M, "<span style=\"color:red\">The pepperoni bounces off your [H.wear_mask]!</span>")
							return
						if(H.head)
							boutput(M, "<span style=\"color:red\">Your [H.head] protects you from the errant pepperoni!</span>")
							return

					if(prob(50))
						M.emote("burp")
						boutput(M, "<span style=\"color:red\">My goodness, that was tasty!</span>")
					else
						boutput(M, "<span style=\"color:red\">A slice of pepperoni slaps you!</span>")
						playsound(M.loc, "sound/weapons/slap.ogg", 50, 1)
						M.TakeDamage("head", 1, 0, 0, DAMAGE_BLUNT)

		fooddrink/juice_lime
			name = "lime juice"
			id = "juice_lime"
			fluid_r = 33
			fluid_g = 248
			fluid_b = 66
			description = "A citric beverage extracted from limes."
			reagent_state = LIQUID
			thirst_value = 1.5

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.wear_mask) return
						if(H.head) return
					if(prob(75))
						M.emote("gasp")
						boutput(M, "<span style=\"color:red\">Your eyes sting!</span>")
						M.change_eye_blurry(rand(5, 20))

		fooddrink/juice_cran
			name = "Cranberry juice"
			id = "juice_cran"
			fluid_r = 255
			fluid_g = 0
			fluid_b = 0
			description = "An extremely tart juice usually mixed into other drinks and juices."
			reagent_state = LIQUID
			thirst_value = 1.5

		fooddrink/juice_orange
			name = "orange juice"
			id = "juice_orange"
			fluid_r = 252
			fluid_g = 163
			fluid_b = 30
			description = "A citric beverage extracted from oranges."
			reagent_state = LIQUID
			thirst_value = 1.5

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.wear_mask) return
						if(H.head) return
					if(prob(75))
						M.emote("gasp")
						boutput(M, "<span style=\"color:red\">Your eyes sting!</span>")
						M.change_eye_blurry(rand(5, 20))

		fooddrink/juice_lemon
			name = "lemon juice"
			id = "juice_lemon"
			fluid_r = 251
			fluid_g = 229
			fluid_b = 30
			description = "A citric beverage extracted from lemons."
			reagent_state = LIQUID
			thirst_value = 1.5

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.wear_mask) return
						if(H.head) return
					if(prob(75))
						M.emote("gasp")
						boutput(M, "<span style=\"color:red\">Your eyes sting!</span>")
						M.change_eye_blurry(rand(5, 20))

		fooddrink/juice_tomato
			name = "tomato juice"
			id = "juice_tomato"
			fluid_r = 255
			fluid_g = 0
			fluid_b = 0
			description = "Tomatoes pureed down to a liquid state."
			reagent_state = LIQUID
			thirst_value = 1.5

		fooddrink/juice_strawberry
			name = "strawberry juice"
			id = "juice_strawberry"
			fluid_r = 195
			fluid_g = 21
			fluid_b = 15
			description = "Fresh juice produced by strawberries."
			reagent_state = LIQUID
			thirst_value = 1.5

		fooddrink/juice_cherry
			name = "cherry juice"
			id = "juice_cherry"
			fluid_r = 235
			fluid_g = 0
			fluid_b = 0
			description = "The juice from a thousand screaming cherries.  Silent screams."
			reagent_state = LIQUID
			thirst_value = 1.5

		fooddrink/juice_pinapple
			name = "pineapple juice"
			id = "juice_pineapple"
			fluid_r = 255
			fluid_g = 249
			fluid_b = 71
			description = "Juice from a pineapple. A surprise, considering the name!"
			reagent_state = LIQUID
			thirst_value = 1.5

		fooddrink/coconut_milk
			name = "coconut milk"
			id = "coconut_milk"
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			description = "Well, it's not actually milk, considering that coconuts aren't mammals with mammary glands. It's really more like coconut juice. Or coconut water."
			reagent_state = LIQUID
			thirst_value = 1

		fooddrink/juice_pickle
			name = "pickle juice"
			id = "juice_pickle"
			fluid_r = 10
			fluid_g = 235
			fluid_b = 10
			transparency = 150
			description = "A salty brine containing garlic and dill, typically used to ferment and pickle cucumbers."
			reagent_state = LIQUID
			thirst_value = 1

		fooddrink/cocktail_citrus
			name = "triple citrus"
			id = "cocktail_citrus"
			description = "A refreshing mixed drink of orange, lemon and lime juice."
			reagent_state = LIQUID
			thirst_value = 2

			fluid_r = 12
			fluid_g = 229
			fluid_b = 72
			reaction_mob(var/mob/M, var/method=INGEST, var/volume)
				if(method == INGEST)
					if (M.get_toxin_damage())
						M.take_toxin_damage(rand(1,2) * -1) //I assume this was not supposed to be poison.
						M.updatehealth()

		fooddrink/lemonade
			name = "lemonade"
			id = "lemonade"
			fluid_r = 237
			fluid_g = 218
			fluid_b = 44
			transparency = 150
			description = "A refreshing, sweet and sour drink consisting of sugar and lemon juice."
			reagent_state = LIQUID
			thirst_value = 2

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if(method == TOUCH)
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.wear_mask) return
						if(H.head) return
					if(prob(75))
						M.emote("gasp")
						boutput(M, "<span style=\"color:red\">Your eyes sting!</span>")
						M.change_eye_blurry(rand(2, 10))
				else if (method == INGEST)
					if (prob(60) && (holder && holder.get_reagent_amount("sugar") < (volume/3)))
						M.visible_message("<b>[M]'s</b> mouth puckers!","<span style=\"color:red\">Yow! Sour!</span>")

		fooddrink/halfandhalf
			name = "half and half"
			id = "halfandhalf"
			reagent_state = LIQUID
			fluid_r = 142
			fluid_g = 115
			fluid_b = 51
			transparency = 200
			description = "A mixture of half lemonade and half tea, sometimes named after a dead Earth golfer. Not to be confused with the dairy kind."
			thirst_value = 2

		fooddrink/swedium
			name = "swedium"
			id = "swedium"
			description = "A rather neutral substance."
			fluid_r = 0
			fluid_g = 0
			fluid_b = 0
			transparency = 20

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M
				//if(method == INGEST)
				//drsingh commented method check to make this stuff work in smoke. because it's funny.
				M.bioHolder.AddEffect("accent_swedish", timeleft = 180)

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.bioHolder.AddEffect("accent_swedish", timeleft = 180)
				..(M)
				return

		fooddrink/essenceofelvis
			name = "essence of Elvis"
			id = "essenceofelvis"
			description = "The King is dead, but a part of him lives on in all of us."
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 60

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M
				//if(method == INGEST)
				//drsingh commented method check to make this stuff work in smoke. because it's funny.
				M.bioHolder.AddEffect("accent_elvis", timeleft = 180)

			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.bioHolder.AddEffect("accent_elvis", timeleft = 180)
				..(M)
				return

		fooddrink/yuck
			name = "????"
			id = "yuck"
			description = "A gross and unidentifiable substance."
			fluid_r = 10
			fluid_g = 220
			fluid_b = 10

			reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume_passed)
				src = null
				if(!volume_passed)
					return
				if(!ishuman(M))
					return

				//var/mob/living/carbon/human/H = M
				if(method == INGEST)
					boutput(M, "<span style=\"color:red\">Ugh! Eating that was a terrible idea!</span>")
					M.stunned += 2
					M.weakened += 2
					M.contract_disease(/datum/ailment/disease/food_poisoning, null, null, 1) // path, name, strain, bypass resist

		fooddrink/fakecheese
			name = "cheese substitute"
			id = "fakecheese"
			description = "A cheese-like substance derived loosely from actual cheese."
			fluid_r = 255
			fluid_b = 50
			fluid_g = 255
			addiction_prob = 10
			overdose = 50

			do_overdose(var/severity, var/mob/M)
				if(!M) M = holder.my_atom

				if (prob(8))
					boutput(M, "<span style=\"color:red\">You feel something squirming in your stomach. Your thoughts turn to cheese and you begin to sweat.</span>")
					M.take_toxin_damage(rand(1,2))
					M.updatehealth()

				return

		fooddrink/ghostchilijuice
			name = "ghost chili juice"
			id = "ghostchilijuice"
			description = "Juice from the universe's hottest chilli. Do not consume."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 127
			fluid_b = 50
			transparency = 255
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				//If the user drinks milk, they'll be fine.
				if(M.reagents.has_reagent("milk"))
					boutput(M, "<span style=\"color:orange\">The milk stops the burning. Ahhh.</span>")
					M.reagents.del_reagent("milk")
					M.reagents.del_reagent("ghostchilijuice")
				if(prob(8))
					boutput(M, "<span style=\"color:red\"><b>Oh god! Oh GODD!!</b></span>")
				if(prob(50))
					boutput(M, "<span style=\"color:red\">Your throat burns furiously!</span>")
					M.emote(pick("scream","cry","choke","gasp"))
					M.stunned++
				if(prob(8))
					boutput(M, "<span style=\"color:red\">Why!? WHY!?</span>")
				if(prob(8))
					boutput(M, "<span style=\"color:red\">ARGHHHH!</span>")
				if(prob(33))
					M.visible_message("<span style=\"color:red\">[M] suddenly and violently vomits!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
					boutput(M, "<span style=\"color:orange\">Thank goodness. You're not sure how long you could have held out with heat that intense!</span>")
					M.reagents.del_reagent("ghostchilijuice")
				if(prob(10))
					boutput(M, "<span style=\"color:red\"><b>OH GOD OH GOD PLEASE NO!!</b></span>")
					var/mob/living/L = M
					if(istype(L) && L.burning)
						L.set_burning(99)
					if(prob(50))
						spawn(20)
							//Roast up the player
							if (M)
								boutput(M, "<span style=\"color:red\"><b>IT BURNS!!!!</b></span>")
								sleep(2)
								M.visible_message("<span style=\"color:red\">[M] is consumed in flames!</span>")
								M.firegib()
				..(M)