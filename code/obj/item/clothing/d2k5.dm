//Custom clothing
//Add most recent to the top of their lists?

//Uniforms
/obj/item/clothing/under/[PLACEHOLDERD]
	wear_image_icon = 'icons/mob/jumpsuits/worn_js_[PLACEHOLDERD].dmi'
	..()

/obj/item/clothing/under/[PLACEHOLDERD]/dark
	name = "dark uniform"
	desc = "???"

	icon_state = "darksuit"
	item_state="darksuit"

/obj/item/clothing/under/[PLACEHOLDERD]/darkfem
	name = "dark dress"
	desc = "???"

	icon_state = "darkfem"
	item_state="darkfem"


/obj/item/clothing/under/[PLACEHOLDERD]/e_officer
	name = "Enclave Officer Uniform"
	desc = "A sharp garment for the discerning Enclave Officer."

	icon_state = "e_officer"
	item_state = "lb_suit"

/obj/item/clothing/under/[PLACEHOLDERD]/schoolgirl2
	name = "schoolgirl uniform"
	desc = "A schoolgirl outfit..."

	icon_state = "schoolgirl2"
	item_state = "schoolgirl2"

/obj/item/clothing/under/[PLACEHOLDERD]/vriska
	name = "vriska uniform"
	desc = "Vriska's outfit..."

	icon_state = "vriska"
	item_state = "vriska"

/obj/item/clothing/under/[PLACEHOLDERD]/rank/barskirt
	desc = "It looks like it could use more flair."
	name = "Female Bartender's Uniform"

	icon_state = "bt_skirt"
	item_state = "bt_skirt"

/obj/item/clothing/under/[PLACEHOLDERD]/rank/startrek1
	desc = "FUCK YOUR SHIT"
	name = "Star Trek Blue"

	icon_state = "st1"
	item_state = "st1"

/obj/item/clothing/under/[PLACEHOLDERD]/rank/startrek2
	desc = "FUCK YOUR SHIT"
	name = "Star Trek Yellow"

	icon_state = "st2"
	item_state = "st2"

/obj/item/clothing/under/[PLACEHOLDERD]/rank/medicskirt
	desc = "It's a female medic uniform."
	name = "Female Medic Uniform"

	icon_state = "female_medic"
	item_state = "female_medic"

/obj/item/clothing/under/[PLACEHOLDERD]/maid
	name = "maid uniform"
	desc = "You have the urge to put this on and act submissively"

	icon_state = "meido"
	item_state = "meido"

/obj/item/clothing/under/[PLACEHOLDERD]/rank/sexyman
	desc = "Sexy mans uniform"
	name = "Sexy Mans Uniform"

	icon_state = "sexyman"
	item_state = "sexyman"

//Taken from LLA
/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/lucy
	name = "Lucy's Attire"
	icon_state = "lucy"
	desc = "Watch out for the Vectors."
	item_state="lucy"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/nyu
	name = "Nyu's Attire"
	icon_state = "nyu"

	item_state="nyu"
	desc = "Making amnesia look GOOD!"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/yoko
	name = "Yoko's Clothing"
	icon_state = "yoko"
	desc = "Good thing you wear it in a desert!"
	item_state="yoko"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/kamina
	name = "Kamina's Attire"
	icon_state = "kamina"
	desc = "Nice tattoos, Bro."

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/kenshiro
	name = "Kenshiro's Suit"
	icon_state = "kenshiro"
	desc = "Anata wa sudeni shinde iru"	//You are already dead

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/haruko
	name = "Haruko's Vespa Gear"
	icon_state = "haruko"
	desc = "Everything you need to... Ride a vespa..."

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/tiny_miniskirt_blue
	name = "Blue Tiny Miniskirt"
	icon_state = "miniskirtb"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/tiny_miniskirt_red
	name = "Red Tiny Miniskirt"
	icon_state = "miniskirtr"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/tiny_miniskirt_green
	name = "Green Tiny Miniskirt"
	icon_state = "miniskirtg"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/tiny_miniskirt_yellow
	name = "Yellow Tiny Miniskirt"
	icon_state = "miniskirty"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/tiny_miniskirt_pink
	name = "Pink Tiny Miniskirt"
	icon_state = "miniskirtp"
	desc = "On my station, all female members will be required to wear TINY MINISKIRTS!"

/obj/item/clothing/suit/[PLACEHOLDERD]/lla/fursuit
	name = "giant furfag suit"
	icon_state = "narkysuit"
	desc = "You are the bringer of furfaggotry"
	flags = FPRINT | TABLEPASS | ONESIZEFITSALL
	item_state="narkysuit"


//Suits
/obj/item/clothing/suit/[PLACEHOLDERD]
	wear_image_icon = 'icons/mob/overcoats/worn_suit_[PLACEHOLDERD].dmi'
	..()

/obj/item/clothing/suit/[PLACEHOLDERD]/darkcoat
	name = "dark trenchcoat"
	desc = "???"
	icon_state = "darkcoat"
	item_state = "darkcoat"
	flags = FPRINT | TABLEPASS

/obj/item/clothing/suit/[PLACEHOLDERD]/medicaltunic
	name = "female medical tunic"
	desc = "A medical tunic for females."
	permeability_coefficient = 0.80
	icon_state = "medicskirt"
	item_state = "medicskirt"


//Shoes
/*/obj/item/clothing/shoes/[PLACEHOLDERD]/brown_blackstockings
	name = "Brown Shoes w/ Black Stockings"
	icon_state = "brown_blackstockings"

/obj/item/clothing/shoes/[PLACEHOLDERD]/brown_whitestockings
	name = "Brown Shoes w/ White Stockings"
	icon_state = "brown_whitestockings"

/obj/item/clothing/shoes/[PLACEHOLDERD]/red_whitestockings
	name = "Red Shoes w/ White Stockings"
	icon_state = "red_whitestockings"

/obj/item/clothing/shoes/[PLACEHOLDERD]/boots_wstockings
	name = "Boots w/ Black Stockings"
	icon_state = "boots_wstockings"*/


//Hats
/obj/item/clothing/head/[PLACEHOLDERD]/fedora
	name = "fedora"
	icon_state = "fedora"
	item_state = "fedora"
	desc = "A euphoric hat for enlightened gentlemen who visit '/r/athiesm'."
	flags = FPRINT|TABLEPASS
