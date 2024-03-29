//Contains reagents that are poisons or otherwise intended to be harmful
datum
	reagent
		harmful/
			name = "dangerous stuff"

		harmful/simple_damage_toxin
			name = "toxin precursor"
			id = "simple_damage_toxin"
			var/damage_factor = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.take_toxin_damage(damage_factor)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison", 3 * damage_factor)

			nitrogen_dioxide
				name = "nitrogen dioxide"
				id = "nitrogen_dioxide"
				description = "A common, mildly toxic pollutant."
				reagent_state = GAS
				fluid_r = 128
				fluid_g = 32
				fluid_b = 32
				transparency = 120
				penetrates_skin = 1

		harmful/simple_damage_burn
			name = "irritant precursor"
			id = "simple_damage_burn"
			var/damage_factor = 1
			on_mob_life(var/mob/M)
				if(!M) M = holder.my_atom
				M.TakeDamage("chest", 0, damage_factor, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison", 3 * damage_factor)

			allyl_chloride
				name = "allyl chloride"
				id = "allyl_chloride"
				description = "A toxic intermediary substance."
				reagent_state = LIQUID
				fluid_r = 220
				fluid_g = 220
				fluid_b = 255
				transparency = 128
				damage_factor = 1.5

		harmful/acid // COGWERKS CHEM REVISION PROJECT. give this a reaction and remove it from the dispenser machine, hydrogen (2) + sulfur (1) + oxygen (4)
			name = "sulphuric acid"
			id = "acid"
			description = "A strong mineral acid with the molecular formula H2SO4."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 255
			fluid_b = 50
			transparency = 20
			blob_damage = 1
			value = 3 // 1c + 1c + 1c

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				//M.take_toxin_damage(1)
				M.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if (method == TOUCH)
					if (volume > 25)
						if (istype(M, /mob/living/carbon/human))
							var/mob/living/carbon/human/H = M
							if (H.wear_mask)
								boutput(M, "<span style=\"color:red\">Your mask protects you from the acid!</span>")
								return
							if (H.head)
								boutput(M, "<span style=\"color:red\">Your helmet protects you from the acid!</span>")
								return

						if (prob(75))
							M.TakeDamage("head", 5, 10, 0, DAMAGE_BURN)
							M.emote("scream")
							boutput(M, "<span style=\"color:red\">Your face has become disfigured!</span>")
							M.real_name = "Unknown"
							M.unlock_medal("Red Hood", 1)
						else
							M.TakeDamage("All", 5, 10, 0, DAMAGE_BURN)
					else
						M.TakeDamage("All", 5, 10, 0, DAMAGE_BURN)
				else
					boutput(M, "<span style=\"color:red\">The greenish acidic substance stings[volume < 10 ? " you, but isn't concentrated enough to harm you" : null]!</span>")
					if (volume >= 10)
						M.TakeDamage("All", 0, min(max(4, (volume - 10) * 2), 20), 0, DAMAGE_BURN)
						M.emote("scream")

			reaction_obj(var/obj/O, var/volume)
				if (istype(O,/obj/item) && prob(40))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in AIviewers(5, O))
						boutput(M, "<span style=\"color:red\">\the [O] melts.</span>")
					qdel(O)

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("acid",5)
				P.growth -= 3

			reaction_blob(var/obj/blob/B, var/volume)
				if (!blob_damage)
					return
				B.take_damage(blob_damage, volume, "mixed")

		harmful/acid/clacid
			name = "hydrochloric acid"
			id = "clacid"
			description = "A strong acid with the molecular formula HCl."
			fluid_r = 0
			fluid_g = 200
			fluid_b = 255
			blob_damage = 1.2

		harmful/acid/nitric_acid
			name = "nitric acid"
			id = "nitric_acid"
			description = "A strong acid."
			fluid_r = 0
			fluid_g = 200
			fluid_b = 255
			blob_damage = 0.7

		harmful/acetic_acid
			name = "acetic acid"
			id = "acetic_acid"
			description = "A weak acid that is the main component of vinegar and bad hangovers."
			fluid_r = 0
			fluid_g = 128
			fluid_b = 255
			transparency = 64
			reagent_state = LIQUID
			blob_damage = 0.2

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if (method == TOUCH)
					if (volume >= 50 && prob(75))
						M.TakeDamage("head", 5, 15, 0, DAMAGE_BURN)
						M.emote("scream")
						boutput(M, "<span style=\"color:red\">Your face has become disfigured!</span>")
						M.real_name = "Unknown"
						M.unlock_medal("Red Hood", 1)
					else
						random_brute_damage(M, 5)
				else
					boutput(M, "<span style=\"color:red\">The transparent acidic substance stings[volume < 25 ? " you, but isn't concentrated enough to harm you" : null]!</span>")
					if (volume >= 25)
						random_brute_damage(M, 2)
						M.emote("scream")

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("acid", 1)

			reaction_blob(var/obj/blob/B, var/volume)
				if (!blob_damage)
					return
				B.take_damage(blob_damage, volume, "mixed")

		harmful/amanitin
			name = "amanitin"
			id = "amanitin"
			description = "A toxin produced by certain mushrooms. Very deadly."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 50
			var/damage_counter = 0

			pooled()
				..()
				damage_counter = 0

			on_mob_life(var/mob/M)

				if (!M) M = holder.my_atom
				if (src.volume <= src.depletion_rate)
					M.take_toxin_damage(damage_counter * rand(2,4))
					M.updatehealth()
				else
					damage_counter++
				..(M)

		harmful/coniine
			name = "coniine" // big brother to cyanide, very strong
			id = "coniine"
			description = "A neurotoxin that rapidly causes respiratory failure."
			reagent_state = LIQUID
			fluid_r = 125
			fluid_g = 195
			fluid_b = 160
			transparency = 80
			depletion_rate = 0.05

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(2)
				M.losebreath+=5
				M.updatehealth()
				..(M)
				return

		harmful/cyanide
			name = "cyanide"
			id = "cyanide"
			fluid_r = 0
			fluid_b = 180
			fluid_g = 25
			transparency = 10
			description = "A highly toxic chemical with some uses as a building block for other things."
			reagent_state = LIQUID
			transparency = 0
			depletion_rate = 0.1
			penetrates_skin = 1
			blob_damage = 5
			value = 7 // 3 2 1 heat

			on_mob_life(var/mob/M) // -cogwerks. previous version
				if (!M) M = holder.my_atom
				M.take_toxin_damage(1.5)
				if (prob(8))
					M.emote("drool")
				if (prob(10))
					boutput(M, "<span style=\"color:red\">You cannot breathe!</span>")
					M.losebreath++
					M.emote("gasp")
				if (prob(8))
					boutput(M, "<span style=\"color:red\">You feel horribly weak.</span>")
					M.stunned +=2
					M.take_toxin_damage(2)
				M.updatehealth()
				..(M)
				return


		harmful/curare
			name = "curare"
			id = "curare"
			description = "A highly dangerous paralytic poison."
			fluid_r = 25
			fluid_g = 25
			fluid_b = 25
			reagent_state = SOLID
			transparency = 255
			depletion_rate = 0.1
			var/counter = 1
			penetrates_skin = 1

			pooled()
				..()
				counter = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				M.take_toxin_damage(1)
				M.take_oxygen_deprivation(1)
				M.updatehealth()
				switch(counter++)
					if (1 to 5)
						if (prob(20) && !M.stat)
							M.emote(pick("drool", "pale", "gasp"))
					if (6 to 10)
						M.change_eye_blurry(5, 5)
						if (prob(8))
							boutput(M, "<span style=\"color:red\"><b>You feel [pick("weak", "horribly weak", "numb", "like you can barely move", "tingly")].</b></span>")
							M.stunned++
						else if (prob(8))
							M.emote(pick("drool","pale", "gasp"))
					if (11 to INFINITY)
						M.stunned = max(M.stunned, 30)
						M.drowsyness  = max(M.drowsyness, 20)
						if (prob(20) && !M.stat)
							M.emote(pick("drool", "faint", "pale", "gasp", "collapse"))
						else if (prob(8))
							boutput(M, "<span style=\"color:red\"><b>You can't [pick("breathe", "move", "feel your legs", "feel your face", "feel anything")]!</b></span>")
							M.losebreath++

				..(M)
				return

		harmful/formaldehyde
			name = "embalming fluid"
			id = "formaldehyde"
			description = "Formaldehyde is a common industrial chemical and is used to preserve corpses and medical samples. It is highly toxic and irritating. Casualdehyde is the less invasive form of this chemical."
			reagent_state = LIQUID
			fluid_r = 180
			fluid_b = 0
			fluid_g = 75
			transparency = 20
			penetrates_skin = 1
			value = 4 // 1 1 1 heat

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(1)
				M.updatehealth()
				if (prob(10))
					M.reagents.add_reagent("histamine", rand(5,15))
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",4)

		harmful/acetaldehyde
			name = "acetaldehyde"
			id = "acetaldehyde"
			description = "Acetaldehyde is a common industrial chemical. It is a severe irritant."
			reagent_state = LIQUID
			fluid_r = 180
			fluid_b = 0
			fluid_g = 75
			transparency = 20
			penetrates_skin = 1
			value = 4

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.TakeDamage("All", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",4)

		harmful/lipolicide
			name = "lipolicide"
			id = "lipolicide"
			description = "A compound found in many seedy dollar stores in the form of a weight-loss tonic."
			fluid_r = 240
			fluid_g = 255
			fluid_b = 240
			transparency = 215
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				// Used to do exactly this back in 2012 or so (Convair880).
				if (prob(10) && M.bioHolder && M.bioHolder.HasEffect("fat"))
					M.bioHolder.RemoveEffect("fat")

				if (!M.nutrition)
					switch(rand(1,3))
						if (1)
							boutput(M, "<span style=\"color:red\">You feel hungry...</span>")
						if (2)
							M.take_toxin_damage(1)
							M.updatehealth()
							boutput(M, "<span style=\"color:red\">Your stomach grumbles painfully!</span>")

				else
					if (prob(60))
						var/fat_to_burn = max(round(M.nutrition/100,1), 5)
						M.nutrition = max(M.nutrition-fat_to_burn,0)
				..(M)
				return

			reaction_blob(var/obj/blob/B, var/volume)
				if (istype(B, /obj/blob/lipid))
					B.take_damage(B.health_max, 2, "chaos")

/*		harmful/initropidril
			name = "initropidril"
			id = "initropidril"
			description = "A highly potent cardiac poison - can kill within minutes."
			reagent_state = LIQUID
			fluid_r = 127
			fluid_g = 16
			fluid_b = 192
			transparency = 255
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_regen"))
					remove_buff = holder.my_atom:add_stam_mod_regen("consumable_good", 33) //lol @ consumable_good, yeah right
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_regen"))
						holder.my_atom:remove_stam_mod_regen("consumable_good")
				return

			on_mob_life(var/mob/living/M)

				if (!M) M = holder.my_atom
				if (prob(33))
					M.take_toxin_damage(rand(5,25))
				if (prob(33))
					boutput(M, "<span style=\"color:red\">You feel horribly weak.</span>")
					M.stunned += 2
				if (prob(10))
					boutput(M, "<span style=\"color:red\">You cannot breathe!</span>")
					M.take_oxygen_deprivation(10)
					M.losebreath++
				if (prob(10))
					boutput(M, "<span style=\"color:red\">Your chest is burning with pain!</span>")
					M.take_oxygen_deprivation(10)
					M.losebreath++
					M.stunned += 3
					M.weakened += 2
					M.contract_disease(/datum/ailment/disease/flatline, null, null, 1) // path, name, strain, bypass resist
				M.updatehealth()
				..(M)

		harmful/initrobeedril_old
			name = "old initrobeedril"
			id = "initrobeedril_old"
			description = "A highly experimental poison originally created by a mad scientist by the name of \"SpyGuy\" on earth in 2014."
			reagent_state = LIQUID
			fluid_r = 127
			fluid_g = 190
			fluid_b = 5
			transparency = 255
			depletion_rate = 0.1 //per 3 sec

			on_mob_life(var/mob/living/M)
				if (!M) M = holder.my_atom

				if (!data) data = 1
				else data++

				var/col = min(data * 5, 255)
				M.color = rgb(255, 255, 255 - col)
				M.take_toxin_damage(1)

				switch(data)
					if (1 to 8)
						if (prob(33))
							boutput(M, "<span style=\"color:red\">You feel weak.</span>")
							M.stunned += 1
					if (9 to 30)
						if (prob(33))
							boutput(M, "<span style=\"color:red\"><I>You feel very weak.</I></span>")
							M.stunned += 2
						if (prob(10))
							boutput(M, "<span style=\"color:red\"><I>You have trouble breathing!</I></span>")
							M.take_oxygen_deprivation(2)
							M.losebreath++
					if (31 to 50)
						if (prob(33))
							boutput(M, "<span style=\"color:red\"><B>You feel horribly weak.</B></span>")
							M.stunned += 3
						if (prob(10))
							boutput(M, "<span style=\"color:red\"><B>You cannot breathe!</B></span>")
							M.take_oxygen_deprivation(2)
							M.losebreath++
						if (prob(10))
							boutput(M, "<span style=\"color:red\"><B>Your heart flutters in your chest!</B></span>")
							M.take_oxygen_deprivation(5)
							M.losebreath++
							M.stunned += 3
							M.weakened += 2
					if (51 to INFINITY) //everything after
						var/obj/critter/domestic_bee/B = new/obj/critter/domestic_bee(M.loc)
						B.name = M.real_name
						B.desc = "This bee looks very much like [M.real_name]. How peculiar."
						B.beeKid = "#ffdddd"
						B.update_icon()
						M.gib()
				M.updatehealth()
				..(M)

			on_remove()
				if (holder.my_atom)
					holder.my_atom.color = "#ffffff"
				return ..()

		harmful/initrobeedril // an attempt to tie noheart to this as per SpyGuy's request
			name = "initrobeedril"
			id = "initrobeedril"
			description = "A highly experimental poison originally created by a mad scientist by the name of \"SpyGuy\" on earth in 2014."
			reagent_state = LIQUID
			fluid_r = 127
			fluid_g = 190
			fluid_b = 5
			transparency = 255
			depletion_rate = 0.2

			on_mob_life(var/mob/living/M)
				if (!M) M = holder.my_atom

				if (!data) data = 1
				else data++

				var/col = min(data * 5, 255)
				M.color = rgb(255, 255, 255 - col)
				M.take_toxin_damage(1)

				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.organHolder && H.organHolder.heart) // you can't barf up a bee heart if you ain't got no heart to barf
						switch (data)
							if (1 to 4)
								if (prob(33))
									boutput(H, "<span style=\"color:red\">You feel weak.</span>")
									H.stunned += 1
							if (5 to 15)
								if (prob(33))
									boutput(H, "<span style=\"color:red\"><I>You feel very weak.</I></span>")
									H.stunned += 2
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><I>You have trouble breathing!</I></span>")
									H.take_oxygen_deprivation(2)
									H.losebreath++
							if (16 to 25)
								if (prob(33))
									boutput(H, "<span style=\"color:red\"><B>You feel horribly weak.</B></span>")
									H.stunned += 3
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><B>You cannot breathe!</B></span>")
									H.take_oxygen_deprivation(2)
									H.losebreath++
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><B>Your heart flutters in your chest!</B></span>")
									H.take_oxygen_deprivation(5)
									H.losebreath++
									H.stunned += 3
									H.weakened += 2
							if (26 to INFINITY)

								var/obj/critter/domestic_bee/B

								if (H.organHolder.heart.robotic)
									B = new/obj/critter/domestic_bee/buddy(H.loc)
									H.remove_stam_mod_regen("heart")
									H.remove_stam_mod_max("heart")

								else
									B = new/obj/critter/domestic_bee(H.loc)

								B.name = "[H.real_name]'s heart"
								B.desc = "[H.real_name]'s heart is flying off. Better catch it quick!"
								B.beeMom = H
								B.beeKid = DEFAULT_BLOOD_COLOR
								B.update_icon()

								playsound(H.loc, "sound/effects/splat.ogg", 50, 1)
								take_bleeding_damage(H, null, rand(10,30), DAMAGE_STAB)
								H.visible_message("<span style=\"color:red\"><B>A bee bursts out of [H]'s chest! Oh fuck!</B></span>", \
								"<span style=\"color:red\"><b>A bee bursts out of your chest! OH FUCK!</b></span>")
								qdel(H.organHolder.heart)

						H.updatehealth()
				..(M)

			on_remove()
				if (holder.my_atom)
					holder.my_atom.color = "#ffffff"
				return ..()

		harmful/royal_initrobeedril // yep
			name = "royal initrobeedril"
			id = "royal_initrobeedril"
			description = "A highly experimental poison originally created by a mad scientist by the name of \"SpyGuy\" on earth in 2014."
			reagent_state = LIQUID
			fluid_r = 102
			fluid_g = 0
			fluid_b = 255
			transparency = 255
			depletion_rate = 0.2

			on_mob_life(var/mob/living/M)
				if (!M) M = holder.my_atom

				if (!data) data = 1
				else data++

				var/col = min(data * 5, 255)
				M.color = rgb(255, 255, 255 - col)
				M.take_toxin_damage(1)

				if (ishuman(M))
					var/mob/living/carbon/human/H = M
					if (H.organHolder && H.organHolder.heart) // you can't barf up a bee heart if you ain't got no heart to barf
						switch(data)
							if (1 to 4)
								if (prob(33))
									boutput(H, "<span style=\"color:red\">You feel weak.</span>")
									H.stunned += 1
							if (5 to 15)
								if (prob(33))
									boutput(H, "<span style=\"color:red\"><I>You feel very weak.</I></span>")
									H.stunned += 2
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><I>You have trouble breathing!</I></span>")
									H.take_oxygen_deprivation(2)
									H.losebreath++
							if (16 to 25)
								if (prob(33))
									boutput(H, "<span style=\"color:red\"><B>You feel horribly weak.</B></span>")
									H.stunned += 3
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><B>You cannot breathe!</B></span>")
									H.take_oxygen_deprivation(2)
									H.losebreath++
								if (prob(10))
									boutput(H, "<span style=\"color:red\"><B>Your heart flutters in your chest!</B></span>")
									H.take_oxygen_deprivation(5)
									H.losebreath++
									H.stunned += 3
									H.weakened += 2
							if (26 to INFINITY)

								var/obj/critter/domestic_bee/queen/B

								if (H.organHolder.heart.robotic)
									B = new/obj/critter/domestic_bee/queen/buddy(H.loc)

								else if (prob(5))
									B = new/obj/critter/domestic_bee/queen/big(H.loc)

								else
									B = new/obj/critter/domestic_bee/queen(H.loc)

								B.name = "[H.real_name]'s heart"
								B.desc = "[H.real_name]'s heart is flying off. What kind of heart problems did they have!?"
								B.beeMom = H
								B.beeKid = DEFAULT_BLOOD_COLOR
								B.update_icon()

								playsound(H.loc, "sound/effects/splat.ogg", 50, 1)
								bleed(H, 500, 5) // you'll be gibbed in a moment you don't need it anyway
								H.visible_message("<span style=\"color:red\"><B>A huge bee bursts out of [H]! OH FUCK!</B></span>")
								H.gib()

						H.updatehealth()
				..(M)

			on_remove()
				if (holder.my_atom)
					holder.my_atom.color = "#ffffff"
				return ..()*/

		harmful/cholesterol
			name = "cholesterol"
			id = "cholesterol"
			description = "Pure cholesterol. Probably not very good for you."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 250
			fluid_b = 200
			transparency = 255
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_bad", -10)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_bad")
				return

			on_mob_life(var/mob/living/M)

				if (!M) M = holder.my_atom
				//if (prob(5)) // this is way too annoying and ruins fried foods
					//boutput(M, "<span style=\"color:red\">You feel [pick(</span>"weak","shaky","ill")]!")
					//M.stunned ++
				else if (holder.get_reagent_amount(src.id) >= 25 && prob(holder.get_reagent_amount(src.id)*0.15))
					boutput(M, "<span style=\"color:red\">Your chest feels [pick("weird","uncomfortable","nasty","gross","odd","unusual","warm")]!</span>")
					M.take_toxin_damage(rand(1,2))
				else if (holder.get_reagent_amount(src.id) >= 45 && prob(holder.get_reagent_amount(src.id)*0.08))
					boutput(M, "<span style=\"color:red\">Your chest [pick("hurts","stings","aches","burns")]!</span>")
					M.take_toxin_damage(rand(2,4))
					M.stunned ++
				else if (holder.get_reagent_amount(src.id) >= 150 && prob(holder.get_reagent_amount(src.id)*0.01))
					boutput(M, "<span style=\"color:red\">Your chest is burning with pain!</span>")
					//M.losebreath++ //heartfailure handles this just fine
					M.stunned++
					M.weakened++
					M.contract_disease(/datum/ailment/disease/heartfailure, null, null, 1) // path, name, strain, bypass resist
				M.updatehealth()
				..(M)

			reaction_blob(var/obj/blob/B, var/volume)
				if (B.type == /obj/blob)
					var/obj/blob/lipid/L = new /obj/blob/lipid(B.loc)
					L.setOvermind(B.overmind)
					qdel(B)

		harmful/itching
			name = "itching powder"
			id = "itching"
			description = "An abrasive powder beloved by cruel pranksters."
			reagent_state = SOLID
			fluid_r = 200
			fluid_g = 200
			fluid_b = 200
			transparency = 100
			depletion_rate = 0.3
			penetrates_skin = 1

			on_mob_life(var/mob/M) // commence the tickling
				if (!M) M = holder.my_atom
				if (prob(25)) M.emote(pick("twitch", "laugh", "sneeze", "cry"))
				if (prob(20))
					boutput(M, "<span style=\"color:orange\"><b>Something tickles!</b></span>")
					M.emote(pick("laugh", "giggle"))
				if (prob(15))
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> scratches at an itch.</span>")
					random_brute_damage(M, 1)
					M.stunned += rand(0,1)
					M.emote("grumble")
				if (prob(10))
					boutput(M, "<span style=\"color:red\"><b>So itchy!</b></span>")
					random_brute_damage(M, 2)
				if (prob(6))
					M.reagents.add_reagent("histamine", rand(1,3))
				if (prob(2))
					boutput(M, "<span style=\"color:red\"><b><font size='[rand(2,5)]'>AHHHHHH!</font></b></span>")
					random_brute_damage(M,5)
					M.weakened +=5
					M.make_jittery(6)
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> falls to the floor, scratching themselves violently!</span>")
					M.emote("scream")
				..(M)
				return

		harmful/pacid // COGWERKS CHEM REVISION PROJECT.. Change this to Fluorosulfuric Acid
			name = "fluorosulfuric acid"
			id = "pacid"
			description = "Fluorosulfuric acid is a an extremely corrosive super-acid."
			reagent_state = LIQUID
			fluid_r = 80
			fluid_g = 80
			fluid_b = 255
			transparency = 40
			dispersal = 1
			blob_damage = 4

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(1)
				M.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if (method == TOUCH)
					if (volume > 9)
						if (ishuman(M))
							var/mob/living/carbon/human/H = M
							var/melted = 0
							if (!H.wear_mask && !H.head)
								H.TakeDamage("head", 0, min(max(8, (volume - 5) * 4), 75), 0, DAMAGE_BURN)
								H.emote("scream")
								boutput(H, "<span style=\"color:red\">Your face has become disfigured!</span>")
								H.real_name = "Unknown"
								H.unlock_medal("Red Hood", 1)
								return
							else
								if (H.wear_mask)
									boutput(M, "<span style=\"color:red\">Your [H.wear_mask] melts away!</span>")
									H.u_equip(H.wear_mask)
									qdel(H.wear_mask)
									melted = 1
								if (H.head)
									boutput(M, "<span style=\"color:red\">Your [H.head] melts into uselessness!</span>")
									H.u_equip(H.head)
									qdel(H.head)
									melted = 1
								if (melted)
									return
						else
							random_brute_damage(M, 15)

				if (volume >= 5)
					M.emote("scream")
					M.TakeDamage("All", 0, min(max(8, (volume - 5) * 4), 75), 0, DAMAGE_BURN)
				boutput(M, "<span style=\"color:red\">The blueish acidic substance stings[volume < 5 ? " you, but isn't concentrated enough to harm you" : null]!</span>")
				return

			reaction_obj(var/obj/O, var/volume)
				if (istype(O,/obj/item))
					var/obj/decal/cleanable/molten_item/I = new/obj/decal/cleanable/molten_item(O.loc)
					I.desc = "Looks like this was \an [O] some time ago."
					for(var/mob/M in AIviewers(5, O))
						boutput(M, "<span style=\"color:red\">\the [O] melts.</span>")
					qdel(O)

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("acid",10)
				P.growth -= 5

			reaction_blob(var/obj/blob/B, var/volume)
				if (!blob_damage)
					return
				B.take_damage(blob_damage, volume, "mixed")

		harmful/pancuronium
			name = "pancuronium"
			id = "pancuronium"
			description = "Pancuronium bromide is a powerful skeletal muscle relaxant."
			reagent_state = LIQUID
			fluid_r = 45
			fluid_g = 80
			fluid_b = 150
			transparency = 50
			depletion_rate = 0.2
			var/counter = 1
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0
				counter = 1

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_bad", -20)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				switch(counter++)
					if (1 to 5)
						if (prob(10))
							M.emote(pick("drool", "tremble"))
					if (6 to 10)
						if (prob(8))
							boutput(M, "<span style=\"color:red\"><b>You feel [pick("weak", "horribly weak", "numb", "like you can barely move", "tingly")].</b></span>")
							M.stunned++
						else if (prob(8))
							M.emote(pick("drool", "tremble"))
					if (11 to INFINITY)
						M.stunned = max(M.stunned, 20)
						M.weakened = max(M.weakened, 20)
						if (prob(10))
							M.emote(pick("drool", "tremble", "gasp"))
							M.losebreath++
						if (prob(9))
							boutput(M, "<span style=\"color:red\"><b>You can't [pick("move", "feel your legs", "feel your face", "feel anything")]!</b></span>")
						if (prob(7))
							boutput(M, "<span style=\"color:red\"><b>You can't breathe!</b></span>")
							M.losebreath+=3
				..(M)
				return

		harmful/polonium
			name = "polonium"
			id = "polonium"
			description = "Polonium is a rare and highly radioactive silvery metal."
			reagent_state = SOLID
			fluid_r = 120
			fluid_g = 120
			fluid_b = 120
			transparency = 255
			depletion_rate = 0.1
			penetrates_skin = 1
			blob_damage = 3

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.irradiate(8,1)
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(80)) P.HYPdamageplant("radiation",5)
				if (prob(25)) P.HYPmutateplant(1)

		harmful/sodium_thiopental // COGWERKS CHEM REVISION PROJECT. idk some sort of potent opiate or sedative. chloral hydrate? ketamine
			name = "sodium thiopental"
			id = "sodium_thiopental"
			description = "An rapidly-acting barbituate tranquilizer."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 150
			fluid_b = 250
			transparency = 20
			depletion_rate = 0.7
			var/counter = 1
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0
				counter = 1

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_bad", -30)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1

				switch(counter++)
					if (1)
						M.emote("drool")
						M.change_misstep_chance(5)
					if (2 to 4)
						M.drowsyness = max(M.drowsyness, 20)
					if (5)
						M.emote("faint")
						M.weakened += 5
					if (6 to INFINITY)
						M.paralysis = max(M.paralysis, 20)

				M.jitteriness = max(M.jitteriness-50,0)

				if (prob(10))
					M.emote("drool")
					M.take_brain_damage(1)

				..(M)
				return

		harmful/sonambutril // COGWERKS CHEM REVISION PROJECT. ketamine
			name = "ketamine"
			id = "sonambutril"
			description = "A potent veterinary tranquilizer."
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 150
			fluid_b = 250
			transparency = 20
			depletion_rate = 0.8
			penetrates_skin = 1
			var/counter = 1
			var/remove_buff = 0

			pooled()
				..()
				remove_buff = 0
				counter = 1

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_bad", -20)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_bad")
				return

			on_mob_life(var/mob/M) // sped this up a bit due to mob loop changes
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				switch(counter++)
					if (1 to 5)
						if (prob(25)) M.emote("yawn")
					if (6 to 9)
						M.change_eye_blurry(10, 10)
						if (prob(35)) M.emote("yawn")
					if (10)
						M.emote("faint")
						M.weakened = max(M.weakened, 5)
					if (11 to INFINITY)
						M.paralysis = max(M.paralysis, 25)

				..(M)
				return

		harmful/sulfonal
			name = "sulfonal"
			id = "sulfonal"
			description = "An old sedative with toxic side-effects."
			reagent_state = LIQUID
			fluid_r = 125
			fluid_g = 195
			fluid_b = 160
			transparency = 80
			depletion_rate = 0.1
			var/counter = 1
			var/remove_buff = 0
			blob_damage = 2

			pooled()
				..()
				remove_buff = 0
				counter = 1

			on_add()
				if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"add_stam_mod_max"))
					remove_buff = holder.my_atom:add_stam_mod_max("consumable_bad", -10)
				return

			on_remove()
				if (remove_buff)
					if (istype(holder) && istype(holder.my_atom) && hascall(holder.my_atom,"remove_stam_mod_max"))
						holder.my_atom:remove_stam_mod_max("consumable_bad")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				M.jitteriness = max(M.jitteriness-30,0)

				switch(counter++)
					if (1 to 10)
						if (prob(7)) M.emote("yawn")
					if (11 to 20)
						M.drowsyness  = max(M.drowsyness, 20)
					if (21)
						M.emote("faint")
					if (22 to INFINITY)
						if (prob(20))
							M.emote("faint")
							M.paralysis = max(M.paralysis, 5)
						M.drowsyness  = max(M.drowsyness, 20)
				M.take_toxin_damage(1)
				M.updatehealth()
				..(M)
				return

		harmful/toxin
			name = "toxin"
			id = "toxin"
			description = "A Toxic chemical."
			reagent_state = LIQUID
			fluid_r = 25
			fluid_b = 0
			fluid_g = 25
			transparency = 20
			blob_damage = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(2)
				M.updatehealth()
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.HYPdamageplant("poison",1)

		harmful/spider_venom
			name = "venom"
			id = "venom"
			description = "An incredibly potent poison. Origin unknown."
			reagent_state = LIQUID
			fluid_r = 240
			fluid_g = 255
			fluid_b = 240
			transparency = 200
			depletion_rate = 0.2

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom

				var/our_amt = holder.get_reagent_amount(src.id)
				if (prob(25))
					M.reagents.add_reagent("histamine", rand(5,10))
				if (our_amt < 20)
					M.take_toxin_damage(1)
					random_brute_damage(M, 1)
					M.updatehealth()
				else if (our_amt < 40)
					if (prob(8))
						M.visible_message("<span style=\"color:red\">[M] pukes all over \himself.</span>", "<span style=\"color:red\">You puke all over yourself!</span>")
						playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(M.loc)
					M.take_toxin_damage(2)
					random_brute_damage(M, 2)
					M.updatehealth()

				if (our_amt > 40 && prob(4))
					M.visible_message("<span style=\"color:red\"><B>[M]</B> starts convulsing violently!</span>", "You feel as if your body is tearing itself apart!")
					M.weakened = max(15, M.weakened)
					M.make_jittery(1000)
					spawn(rand(20, 100))
						M.gib()
					return

				..(M)
				return

		harmful/neurotoxin // COGWERKS CHEM REVISION PROJECT. which neurotoxin?
			name = "neurotoxin"
			id = "neurotoxin"
			description = "A dangerous toxin that attacks the nervous system"
			reagent_state = LIQUID
			fluid_r = 100
			fluid_g = 145
			fluid_b = 110
			depletion_rate = 1
			var/counter = 1
			blob_damage = 1
			value = 4 // 3c + heat

			pooled()
				..()
				counter = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				if (!counter) counter = 1
				switch(counter++)
					if (1 to 4)
						return // let's not be incredibly obvious about who stung you for changelings
					if (5 to 8)
						M.make_dizzy(1)
						M.change_misstep_chance(10)
					if (9 to 12)
						M.drowsyness  = max(M.drowsyness, 10)
						M.make_dizzy(1)
						M.change_misstep_chance(20)
					if (13)
						M.emote("faint")
					if (14 to INFINITY)
						M.paralysis = max(M.paralysis, 10)
						M.drowsyness  = max(M.drowsyness, 20)

				M.jitteriness = max(M.jitteriness-30,0)
				if (M.get_brain_damage() <= 80)
					M.take_brain_damage(1)
				else
					if (prob(10)) M.take_brain_damage(1) // let's slow down a bit after 80
				if (prob(10)) M.emote("drool")
				M.take_toxin_damage(1)
				M.updatehealth()
				..(M)
				return

		harmful/mutagen // COGWERKS CHEM REVISION PROJECT. magic chemical, fine as is
			name = "unstable mutagen"
			id = "mutagen"
			description = "Might cause unpredictable mutations. Keep away from children."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 255
			fluid_b = 0
			transparency = 255
			depletion_rate = 0.3
			blob_damage = 1
			value = 3 // 1 1 1

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(33)) || method==INGEST)
					M.bioHolder.RandomEffect("bad")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.irradiate(2,1)
				var/mutChance = 4
				if (M.traitHolder && M.traitHolder.hasTrait("stablegenes")) mutChance = 2
				if (prob(mutChance))
					M.bioHolder.RandomEffect("bad")
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				/*if (prob(80)) P.growth -= rand(1,2)
				if (prob(16)) P.HYPmutateplant(1)*/
				if (prob(40) && P.growth > 1)
					P.growth--
				if (prob(24))
					P.HYPmutateplant(1)

		////////////// work in progress. new mutagen for omega slurrypods - cogwerks

		harmful/omega_mutagen
			name = "glowing slurry"
			id = "omega_mutagen"
			description = "This is probably not good for you."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 255
			fluid_b = 0
			transparency = 255

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				src = null
				if ( (method==TOUCH && prob(50)) || method==INGEST)
					M.bioHolder.RandomEffect("bad")
				return

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.irradiate(2,1)
				// DNA buckshot
				var/mutChance = 15
				if (M.traitHolder && M.traitHolder.hasTrait("stablegenes")) mutChance = 7
				if (prob(mutChance))
					M.bioHolder.RandomEffect("bad")
				if (prob(3))
					M.bioHolder.RandomEffect("good")
				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				P.growth -= rand(1,2)
				P.HYPmutateplant(1)

/*		harmful/formaldehyde/werewolf_serum_fake1
			name = "Werewolf Serum Precursor Alpha"
			id = "werewolf_part1"
			description = "A strange and poisonous lupine compound."
			reagent_state = LIQUID
			fluid_r = 149
			fluid_g = 172
			fluid_b = 147
			transparency = 150

		harmful/omega_mutagen/werewolf_serum_fake2
			name = "Werewolf Serum Precursor Beta"
			id = "werewolf_part2"
			description = "A potent and very unstable mutagenic substance."
			reagent_state = LIQUID
			fluid_r = 50
			fluid_g = 172
			fluid_b = 100
			transparency = 200

		harmful/fake_initropidril
			name = "initropidril"
			id = "fake_initropidril"
			description = "A highly potent toxin - can kill within minutes."
			reagent_state = LIQUID
			fluid_r = 127
			fluid_g = 16
			fluid_b = 192
			transparency = 220*/

		harmful/wolfsbane
			name = "Aconitum"
			id = "wolfsbane"
			description = "Also known as monkshood or wolfsbane, aconitum is a very potent neurotoxin."
			reagent_state = LIQUID
			fluid_r = 129
			fluid_b = 116
			fluid_g = 198
			transparency = 20

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.take_toxin_damage(2)
				if (prob(4))
					M.emote("drool")
				if (prob(8))
					boutput(M, "<span style=\"color:red\">You cannot breathe!</span>")
					M.losebreath++
					M.emote("gasp")
				if (prob(10))
					boutput(M, "<span style=\"color:red\">You feel horribly weak.</span>")
					M.stunned +=2
					M.take_toxin_damage(2)
				M.updatehealth()
				..(M)
				return

		harmful/toxic_slurry
			name = "toxic slurry"
			id = "toxic_slurry"
			description = "A filthy, carcinogenic sludge produced by the Slurrypod plant."
			reagent_state = LIQUID
			fluid_r = 0
			fluid_g = 200
			fluid_b = 30
			transparency = 255

			on_mob_life(var/mob/M)

				if (!M) M = holder.my_atom
				if (prob(10))
					M.take_toxin_damage(rand(2.4))
					M.updatehealth()
				if (prob(7))
					boutput(M, "<span style=\"color:red\">A horrible migraine overpowers you.</span>")
					M.stunned += rand(2,5)
				if (prob(7))
					for(var/mob/O in AIviewers(M, null))
						O.show_message("<span style=\"color:red\">[M] vomits up some green goo.</span>", 1)
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/greenpuke(M.loc)
				..(M)

		harmful/histamine
			name = "histamine" // cogwerks notes. allergic reaction tests (see. MSG) can metabolize this in the body for allergy simulation, if extracted and mass-produced, it's fairly lethal
			id = "histamine"
			description = "Immune-system neurotransmitter. If detected in blood, the subject is likely undergoing an allergic reaction."
			reagent_state = LIQUID
			fluid_r = 250
			fluid_g = 100
			fluid_b = 100
			transparency = 60
			depletion_rate = 0.2
			overdose = 40

			on_mob_life(var/mob/M) // allergies suck fyi
				if (!M) M = holder.my_atom
				if (prob(20)) M.emote(pick("twitch", "grumble", "sneeze", "cough"))
				if (prob(10))
					boutput(M, "<span style=\"color:orange\"><b>Your eyes itch.</b></span>")
					M.emote(pick("blink", "sneeze"))
					M.change_eye_blurry(3, 3)
				if (prob(10))
					M.visible_message("<span style=\"color:red\"><b>[M.name]</b> scratches at an itch.</span>")
					random_brute_damage(M, 1)
					M.emote("grumble")
				if (prob(5))
					boutput(M, "<span style=\"color:red\"><b>You're getting a rash!</b></span>")
					random_brute_damage(M, 2)
				..(M)
				return

			reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
				if (method == TOUCH)
					M.reagents.add_reagent("histamine", 10)
					M.make_jittery(10)
				else
					boutput(M, "<span style=\"color:red\"><b>You feel a burning sensation in your throat...</span>")
					M.make_jittery(30)
					M.emote(pick("drool"))
				return

			do_overdose(var/severity, var/mob/M)
				var/effect = ..(severity, M)
				if (severity == 1)
					if (effect <= 2)
						boutput(M, "<span style=\"color:red\"><b>You feel mucus running down the back of your throat.</b></span>")
						M.take_toxin_damage(1)
						M.updatehealth()
						M.make_jittery(4)
						M.emote("sneeze", "cough")
					else if (effect <= 4)
						M.stuttering += rand(0,5)
						if (prob(25))
							M.emote(pick("choke","gasp"))
							M.take_oxygen_deprivation(5)
					else if (effect <= 7)
						boutput(M, "<span style=\"color:red\"><b>Your chest hurts!</b></span>")
						M.emote(pick("cough","gasp"))
						M.take_oxygen_deprivation(3)
						M.updatehealth()
				else if (severity == 2)
					if (effect <= 2)
						M.visible_message("<span style=\"color:red\"><b>[M.name]<b> breaks out in hives!</span>")
						random_brute_damage(M, 6)
					else if (effect <= 4)
						M.visible_message("<span style=\"color:red\"><b>[M.name]</b> has a horrible coughing fit!</span>")
						M.make_jittery(10)
						M.stuttering += rand(0,5)
						M.emote("cough")
						if (prob(40))
							M.emote(pick("choke","gasp"))
							M.take_oxygen_deprivation(6)
						M.updatehealth()
						M.weakened += 8
					else if (effect <= 7)
						boutput(M, "<span style=\"color:red\"><b>Your heartbeat is pounding inside your head!</b></span>")
						M.playsound_local(M.loc, "heartbeat.ogg", 50, 1)
						M.emote("collapse")
						M.take_oxygen_deprivation(8)
						M.take_toxin_damage(3)
						M.updatehealth()
						M.weakened += 3
						M.emote(pick("choke", "gasp"))
						boutput(M, "<span style=\"color:red\"><b>You feel like you're dying!</b></span>")

		harmful/sarin // yet another thing that will put ol' cogwerks on a watch list probably
			name = "sarin"
			id = "sarin"
			description = "A lethal organophosphate nerve agent. Can be neutralized with atropine."
			reagent_state = LIQUID
			fluid_r = 255
			fluid_g = 255
			fluid_b = 255
			transparency = 255
			penetrates_skin = 1
			depletion_rate = 0.1
			overdose = 25
			var/counter = 1
			blob_damage = 5

			pooled()
				..()
				counter = 1

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				switch(counter++)
					if (1 to 15)
						M.make_jittery(20)
						if (prob(20))
							M.emote(pick("twitch","twitch_v","quiver"))
					if (16 to 30)
						if (prob(25))
							M.emote(pick("twitch","twitch_v","drool","quiver","tremble"))
						M.change_eye_blurry(5, 5)
						M.stuttering = max(M.stuttering, 5)
						if (prob(10))
							M.change_misstep_chance(15)
						if (prob(15))
							M.stunned++
							if (M.stat != 2)
								M.emote("scream")
					if (30 to 60)
						M.change_eye_blurry(5, 5)
						M.stuttering = max(M.stuttering, 5)
						if (prob(10))
							M.stunned++
							M.emote(pick("twitch","twitch_v","drool","shake","tremble"))
						if (prob(5))
							M.emote("collapse")
						if (prob(5))
							M.weakened = max(M.weakened, 3)
							M.visible_message("<span style=\"color:red\"><b>[M] has a seizure!</b></span>")
							M.make_jittery(1000)
						if (prob(5))
							boutput(M, "<span style=\"color:red\"><b>You can't breathe!</b></span>")
							M.emote(pick("gasp", "choke", "cough"))
							M.losebreath++
					if (61 to INFINITY)
						if (prob(15))
							M.emote(pick("gasp", "choke", "cough","twitch", "shake", "tremble","quiver","drool", "twitch_v","collapse"))
						M.losebreath = max(5, M.losebreath + 5)
						M.take_toxin_damage(1)
						M.take_brain_damage(1)
						M.weakened = max(M.weakened, 4)
				if (prob(8))
					M.visible_message("<span style=\"color:red\">[M] pukes all over \himself.</span>", "<span style=\"color:red\">You puke all over yourself!</span>")
					playsound(M.loc, "sound/effects/splat.ogg", 50, 1)
					new /obj/decal/cleanable/vomit(M.loc)
				M.take_toxin_damage(1)
				M.take_brain_damage(1)
				M.TakeDamage("chest", 0, 1, 0, DAMAGE_BURN)
				M.updatehealth()
				..(M)
				return

		harmful/dna_mutagen
			name = "stable mutagen"
			id = "dna_mutagen"
			description = "Just the regular, boring sort of mutagenic compound.  Works in a completely predictable manner."
			reagent_state = LIQUID
			fluid_r = 125
			fluid_g = 255
			fluid_b = 0
			transparency = 255
			pathogen_nutrition = list("dna_mutagen")

			var/tmp/progress_timer = 1
/*
			reaction_temperature(exposed_temperature, exposed_volume)
				var/myvol = volume

				if (exposed_temperature > 50 && !holder.has_reagent("stabiliser") || exposed_temperature > 300)
					volume = 0
					holder.add_reagent("mutagen", myvol, null)

				return
*/

			pooled()
				..()
				progress_timer = 1


			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				M.irradiate(2,1) // let's not totally kill people
				var/datum/bioHolder/data_as_holder = null
				if (!src.data) //Do we have some BLOOODDD to use?
					var/datum/reagent/blood/cheating = holder.reagent_list["blood"]
					if (cheating && istype(cheating.data, /datum/bioHolder))
						src.data = cheating.data
						data_as_holder = src.data



				if (src.data && M.bioHolder && progress_timer <= 10)

					M.bioHolder.StaggeredCopyOther(data, progress_timer++)
					if (progress_timer == 10)
						if (data_as_holder && data_as_holder.ownerName)
							M.real_name = data_as_holder.ownerName
							M.bioHolder.ownerName = M.real_name
							M.bioHolder.CopyOther(data)
						else if (data && data:ownerName)
							M.real_name = data:ownerName
							M.bioHolder.ownerName = M.real_name

				..(M)
				return

			on_plant_life(var/obj/machinery/plantpot/P)
				if (prob(80)) P.growth -= rand(1,3)
				if (prob(16)) P.HYPmutateplant(1)

		harmful/madness_toxin
			name = "Rajaijah"
			id = "madness_toxin"
			description = "A synthetic version of a potent neurotoxin derived from plants capable of driving a person to madness. First discovered in India by a Belgian reporter in 1931."
			reagent_state = LIQUID
			fluid_r = 157
			fluid_g = 206
			fluid_b = 69
			transparency = 255
			depletion_rate = 0.1
			var/spooksounds = list('sound/effects/ghost.ogg' = 80,'sound/effects/ghost2.ogg' = 20,'sound/effects/ghostbreath.ogg' = 60, \
					'sound/effects/ghostlaugh.ogg' = 40,'sound/effects/ghostvoice.ogg' = 90)

			var/lastSpook = 0
			var/lastSpookLen = 0
			var/ai_was_active = 0
			pooled()
				..()
				lastSpook = 0
				lastSpookLen = 0
				ai_was_active = 0

			on_mob_life(var/mob/M)
				if (!M) M = holder.my_atom
				var/mob/living/carbon/human/H = M
				if (!istype(H)) return

				switch(data++)
					if (2 to 10) //Uh oh
						if (prob(33))
							H.drowsyness = max(H.drowsyness,4)
							H.show_text(pick_string("chemistry_reagent_messages.txt", "madness0"), "red")
						if (prob(10)) H.emote(pick_string("chemistry_reagent_messages.txt", "madness_e0"))

					if (11 to 17) //Not too bad after all
						if (prob(33))
							H.drowsyness = max(H.drowsyness,7)
							H.show_text(pick_string("chemistry_reagent_messages.txt", "madness1"), "blue")
						if (prob(10)) H.emote(pick_string("chemistry_reagent_messages.txt", "madness_e1"))

					if (18 to 25) //Oh god!
						if (prob(33))
							H.drowsyness = max(H.drowsyness,7)
							H.make_jittery(300)
							H.show_text("<B>[pick_string("chemistry_reagent_messages.txt", "madness2")]</B>", "red")
							if (prob(33) && world.time > lastSpook + lastSpookLen)
								var/spook = pick(spooksounds)
								H.playsound_local(H, spook, 50, 1)
								lastSpookLen = spooksounds[spook]
								lastSpook = world.time

						if (prob(15)) H.emote(pick_string("chemistry_reagent_messages.txt", "madness_e2"))



					if (26) //Whew
						H.show_text("<B>Your mind feels clearer.<B>", "blue")
						H.drowsyness = 0
					if (29) //Oh no
						H.show_text("<font size=+2><B>IT HURTS!!</B></font>","red")
						H.emote("scream")
						H.drowsyness = max(H.drowsyness,30)
						ai_was_active = H.ai_active
						H.ai_init() //:getin:
						H.ai_aggressive = 1 //Fak
						logTheThing("combat", H, null, "has their AI enabled by [src.id]")
						H.playsound_local(H, 'sound/effects/Heart Beat.ogg', 50, 1)
						lastSpook = world.time
					if (30 to 100) //FIGHTIN'
						if (prob(33))
							H.drowsyness = max(H.drowsyness,10)
							H.make_jittery(600)
							H.show_text("<B>[pick_string("chemistry_reagent_messages.txt", "madness3")]</B>", "red")

						if (prob(33)) H.emote(pick_string("chemistry_reagent_messages.txt", "madness_e2"))

						if (prob(20) && world.time > lastSpook + 510)
							H.show_text("You feel your heartbeat pounding inside your head...", "red")
							H.playsound_local(H, 'sound/effects/Heart Beat.ogg', 75, 1) // LOUD
							lastSpook = world.time


						//POWER UP!!

						if (data > 50) //Oh dear
							if (data == 51)
								H.add_stam_mod_regen(src.id, 100) //Buff
								H.show_text("You feel very buff!", "red")
							if (prob(20)) //The AI is in control now.
								H.change_misstep_chance(100)
								H.show_text("You can't seem to control your legs!", "red")

							if (prob(10)) //Stronk
								H.show_text("You feel strong!", "red")
								H.weakened = 0
								H.stunned = 0
								H.paralysis = 0

					if (101) //Uh oh
						H.ai_suicidal = 1
						H.show_text("Death... I can only stop this by dying...", "red")
					if (102 to INFINITY)
						if (prob(33))
							H.drowsyness = max(H.drowsyness,10)
							H.make_jittery(600)
							H.show_text("<B>[pick_string("chemistry_reagent_messages.txt", "madness3")]</B>", "red")

						if (prob(33)) H.emote(pick_string("chemistry_reagent_messages.txt", "madness_e2"))

						if (prob(20) && world.time > lastSpook + 510)
							H.show_text("You feel your heartbeat pounding inside your head...", "red")
							H.playsound_local(H, 'sound/effects/Heart Beat.ogg', 100, 1) // LOUD
							lastSpook = world.time


						//POWER UP!!
						if (prob(20)) //The AI is in control now.
							H.change_misstep_chance(100)
							H.show_text("You can't seem to control your legs!", "red")

						if (prob(20)) //V. Stronk
							H.show_text("You feel strong!", "red")
							H.weakened = 0
							H.stunned = 0
							H.paralysis = 0

				H.take_brain_damage(0.5)
				..(M)
			on_remove()
				if (holder && holder.my_atom && istype(holder.my_atom, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = holder.my_atom
					if (data >= 30)
						H.remove_stam_mod_regen(src.id) //Not so buff
						if(!ai_was_active)
							H.ai_stop()
						H.ai_aggressive = initial(H.ai_aggressive)
						H.ai_suicidal = 0
						logTheThing("combat", H, null, "has their AI disabled by [src.id]")
						H.show_text("It's okay... it's okay... breathe... calm... it's okay...", "blue")

		harmful/strychnine
			name = "strychnine"
			id = "strychnine"
			description = "A highly potent neurotoxin in crystalline form. Causes severe convulsions and eventually death by asphyxiation. Has been known to be used as a performance enhancer by certain athletes."
			reagent_state = SOLID
			fluid_r = 244
			fluid_g = 244
			fluid_b = 244
			transparency = 255
			depletion_rate = 0.2

			on_mob_life(var/mob/M)

				var/mob/living/carbon/human/H = M
				if (!istype(H)) return

				switch(data++)

					if(2) //Just started out. Everything's cool
						H.add_stam_mod_max(src.id, 75)
					if(3 to 14)
						if(prob(20)) do_stuff(0, H)

					if(15 to 24) //Ok, now it's getting worrying
						if(prob(30)) do_stuff(1, H)
					if(25)
						H.remove_stam_mod_max(src.id)
						H.add_stam_mod_max(src.id, -50)
						H.add_stam_mod_regen(src.id, -2)
					if(26 to 35)
						if(prob(30)) do_stuff(2, H)
					if(36 to INFINITY)
						if(prob(min(data, 100))) //Start at 30% chance of bad stuff, increase until death
							do_stuff(3, H)

				..()

			on_remove()
				..()
				var/mob/living/carbon/human/H = holder.my_atom
				if (!istype(H)) return
				H.remove_stam_mod_max(src.id)
				H.remove_stam_mod_regen(src.id)


			proc/do_stuff(var/severity, var/mob/living/carbon/human/H)
				if(!istype(H)) return

				switch(severity)
					if(0) //Harmless messages, etc
						H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine0"), "blue")
					if(1) //Getting kinda stiff... ouch (stuns, dropping items, etc)
						switch(rand(1,6))
							if(1 to 3) //Feels bad
								H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine1"), "red")
							if(4) //Drop stuff
								H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine1b"), "red")
								H.stunned++
							if(5) //Trip
								H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine1c"), "red")
								H.weakened += rand(1,2)
							if(6) //Light-headedness
								H.show_text("You feel light-headed.", "red")
								H.drowsyness += rand(2,4)

					if(2) //I don't feel so good (tripping, hard time breathing, randomly dropping stuff)
						switch(rand(1,4))
							if(1) //Chest-heaviness
								H.show_text("Your chest feels heavy.", "red")
								H.emote(pick("gasp", "choke", "cough"))
								H.losebreath++
								H.oxyloss += rand(5, 10)
							if(2) //Drop stuff
								H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine2"), "red")
								H.stunned += rand(2,4)
								H.change_misstep_chance(20)
							if(3) //Trip
								H.show_text(pick_string("chemistry_reagent_messages.txt", "strychnine2b"), "red")
								H.visible_message("<span class='combat bold'>[H] stumbles and falls!</span>")
								if(prob(10)) H.emote("scream")
								H.weakened += rand(2,4)
							if(4) //Light-headedness
								H.show_text("You feel like you are about to faint!", "red")
								H.drowsyness += rand(4,7)
								if(prob(20)) H.emote(pick("faint", "collapse"))
						if(prob(30))
							H.make_jittery(15)
				if(severity > 2)
					if(prob(min(data, 100))) //Stun, twitch, 50% chance ramps up to 100 after
						H.make_jittery(50)
						H.visible_message("<span class='combat bold'>[H][pick_string("chemistry_reagent_messages.txt", "strychnine_deadly")]</span>")
						H.weakened = min( H.weakened + rand(5,10), 20 )
						if(prob(50))
							H.emote("scream") //It REALLY hurts
							H.TakeDamage(zone="All", brute=rand(2,5))

					if(prob(minmax(data/1.5, 100, 30))) //At least 30% risk of oxy damage
						if(prob(50))H.emote(pick("gasp", "choke", "cough"))
						H.losebreath += rand(1,2)

					if(prob(25))
						H.emote(pick_string("chemistry_reagent_messages.txt", "strychnine_deadly_emotes"))

					if(prob(10))
						H.visible_message("<span style=\"color:red\">[H] pukes all over \himself.</span>", "<span style=\"color:red\">You puke all over yourself!</span>")
						playsound(H.loc, "sound/effects/splat.ogg", 50, 1)
						new /obj/decal/cleanable/vomit(H.loc)
					else if (prob(5))
						var/damage = rand(1,5)
						H.visible_message("<span style=\"color:red\">[H] [damage > 3 ? "vomits" : "coughs up"] blood!</span>", "<span style=\"color:red\">You [damage > 3 ? "vomit" : "cough up"] blood!</span>")
						playsound(H.loc, "sound/effects/splat.ogg", 50, 1)
						H.TakeDamage(zone="All", brute=damage)
						bleed(H, damage * 2, damage)
						//TODO: Blood