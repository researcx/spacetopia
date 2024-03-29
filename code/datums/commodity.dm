// Commodities
/datum/commodity/
	var/comname = "commodity" // Name of the item on the market
	var/comtype = null // Type Path of the item on the market
	var/price = 0 // Current selling price for this commodity
	var/baseprice = 0 // Baseline selling price for this commodity
	var/onmarket = 1 // Whether this item is currently being accepted for sale
	var/indemand = 0 // Whether this item is currently being bought at a high price
	var/upperfluc = 0 // Highest this item's price can raise in one shift
	var/lowerfluc = 0 // Lowest this item's price can drop in one shift (negative numbers only)
	var/desc = "item" //Description for item
	var/desc_buy = "There are several buyers interested in acquiring this item." //Description for player selling
	var/desc_buy_demand = "This item is in high demand." //Descripition for player selling when in high demand
	var/hidden = 0 //Sometimes traders won't say if they will buy something
	var/haggleattempts = 0
	var/amount = -1 // Used for QM traders - how much of a thing they have for sale, unlim if -1
	// if its in the shopping cart, this is how many you're buying instead

/*
/datum/commodity/clothing
	comname = "Jumpsuits"
	comtype = /obj/item/clothing/under
	price = 30
	baseprice = 30
	upperfluc = 20
	lowerfluc = 10

/datum/commodity/shoes
	comname = "Shoes"
	comtype = /obj/item/clothing/shoes
	price = 20
	baseprice = 20
	upperfluc = 10
	lowerfluc = 10 */

/datum/commodity/electronics
	comname = "Electronic Parts"
	comtype = /obj/item/electronics
	price = 25
	baseprice = 25
	upperfluc = 15
	lowerfluc = -15
	onmarket = 1

/datum/commodity/robotics
	comname = "Robot Parts"
	comtype = /obj/item/parts/robot_parts
	desc_buy = "The Omega Mining Corporation is expanding its operations and is in need of some robot parts"
	desc_buy_demand = "Cyborgs have revolted in the Lambada Quadrant, they are in desprate need of some more robot parts"
	price = 65
	baseprice = 65
	upperfluc = 30
	lowerfluc = -30

/datum/commodity/produce
	comname = "Fresh Produce"
	comtype = /obj/item/reagent_containers/food/snacks/plant
	price = 50
	baseprice = 50
	upperfluc = 25
	lowerfluc = -25

/datum/commodity/meat
	comname = "Meat"
	comtype = /obj/item/reagent_containers/food/snacks/ingredient/meat
	price = 50
	baseprice = 50
	upperfluc = 25
	lowerfluc = -25

/datum/commodity/herbs
	comname = "Medical Herbs"
	comtype = /obj/item/plant/herb
	price = 75
	baseprice = 75
	upperfluc = 50
	lowerfluc = -50

/datum/commodity/honey
	comname = "Space Honey"
	comtype = /obj/item/reagent_containers/food/snacks/ingredient/honey
	desc_buy = "Meagre nectar yields this year have made honey imports desirable to space-bee hives."
	price = 100
	baseprice = 100
	upperfluc = 50
	lowerfluc = -50

/datum/commodity/sheet
	comname = "Material Sheets"
	comtype = /obj/item/sheet
	desc = "High-quality material sheets."
	price = 7 // no more scamming
	baseprice = 7

/datum/commodity/ore // because QMs keep scamming the system, I am lowering the base price of ore way down - cogwerks
	comname = "ore"
	comtype = null
	desc = "An ore that has various practical uses in manufacturing and research."
	desc_buy = "The Promethus Consortium is currently gathering resources for a research project and is willing to buy this item"
	desc_buy_demand = "The colony on Regus X has had their main power reactor break down and need this item for repairs"
	price = 2
	baseprice = 2
	upperfluc = 2
	lowerfluc = -1

/datum/commodity/ore/mauxite
	comname = "Mauxite"
	comtype = /obj/item/raw_material/mauxite

/datum/commodity/ore/pharosium
	comname = "Pharosium"
	comtype = /obj/item/raw_material/pharosium

/datum/commodity/ore/char
	comname = "Char"
	comtype = /obj/item/raw_material/char
	price = 35
	baseprice = 35
	upperfluc = 50
	lowerfluc = -25

/datum/commodity/ore/molitz
	comname = "Molitz"
	comtype = /obj/item/raw_material/molitz

/datum/commodity/ore/cobryl
	comname = "Cobryl"
	comtype = /obj/item/raw_material/cobryl
	price = 200
	baseprice = 200
	upperfluc = 200
	lowerfluc = -100

/datum/commodity/ore/uqill
	comname = "Uqill"
	comtype = /obj/item/raw_material/uqill
	price = 750
	baseprice = 750
	upperfluc = 1000
	lowerfluc = -500

/datum/commodity/ore/telecrystal
	comname = "Telecrystal"
	comtype = /obj/item/raw_material/telecrystal
	desc = "A large unprocessed telecrystal, a gemstone with space-warping properties."
	price = 1000
	baseprice = 1000
	upperfluc = 1000
	lowerfluc = -500

/datum/commodity/ore/fibrilith // why is this worth a ton of money?? dropping the value to further upset QMs
	comname = "Fibrilith"
	comtype = /obj/item/raw_material/fibrilith

/datum/commodity/ore/koshmarite
	comname = "Koshmarite"
	comtype = /obj/item/raw_material/eldritch
	price = 100
	baseprice = 100
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/ore/viscerite
	comname = "Viscerite"
	comtype = /obj/item/raw_material/martian
	price = 100
	baseprice = 100
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/ore/bohrum
	comname = "Bohrum"
	comtype = /obj/item/raw_material/bohrum
	price = 200
	baseprice = 200
	upperfluc = 200
	lowerfluc = -100

/datum/commodity/ore/claretine
	comname = "Claretine"
	comtype = /obj/item/raw_material/claretine
	price = 350
	baseprice = 350
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/ore/erebite
	comname = "Erebite"
	comtype = /obj/item/raw_material/erebite
	price = 650
	baseprice = 650
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/ore/cerenkite
	comname = "Cerenkite"
	comtype = /obj/item/raw_material/cerenkite
	price = 480
	baseprice = 480
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/ore/plasmastone
	comname = "Plasmastone"
	comtype = /obj/item/raw_material/plasmastone
	price = 550
	baseprice = 550
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/ore/syreline
	comname = "Syreline"
	comtype = /obj/item/raw_material/syreline
	price = 800
	baseprice = 800
	upperfluc = 1000
	lowerfluc = -300

/datum/commodity/ore/gold
	comname = "Gold Nugget"
	comtype = /obj/item/raw_material/gold
	price = 3500
	baseprice = 3500
	upperfluc = 5000
	lowerfluc = -2500
	onmarket = 1

/datum/commodity/goldbar
	comname = "Gold Ingot"
	comtype = /obj/item/material_piece/gold
	price = 35000
	baseprice = 35000
	upperfluc = 50000
	lowerfluc = -25000
	onmarket = 1

/datum/commodity/laser_gun
	comname = "Laser Gun"
	comtype =  /obj/item/gun/energy/laser_gun
	desc = "A laser gun. Pew pew."
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/pen
	comname = "Pen"
	comtype = /obj/item/pen
	desc = "A useful writing tool."
	price = 10
	baseprice = 10
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/guardbot_medicator
	comname = "Medicator Tool Module"
	comtype = /obj/item/device/guardbot_tool/medicator
	desc = "A 'Medicator' syringe launcher module for PR-6S Guardbuddies. These things are actually outlawed on Earth."
	price = 75
	baseprice = 75
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/guardbot_smoker
	comname = "Smoker Tool Module"
	comtype = /obj/item/device/guardbot_tool/smoker
	desc = "A riot-control gas module for PR-6S Guardbuddies."
	price = 250
	baseprice = 250
	upperfluc = 40
	lowerfluc = -40

/datum/commodity/guardbot_flash
	comname = "Flash Tool Module"
	comtype = /obj/item/device/guardbot_tool/flash
	desc = "A flash module for PR-6S Guardbuddies."
	price = 75
	baseprice = 75
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/guardbot_taser
	comname = "Taser Tool Module"
	comtype = /obj/item/device/guardbot_tool/taser
	desc = "A taser module for PR-6S Guardbuddies."
	price = 175
	baseprice = 75
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/guardbot_kit
	comname = "Guardbot Construction Kit"
	comtype = /obj/item/storage/box/guardbot_kit
	desc = "A useful kit for building guardbuddies. All you need is a module!"
	price = 100
	baseprice = 100
	upperfluc = 50
	lowerfluc = -50

/datum/commodity/boogiebot
	comname = "Boogiebot"
	comtype = /obj/critter/boogiebot
	desc = "The latest in boogie technology!"
	price = 5000
	baseprice = 5000
	upperfluc = 500
	lowerfluc = -500

// cogwerks - NPC stuff

/datum/commodity/fuel // buy from trader NPC
	comname = "Fuel Tank"
	comtype = /obj/item/tank/plasma
	desc = "A small tank of plasma. Use with caution."
	price = 250
	baseprice = 250
	upperfluc = 50
	lowerfluc = -50
	onmarket = 0

/datum/commodity/royaljelly
	comname = "Royal Jelly"
	comtype = /obj/item/reagent_containers/food/snacks/ingredient/royal_jelly
	desc = "A sample of royal jelly, a nutritive compound for bee larvae."
	price = 200
	baseprice = 200
	upperfluc = 200
	lowerfluc = -100
	onmarket = 0

/datum/commodity/beeegg
	comname = "Bee Egg"
	comtype = /obj/item/reagent_containers/food/snacks/ingredient/egg/bee
	desc = "A space bee egg.  Space bees hatch from these."
	price = 75
	baseprice = 75
	upperfluc = 10
	lowerfluc = -10
	onmarket = 0

/datum/commodity/b33egg
	comname = "Irregular Egg"
	comtype = /obj/item/reagent_containers/food/snacks/ingredient/egg/bee/buddy
	desc = "This batch of space bee eggs exhibits a minor irregularity that kept it out of normal distribution channels."
	price = 75
	baseprice = 75
	upperfluc = 10
	lowerfluc = -10
	onmarket = 0

/datum/commodity/bee_kibble
	comname = "Bee Kibble"
	comtype = /obj/item/reagent_containers/food/snacks/beefood
	desc = "Essentially cereal for bees.  Tastes pretty good, provided that you are a bee."
	price = 50
	baseprice = 50
	upperfluc = 10
	lowerfluc = -10
	onmarket = 0

//////////////////////
//// pod sales ///////
//////////////////////

/datum/commodity/podparts
	onmarket = 0

/datum/commodity/podparts/engine
	comname = "HERMES Engine"
	comtype = /obj/item/shipcomponent/engine/hermes
	desc = "A heavy-duty engine for pod vehicles."
	price = 5500
	baseprice = 5500
	upperfluc = 2000
	lowerfluc = -2000

/datum/commodity/podparts/laser
	comname = "Mk.2 Scout Laser"
	comtype = /obj/item/shipcomponent/mainweapon/laser
	desc = "A standard military laser built around a pod-based weapons platform."
	price = 25000
	baseprice = 25000
	upperfluc = 10000
	lowerfluc = -10000

/datum/commodity/podparts/asslaser
	comname = "Assault Laser Array"
	comtype = /obj/item/shipcomponent/mainweapon/laser_ass
	desc = "Usually only seen on cruiser-class ships. How the hell did this end up here?"
	price = 120000
	baseprice = 120000
	upperfluc = 25000
	lowerfluc = -25000

/datum/commodity/podparts/blackarmor
	comname = "Strange Armor Plating"
	comtype = /obj/item/pod/armor_black
	desc = "NT Special Ops vehicular armor plating, almost certainly stolen."
	price = 50000
	baseprice = 50000
	upperfluc = 15000
	lowerfluc = -15000

/datum/commodity/podparts/redarmor
	comname = "Syndicate Pod Armor"
	comtype = /obj/item/pod/armor_red
	desc = "A kit of Syndicate pod armor plating."
	price = 25000
	baseprice = 25000
	upperfluc = 8000
	lowerfluc = -8000

/datum/commodity/podparts/goldarmor
	comname = "Gold Pod Armor"
	comtype = /obj/item/pod/armor_gold
	desc = "A kit of gold-plated pod armor plating."
	price = 32500
	baseprice = 32500
	upperfluc = 8000
	lowerfluc = -8000

/datum/commodity/podparts/ballistic
	comname = "Ballistic System"
	comtype = /obj/item/shipcomponent/mainweapon/gun
	desc = "A pod-mounted kinetic weapon system."
	price = 45000
	baseprice = 45000
	upperfluc = 10000
	lowerfluc = -10000

/datum/commodity/podparts/artillery
	comname = "40mm Assault Platform"
	comtype = /obj/item/shipcomponent/mainweapon/artillery
	desc = "A pair of ballistic launchers, fires explosive 40mm shells."
	price = 250000
	baseprice = 250000
	upperfluc = 25000
	lowerfluc = -25000

/datum/commodity/contraband/artillery_ammo
	comname = "40mm HE Ammunition"
	comtype = /obj/item/ammo/bullets/autocannon
	desc = "High explosive grenades, for the resupplement of artillery assault platforms."
	price = 100000
	baseprice = 100000
	upperfluc = 10000
	lowerfluc = -10000

/datum/commodity/podparts/cloak
	comname = "Medusa Stealth System 300"
	comtype = /obj/item/shipcomponent/secondary_system/cloak
	desc = "A cloaking device for stealth recon vehicles."
	price = 500000
	baseprice = 500000
	upperfluc = 25000
	lowerfluc = -25000

/datum/commodity/podparts/skin_stripe_r
	comname = "Pod Paint Job Kit (Red Racing Stripes)"
	comtype = /obj/item/pod/paintjob/stripe_r
	desc = "A pod paint job kit that makes it look all spiffy!"
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -2500

/datum/commodity/podparts/skin_stripe_b
	comname = "Pod Paint Job Kit (Blue Racing Stripes)"
	comtype = /obj/item/pod/paintjob/stripe_b
	desc = "A pod paint job kit that makes it look all spiffy!"
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -2500

/datum/commodity/podparts/skin_flames
	comname = "Pod Paint Job Kit (Flames)"
	comtype = /obj/item/pod/paintjob/flames
	desc = "A pod paint job kit that makes it look all spiffy!"
	price = 9000
	baseprice = 9000
	upperfluc = 5000
	lowerfluc = -5000

////////////////////////////
///// 420 all day //////////
////////////////////////////

/datum/commodity/drugs
	desc = "Illegal drugs."
	onmarket = 0

/// these are things that you can sell to the traders

/datum/commodity/drugs/shrooms
	comname = "Psilocybin"
	comtype = /obj/item/reagent_containers/food/snacks/mushroom/psilocybin
	price = 500
	baseprice = 500
	upperfluc = 300
	lowerfluc = -300

/datum/commodity/drugs/cannabis
	comname = "Cannabis"
	comtype = /obj/item/plant/herb/cannabis
	price = 150
	baseprice = 150
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/drugs/cannabis_mega
	comname = "Rainbow Cannabis"
	comtype = /obj/item/plant/herb/cannabis/mega
	price = 700
	baseprice = 700
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/drugs/cannabis_white
	comname = "White Cannabis"
	comtype = /obj/item/plant/herb/cannabis/white
	price = 450
	baseprice = 450
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/drugs/cannabis_omega
	comname = "Omega Cannabis"
	comtype = /obj/item/plant/herb/cannabis/omega
	price = 2500
	baseprice = 2500
	upperfluc = 2000
	lowerfluc = -1000

///// things you can buy from the traders

/datum/commodity/drugs/methamphetamine
	comname = "Methamphetamine (5x pills)"
	comtype = /obj/item/storage/pill_bottle/methamphetamine
	desc = "Methamphetamine is a highly effective and dangerous stimulant drug."
	price = 1250
	baseprice = 1250
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/drugs/crank
	comname = "Crank (5x pills)"
	comtype = /obj/item/storage/pill_bottle/crank
	desc = "A cheap and dirty stimulant drug, commonly used by space biker gangs."
	price = 400
	baseprice = 400
	upperfluc = 200
	lowerfluc = -100

/datum/commodity/drugs/bathsalts
	comname = "Bath Salts (5x pills)"
	comtype = /obj/item/storage/pill_bottle/bathsalts
	desc = "Sometimes packaged as a refreshing bathwater additive, these crystals are definitely not for human consumption."
	price = 6500
	baseprice = 6500
	upperfluc = 2500
	lowerfluc = -1500

/datum/commodity/drugs/catdrugs
	comname = "Cat Drugs (5x pills)"
	comtype = /obj/item/storage/pill_bottle/catdrugs
	desc = "Uhh..."
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -1500

/datum/commodity/drugs/morphine
	comname = "Morphine (1x syringe)"
	comtype = /obj/item/reagent_containers/syringe/morphine
	desc = "A strong but highly addictive opiate painkiller with sedative side effects."
	price = 350
	baseprice = 350
	upperfluc = 250
	lowerfluc = -250

/datum/commodity/drugs/krokodil
	comname = "Krokodil (1x syringe)"
	comtype = /obj/item/reagent_containers/syringe/krokodil
	desc = "A sketchy homemade opiate often used by disgruntled Cosmonauts."
	price = 100
	baseprice = 100
	upperfluc = 150
	lowerfluc = -150

/datum/commodity/drugs/lsd
	comname = "LSD (1x patch)"
	comtype = /obj/item/reagent_containers/patch/LSD
	desc = "A highly potent hallucinogenic substance. Far out, maaaan."
	price = 250
	baseprice = 250
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/pills/uranium
	comname = "Uranium (1x nugget)"
	comtype = /obj/item/reagent_containers/pill/uranium
	desc = "A nugget of weapons grade uranium. Label says it's roughly 'size 5'."
	price = 1000
	baseprice = 1000
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/drugs/cyberpunk
	comname = "Designer Drugs (5x pills)"
	comtype = /obj/item/storage/pill_bottle/cyberpunk
	desc = "Who knows what you might get."
	price = 500
	baseprice = 500
	upperfluc = 500
	lowerfluc = -250

/////////////////////////////////
//// valuable space junk ////////
/////////////////////////////////

/datum/commodity/relics
	desc = "Strange things from deep space."
	onmarket = 0

/datum/commodity/relics/skull
	comname = "Skull"
	comtype = /obj/item/skull
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -1000

/datum/commodity/relics/relic
	comname = "Strange Relic"
	comtype = /obj/item/relic
	price = 49500
	baseprice = 49500
	upperfluc = 12500
	lowerfluc = -12500

/datum/commodity/relics/gnome
	comname = "Garden Gnome"
	comtype = /obj/item/gnomechompski
	price = 6000
	baseprice = 6000
	upperfluc = 2500
	lowerfluc = -2500

/*/datum/commodity/relics/crown
	comname = "Obsidian Crown"
	comtype = /obj/item/clothing/head/void_crown
	price = 52250
	baseprice = 52250
	upperfluc = 20000
	lowerfluc = -20000

/datum/commodity/relics/armor
	comname = "Ancient Armor"
	comtype = /obj/item/clothing/suit/armor/ancient
	price = 86500
	baseprice = 86500
	upperfluc = 20000
	lowerfluc = -20000*/

/datum/commodity/relics/marshelmet
	comname = "Antique Mars Helmet"
	comtype = /obj/item/clothing/head/helmet/mars
	price = 3500
	baseprice = 3500
	upperfluc = 3000
	lowerfluc = -1500

/datum/commodity/relics/marsuit
	comname = "Antique Mars Suit"
	comtype = /obj/item/clothing/suit/armor/mars
	price = 7000
	baseprice = 7000
	upperfluc = 5000
	lowerfluc = -3000

////////////////////////////////
///// syndicate trader /////////
////////////////////////////////

/datum/commodity/contraband
	comname = "Contraband"
	desc = "Stolen gear and syndicate products."
	onmarket = 0

/datum/commodity/contraband/captainid
	comname = "NT Captain Gold ID"
	comtype = /obj/item/card/id/captains_spare
	desc = "NT gold-level registered captain ID."
	price = 7500
	baseprice = 7500
	upperfluc = 5000
	lowerfluc = -2000

	bee
		comname = "Captain Gold ID"
		desc_buy = "The kind of ID a queen would probably hang on the wall of the hive or something."

/datum/commodity/contraband/spareid
	comname = "NT Spare Gold ID"
	comtype = /obj/item/card/id/gold
	desc = "NT gold-level unregistered spare ID."
	price = 7500
	baseprice = 7500
	upperfluc = 5000
	lowerfluc = -2000

	bee
		comname = "Gold ID"
		desc_buy = "You know, gold, like honey! Grey ones are out of place in a hive."

/datum/commodity/contraband/secheadset
	comname = "Security Headset"
	comtype = /obj/item/device/radio/headset/security
	desc = "A radio headset used by NT security forces."
	price = 2000
	baseprice = 2000
	upperfluc = 2000
	lowerfluc = -1000

/datum/commodity/contraband/hosberet
	comname = "Head of Security Beret"
	comtype = /obj/item/clothing/head/helmet/HoS
	desc = "The beloved beret of an NT HoS."
	price = 10000
	baseprice = 10000
	upperfluc = 5000
	lowerfluc = -3000

/datum/commodity/contraband/egun
	comname = "Energy Gun"
	comtype = /obj/item/gun/energy/egun
	desc = "A standard-issue NT energy gun."
	price = 7000
	baseprice = 7000
	upperfluc = 4000
	lowerfluc = -1000

//// purchase stuff

/datum/commodity/contraband/command_suit
	comname = "Armored Spacesuit"
	comtype = /obj/item/clothing/suit/space/industrial/syndicate
	desc = "An armored spacesuit issued to Syndicate squad leaders."
	price = 20000
	baseprice = 20000
	upperfluc = 5000
	lowerfluc = -5000

/datum/commodity/contraband/swatmask
	comname = "Scary Gasmask"
	comtype = /obj/item/clothing/mask/gas/swat
	desc = "Pretty much exactly what it sounds like."
	price = 1000
	baseprice = 1000
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/contraband/plutonium
	comname = "Plutonium Core"
	comtype = /obj/item/plutonium_core
	desc = "Stolen from a nuclear warhead."
	price = 999999
	baseprice = 999999
	upperfluc = 0
	lowerfluc = 0

/datum/commodity/contraband/radiojammer
	comname = "Radio Jammer"
	comtype = /obj/item/radiojammer
	desc = "A device that can block radio transmissions around it."
	price = 6000
	baseprice = 6000
	upperfluc = 2000
	lowerfluc = -2000

/datum/commodity/contraband/stealthstorage
	comname = "Stealth Storage"
	comtype = /obj/item/storage/box/syndibox
	desc = "Can take on the appearance of another item. Creates a small dimensional rift in space-time, allowing it to hold multiple items."
	price = 400
	baseprice = 400
	upperfluc = 200
	lowerfluc = -200

/datum/commodity/contraband/chamsuit
	comname = "Chameleon Jumpsuit"
	comtype = /obj/item/clothing/under/chameleon
	desc = "A jumpsuit made of advanced fibres that can change colour to suit the needs of the wearer. Do not expose to electromagnetic interference."
	price = 5000
	baseprice = 5000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/contraband/dnascram
	comname = "DNA Scrambler"
	comtype = /obj/item/genetics_injector/dna_scrambler
	desc = "An injector that gives a new, random identity upon injection."
	price = 15000
	baseprice = 15000
	upperfluc = 3000
	lowerfluc = -3000

/datum/commodity/contraband/voicechanger
	comname = "Voice Changer"
	comtype = /obj/item/voice_changer
	desc = "This voice-modulation device will dynamically disguise your voice to that of whoever is listed on your identification card, via incredibly complex algorithms. Discretely fits inside most masks, and can be removed with wirecutters."
	price = 4000
	baseprice = 4000
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/contraband/briefcase
	comname = "Briefcase Valve Assembly"
	comtype = /obj/item/device/transfer_valve/briefcase
	desc = "Bomb not included."
	price = 2500
	baseprice = 2500
	upperfluc = 1500
	lowerfluc = -1500

/datum/commodity/contraband/disguiser
	comname = "Holographic Disguiser"
	comtype = /obj/item/device/disguiser
	desc = "Another one of those experimental Syndicate holographic projects, seems to be an older model."
	price = 15000
	baseprice = 15000
	upperfluc = 5000
	lowerfluc = -5000

/datum/commodity/contraband/birdbomb
	comname = "12ga AEX ammo"
	comtype = /obj/item/ammo/bullets/aex
	desc = "12 gauge ammo marked 12ga AEX Large Wildlife Dispersal Cartridge. Huh."
	price = 40000
	baseprice = 40000
	upperfluc = 10000
	lowerfluc = -5000

/datum/commodity/contraband/flare
	comname = "12ga Flare Shells"
	comtype = /obj/item/ammo/bullets/flare
	desc = "Military-grade 12 gauge flare shells. Guaranteed to brighten your day."
	price = 15000
	baseprice = 15000
	upperfluc = 2500
	lowerfluc = -2500

/datum/commodity/contraband/eguncell_highcap
	comname = "High-Capacity Power Cell"
	comtype = /obj/item/ammo/power_cell/high_power
	desc = "Power cell with a capacity of 300 PU. Compatible with energy guns and stun batons."
	price = 10000
	baseprice = 10000
	upperfluc = 2500
	lowerfluc = -2500

//NT stuff

/datum/commodity/contraband/ntso_uniform
	comname = "NT-SO uniform"
	comtype = /obj/item/clothing/under/misc/turds
	desc = "Freshly salvaged from an NT transport craft. Best not to ask too many questions."
	price = 1500
	baseprice = 1500
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/contraband/ntso_beret
	comname = "NT-SO beret"
	comtype = /obj/item/clothing/head/NTberet
	desc = "Fancy. Possibly salvaged, possibly stolen, what's it to you?"
	price = 2500
	baseprice = 2500
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/contraband/ntso_vest
	comname = "NT-SO vest"
	comtype = /obj/item/clothing/suit/armor/NT_alt
	desc = "Sure is a pretty shade of blue. Other than that, it's really just a standard armor vest."
	price = 2500
	baseprice = 2500
	upperfluc = 500
	lowerfluc = -500

/////////////////////////////////
////// salvage trader ///////////
/////////////////////////////////

/datum/commodity/salvage
	comname = "Salvaged Junk"
	desc = "Bits of debris."
	onmarket = 0

/datum/commodity/salvage/scrap
	comname = "Scrap Metal"
	comtype = /obj/item/scrap
	price = 10
	baseprice = 10
	upperfluc = 15
	lowerfluc = -5

/datum/commodity/salvage/machinedebris
	comname = "Twisted Shrapnel"
	comtype = /obj/decal/cleanable/machine_debris
	price = 120
	baseprice = 120
	upperfluc = 120
	lowerfluc = -50

/datum/commodity/salvage/robotdebris
	comname = "Robot Debris"
	comtype = /obj/decal/cleanable/robot_debris
	price = 200
	baseprice = 200
	upperfluc = 200
	lowerfluc = -100

/datum/commodity/salvage/robot_upgrades
	comname = "Cyborg Upgrade"
	desc = "A salvaged cyborg upgrade kit."
	onmarket = 0

/datum/commodity/salvage/robot_upgrades/efficiency
	comname = "Cyborg Upgrade (Efficiency)"
	comtype = /obj/item/roboupgrade/efficiency
	price = 5000
	baseprice = 5000
	upperfluc = 150
	lowerfluc = -150

/datum/commodity/salvage/robot_upgrades/expand
	comname = "Cyborg Upgrade (Expansion)"
	comtype = /obj/item/roboupgrade/expand
	price = 6300
	baseprice = 6300
	upperfluc = 150
	lowerfluc = -150

/datum/commodity/salvage/robot_upgrades/selfrepair
	comname = "Cyborg Upgrade (Self-Repair)"
	comtype = /obj/item/roboupgrade/repair
	price = 10000
	baseprice = 10000
	upperfluc = 250
	lowerfluc = -150

/datum/commodity/salvage/robot_upgrades/stunresist
	comname = "Cyborg Upgrade (Recovery)"
	comtype = /obj/item/roboupgrade/aware
	price = 9500
	baseprice = 9500
	upperfluc = 250
	lowerfluc = -150

/datum/commodity/junk
	comname = "Space Junk"
	desc = "Space junk and trinkets."
	onmarket = 0

/datum/commodity/junk/horsemask
	comname = "Horse Mask"
	comtype = /obj/item/clothing/mask/horse_mask
	price = 100
	baseprice = 100
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/junk/batmask
	comname = "Bat Mask"
	comtype = /obj/item/clothing/mask/batman
	price = 350
	baseprice = 350
	upperfluc = 50
	lowerfluc = -50

/datum/commodity/junk/johnny
	comname = "Strange Suit"
	comtype = /obj/item/clothing/suit/johnny_coat
	price = 1500
	baseprice = 1500
	upperfluc = 300
	lowerfluc = -300

/datum/commodity/junk/buddy
	comname = "Robuddy Costume"
	comtype = /obj/item/clothing/suit/robuddy
	price = 600
	baseprice = 600
	upperfluc = 300
	lowerfluc = -300

/datum/commodity/junk/cowboy_boots
	comname = "Cowboy Boots"
	comtype = /obj/item/clothing/shoes/cowboy
	price = 80
	baseprice = 80
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/junk/cowboy_hat
	comname = "Cowboy Hat"
	comtype = /obj/item/clothing/head/cowboy
	price = 60
	baseprice = 60
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/junk/voltron
	comname = "Voltron"
	comtype = /obj/item/device/voltron
	price = 185000
	baseprice = 185000
	upperfluc = 10000
	lowerfluc = -10000

/datum/commodity/junk/cloner_upgrade
	comname = "Cloning Machine Upgrade Board"
	comtype = /obj/item/cloner_upgrade
	price = 2500
	baseprice = 2500
	upperfluc = 750
	lowerfluc = -500

/////////////////////////////////
///////food trader //////////////
/////////////////////////////////

/datum/commodity/produce/special
	desc = "Valuable produce."
	onmarket = 0

/datum/commodity/produce/special/gmelon
	comname = "George Melon"
	comtype = /obj/item/reagent_containers/food/snacks/plant/melon/george
	price = 170
	baseprice = 170
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/produce/special/greengrape
	comname = "Green Grapes"
	comtype = /obj/item/reagent_containers/food/snacks/plant/grape/green
	price = 85
	baseprice = 85
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/produce/special/chilly
	comname = "Chilly Pepper"
	comtype = /obj/item/reagent_containers/food/snacks/plant/chili/chilly
	price = 100
	baseprice = 100
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/produce/special/ghostchili
	comname = "Ghost Chili Pepper"
	comtype = /obj/item/reagent_containers/food/snacks/plant/chili/ghost_chili
	price = 200
	baseprice = 200
	upperfluc = 100
	lowerfluc = -50

/datum/commodity/produce/special/lashberry
	comname = "Lashberry"
	comtype = /obj/item/reagent_containers/food/snacks/plant/lashberry
	price = 700
	baseprice = 700
	upperfluc = 500
	lowerfluc = -250

/datum/commodity/produce/special/glowfruit
	comname = "Glowfruit"
	comtype = /obj/item/reagent_containers/food/snacks/plant/glowfruit
	price = 350
	baseprice = 350
	upperfluc = 200
	lowerfluc = -100

/datum/commodity/produce/special/purplegoop
	comname = "Purple Goop"
	comtype = /obj/item/reagent_containers/food/snacks/plant/purplegoop
	price = 215
	baseprice = 215
	upperfluc = 150
	lowerfluc = -75

// sell

/datum/commodity/diner
	desc = "Diner food of questionable quality."
	onmarket = 0

/datum/commodity/diner/mysteryburger
	comname = "Mystery Burger"
	comtype = /obj/item/reagent_containers/food/snacks/burger/mysteryburger
	price = 7
	baseprice = 7
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/monster
	comname = "THE MONSTER"
	comtype = /obj/item/reagent_containers/food/snacks/burger/monsterburger
	price = 100
	baseprice = 100
	upperfluc = 20
	lowerfluc = -20

/datum/commodity/diner/sloppyjoe
	comname = "Sloppy Joe"
	comtype = /obj/item/reagent_containers/food/snacks/burger/sloppyjoe
	price = 10
	baseprice = 10
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/mashedpotatoes
	comname = "Mashed Potatoes"
	comtype = /obj/item/reagent_containers/food/snacks/mashedpotatoes
	price = 6
	baseprice = 6
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/waffles
	comname = "Waffles"
	comtype = /obj/item/reagent_containers/food/snacks/waffles
	price = 12
	baseprice = 12
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/pancake
	comname = "Pancake"
	comtype = /obj/item/reagent_containers/food/snacks/pancake
	price = 10
	baseprice = 10
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/meatloaf
	comname = "Meatloaf"
	comtype = /obj/item/reagent_containers/food/snacks/meatloaf
	price = 15
	baseprice = 15
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/slurrypie
	comname = "Slurry Pie"
	comtype = /obj/item/reagent_containers/food/snacks/pie/slurry
	price = 12
	baseprice = 12
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/creampie
	comname = "Cream Pie"
	comtype = /obj/item/reagent_containers/food/snacks/pie/cream
	price = 20
	baseprice = 20
	upperfluc = 5
	lowerfluc = -5

/datum/commodity/diner/daily_special
	comname = "Daily Special"
	comtype = null
	price = 15
	baseprice = 15
	upperfluc = 5
	lowerfluc = -5

	New()
		..()
		switch (lowertext( time2text(world.realtime, "Day") ))
			if ("monday")
				comtype = /obj/item/reagent_containers/food/snacks/corndog/banana
			if ("tuesday")
				comtype = /obj/item/reagent_containers/food/snacks/bakedpotato
			if ("wednesday")
				comtype = /obj/item/reagent_containers/food/snacks/breadloaf/corn/sweet/honey
			if ("thursday")
				comtype = /obj/item/reagent_containers/food/snacks/sandwich/meatball
			if ("friday")
				comtype = /obj/item/reagent_containers/food/snacks/burger/fishburger
			if ("saturday")
				comtype = /obj/item/reagent_containers/food/snacks/breakfast
			if ("sunday")
				comtype = /obj/item/reagent_containers/food/snacks/pie/pot

///// body parts

/datum/commodity/bodyparts
	desc = "It's best not to ask too many questions."
	onmarket = 0

/datum/commodity/bodyparts/armL
	comname = "Human Arm - Left"
	comtype = /obj/item/parts/human_parts/arm/left
	price = 2500
	baseprice = 2500
	upperfluc = 1500
	lowerfluc = -500

/datum/commodity/bodyparts/armR
	comname = "Human Arm - Right"
	comtype = /obj/item/parts/human_parts/arm/right
	price = 2500
	baseprice = 2500
	upperfluc = 1500
	lowerfluc = -500

/datum/commodity/bodyparts/legL
	comname = "Human Leg - Left"
	comtype = /obj/item/parts/human_parts/leg/left
	price = 2500
	baseprice = 2500
	upperfluc = 1500
	lowerfluc = -500

/datum/commodity/bodyparts/legR
	comname = "Human Leg - Right"
	comtype = /obj/item/parts/human_parts/leg/right
	price = 2500
	baseprice = 2500
	upperfluc = 1500
	lowerfluc = -500

/datum/commodity/bodyparts/brain
	comname = "Brain"
	comtype = /obj/item/organ/brain
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -1000

/datum/commodity/bodyparts/synthbrain
	comname = "Synthetic Brain"
	comtype = /obj/item/organ/brain/synth
	price = 500
	baseprice = 500
	upperfluc = 250
	lowerfluc = -250

/datum/commodity/bodyparts/aibrain
	comname = "AI Neural Net Processor"
	comtype = /obj/item/organ/brain/ai
	price = 30000
	baseprice = 30000
	upperfluc = 25000
	lowerfluc = -10000

/datum/commodity/bodyparts/butt
	comname = "Human Butt"
	comtype = /obj/item/clothing/head/butt
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -2500

/datum/commodity/bodyparts/synthbutt
	comname = "Synthetic Butt"
	comtype = /obj/item/clothing/head/butt/synth
	price = 300
	baseprice = 300
	upperfluc = 300
	lowerfluc = -150

/datum/commodity/bodyparts/cyberbutt
	comname = "Robutt"
	comtype = /obj/item/clothing/head/butt/cyberbutt
	price = 4000
	baseprice = 4000
	upperfluc = 2000
	lowerfluc = -2000

/datum/commodity/bodyparts/heart
	comname = "Human Heart"
	comtype = /obj/item/organ/heart
	price = 5000
	baseprice = 5000
	upperfluc = 2500
	lowerfluc = -2500

/datum/commodity/bodyparts/synthheart
	comname = "Synthetic Heart"
	comtype = /obj/item/organ/heart/synth
	price = 500
	baseprice = 500
	upperfluc = 250
	lowerfluc = -250

/datum/commodity/bodyparts/cyberheart
	comname = "Cyberheart"
	comtype = /obj/item/organ/heart/cyber
	price = 4000
	baseprice = 4000
	upperfluc = 2000
	lowerfluc = -2000

/datum/commodity/bodyparts/eye
	comname = "Human Eye"
	comtype = /obj/item/organ/eye
	price = 2500
	baseprice = 2500
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/syntheye
	comname = "Synthetic Eye"
	comtype = /obj/item/organ/eye/synth
	price = 250
	baseprice = 250
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/bodyparts/cybereye
	comname = "Cybereye"
	comtype = /obj/item/organ/eye/cyber
	price = 1500
	baseprice = 1500
	upperfluc = 750
	lowerfluc = -750

/datum/commodity/bodyparts/cybereye_sunglass
	comname = "Polarized Cybereye"
	comtype = /obj/item/organ/eye/cyber/sunglass
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/cybereye_thermal
	comname = "Thermal Imager Cybereye"
	comtype = /obj/item/organ/eye/cyber/thermal
	price = 2200
	baseprice = 2200
	upperfluc = 1100
	lowerfluc = -1100

/datum/commodity/bodyparts/cybereye_meson
	comname = "Mesonic Imager Cybereye"
	comtype = /obj/item/organ/eye/cyber/meson
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/cybereye_spectro
	comname = "Spectroscopic Imager Cybereye"
	comtype = /obj/item/organ/eye/cyber/spectro
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/cybereye_prodoc
	comname = "ProDoc Healthview Cybereye"
	comtype = /obj/item/organ/eye/cyber/prodoc
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/cybereye_camera
	comname = "Camera Cybereye"
	comtype = /obj/item/organ/eye/cyber/camera
	price = 2000
	baseprice = 2000
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/bodyparts/cybereye_ecto
	comname = "Ectosensor Cybereye"
	comtype = /obj/item/organ/eye/cyber/ecto
	price = 26000
	baseprice = 26000
	upperfluc = 10000
	lowerfluc = -10000

/datum/commodity/bodyparts/lung
	comname = "Human Lung"
	comtype = /obj/item/organ/lung
	price = 2500
	baseprice = 2500
	upperfluc = 1000
	lowerfluc = -1000

/datum/commodity/medical
	onmarket = 0
	desc = "Medical Supplies."

/datum/commodity/medical/injectorbelt
	comname = "Injector Belt"
	comtype = /obj/item/injector_belt
	price = 5500
	baseprice = 5500
	upperfluc = 1500
	lowerfluc = -1500

/datum/commodity/medical/injectormask
	comname = "Vapo-Matic"
	comtype = /obj/item/clothing/mask/gas/injector_mask
	price = 7000
	baseprice = 7000
	upperfluc = 2500
	lowerfluc = -2500

/*/datum/commodity/medical/strange_reagent
	comname = "Strange Reagent"
	comtype = /obj/item/reagent_containers/glass/beaker/strange_reagent
	price = 25000
	baseprice = 25000
	upperfluc = 10000
	lowerfluc = -10000*/

/datum/commodity/medical/firstaidR
	comname = "First Aid Kit - Regular"
	comtype = /obj/item/storage/firstaid/regular
	price = 500
	baseprice = 500
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/medical/firstaidBr
	comname = "First Aid Kit - Brute"
	comtype = /obj/item/storage/firstaid/brute
	price = 600
	baseprice = 600
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/medical/firstaidB
	comname = "First Aid Kit - Fire"
	comtype = /obj/item/storage/firstaid/fire
	price = 600
	baseprice = 600
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/medical/firstaidT
	comname = "First Aid Kit - Toxin"
	comtype = /obj/item/storage/firstaid/toxin
	price = 600
	baseprice = 600
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/medical/firstaidO
	comname = "First Aid Kit - Suffocation"
	comtype = /obj/item/storage/firstaid/oxygen
	price = 800
	baseprice = 800
	upperfluc = 100
	lowerfluc = -100

/datum/commodity/medical/firstaidN
	comname = "First Aid Kit - Neurological"
	comtype = /obj/item/storage/firstaid/brain
	price = 1200
	baseprice = 1200
	upperfluc = 100
	lowerfluc = -100

///// costume kits

/datum/commodity/costume/bee
	comname = "Bee Costume"
	comtype = /obj/item/storage/box/costume/bee
	desc = "A licensed costume that makes you look like a bumbly bee!"
	price = 500
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/monkey
	comname = "Monkey Costume"
	comtype = /obj/item/storage/box/costume/monkey
	desc = "A licensed costume that makes you look like a monkey!"
	price = 500
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/robuddy
	comname = "Guardbuddy Costume"
	comtype = /obj/item/storage/box/costume/robuddy
	desc = "A licensed costume that makes you look like a PR-6 Guardbuddy!"
	price = 500
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/waltwhite
	comname = "Meth Scientist Costume"
	comtype = /obj/item/storage/box/costume/crap/waltwhite
	price = 100
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/spiderman
	comname = "Red Alien Costume"
	comtype = /obj/item/storage/box/costume/crap/spiderman
	price = 100
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/wonka
	comname = "Victorian Confectionery Factory Owner Costume"
	comtype = /obj/item/storage/box/costume/crap/wonka
	price = 100
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/light_borg //YJHGHTFH's light borg costume
	comname = "Light Cyborg Costume"
	comtype = /obj/item/storage/box/costume/light_borg
	desc = "Beep-bop synthesizer sold separately."
	price = 500
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/costume/utena //YJHGHTFH's utena costume & AffableGiraffe's anthy dress
	comname = "Revolutionary Costume Set"
	comtype = /obj/item/storage/box/costume/utena
	desc = "A set of fancy clothes that may or may not give you the power to revolutionize things. Magic sword not included."
	price = 200
	baseprice = 100
	upperfluc = 150
	lowerfluc = -100

/datum/commodity/balloons //no it ain't a costume kit but it's going in Geoff's wares so idgaf tOt fite me
	comname = "box of balloons"
	comtype = /obj/item/storage/box/balloonbox
	desc = "A box full of colorful balloons!  Neat!"
	price = 50
	baseprice = 50
	upperfluc = 100
	lowerfluc = -50

/// pathology
/datum/commodity/synthmodule
	comname = "Synth-O-Matic module"
	comtype = /obj/item/synthmodule
	desc = "A synth-o-matic module."
	onmarket = 0
	price = 5000
	baseprice = 5000
	upperfluc = 2000
	lowerfluc = -2000

/datum/commodity/synthmodule/vaccine
	comname = "Synth-O-Matic vaccine module"
	comtype = /obj/item/synthmodule/vaccine
	onmarket = 1

/datum/commodity/synthmodule/upgrader
	comname = "Synth-O-Matic efficiency module"
	comtype = /obj/item/synthmodule/upgrader
	onmarket = 1

/datum/commodity/synthmodule/assistant
	comname = "Synth-O-Matic assistant module"
	comtype = /obj/item/synthmodule/assistant
	onmarket = 1

/datum/commodity/synthmodule/synthesizer
	comname = "Synth-O-Matic synthesizer module"
	comtype = /obj/item/synthmodule/synthesizer
	onmarket = 1

/datum/commodity/synthmodule/virii
	comname = "Synth-O-Matic virus module"
	comtype = /obj/item/synthmodule/virii
	onmarket = 1

/datum/commodity/synthmodule/bacteria
	comname = "Synth-O-Matic bacterium module"
	comtype = /obj/item/synthmodule/bacteria
	onmarket = 1

/datum/commodity/synthmodule/fungi
	comname = "Synth-O-Matic fungus module"
	comtype = /obj/item/synthmodule/fungi
	onmarket = 1

/datum/commodity/synthmodule/parasite
	comname = "Synth-O-Matic parasite module"
	comtype = /obj/item/synthmodule/parasite
	onmarket = 1

/datum/commodity/synthmodule/gmcell
	comname = "Synth-O-Matic great mutatis cell module"
	comtype = /obj/item/synthmodule/gmcell
	onmarket = 1

/datum/commodity/synthmodule/radiation
	comname = "Synth-O-Matic irradiation module"
	comtype = /obj/item/synthmodule/radiation
	onmarket = 1

/datum/commodity/pathogensample
	comname = "Pathogen sample"
	comtype = /obj/item/reagent_containers/glass/vial/prepared
	desc = "A sample of pathogen. Probably stolen from a lab somewhere. Handle with care."
	onmarket = 1
	price = 700
	upperfluc = 500
	lowerfluc = -500

/datum/commodity/largeartifact
	comname = "Large Artifact"
	comtype = null
	price = 2000
	baseprice = 2000
	upperfluc = 1500
	lowerfluc = -1500

/datum/commodity/smallartifact
	comname = "Handheld Artifact"
	comtype = null
	price = 400
	baseprice = 400
	upperfluc = 400
	lowerfluc = -200
