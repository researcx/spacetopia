/datum/manufacture
	var/name = null                // Name of the schematic
	var/list/item_paths = list()   // Materials required
	var/list/item_names = list()   // Name of each material
	var/list/item_amounts = list() // How many of each material is needed
	var/list/item_outputs = list() // What the schematic outputs
	var/randomise_output = 0
	// 0 - will create each item in the list once per loop (see manufacturer.dm Line 755)
	// 1 - will pick() a random item in the list once per loop
	// 2 - will pick() a random item before the loop begins then output one of the selected item each loop
	var/create = 1                 // How many times it'll make each thing in the list
	var/time = 5                   // How long it takes to build
	var/category = null            // Tool, Clothing, Resource, Component, Machinery or Miscellaneous
	var/sanity_check_exemption = 0
	var/apply_material = 0

	New()
		if (!sanity_check_exemption)
			src.sanity_check()

	proc/sanity_check()
		if (item_paths.len != item_names.len || item_paths.len != item_amounts.len || item_names.len != item_amounts.len)
			logTheThing("debug", null, null, "<b>Manufacturer:</b> [src.name] schematic requirement lists not properly configured")
			qdel(src)
			return
		if (!item_outputs.len)
			logTheThing("debug", null, null, "<b>Manufacturer:</b> [src.name] schematic output list not properly configured")
			qdel(src)
			return

	proc/modify_output(var/obj/machinery/manufacturer/M, var/atom/A,var/list/materials)
		// use this if you want the outputted item to be customised in any way by the manufacturer
		if (M.malfunction && M.text_bad_output_adjective.len > 0 && prob(66))
			A.name = "[pick(M.text_bad_output_adjective)] [A.name]"
			//A.quality -= rand(25,50)
		if (src.apply_material && materials.len > 0)
			A.setMaterial(getCachedMaterial(materials[1]))
		return 1

/datum/manufacture/mechanics
	name = "Reverse-Engineered Schematic"
	item_paths = list("MET-1","CON-1","CRY-1")
	item_names = list("Metal", "Conductive Material", "Crystal")
	item_amounts = list(1,1,1)
	item_outputs = list(/obj/item/electronics/frame)
	var/frame_path = null

	modify_output(var/obj/machinery/manufacturer/M, var/atom/A)
		if (!(..()))
			return

		if (istype(A,/obj/item/electronics/frame/))
			var/obj/item/electronics/frame/F = A
			if (ispath(src.frame_path))
				F.name = "[src.name] frame"
				F.store_type = src.frame_path
				F.viewstat = 2
				F.secured = 2
				F.icon_state = "dbox"
			else
				qdel(F)
				return

/*
/datum/manufacture/iron
	// purely a test
	name = "Iron"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list("reagent-iron")
	time = 1
	create = 10
	category = "Resource"
*/

/datum/manufacture/crowbar
	name = "Crowbar"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/crowbar)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/screwdriver
	name = "Screwdriver"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/screwdriver)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/wirecutters
	name = "Wirecutters"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/wirecutters)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/wrench
	name = "Wrench"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/wrench)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/flashlight
	name = "Flashlight"
	item_paths = list("MET-1","CON-1","CRY-1")
	item_names = list("Metal","Conductive Material","Crystal")
	item_amounts = list(1,1,1)
	item_outputs = list(/obj/item/device/flashlight)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/vuvuzela
	name = "Vuvuzela"
	item_paths = list("ALL")
	item_names = list("Any Material")
	item_amounts = list(1)
	item_outputs = list(/obj/item/vuvuzela)
	time = 5
	create = 1
	category = "Miscellaneous"

/datum/manufacture/harmonica
	name = "Harmonica"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/harmonica)
	time = 5
	create = 1
	category = "Miscellaneous"

/datum/manufacture/bottle
	name = "Glass Bottle"
	item_paths = list("CRY-1")
	item_names = list("Crystal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/reagent_containers/food/drinks/bottle)
	time = 4
	create = 1
	category = "Miscellaneous"

/datum/manufacture/bikehorn
	name = "Bicycle Horn"
	item_paths = list("ALL")
	item_names = list("Any Material")
	item_amounts = list(1)
	item_outputs = list(/obj/item/bikehorn)
	time = 5
	create = 1
	category = "Miscellaneous"

/datum/manufacture/stunrounds
	name = ".38 Stunner Rounds"
	item_paths = list("MET-1","CON-1", "CRY-1")
	item_names = list("Metal","Conductive Material", "Crystal")
	item_amounts = list(3,2,2)
	item_outputs = list(/obj/item/ammo/bullets/a38/stun)
	time = 20
	create = 1
	category = "Resource"

/datum/manufacture/bullet_22
	name = ".22 Bullets"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(30,24)
	item_outputs = list(/obj/item/ammo/bullets/bullet_22)
	time = 30
	create = 1
	category = "Resource"

/datum/manufacture/bullet_smoke
	name = "40mm Smoke Grenade"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(30,25)
	item_outputs = list(/obj/item/ammo/bullets/smoke)
	time = 35
	create = 1
	category = "Resource"

/datum/manufacture/extinguisher
	name = "Fire Extinguisher"
	item_paths = list("MET-2","CRY-1")
	item_names = list("Sturdy Metal","Crystal")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/extinguisher)
	time = 8
	create = 1
	category = "Tool"

/datum/manufacture/welder
	name = "Welding Tool"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/weldingtool)
	time = 8
	create = 1
	category = "Tool"

/datum/manufacture/soldering
	name = "Soldering Iron"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(1,2)
	item_outputs = list(/obj/item/electronics/soldering)
	time = 8
	create = 1
	category = "Tool"

/datum/manufacture/stapler
	name = "Staple Gun"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(2,1)
	item_outputs = list(/obj/item/staple_gun)
	time = 10
	create = 1
	category = "Tool"

/datum/manufacture/multitool
	name = "Multi Tool"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/device/multitool)
	time = 8
	create = 1
	category = "Tool"

/datum/manufacture/weldingmask
	name = "Welding Mask"
	item_paths = list("MET-2","CRY-1")
	item_names = list("Sturdy Metal","Crystal")
	item_amounts = list(2,2)
	item_outputs = list(/obj/item/clothing/head/helmet/welding)
	time = 10
	create = 1
	category = "Clothing"

/datum/manufacture/light_bulb
	name = "Light Bulb Box"
	item_paths = list("CRY-1")
	item_names = list("Crystal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs)
	time = 4
	create = 1
	category = "Resource"

/datum/manufacture/red_bulb
	name = "Red Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/red)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/yellow_bulb
	name = "Yellow Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/yellow)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/green_bulb
	name = "Green Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/green)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/cyan_bulb
	name = "Cyan Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/cyan)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/blue_bulb
	name = "Blue Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/blue)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/purple_bulb
	name = "Purple Light Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/purple)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/blacklight_bulb
	name = "Blacklight Bulb Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/bulbs/blacklight)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/light_tube
	name = "Light Tube Box"
	item_paths = list("CRY-1")
	item_names = list("Crystal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes)
	time = 4
	create = 1
	category = "Resource"

/datum/manufacture/red_tube
	name = "Red Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/red)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/yellow_tube
	name = "Yellow Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/yellow)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/green_tube
	name = "Green Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/green)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/cyan_tube
	name = "Cyan Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/cyan)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/blue_tube
	name = "Blue Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/blue)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/purple_tube
	name = "Purple Light Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/purple)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/blacklight_tube
	name = "Blacklight Tube Box"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/storage/box/lightbox/tubes/blacklight)
	time = 8
	create = 1
	category = "Resource"

/datum/manufacture/metal
	name = "Metal Sheet"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/sheet)
	time = 2
	create = 1
	category = "Resource"
	apply_material = 1

/datum/manufacture/metalR
	name = "Reinforced Metal"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(2)
	item_outputs = list(/obj/item/sheet)
	time = 12
	create = 1
	category = "Resource"
	apply_material = 1

	modify_output(var/obj/machinery/manufacturer/M, var/atom/A, var/list/materials)
		..()
		var/obj/item/sheet/S = A
		if (materials.len > 1)
			S.set_reinforcement(materials[2])
		else
			S.set_reinforcement(materials[1])

/datum/manufacture/glass
	name = "Glass Panel"
	item_paths = list("CRY-1")
	item_names = list("Crystal")
	item_amounts = list(5)
	item_outputs = list(/obj/item/sheet)
	time = 8
	create = 5
	category = "Resource"
	apply_material = 1

/datum/manufacture/glassR
	name = "Reinforced Glass Panel"
	item_paths = list("CRY-1","MET-2")
	item_names = list("Crystal","Sturdy Metal")
	item_amounts = list(1,1)
	item_outputs = list(/obj/item/sheet/glass/reinforced)
	time = 12
	create = 1
	category = "Resource"
	apply_material = 1

	modify_output(var/obj/machinery/manufacturer/M, var/atom/A, var/list/materials)
		..()
		var/obj/item/sheet/S = A
		S.set_reinforcement(materials[2])

/datum/manufacture/rods2
	name = "Metal Rods (x2)"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/rods)
	time = 3
	create = 5
	category = "Resource"
	apply_material = 1

	modify_output(var/obj/machinery/manufacturer/M, var/atom/A)
		..()
		var/obj/item/sheet/S = A
		S.amount = 2

/datum/manufacture/atmos_can
	name = "Portable Gas Canister"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(3)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister)
	time = 10
	create = 1
	category = "Machinery"

//// cogwerks - gas extraction stuff

/datum/manufacture/co2_can
	name = "CO2 Canister"
	item_paths = list("MET-2","ALL")
	item_names = list("Sturdy Metal","Char")//Any Material")
	item_amounts = list(3,10)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister/carbon_dioxide)
	time = 100
	create = 1
	category = "Machinery"

/datum/manufacture/o2_can
	name = "O2 Canister"
	item_paths = list("MET-2","ALL")
	item_names = list("Sturdy Metal","Molitz")
	item_amounts = list(3,10)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister/oxygen)
	time = 100
	create = 1
	category = "Machinery"

/datum/manufacture/plasma_can
	name = "Plasma Canister"
	item_paths = list("MET-2","plasmastone")
	item_names = list("Sturdy Metal","Plasmastone")
	item_amounts = list(3,10)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister/toxins)
	time = 100
	create = 1
	category = "Machinery"

/datum/manufacture/n2_can
	name = "N2 Canister"
	item_paths = list("MET-2","cerenkite")
	item_names = list("Sturdy Metal","Cerenkite")
	item_amounts = list(3,10)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister/nitrogen)
	time = 100
	create = 1
	category = "Machinery"

/datum/manufacture/n2o_can
	name = "N2O Canister"
	item_paths = list("MET-2","koshmarite")
	item_names = list("Sturdy Metal","Koshmarite")
	item_amounts = list(3,10)
	item_outputs = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent)
	time = 100
	create = 1
	category = "Machinery"

////////////////////////////////

/datum/manufacture/circuit_board
	name = "Circuit Board"
	item_paths = list("CON-1")
	item_names = list("Conductive Material")
	item_amounts = list(2)
	item_outputs = list(/obj/item/electronics/board)
	time = 5
	create = 1
	category = "Component"

/datum/manufacture/cable
	name = "Electrical Cable Coil"
	item_paths = list("INS-1", "CON-1")
	item_names = list("Insulative Material", "Conductive Material")
	item_amounts = list(10, 10)
	item_outputs = list(/obj/item/cable_coil)
	time = 3
	create = 1
	category = "Resource"
	apply_material = 0

	modify_output(var/obj/machinery/manufacturer/M, var/atom/A,var/list/materials)
		..()
		var/obj/item/cable_coil/coil = A
		var/min_cond = 1
		var/max_cond = 0
		var/min_cond_mat = null
		var/max_cond_mat = null
		for (var/mat_id in materials)
			var/datum/material/cand = getCachedMaterial(mat_id)
			if (!cand)
				continue
			if (cand.getProperty(PROP_ELECTRICAL) < min_cond)
				min_cond = cand.getProperty(PROP_ELECTRICAL)
				min_cond_mat = cand
			else if (cand.getProperty(PROP_ELECTRICAL) > max_cond)
				max_cond = cand.getProperty(PROP_ELECTRICAL)
				max_cond_mat = cand
		coil.setInsulator(min_cond_mat)
		coil.setConductor(max_cond_mat)
		return 1

/datum/manufacture/RCD
	name = "Rapid Construction Device"
	item_paths = list("MET-3","DEN-1","CON-1")
	item_names = list("Heavy Metal","High Density Material","Conductive Material")
	item_amounts = list(5,1,10)
	item_outputs = list(/obj/item/rcd)
	time = 90
	create = 1
	category = "Tool"

/datum/manufacture/RCDammo
	name = "Compressed Matter Cartridge"
	item_paths = list("DEN-1")
	item_names = list("High Density Material")
	item_amounts = list(5)
	item_outputs = list(/obj/item/rcd_ammo)
	time = 10
	create = 1
	category = "Resource"

/datum/manufacture/RCDammolarge
	name = "Large Compressed Matter Cartridge"
	item_paths = list("DEN-1")
	item_names = list("High Density Material")
	item_amounts = list(45)
	item_outputs = list(/obj/item/rcd_ammo/big)
	time = 30
	create = 1
	category = "Resource"

/datum/manufacture/jumpsuit
	name = "Grey Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/grey)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/shoes
	name = "Black Shoes"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(3)
	item_outputs = list(/obj/item/clothing/shoes/black)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/shoes_white
	name = "White Shoes"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(3)
	item_outputs = list(/obj/item/clothing/shoes/white)
	time = 5
	create = 1
	category = "Clothing"

/******************** Medical **************************/

/datum/manufacture/scalpel
	name = "Scalpel"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/scalpel)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/circular_saw
	name = "Circular Saw"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/circular_saw)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/surgical_spoon
	name = "Enucleation Spoon"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/surgical_spoon)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/suture
	name = "Suture"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/suture)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/deafhs
	name = "Auditory Headset"
	item_paths = list("CON-1","CRY-1")
	item_names = list("Conductive Material","Crystal")
	item_amounts = list(3,3)
	item_outputs = list(/obj/item/device/radio/headset/deaf)
	time = 40
	create = 1
	category = "Clothing"

/datum/manufacture/visor
	name = "VISOR Prosthesis"
	item_paths = list("CON-1","CRY-1")
	item_names = list("Conductive Material","Crystal")
	item_amounts = list(3,3)
	item_outputs = list(/obj/item/clothing/glasses/visor)
	time = 40
	create = 1
	category = "Clothing"

/datum/manufacture/hypospray
	name = "Hypospray"
	item_paths = list("MET-1","CON-1","CRY-1")
	item_names = list("Metal","Conductive Material","Crystal")
	item_amounts = list(2,2,2)
	item_outputs = list(/obj/item/reagent_containers/hypospray)
	time = 40
	create = 1
	category = "Tool"

/datum/manufacture/prodocs
	name = "ProDoc Healthgoggles"
	item_paths = list("MET-1","CRY-1")
	item_names = list("Metal","Crystal")
	item_amounts = list(1,2)
	item_outputs = list(/obj/item/clothing/glasses/healthgoggles)
	time = 20
	create = 1
	category = "Clothing"

/datum/manufacture/cyberheart
	name = "Cyberheart"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(3,3,2)
	item_outputs = list(/obj/item/organ/heart/cyber)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cyberbutt
	name = "Cyberbutt"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(2,2,2)
	item_outputs = list(/obj/item/clothing/head/butt/cyberbutt)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/cybereye
	name = "Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(2,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber)
	time = 20
	create = 1
	category = "Component"

/datum/manufacture/cybereye_sunglass
	name = "Polarized Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/sunglass)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cybereye_thermal
	name = "Thermal Imager Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/thermal)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cybereye_meson
	name = "Mesonic Imager Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/meson)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cybereye_spectro
	name = "Spectroscopic Imager Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/spectro)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cybereye_prodoc
	name = "ProDoc Healthview Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/prodoc)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/cybereye_camera
	name = "Camera Cybereye"
	item_paths = list("CRY-1","MET-1","CON-1","INS-1")
	item_names = list("Crystal","Metal","Conductive Material","Insulative Material")
	item_amounts = list(3,1,2,1)
	item_outputs = list(/obj/item/organ/eye/cyber/camera)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/implant_health
	name = "Health Monitor Implant"
	item_paths = list("CON-1","CRY-1")
	item_names = list("Conductive Material","Crystal")
	item_amounts = list(3,3)
	item_outputs = list(/obj/item/implantcase/health)
	time = 40
	create = 1
	category = "Resource"

/******************** Robotics **************************/

/datum/manufacture/robo_frame
	name = "Cyborg Frame"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(18)
	item_outputs = list(/obj/item/parts/robot_parts/robot_frame)
	time = 45
	create = 1
	category = "Component"

/datum/manufacture/full_cyborg_standard
	name = "Standard Cyborg Parts"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(48)
	item_outputs = list(/obj/item/parts/robot_parts/chest,/obj/item/parts/robot_parts/head,
/obj/item/parts/robot_parts/arm/right,/obj/item/parts/robot_parts/arm/left,
/obj/item/parts/robot_parts/leg/right,/obj/item/parts/robot_parts/leg/left)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/full_cyborg_light
	name = "Light Cyborg Parts"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(24)
	item_outputs = list(/obj/item/parts/robot_parts/chest/light,/obj/item/parts/robot_parts/head/light,
/obj/item/parts/robot_parts/arm/right/light,/obj/item/parts/robot_parts/arm/left/light,
/obj/item/parts/robot_parts/leg/right/light,/obj/item/parts/robot_parts/leg/left/light)
	time = 62
	create = 1
	category = "Component"

/datum/manufacture/robo_chest
	name = "Cyborg Chest"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(12)
	item_outputs = list(/obj/item/parts/robot_parts/chest)
	time = 30
	create = 1
	category = "Component"

/datum/manufacture/robo_chest_light
	name = "Light Cyborg Chest"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/chest/light)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_head
	name = "Cyborg Head"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(12)
	item_outputs = list(/obj/item/parts/robot_parts/head)
	time = 30
	create = 1
	category = "Component"

/datum/manufacture/robo_head_light
	name = "Light Cyborg Head"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/head/light)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_arm_r
	name = "Cyborg Arm (Right)"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/arm/right)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_arm_r_light
	name = "Light Cyborg Arm (Right)"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(3)
	item_outputs = list(/obj/item/parts/robot_parts/arm/right/light)
	time = 8
	create = 1
	category = "Component"

/datum/manufacture/robo_arm_l
	name = "Cyborg Arm (Left)"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/arm/left)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_arm_l_light
	name = "Light Cyborg Arm (Left)"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(3)
	item_outputs = list(/obj/item/parts/robot_parts/arm/left/light)
	time = 8
	create = 1
	category = "Component"

/datum/manufacture/robo_leg_r
	name = "Cyborg Leg (Right)"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/leg/right)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_leg_r_light
	name = "Light Cyborg Leg (Right)"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(3)
	item_outputs = list(/obj/item/parts/robot_parts/leg/right/light)
	time = 8
	create = 1
	category = "Component"

/datum/manufacture/robo_leg_l
	name = "Cyborg Leg (Left)"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(6)
	item_outputs = list(/obj/item/parts/robot_parts/leg/left)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_leg_l_light
	name = "Light Cyborg Leg (Left)"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(3)
	item_outputs = list(/obj/item/parts/robot_parts/leg/left/light)
	time = 8
	create = 1
	category = "Component"

/datum/manufacture/robo_leg_treads
	name = "Cyborg Treads"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(12,6)
	item_outputs = list(/obj/item/parts/robot_parts/leg/left/treads, /obj/item/parts/robot_parts/leg/right/treads)//list(/obj/item/parts/robot_parts/leg/treads)
	time = 15
	create = 1
	category = "Component"

/datum/manufacture/robo_stmodule
	name = "Standard Cyborg Module"
	item_paths = list("CON-1","ALL")
	item_names = list("Conductive Material","Any Material")
	item_amounts = list(2,3)
	item_outputs = list(/obj/item/robot_module/standard)
	time = 40
	create = 1
	category = "Component"

/datum/manufacture/powercell
	name = "Power Cell"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(4,4,4)
	item_outputs = list(/obj/item/cell/supercell)
	time = 30
	create = 1
	category = "Component"

/datum/manufacture/powercellE
	name = "Erebite Power Cell"
	item_paths = list("MET-1","ALL","erebite")
	item_names = list("Metal","Any Material","Erebite")
	item_amounts = list(4,4,2)
	item_outputs = list(/obj/item/cell/erebite)
	time = 45
	create = 1
	category = "Component"

/datum/manufacture/powercellC
	name = "Cerenkite Power Cell"
	item_paths = list("MET-1","ALL","cerenkite")
	item_names = list("Metal","Any Material","Cerenkite")
	item_amounts = list(4,4,2)
	item_outputs = list(/obj/item/cell/cerenkite)
	time = 45
	create = 1
	category = "Component"

/datum/manufacture/shell_frame
	name = "AI Shell Frame"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(12)
	item_outputs = list(/obj/item/shell_frame)
	time = 25
	create = 1
	category = "Component"

/datum/manufacture/ai_interface
	name = "AI Interface Board"
	item_paths = list("MET-2","CON-1","CRY-1")
	item_names = list("Sturdy Metal","Conductive Material","Crystal")
	item_amounts = list(3,5,2)
	item_outputs = list(/obj/item/ai_interface)
	time = 35
	create = 1
	category = "Component"

/datum/manufacture/shell_cell
	name = "AI Shell Power Cell"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(2,2,1)
	item_outputs = list(/obj/item/cell/shell_cell)
	time = 20
	create = 1
	category = "Component"

/datum/manufacture/flash
	name = "Flash"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(2,2)
	item_outputs = list(/obj/item/device/flash)
	time = 15
	create = 1
	category = "Tool"

// Robotics Research

/datum/manufacture/implanter
	name = "Implanter"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/implanter)
	time = 3
	create = 1
	category = "Tool"

/datum/manufacture/secbot
	name = "Security Drone"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(10,5,5)
	item_outputs = list(/obj/machinery/bot/secbot)
	time = 60
	create = 1
	category = "Machinery"

/datum/manufacture/floorbot
	name = "Construction Drone"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(10,5,5)
	item_outputs = list(/obj/machinery/bot/floorbot)
	time = 60
	create = 1
	category = "Machinery"

/datum/manufacture/medbot
	name = "Medical Drone"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(10,5,5)
	item_outputs = list(/obj/machinery/bot/medbot)
	time = 60
	create = 1
	category = "Machinery"

/datum/manufacture/firebot
	name = "Firefighting Drone"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(10,5,5)
	item_outputs = list(/obj/machinery/bot/firebot)
	time = 60
	create = 1
	category = "Machinery"

/datum/manufacture/cleanbot
	name = "Sanitation Drone"
	item_paths = list("MET-1","CON-1","ALL")
	item_names = list("Metal","Conductive Material","Any Material")
	item_amounts = list(10,5,5)
	item_outputs = list(/obj/machinery/bot/cleanbot)
	time = 60
	create = 1
	category = "Machinery"

/datum/manufacture/robup_jetpack
	name = "Propulsion Upgrade"
	item_paths = list("CON-1","MET-1")
	item_names = list("Conductive Material","Sturdy Metal")
	item_amounts = list(3,5)
	item_outputs = list(/obj/item/roboupgrade/jetpack)
	time = 60
	create = 1
	category = "Component"

/datum/manufacture/robup_speed
	name = "Speed Upgrade"
	item_paths = list("CON-1","CRY-1")
	item_names = list("Conductive Material","Crystal")
	item_amounts = list(3,5)
	item_outputs = list(/obj/item/roboupgrade/speed)
	time = 60
	create = 1
	category = "Component"

/datum/manufacture/robup_recharge
	name = "Recharge Pack"
	item_paths = list("CON-1")
	item_names = list("Conductive Material")
	item_amounts = list(5)
	item_outputs = list(/obj/item/roboupgrade/rechargepack)
	time = 60
	create = 1
	category = "Component"

/datum/manufacture/robup_repairpack
	name = "Repair Pack"
	item_paths = list("CON-1")
	item_names = list("Conductive Material")
	item_amounts = list(5)
	item_outputs = list(/obj/item/roboupgrade/repairpack)
	time = 60
	create = 1
	category = "Component"

/datum/manufacture/robup_physshield
	name = "Force Shield Upgrade"
	item_paths = list("CON-2", "MET-2", "POW-2")
	item_names = list("High Energy Conductor","Sturdy Metal","Significant Power Source")
	item_amounts = list(2,10,2)
	item_outputs = list(/obj/item/roboupgrade/physshield)
	time = 90
	create = 1
	category = "Component"

/datum/manufacture/robup_fireshield
	name = "Heat Shield Upgrade"
	item_paths = list("CON-2","CRY-1")
	item_names = list("High Energy Conductor","Crystal")
	item_amounts = list(2,10)
	item_outputs = list(/obj/item/roboupgrade/fireshield)
	time = 90
	create = 1
	category = "Component"

/datum/manufacture/robup_aware
	name = "Recovery Upgrade"
	item_paths = list("CON-2","CRY-1","CON-1")
	item_names = list("High Energy Conductor","Crystal","Conductive Material")
	item_amounts = list(2,5,5)
	item_outputs = list(/obj/item/roboupgrade/aware)
	time = 90
	create = 1
	category = "Component"

/datum/manufacture/robup_efficiency
	name = "Efficiency Upgrade"
	item_paths = list("DEN-1","CON-2")
	item_names = list("High Density Matter","High Energy Conductor")
	item_amounts = list(3,10)
	item_outputs = list(/obj/item/roboupgrade/efficiency)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/robup_repair
	name = "Self-Repair Upgrade"
	item_paths = list("DEN-1","MET-3")
	item_names = list("High Density Matter","Dense Metal")
	item_amounts = list(3,10)
	item_outputs = list(/obj/item/roboupgrade/repair)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/robup_teleport
	name = "Teleport Upgrade"
	item_paths = list("CON-1","DEN-1", "POW-2") //Okay enough roundstart teleportborgs. Fuck.
	item_names = list("Conductive Material","High Density Matter", "Significant Power Source")
	item_amounts = list(10,1, 10)
	item_outputs = list(/obj/item/roboupgrade/teleport)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/robup_expand
	name = "Expansion Upgrade"
	item_paths = list("DEN-1","POW-1")
	item_names = list("High Density Matter","Power Source")
	item_amounts = list(3,1)
	item_outputs = list(/obj/item/roboupgrade/expand)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/robup_meson
	name = "Optical Meson Upgrade"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(2,4)
	item_outputs = list(/obj/item/roboupgrade/opticmeson)
	time = 90
	create = 1
	category = "Component"
/* shit done be broked
/datum/manufacture/robup_thermal
	name = "Optical Thermal Upgrade"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(4,8)
	item_outputs = list(/obj/item/roboupgrade/opticthermal)
	time = 90
	create = 1
	category = "Component"
*/
/datum/manufacture/robup_healthgoggles
	name = "ProDoc Healthgoggle Upgrade"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(4,6)
	item_outputs = list(/obj/item/roboupgrade/healthgoggles)
	time = 90
	create = 1
	category = "Component"

/datum/manufacture/robup_visualizer
	name = "Construction Visualizer"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(4,6)
	item_outputs = list(/obj/item/roboupgrade/visualizer)
	time = 90
	create = 1
	category = "Component"

/datum/manufacture/implant_robotalk
	name = "Machine Translator Implant"
	item_paths = list("CON-1","CRY-1")
	item_names = list("Conductive Material","Crystal")
	item_amounts = list(3,3)
	item_outputs = list(/obj/item/implantcase/robotalk)
	time = 40
	create = 1
	category = "Resource"

// Mining Gear

/datum/manufacture/mining_magnet
	name = "Mining Magnet Replacement Parts"
	item_paths = list("DEN-1","MET-3","CON-2")
	item_names = list("High Density Matter","Dense Metal","High Energy Conductor")
	item_amounts = list(5,30,30)
	item_outputs = list(/obj/item/magnet_parts)
	time = 120
	create = 1
	category = "Component"

/datum/manufacture/pick
	name = "Pickaxe"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(1)
	item_outputs = list(/obj/item/mining_tool)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/powerpick
	name = "Powered Pick"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(2,5)
	item_outputs = list(/obj/item/mining_tool/power_pick)
	time = 10
	create = 1
	category = "Tool"

/datum/manufacture/blastchargeslite
	name = "Low-Yield Mining Explosives (x5)"
	item_paths = list("MET-1","CRY-1","CON-1")
	item_names = list("Metal","Crystal","Conductive Material")
	item_amounts = list(3,3,7)
	item_outputs = list(/obj/item/breaching_charge/mining/light)
	time = 40
	create = 5
	category = "Resource"

/datum/manufacture/blastcharges
	name = "Mining Explosives (x5)"
	item_paths = list("MET-1","CRY-1","CON-1")
	item_names = list("Metal","Crystal","Conductive Material")
	item_amounts = list(7,7,15)
	item_outputs = list(/obj/item/breaching_charge/mining)
	time = 60
	create = 5
	category = "Resource"

/datum/manufacture/powerhammer
	name = "Power Hammer"
	item_paths = list("DEN-1","CON-1")
	item_names = list("High Density Matter","Conductive Material")
	item_amounts = list(1,8)
	item_outputs = list(/obj/item/mining_tool/powerhammer)
	time = 70
	create = 1
	category = "Tool"

/datum/manufacture/drill
	name = "Laser Drill"
	item_paths = list("MET-2","MET-3","CON-2")
	item_names = list("Sturdy Metal","Dense Metal","High Energy Conductor")
	item_amounts = list(15,7,10)
	item_outputs = list(/obj/item/mining_tool/drill)
	time = 90
	create = 1
	category = "Tool"

/datum/manufacture/conc_gloves
	name = "Concussive Gauntlets"
	item_paths = list("MET-3","CON-2","POW-1")
	item_names = list("Dense Metal","High Energy Conductor","Power Source")
	item_amounts = list(15,15,2)
	item_outputs = list(/obj/item/clothing/gloves/concussive)
	time = 120
	create = 1
	category = "Tool"

/datum/manufacture/ore_accumulator
	name = "Mineral Accumulator"
	item_paths = list("MET-2","CON-2","DEN-1")
	item_names = list("Sturdy Metal","High Energy Conductor","High Density Matter")
	item_amounts = list(25,15,2)
	item_outputs = list(/obj/machinery/oreaccumulator)
	time = 120
	create = 1
	category = "Machinery"

/datum/manufacture/eyes_meson
	name = "Optical Meson Scanner"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(3,2)
	item_outputs = list(/obj/item/clothing/glasses/meson)
	time = 10
	create = 1
	category = "Clothing"

/datum/manufacture/geoscanner
	name = "Geological Scanner"
	item_paths = list("MET-1","CON-1","CRY-1")
	item_names = list("Metal","Conductive Material","Crystal")
	item_amounts = list(1,1,1)
	item_outputs = list(/obj/item/oreprospector)
	time = 8
	create = 1
	category = "Tool"

/datum/manufacture/industrialarmor
	name = "Industrial Space Armor Set"
	item_paths = list("MET-3","CON-2","DEN-1")
	item_names = list("Dense Metal","High Energy Conductor","High Density Matter")
	item_amounts = list(15,7,3)
	item_outputs = list(/obj/item/clothing/suit/space/industrial,/obj/item/clothing/head/helmet/space/industrial)
	time = 90
	create = 1
	category = "Clothing"

/datum/manufacture/industrialboots
	name = "Mechanised Boots"
	item_paths = list("MET-2","CON-2","POW-1")
	item_names = list("Sturdy Metal","High Energy Conductor","Power Source")
	item_amounts = list(15,7,3)
	item_outputs = list(/obj/item/clothing/shoes/industrial)
	time = 40
	create = 1
	category = "Clothing"

/datum/manufacture/breathmask
	name = "Breath Mask"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(1)
	item_outputs = list(/obj/item/clothing/mask/breath)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/patch
	name = "Chemical Patch"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(1)
	item_outputs = list(/obj/item/reagent_containers/patch)
	time = 5
	create = 2
	category = "Resource"

/datum/manufacture/spacesuit
	name = "Space Suit Set"
	item_paths = list("FAB-1","MET-1","CRY-1")
	item_names = list("Fabric","Metal","Crystal")
	item_amounts = list(3,3,2)
	item_outputs = list(/obj/item/clothing/suit/space,/obj/item/clothing/head/helmet/space)
	time = 15
	create = 1
	category = "Clothing"

/datum/manufacture/engspacesuit
	name = "Engineering Space Suit Set"
	item_paths = list("FAB-1","MET-1","CRY-1")
	item_names = list("Fabric","Metal","Crystal")
	item_amounts = list(3,3,2)
	item_outputs = list(/obj/item/clothing/suit/space/engineer,/obj/item/clothing/head/helmet/space/engineer)
	time = 15
	create = 1
	category = "Clothing"

/datum/manufacture/oresatchel
	name = "Ore Satchel"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(5)
	item_outputs = list(/obj/item/satchel/mining)
	time = 5
	create = 1
	category = "Tool"

/datum/manufacture/oresatchelL
	name = "Large Ore Satchel"
	item_paths = list("FAB-1","MET-3")
	item_names = list("Fabric","Dense Metal")
	item_amounts = list(25,3)
	item_outputs = list(/obj/item/satchel/mining/large)
	time = 15
	create = 1
	category = "Tool"

/datum/manufacture/jetpack
	name = "Jetpack"
	item_paths = list("MET-3","CON-1")
	item_names = list("Dense Metal","Conductive Material")
	item_amounts = list(2,10)
	item_outputs = list(/obj/item/tank/jetpack)
	time = 60
	create = 1
	category = "Clothing"

/// Ship Items -- OLD COMPONENTS

/datum/manufacture/engine
	name = "Warp-1 Engine"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(3,5)
	item_outputs = list(/obj/item/shipcomponent/engine)
	time = 10
	create = 1
	category = "Resource"

/datum/manufacture/engine2
	name = "Helios Mark-II Engine"
	item_paths = list("MET-2","MET-3","CON-2")
	item_names = list("Sturdy Metal","Dense Metal","High Energy Conductor")
	item_amounts = list(20,10,15)
	item_outputs = list(/obj/item/shipcomponent/engine/helios)
	time = 90
	create = 1
	category = "Resource"

/datum/manufacture/engine3
	name = "Hermes 3.0 Engine"
	item_paths = list("MET-3","CON-2","POW-1")
	item_names = list("Dense Metal","High Energy Conductor","Power Source")
	item_amounts = list(20,20,5)
	item_outputs = list(/obj/item/shipcomponent/engine/hermes)
	time = 120
	create = 1
	category = "Resource"


/datum/manufacture/gps
	name = "Ship's Navigation GPS"
	item_paths = list("MET-1")
	item_names = list("Metal")
	item_amounts = list(2)
	item_outputs = list(/obj/item/shipcomponent/secondary_system/gps)
	time = 12
	create = 1
	category = "Resource"

/datum/manufacture/cargohold
	name = "Cargo Hold"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(20)
	item_outputs = list(/obj/item/shipcomponent/secondary_system/cargo)
	time = 12
	create = 1
	category = "Resource"

/datum/manufacture/shipRCD
	name = "Duracorp Construction Device"
	item_paths = list("MET-3","DEN-1","CON-1")
	item_names = list("Dense Metal","High Density Matter","Conductive Material")
	item_amounts = list(5,1,10)
	item_outputs = list(/obj/item/shipcomponent/secondary_system/cargo)
	time = 90
	create = 1
	category = "Resource"

/datum/manufacture/conclave
	name = "Conclave A-1984 Sensor System"
	item_paths = list("POW-1","CRY-1","CON-2")
	item_names = list("Power Source","Crystal","High Energy Conductor")
	item_amounts = list(1,5,2)
	item_outputs = list(/obj/item/shipcomponent/sensor/mining)
	time = 5
	create = 1
	category = "Resource"

//  cogwerks - clothing manufacturer datums

/datum/manufacture/shoes_brown
	name = "Brown Shoes"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/shoes/brown)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_white
	name = "White Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/white)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_black
	name = "Black Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/black)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_blue
	name = "Blue Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/blue)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_red
	name = "Red Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/red)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_green
	name = "Green Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/green)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_yellow
	name = "Yellow Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(2)
	item_outputs = list(/obj/item/clothing/head/yellow)
	time = 2
	create = 1
	category = "Clothing"

/datum/manufacture/hat_tophat
	name = "Top Hat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(3)
	item_outputs = list(/obj/item/clothing/head/that)
	time = 3
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_white
	name = "White Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/white)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_red
	name = "Red Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/red)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_yellow
	name = "Yellow Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/yellow)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_green
	name = "Green Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/green)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_pink
	name = "Pink Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/pink)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_blue
	name = "Blue Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/blue)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_brown
	name = "Brown Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/brown)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_black
	name = "Black Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/jumpsuit_orange
	name = "Orange Jumpsuit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/color/orange)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/suit_black
	name = "Fancy Black Suit"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/suit)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/labcoat
	name = "Labcoat"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/suit/labcoat)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/scrubs_white
	name = "White Scrubs"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/scrub)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/scrubs_teal
	name = "Teal Scrubs"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/scrub/teal)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/scrubs_maroon
	name = "Maroon Scrubs"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/scrub/maroon)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/scrubs_blue
	name = "Blue Scrubs"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(4)
	item_outputs = list(/obj/item/clothing/under/scrub/blue)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/surgical_mask
	name = "Sterile Mask"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(1)
	item_outputs = list(/obj/item/clothing/mask/surgical)
	time = 5
	create = 1
	category = "Clothing"

/datum/manufacture/surgical_shield
	name = "Surgical Face Shield"
	item_paths = list("FAB-1")
	item_names = list("Fabric")
	item_amounts = list(1)
	item_outputs = list(/obj/item/clothing/mask/surgical_shield)
	time = 5
	create = 1
	category = "Clothing"

/////// pod construction components

/datum/manufacture/pod/parts
	name = "Pod Frame Kit"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(30)
	item_outputs = list(/obj/item/pod/frame_box)
	time = 20
	create = 1
	category = "Component"

/datum/manufacture/pod/engine
	name = "Engine Manifold"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(10,5)
	item_outputs = list(/obj/item/pod/engine)
	time = 10
	create = 1
	category = "Component"

/datum/manufacture/pod/boards
	name = "Pod Circuitry"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(5,5)
	item_outputs = list(/obj/item/pod/boards)
	time = 10
	create = 1
	category = "Component"

/datum/manufacture/pod/armor_light
	name = "Light Pod Armor"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(30,20)
	item_outputs = list(/obj/item/pod/armor_light)
	time = 20
	create = 1
	category = "Component"

/datum/manufacture/pod/armor_heavy
	name = "Heavy Pod Armor"
	item_paths = list("MET-2","MET-3")
	item_names = list("Sturdy Metal","Dense Metal")
	item_amounts = list(30,20)
	item_outputs = list(/obj/item/pod/armor_heavy)
	time = 30
	create = 1
	category = "Component"

/datum/manufacture/pod/armor_industrial
	name = "Industrial Pod Armor"
	item_paths = list("MET-3","CON-2","DEN-1")
	item_names = list("Dense Metal","High Energy Conductor","High Density Matter")
	item_amounts = list(25,10,5)
	item_outputs = list(/obj/item/pod/armor_industrial)
	time = 50
	create = 1
	category = "Component"

/datum/manufacture/pod/control
	name = "Pod Control Interface"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(10,10)
	item_outputs = list(/obj/item/pod/control)
	time = 10
	create = 1
	category = "Component"

/datum/manufacture/putt/parts
	name = "MiniPutt Frame Kit"
	item_paths = list("MET-2")
	item_names = list("Sturdy Metal")
	item_amounts = list(15)
	item_outputs = list(/obj/item/putt/frame_box)
	time = 10
	create = 1
	category = "Component"

/datum/manufacture/putt/engine
	name = "MiniPutt Engine Manifold"
	item_paths = list("MET-2","CON-1")
	item_names = list("Sturdy Metal","Conductive Material")
	item_amounts = list(5,2)
	item_outputs = list(/obj/item/putt/engine)
	time = 5
	create = 1
	category = "Component"

/datum/manufacture/putt/boards
	name = "MiniPutt Circuitry"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(2,2)
	item_outputs = list(/obj/item/putt/boards)
	time = 5
	create = 1
	category = "Component"

/datum/manufacture/putt/control
	name = "MiniPutt Control Interface"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(5,5)
	item_outputs = list(/obj/item/putt/control)
	time = 5
	create = 1
	category = "Component"

//// pod addons

/datum/manufacture/pod/weapon/mining
	name = "Plasma Cutter System"
	item_paths = list("POW-1","MET-3")
	item_names = list("Power Source","Dense Metal")
	item_amounts = list(10,10)
	item_outputs = list(/obj/item/shipcomponent/mainweapon/mining)
	time = 20
	create = 1
	category = "Tool"

/datum/manufacture/pod/weapon/ltlaser
	name = "Mk.1.5 Light Phasers"
	item_paths = list("MET-2","CON-1","CRY-1")
	item_names = list("Sturdy Metal","Conductive Material","Crystal")
	item_amounts = list(15,15,15)
	item_outputs = list(/obj/item/shipcomponent/mainweapon/phaser)
	time = 20
	create  = 1
	category = "Tool"

/datum/manufacture/pod/lock
	name = "Pod Locking Mechanism"
	item_paths = list("CRY-1","CON-1")
	item_names = list("Crystal","Conductive Material")
	item_amounts = list(5,10)
	item_outputs = list(/obj/item/shipcomponent/secondary_system/lock)
	time = 10
	create = 1
	category = "Tool"