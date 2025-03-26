var/global/list/d_faces[0]
var/global/list/d_arms[0]
var/global/list/d_chests[0]
var/global/list/d_legs[0]
var/global/list/d_ears[0]
var/global/list/d_tails[0]
var/global/list/d_hhairs[0]
var/global/list/d_fhairs[0]

datum/preferences
	var/profile_name
	var/real_name
	var/gender = NEUTER
	var/writtengender = "Neutral"
	var/age = 18
	var/pin = null
	var/blType = "A+"
	var/display = ""
	var/charsheet = ""

	var/be_changeling = 0
	var/be_revhead = 0
	var/be_syndicate = 0
	var/be_wizard = 0
	var/be_traitor = 0
	var/be_vampire = 0
	var/be_spy = 0
	var/be_gangleader = 0
	var/be_wraith = 0
	var/be_blob = 0
	var/be_misc = 0

	var/be_random_name = 0
	var/be_random_look = 0
	var/random_blood = 0
	var/view_changelog = 1
	var/view_score = 1
	var/view_tickets = 1
	var/admin_music_volume = 50
	var/use_click_buffer = 0
	var/listen_ooc = 1
	var/listen_looc = 1
	var/default_wasd = 0 // do they want wasd on by default?
	var/use_azerty = 0 // do they have an AZERTY keyboard?

	var/job_favorite = null
	var/list/jobs_med_priority = list()
	var/list/jobs_low_priority = list()
	var/list/jobs_unwanted = list()

	var/datum/appearanceHolder/AH = new

	var/random = 0
	var/random2 = 0
	var/random3 = 0

	var/icon/preview_icon = null
	var/previewrotation = SOUTH

	var/mentor = 0
	var/see_mentor_pms = 1 // do they wanna disable mentor pms?
	var/antispam = 0

	var/datum/traitPreferences/traitPreferences = new

	var/target_cursor = "Default"
	var/hud_style = "Old"
	var/selectedview = "800x600"

	var/list/tops[0]
	var/shirt = "Plain Shirt"
	var/shirt_color = "#FFFFFF"
	var/shirt_detail_color = "#101010"

	var/list/jackets[0]
	var/jacket = "None"
	var/jacket_color = "#FFFFFF"
	var/jacket_detail_color = "#101010"

	var/list/bottoms[0]
	var/bottom = "Plain Trousers"
	var/bottom_color = "#101010"
	var/bottom_detail_color = "#FFFFFF"

	var/list/socks[0]
	var/sock = "Plain Socks"
	var/sock_color = "#f2ecd2"
	var/sock_detail_color = "#FFFFFF"

	var/list/shoes[0]
	var/shoe = "Plain Shoes"
	var/shoe_color = "#3d2727"
	var/shoe_detail_color = "#FFFFFF"

	var/list/underwears[0] //i know it's wrong fuck off
	var/underwear = "Boxers"
	var/underwear_color = "#101010"
	var/underwear_detail_color = "#FFFFFF"

	//default preview icons should be referenced here
	var/icon/sock1_s
	var/icon/sock2_s

	var/icon/shoe1_s
	var/icon/shoe2_s

	var/icon/underwear_s
	var/icon/shirt_s
	var/icon/jacket_s
	var/icon/bottom_s

	var/icon/ears_s
	var/icon/tails_s

	var/icon/face_s
	var/icon/chest_s

	var/icon/arm1_s
	var/icon/arm2_s

	var/icon/leg1_s
	var/icon/leg2_s

	var/icon/hair_s
	var/icon/facial_s
	New()
		randomize_name()
		..()

	proc/randomize_name()
		real_name = random_name(src.gender)

	proc/randomizeLook() // im laze
		if (!AH)
			logTheThing("debug", usr ? usr : null, null, "a preference datum's appearence holder is null!")
			return
		randomize_look(AH, 0, 0, 0, 0, 0, 0) // keep gender/bloodtype/age/name/underwear/bioeffects

		update_preview_icon()

	proc/sanitize_name()
		var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "\[", "\]", "{", "}", "|", "\\", "/")
		for (var/c in bad_characters)
			real_name = replacetext(real_name, c, "")
		var/list/namecheck = splittext(trim(real_name), " ")
		if (namecheck.len < 2 || length(real_name) < 5)
			randomize_name()
			return
		for (var/i = 1, i <= namecheck.len, i++)
			namecheck[i] = capitalize(namecheck[i])
		real_name = jointext(namecheck, " ")

	proc/update_preview_icon()
		//qdel(src.preview_icon)
		if (!AH)
			logTheThing("debug", usr ? usr : null, null, "a preference datum's appearence holder is null!")
			return

		src.preview_icon = null

		src.preview_icon = new /icon('icons/mob/human.dmi', "body_[src.gender == MALE ? "m" : "f"]", "dir" = previewrotation)

		// Skin tone
		/*
		if (AH.s_tone >= 0)
			src.preview_icon.Blend(rgb(AH.s_tone, AH.s_tone, AH.s_tone), ICON_ADD)
		else
			src.preview_icon.Blend(rgb(-AH.s_tone,  -AH.s_tone,  -AH.s_tone), ICON_SUBTRACT)
		*/
		// Skin color
		if (is_valid_color_string(AH.s_color))
			src.preview_icon.Blend(AH.s_color, ICON_MULTIPLY)
		else
			src.preview_icon.Blend("#fec081", ICON_MULTIPLY)

		var/icon/eyes_s = new/icon("icon" = 'icons/mob/human_hair.dmi', "icon_state" = "eyes", "dir" = previewrotation)
		if (is_valid_color_string(AH.e_color))
			eyes_s.Blend(AH.e_color, ICON_MULTIPLY)
		else
			eyes_s.Blend("#101010", ICON_MULTIPLY)

		if(AH.customization_first != "None")
			hair_s = new/icon("icon" = file("icons/custom_icons/" + d_hhairs[AH.customization_first]["icon"]), "dir" = previewrotation)
			if (is_valid_color_string(AH.customization_first_color))
				hair_s.Blend(AH.customization_first_color, ICON_MULTIPLY)

		if(AH.customization_third != "None")
			facial_s = new/icon("icon" = file("icons/custom_icons/" + d_fhairs[AH.customization_third]["icon"]), "dir" = previewrotation)
			if (is_valid_color_string(AH.customization_third_color))
				facial_s.Blend(AH.customization_third_color, ICON_MULTIPLY)


		//furry shit
		if(AH.ears != "None")
			ears_s = new/icon("icon" = file("icons/custom_icons/" + d_ears[AH.ears]["icon"]), "dir" = previewrotation)
			if(d_ears[AH.ears]["options"] != "0")
				if(d_ears[AH.ears]["options"] == "2")
					ears_s.MapColors(AH.ear_color, AH.ear_detail_color, null, null)
				else
					ears_s *= AH.ear_color

		if(AH.tail != "None")
			tails_s = new/icon("icon" = file("icons/custom_icons/" + d_tails[AH.tail]["icon"]), "dir" = previewrotation)
			if(d_tails[AH.tail]["options"] != "0")
				if(d_tails[AH.tail]["options"] == "2")
					tails_s.MapColors(AH.tail_color, AH.tail_detail_color, null, null)
				else
					tails_s *= AH.tail_color

		if(AH.face_detail != "None")
			face_s = new/icon("icon" = file("icons/custom_icons/" + d_faces[AH.face_detail]["icon"]), "dir" = previewrotation)
			if (is_valid_color_string(AH.face_detail_color))
				face_s.Blend(AH.face_detail_color, ICON_MULTIPLY)

		if(AH.chest_detail != "None")
			chest_s = new/icon("icon" = file("icons/custom_icons/" + d_chests[AH.chest_detail]["icon"]), "dir" = previewrotation)
			if (is_valid_color_string(AH.chest_detail_color))
				chest_s.Blend(AH.chest_detail_color, ICON_MULTIPLY)

		if(AH.arm_detail != "None")
			arm1_s = new/icon("icon" = file("icons/custom_icons/" + d_arms[AH.arm_detail]["icon"]),"icon_state" = "left", "dir" = previewrotation)
			if (is_valid_color_string(AH.arm_detail_color))
				arm1_s.Blend(AH.arm_detail_color, ICON_MULTIPLY)

			arm2_s = new/icon("icon" = file("icons/custom_icons/" + d_arms[AH.arm_detail]["icon"]),"icon_state" = "right", "dir" = previewrotation)
			if (is_valid_color_string(AH.arm_detail_color))
				arm2_s.Blend(AH.arm_detail_color, ICON_MULTIPLY)

		if(AH.leg_detail != "None")
			leg1_s = new/icon("icon" = file("icons/custom_icons/" + d_legs[AH.leg_detail]["icon"]),"icon_state" = "left", "dir" = previewrotation)
			if (is_valid_color_string(AH.leg_detail_color))
				leg1_s.Blend(AH.leg_detail_color, ICON_MULTIPLY)

			leg2_s = new/icon("icon" = file("icons/custom_icons/" + d_legs[AH.leg_detail]["icon"]),"icon_state" = "right", "dir" = previewrotation)
			if (is_valid_color_string(AH.leg_detail_color))
				leg2_s.Blend(AH.leg_detail_color, ICON_MULTIPLY)


		if(shirt != "None")
			shirt_s = new/icon("icon" = file("icons/custom_icons/" + src.tops[shirt]["icon"]),"icon_state" = "worn", "dir" = previewrotation)
			if(src.tops[shirt]["options"] != "0")
				if(src.tops[shirt]["options"] == "2")
					shirt_s.MapColors(src.shirt_color, src.shirt_detail_color, null, null)
				else
					shirt_s *= src.shirt_color

		if(jacket != "None")
			jacket_s = new/icon("icon" = file("icons/custom_icons/" + src.jackets[jacket]["icon"]),"icon_state" = "worn", "dir" = previewrotation)
			if(src.jackets[jacket]["options"] != "0")
				if(src.jackets[jacket]["options"] == "2")
					jacket_s.MapColors(src.jacket_color, src.jacket_detail_color, null, null)
				else
					jacket_s *= src.jacket_color

		if(bottom != "None")
			bottom_s = new/icon("icon" = file("icons/custom_icons/" + src.bottoms[bottom]["icon"]),"icon_state" = "worn", "dir" = previewrotation)
			if(src.bottoms[bottom]["options"] != "0")
				if(src.bottoms[bottom]["options"] == "2")
					bottom_s.MapColors(src.bottom_color, src.bottom_detail_color, null, null)
				else
					bottom_s *= src.bottom_color
		if(sock != "None")
			sock1_s = new/icon("icon" = file("icons/custom_icons/" + src.socks[sock]["icon"]),"icon_state" = "left_worn", "dir" = previewrotation)
			if(src.socks[sock]["options"] != "0")
				if(src.socks[sock]["options"] == "2")
					sock1_s.MapColors(src.sock_color, src.sock_detail_color, null, null)
				else
					sock1_s *= src.sock_color
			sock2_s = new/icon("icon" = file("icons/custom_icons/" + src.socks[sock]["icon"]),"icon_state" = "right_worn", "dir" = previewrotation)
			if(src.socks[sock]["options"] != "0")
				if(src.socks[sock]["options"] == "2")
					sock2_s.MapColors(src.sock_color, src.sock_detail_color, null, null)
				else
					sock2_s *= src.sock_color
		if(shoe != "None")
			shoe1_s = new/icon("icon" = file("icons/custom_icons/" + src.shoes[shoe]["icon"]),"icon_state" = "left_worn", "dir" = previewrotation)
			if(src.shoes[shoe]["options"] != "0")
				if(src.shoes[shoe]["options"] == "2")
					shoe1_s.MapColors(src.shoe_color, src.shoe_detail_color, null, null)
				else
					shoe1_s *= src.shoe_color
			shoe2_s = new/icon("icon" = file("icons/custom_icons/" + src.shoes[shoe]["icon"]),"icon_state" = "right_worn", "dir" = previewrotation)
			if(src.shoes[shoe]["options"] != "0")
				if(src.shoes[shoe]["options"] == "2")
					shoe2_s.MapColors(src.shoe_color, src.shoe_detail_color, null, null)
				else
					shoe2_s *= src.shoe_color
		if(underwear != "None")
			underwear_s = new/icon("icon" = file("icons/custom_icons/" + src.underwears[underwear]["icon"]),"icon_state" = "worn", "dir" = previewrotation)
			if(src.underwears[underwear]["options"] != "0")
				if(src.underwears[underwear]["options"] == "2")
					underwear_s.MapColors(src.underwear_color, src.underwear_detail_color, null, null)
				else
					underwear_s *= src.underwear_color
/*
		if(underwear_styles[underwear] && underwear_styles[underwear] != "none")
			var/underwearpath = text2path(underwear_styles[underwear])
			var/obj/item/clothing/underwear/underwearobj = new underwearpath
			underwear_s = new/icon("icon" = 'icons/mob/underwear.dmi', "icon_state" = "[underwearobj.icon_state]", "dir" = previewrotation)
			if(underwearobj.has_detail)
				underwear_s.MapColors(src.underwear_color, src.underwear_detail_color, null, null)
			else
				underwear_s *= src.underwear_color

			//var/shirtpath = text2path(shirt_styles[shirt])
			//var/obj/item/clothing/under/shirtobj = new shirtpath
			//if(shirtobj.has_detail)
			//	shirt_s.MapColors(src.shirt_color, src.shirt_detail_color, null, null)
		//	else
			//	shirt_s *= src.shirt_color

		if(bottom_styles[bottom] && bottom_styles[bottom] != "none")
			var/bottompath = text2path(bottom_styles[bottom])
			var/obj/item/clothing/under/bottomobj = new bottompath
			bottom_s = new/icon("icon" = 'icons/mob/pants.dmi', "icon_state" = "[bottomobj.icon_state]", "dir" = previewrotation)
			if(bottomobj.has_detail)
				bottom_s.MapColors(src.bottom_color, src.bottom_detail_color, null, null)
			else
				bottom_s *= src.bottom_color

		if(sock_styles[sock] && sock_styles[sock] != "none")
			var/sockpath = text2path(sock_styles[sock])
			var/obj/item/clothing/under/sockobj = new sockpath
			sock1_s = new/icon("icon" = 'icons/mob/socks.dmi', "icon_state" = "left_[sockobj.icon_state]", "dir" = previewrotation)
			sock2_s = new/icon("icon" = 'icons/mob/socks.dmi', "icon_state" = "right_[sockobj.icon_state]", "dir" = previewrotation)
			if(sockobj.has_detail)
				sock1_s.MapColors(src.sock_color, src.sock_detail_color, null, null)
				sock2_s.MapColors(src.sock_color, src.sock_detail_color, null, null)
			else
				sock1_s *= src.sock_color
				sock2_s *= src.sock_color

		if(shoe_styles[shoe] && shoe_styles[shoe] != "none")
			var/shoepath = text2path(shoe_styles[shoe])
			var/obj/item/clothing/under/shoeobj = new shoepath
			shoe1_s = new/icon("icon" = 'icons/mob/feet.dmi', "icon_state" = "left_[shoeobj.icon_state]", "dir" = previewrotation)
			shoe2_s = new/icon("icon" = 'icons/mob/feet.dmi', "icon_state" = "right_[shoeobj.icon_state]", "dir" = previewrotation)
			if(shoeobj.has_detail)
				shoe1_s.MapColors(src.shoe_color, src.shoe_detail_color, null, null)
				shoe2_s.MapColors(src.shoe_color, src.shoe_detail_color, null, null)
			else
				shoe1_s *= src.shoe_color
				shoe2_s *= src.shoe_color*/



		if(AH.chest_detail != "None")
			eyes_s.Blend(chest_s, ICON_OVERLAY)

		if(AH.arm_detail != "None")
			eyes_s.Blend(arm1_s, ICON_OVERLAY)
			eyes_s.Blend(arm2_s, ICON_OVERLAY)

		if(AH.leg_detail != "None")
			eyes_s.Blend(leg1_s, ICON_OVERLAY)
			eyes_s.Blend(leg2_s, ICON_OVERLAY)


		if(AH.customization_first != "None")
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		if(AH.customization_third != "None")
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		if(sock && sock != "None")
			eyes_s.Blend(sock1_s, ICON_OVERLAY)
			eyes_s.Blend(sock2_s, ICON_OVERLAY)

		if(shoe && shoe != "None")
			eyes_s.Blend(shoe1_s, ICON_OVERLAY)
			eyes_s.Blend(shoe2_s, ICON_OVERLAY)

		if(underwear && underwear != "None")
			eyes_s.Blend(underwear_s, ICON_OVERLAY)

		if(shirt && shirt != "None")
			eyes_s.Blend(shirt_s, ICON_OVERLAY)

		if(jacket && jacket != "None")
			eyes_s.Blend(jacket_s, ICON_OVERLAY)

		if(bottom && bottom != "None")
			eyes_s.Blend(bottom_s, ICON_OVERLAY)

		if(AH.ears != "None")
			eyes_s.Blend(ears_s, ICON_OVERLAY)

		if(AH.tail != "None")
			eyes_s.Blend(tails_s, ICON_OVERLAY)

		if(AH.face_detail != "None")
			eyes_s.Blend(face_s, ICON_OVERLAY)

		src.preview_icon.Blend(eyes_s, ICON_OVERLAY)

		chest_s = null
		arm1_s = null
		arm2_s = null
		leg1_s = null
		leg2_s = null

		face_s = null

		shirt_s = null
		jacket_s = null
		bottom_s = null
		underwear_s = null
		shoe1_s = null
		shoe2_s = null
		sock1_s = null
		sock2_s = null

		facial_s = null
		hair_s = null

		ears_s = null
		tails_s = null
		eyes_s = null


	proc/ShowChoices(mob/user)
		sanitize_null_values()

		src.tops["None"] = "None"
		src.jackets["None"] = "None"
		src.bottoms["None"] = "None"
		src.socks["None"] = "None"
		src.shoes["None"] = "None"
		src.underwears["None"] = "None"
		d_faces["None"] = "None"
		d_arms["None"] = "None"
		d_chests["None"] = "None"
		d_legs["None"] = "None"
		d_ears["None"] = "None"
		d_tails["None"] = "None"
		d_hhairs["None"] = "None"
		d_fhairs["None"] = "None"


		var/list/default_clothing = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[user.ckey]&defaultclothing=text")
		var/list/owned_clothing = world.Export("http://spacetopia.pw/modules/ss13.php?ckey=[user.ckey]&ownedclothing=text")

		if(default_clothing)
			var/content = file2text(default_clothing["CONTENT"])
			var/list/json = json2list(replacetext(content, "{}", "null")) //breaks without this hack

			for(var/t in json["top"])
				src.tops[json["top"][t]["name"]] = list("name" = json["top"][t]["name"], "icon" = json["top"][t]["icon"], "options" = json["top"][t]["options"])

			for(var/t in json["jacket"])
				src.jackets[json["jacket"][t]["name"]] = list("name" = json["jacket"][t]["name"], "icon" = json["jacket"][t]["icon"], "options" = json["jacket"][t]["options"])

			for(var/t in json["bottom"])
				src.bottoms[json["bottom"][t]["name"]] = list("name" = json["bottom"][t]["name"], "icon" = json["bottom"][t]["icon"], "options" = json["bottom"][t]["options"])

			for(var/t in json["socks"])
				src.socks[json["socks"][t]["name"]] = list("name" = json["socks"][t]["name"], "icon" = json["socks"][t]["icon"], "options" = json["socks"][t]["options"])

			for(var/t in json["shoes"])
				src.shoes[json["shoes"][t]["name"]] = list("name" = json["shoes"][t]["name"], "icon" = json["shoes"][t]["icon"], "options" = json["shoes"][t]["options"])

			for(var/t in json["underwear"])
				src.underwears[json["underwear"][t]["name"]] = list("name" = json["underwear"][t]["name"], "icon" = json["underwear"][t]["icon"], "options" = json["underwear"][t]["options"])

			for(var/t in json["face"])
				d_faces[json["face"][t]["name"]] = list("name" = json["face"][t]["name"], "icon" = json["face"][t]["icon"], "options" = json["face"][t]["options"])

			for(var/t in json["arms"])
				d_arms[json["arms"][t]["name"]] = list("name" = json["arms"][t]["name"], "icon" = json["arms"][t]["icon"], "options" = json["arms"][t]["options"])

			for(var/t in json["chest"])
				d_chests[json["chest"][t]["name"]] = list("name" = json["chest"][t]["name"], "icon" = json["chest"][t]["icon"], "options" = json["chest"][t]["options"])

			for(var/t in json["legs"])
				d_legs[json["legs"][t]["name"]] = list("name" = json["legs"][t]["name"], "icon" = json["legs"][t]["icon"], "options" = json["legs"][t]["options"])

			for(var/t in json["ears"])
				d_ears[json["ears"][t]["name"]] = list("name" = json["ears"][t]["name"], "icon" = json["ears"][t]["icon"], "options" = json["ears"][t]["options"])

			for(var/t in json["tails"])
				d_tails[json["tails"][t]["name"]] = list("name" = json["tails"][t]["name"], "icon" = json["tails"][t]["icon"], "options" = json["tails"][t]["options"])

			for(var/t in json["hhairs"])
				d_hhairs[json["hhairs"][t]["name"]] = list("name" = json["hhairs"][t]["name"], "icon" = json["hhairs"][t]["icon"], "options" = json["hhairs"][t]["options"])

			for(var/t in json["fhairs"])
				d_fhairs[json["fhairs"][t]["name"]] = list("name" = json["fhairs"][t]["name"], "icon" = json["fhairs"][t]["icon"], "options" = json["fhairs"][t]["options"])

		if(owned_clothing)
			var/content = file2text(owned_clothing["CONTENT"])
			var/list/json = json2list(replacetext(content, "{}", "null")) //breaks without this hack

			for(var/t in json["top"])
				src.tops[json["top"][t]["name"]] = list("name" = json["top"][t]["name"], "icon" = json["top"][t]["icon"], "options" = json["top"][t]["options"])

			for(var/t in json["jacket"])
				src.jackets[json["jacket"][t]["name"]] = list("name" = json["jacket"][t]["name"], "icon" = json["jacket"][t]["icon"], "options" = json["jacket"][t]["options"])

			for(var/t in json["bottom"])
				src.bottoms[json["bottom"][t]["name"]] = list("name" = json["bottom"][t]["name"], "icon" = json["bottom"][t]["icon"], "options" = json["bottom"][t]["options"])

			for(var/t in json["socks"])
				src.socks[json["socks"][t]["name"]] = list("name" = json["socks"][t]["name"], "icon" = json["socks"][t]["icon"], "options" = json["socks"][t]["options"])

			for(var/t in json["shoes"])
				src.shoes[json["shoes"][t]["name"]] = list("name" = json["shoes"][t]["name"], "icon" = json["shoes"][t]["icon"], "options" = json["shoes"][t]["options"])

			for(var/t in json["underwear"])
				src.underwears[json["underwear"][t]["name"]] = list("name" = json["underwear"][t]["name"], "icon" = json["underwear"][t]["icon"], "options" = json["underwear"][t]["options"])

			for(var/t in json["face"])
				d_faces[json["face"][t]["name"]] = list("name" = json["face"][t]["name"], "icon" = json["face"][t]["icon"], "options" = json["face"][t]["options"])

			for(var/t in json["arms"])
				d_arms[json["arms"][t]["name"]] = list("name" = json["arms"][t]["name"], "icon" = json["arms"][t]["icon"], "options" = json["arms"][t]["options"])

			for(var/t in json["chest"])
				d_chests[json["chest"][t]["name"]] = list("name" = json["chest"][t]["name"], "icon" = json["chest"][t]["icon"], "options" = json["chest"][t]["options"])

			for(var/t in json["legs"])
				d_legs[json["legs"][t]["name"]] = list("name" = json["legs"][t]["name"], "icon" = json["legs"][t]["icon"], "options" = json["legs"][t]["options"])

			for(var/t in json["ears"])
				d_ears[json["ears"][t]["name"]] = list("name" = json["ears"][t]["name"], "icon" = json["ears"][t]["icon"], "options" = json["ears"][t]["options"])

			for(var/t in json["tails"])
				d_tails[json["tails"][t]["name"]] = list("name" = json["tails"][t]["name"], "icon" = json["tails"][t]["icon"], "options" = json["tails"][t]["options"])

			for(var/t in json["hhairs"])
				d_hhairs[json["hhairs"][t]["name"]] = list("name" = json["hhairs"][t]["name"], "icon" = json["hhairs"][t]["icon"], "options" = json["hhairs"][t]["options"])

			for(var/t in json["fhairs"])
				d_fhairs[json["fhairs"][t]["name"]] = list("name" = json["fhairs"][t]["name"], "icon" = json["fhairs"][t]["icon"], "options" = json["fhairs"][t]["options"])


		/*if (!src.savefile_load(user) && !user.client.authed)
			src.profile_name = user.client.api["username"]
			src.real_name = user.client.api["real_name"]
			src.age = user.client.api["age"]
			user.bioHolder.age = user.client.api["age"]
			user.writtengender = user.client.api["gender"]
			user.bioHolder.charsheet = user.client.api["bio"]

			var/new_gender = user.client.api["gender"]
			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_gender = replacetext(new_gender, c, "")

			new_gender = trim(new_gender)

			if(new_gender == "male")
				src.gender = MALE
				AH.gender = MALE
				src.writtengender = new_gender
				AH.writtengender = new_gender
				src.bottom = "Plain Trousers"
				src.underwear = "Briefs"
				AH.customization_first = "Bedhead"
			else if(new_gender == "female")
				src.gender = FEMALE
				AH.gender = FEMALE
				src.writtengender = new_gender
				AH.writtengender = new_gender
				src.bottom = "None"
				src.sock = "Stockings"
				src.sock_color = "#101010"
				src.underwear = "Bra and Panties"
				AH.customization_first = "Messy"
			else
				src.gender = FEMALE
				AH.gender = FEMALE
				src.writtengender = new_gender
				AH.writtengender = new_gender
				src.bottom = "Plain Skirt"
				src.sock = "Striped Stockings"
				src.underwear = "Bra and Panties"
				src.sock_color = "#101010"
				AH.customization_first = "Scene"*/

		update_preview_icon()
		user << browse_rsc(preview_icon, "previewicon.png")
		//user << browse_rsc(icon(cursors_selection[target_cursor]), "tcursor.png")
		//user << browse_rsc(icon(hud_style_selection[hud_style], "preview"), "hud_preview.png")

		var/spacing = "&nbsp;&nbsp;"
		var/dat = "<!DOCTYPE html> \
<html> \
      <head> \
            <meta charset=\"utf-8\"> \
            <title>Character Setup</title> \
            [css_character] \
      </head> \
      <body> \
            <div class=\"pageColumnLeft\"> \
                  <div class=\"heading\">Character</div> \
 \
                  <!-- Name --> \
                  <span class=\"fieldinput\"><a href=\"byond://?src=\ref[user];preferences=1;real_name=input\">[src.real_name]</a></span> \
                  <span class=\"fieldtitle\">Name:</span> \
                  <br/> \
 \
                  <!-- Age --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;age=input'>[src.age]</a></span> \
                  <span class=\"fieldtitle\">Age:</span> \
                  <br/> \
 \
                  <!-- Gender --> \
                  <span class=\"fieldinput\"><a href=\"byond://?src=\ref[user];preferences=1;gender=input\">[AH.writtengender]</a></span> \
                  <span class=\"fieldtitle\">Gender:</span> \
                  <br/> \
 \
                  <!-- Blood Type --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;blType=input'>[src.random_blood ? "Random" : src.blType]</a></span> \
                  <span class=\"fieldtitle\">Blood Type:</span> \
                  <br/> \
  \
                  <!-- Extra --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;charsheet=input'>Character Sheet</a> | <a href=\"byond://?src=\ref[user];preferences=1;traitswindow=1\">Traits</a></span> \
                  <span class=\"fieldtitle\">Extra:</span> \
                  <br/><br/> \
 \
                  <div class=\"heading\">Settings</div> \
 \
                  <!-- Bank Pin --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;pin=input'>[src.pin ? src.pin : "Random"]</a></span> \
                  <span class=\"fieldtitle\">Bank Pin:</span> \
                  <br/> \
 \
                  <!-- Screen Resolution --> \
                  <span class=\"fieldinput\"><a href =\"byond://?src=\ref[user];preferences=1;set_resolution=1\">[selectedview]</a></span> \
                  <span class=\"fieldtitle\">Screen Resolution:</span> \
                  <br/> \
 \
                  <!-- Hotkey Mode --> \
                  <span class=\"fieldinput\"><a href =\"byond://?src=\ref[user];preferences=1;default_wasd=1\">[(src.default_wasd ? "On" : "Off")]</a> (<a href =\"byond://?src=\ref[user];preferences=1;use_azerty=1\">[(src.use_azerty ? "AZERTY" : "WASD")]</a>)</span> \
                  <span class=\"fieldtitle\">Hotkey Mode:</span> \
                  <br/> \
 \
                  <!-- Local OOC --> \
                  <span class=\"fieldinput\"><a href=\"byond://?src=\ref[user];preferences=1;listen_looc=1\">[(src.listen_looc ? "Show" : "Hide")]</a></span> \
                  <span class=\"fieldtitle\">Local OOC:</span> \
                  <br/><br/> \
 \
 \
                  <!-- Save Profile -->"
		dat += "<span class=\"fieldinput\">"
		for (var/i=1, i <= SAVEFILE_PROFILES_MAX, i++)
			dat += " <a href='byond://?src=\ref[user];preferences=1;save=[i]'>[i]</a>"
		dat += "</span>"
		dat += "<span class=\"fieldtitle\">Save Profile:</span> \
                  <br/> \
 \
                  <!-- Load Profile -->"
		dat += "<span class=\"fieldinput\">"
		for (var/i=1, i <= SAVEFILE_PROFILES_MAX, i++)
			dat += " <a href='byond://?src=\ref[user];preferences=1;load=[i]' title='[savefile_get_profile_name(user, i) || i]'>[i]</a>"
		dat += "</span>"
		dat += "<span class=\"fieldtitle\">Load Profile:</span> \
                  <br/><br/> \
 \
                  <!-- Profile Name --> \
                  <span class=\"fieldinput\"><a href=\"byond://?src=\ref[user];preferences=1;profile_name=input\">[src.profile_name ? src.profile_name : "Unnamed"]</a></span> \
                  <span class=\"fieldtitle\">Profile Name:</span> \
                  <br/> \
 \
                  <!-- Reset Profile --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;spacetopiaload=1'>Load</a></span> \
                  <span class=\"fieldtitle\">Spacetopia Profile:</span> \
                  <br/> \
            </div> \
            <div class=\"pageColumnMid\"> \
                  <div class=\"heading\">Clothing</div> \
 \
                  <!-- Shirt --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;shirt=input'>[shirt]</a> <a href='byond://?src=\ref[user];preferences=1;shirt_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [shirt_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;shirt_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [shirt_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Top:</span> \
                  <br/> \
 \
                  <!-- Jacket --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;jacket=input'>[jacket]</a> <a href='byond://?src=\ref[user];preferences=1;jacket_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [jacket_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;jacket_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [jacket_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Overcoat:</span> \
                  <br/> \
 \
                  <!-- Bottom --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;bottom=input'>[bottom]</a> <a href='byond://?src=\ref[user];preferences=1;bottom_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [bottom_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;bottom_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [bottom_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Bottom:</span> \
                  <br/> \
 \
                  <!-- Feet --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;sock=input'>[sock]</a> <a href='byond://?src=\ref[user];preferences=1;sock_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [sock_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;sock_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [sock_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Socks:</span> \
                  <br/> \
 \
                  <!-- Shoes --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;shoe=input'>[shoe]</a> <a href='byond://?src=\ref[user];preferences=1;shoe_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [shoe_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;shoe_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [shoe_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Shoes:</span> \
                  <br/> \
 \
 \
                  <!-- Underwear --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;underwear=input'>[underwear]</a> <a href='byond://?src=\ref[user];preferences=1;underwear_color=input'><span class=\"colorbutton\" title=\"Primary Color\" style=\"background-color: [underwear_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;underwear_detail_color=input'><span class=\"colorbutton\" title=\"Secondary Color\" style=\"background-color: [underwear_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Underwear:</span> \
                  <br/><br/> \
 \
                  <div class=\"heading\">Appearance</div> \
 \
                  <!-- Skin Color --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;s_color=input'><span class=\"colorbutton\" title=\"Skin Color\" style=\"background-color: [AH.s_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Skin Color:</span> \
                  <br/> \
 \
                  <!-- Eye Color --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;eyes=input'><span class=\"colorbutton\" title=\"Eye Color\" style=\"background-color: [AH.e_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Eye Color:</span> \
                  <br/> \
 \
 \
                  <!-- Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;customization_first=input'>[AH.customization_first]</a> <a href='byond://?src=\ref[user];preferences=1;hair=input'><span class=\"colorbutton\" title=\"Detail Color\" style=\"background-color: [AH.customization_first_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Hairstyle:</span> \
                  <br/> \
 \
                  <!-- Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;customization_third=input'>[AH.customization_third]</a> <a href='byond://?src=\ref[user];preferences=1;facial=input'><span class=\"colorbutton\" title=\"Detail Color\" style=\"background-color: [AH.customization_third_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Facial Hair:</span> \
                  <br/> \
  \
                  <!-- Face Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;face_detail=input'>[AH.face_detail]</a> <a href='byond://?src=\ref[user];preferences=1;face_detail_color=input'><span class=\"colorbutton\" title=\"Face Color\" style=\"background-color: [AH.face_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Face Detail:</span> \
                  <br/> \
 \
                  <!-- Chest Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;chest_detail=input'>[AH.chest_detail]</a> <a href='byond://?src=\ref[user];preferences=1;chest_detail_color=input'><span class=\"colorbutton\" title=\"Chest Color\" style=\"background-color: [AH.chest_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Chest Detail:</span> \
                  <br/> \
 \
                  <!-- Arm Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;arm_detail=input'>[AH.arm_detail]</a> <a href='byond://?src=\ref[user];preferences=1;arm_detail_color=input'><span class=\"colorbutton\" title=\"Arm Color\" style=\"background-color: [AH.arm_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Arm Detail:</span> \
                  <br/> \
 \
                  <!-- Leg Detail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;leg_detail=input'>[AH.leg_detail]</a> <a href='byond://?src=\ref[user];preferences=1;leg_detail_color=input'><span class=\"colorbutton\" title=\"Leg Color\" style=\"background-color: [AH.leg_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Leg Detail:</span> \
                  <br/> \
 \
                  <!-- Ears --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;ears=input'>[AH.ears]</a> <a href='byond://?src=\ref[user];preferences=1;ears_color=input'><span class=\"colorbutton\" title=\"Ear Color\" style=\"background-color: [AH.ear_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;ears_detail_color=input'><span class=\"colorbutton\" title=\"Ear Detail Color\" style=\"background-color: [AH.ear_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Ears:</span> \
                  <br/> \
 \
                  <!-- Tail --> \
                  <span class=\"fieldinput\"><a href='byond://?src=\ref[user];preferences=1;tails=input'>[AH.tail]</a> <a href='byond://?src=\ref[user];preferences=1;tails_color=input'><span class=\"colorbutton\" title=\"Tail Color\" style=\"background-color: [AH.tail_color]\">[spacing]</span></a> <a href='byond://?src=\ref[user];preferences=1;tails_detail_color=input'><span class=\"colorbutton\" title=\"Tail Detail Color\" style=\"background-color: [AH.tail_detail_color]\">[spacing]</span></a></span> \
                  <span class=\"fieldtitle\">Tail:</span> \
                   \
 \
            </div> \
            <div class=\"pageColumnRight\"> \
 \
 \
                  <br/><br/><br/><br/><br/> \
 \
                  <div class=\"displayicon\"> \
                        <a href=\"byond://?src=\ref[user];preferences=1;previewrotation=1\" class=\"noborder\"><img class=\"noborder\" style=\"-ms-interpolation-mode:nearest-neighbor;\" src=previewicon.png height=64 width=64></a> \
                  </div> \
 \
                  <br/>"
		if(user.client.authed)
			dat += "<a href='byond://?src=\ref[user];late_join=1'><div class=\"joinbutton\">Join Game</div></a>"
		else
			dat += "<a href='byond://?src=\ref[user];apply_now=1'><div class=\"applybutton\">Apply Now</div></a>"
		dat += "</div> \
      </body> \
</html>"
		traitPreferences.updateTraits(user)

		user << browse(dat,"window=preferences;size=725x410;can_close=0;can_minimize=1")

	proc/ResetAllPrefsToMed(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (jobban_isbanned(user,J.name) || (J.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				src.jobs_unwanted += J.name
				continue
			src.jobs_med_priority += J.name
		return

	proc/ResetAllPrefsToLow(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (jobban_isbanned(user,J.name) || (J.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				src.jobs_unwanted += J.name
				continue
			src.jobs_low_priority += J.name
		return

	proc/ResetAllPrefsToUnwanted(mob/user)
		src.job_favorite = null
		src.jobs_med_priority = list()
		src.jobs_low_priority = list()
		src.jobs_unwanted = list()
		for (var/datum/job/J in job_controls.staple_jobs)
			if (istype(J, /datum/job/daily))
				continue
			if (J.cant_allocate_unwanted)
				src.jobs_low_priority += J.name
			else
				src.jobs_unwanted += J.name
		return

	proc/SetChoices(mob/user)

		if (isnull(src.jobs_med_priority) || isnull(src.jobs_low_priority) || isnull(src.jobs_unwanted))
			src.ResetAllPrefsToLow(user)
			boutput(user, "<span style=\"color:red\"><b>Your Job Preferences were null, and have been reset.</b></span>")
		else if (isnull(src.job_favorite) && !src.jobs_med_priority.len && !src.jobs_low_priority.len && !src.jobs_unwanted.len)
			src.ResetAllPrefsToLow(user)
			boutput(user, "<span style=\"color:red\"><b>Your Job Preferences were empty, and have been reset.</b></span>")

		var/HTML = "<body><title>Job Preferences</title>"

		HTML += "<b>Favorite Job:</b>"
		if (!src.job_favorite)
			HTML += " None"
		else
			var/datum/job/J_Fav = find_job_in_controller_by_string(src.job_favorite)
			if (!J_Fav)
				HTML += " Favorite Job not found!"
			else if (jobban_isbanned(user,J_Fav.name) || (J_Fav.requires_whitelist && !NT.Find(ckey(user.mind.key))))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Fav.name]. It has been removed from your Favorite slot.</span>")
				src.jobs_unwanted += J_Fav.name
				src.job_favorite = null
			else
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=1;job=[J_Fav.name];level=0\"><font color=[J_Fav.linkcolor]>[J_Fav.name]</font></a>"
		HTML += " <a href=\"byond://?src=\ref[user];preferences=1;help=favjobs\"><small>(Help)</small></a><br>"

		HTML += "<table>"

		HTML += "<tr>"
		HTML += "<th><b>Medium Priority:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=medjobs\"><small>(Help)</small></a></th>"
		HTML += "<th><b>Low Priority:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=lowjobs\"><small>(Help)</small></a></th>"
		HTML += "<th><b>Unwanted Jobs:</b> <a href=\"byond://?src=\ref[user];preferences=1;help=unjobs\"><small>(Help)</small></a></th>"
		HTML += "</tr><tr>"

		var/category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_med_priority)
			var/datum/job/J_Med = find_job_in_controller_by_string(J)
			if (!J_Med) continue
			if (jobban_isbanned(user,J_Med.name))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Med.name]. It has been removed from your Medium Priority List.</span>")
				src.jobs_med_priority -= J_Med.name
				src.jobs_unwanted += J_Med.name
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=1\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=0\"><font color=[J_Med.linkcolor]>[J_Med.name]</font></a>"
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=2;job=[J_Med.name];level=3\">\></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_low_priority)
			var/datum/job/J_Low = find_job_in_controller_by_string(J)
			if (!J_Low) continue
			if (J_Low.requires_whitelist && !NT.Find(ckey(user.mind.key))) continue
			if (jobban_isbanned(user,J_Low.name))
				boutput(user, "<span style=\"color:red\"><b>You are no longer allowed to play [J_Low.name]. It has been removed from your Low Priority List.</span>")
				src.jobs_low_priority -= J_Low.name
				src.jobs_unwanted += J_Low.name
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=2\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=0\"><font color=[J_Low.linkcolor]>[J_Low.name]</font></a>"
				HTML += " <a href=\"byond://?src=\ref[user];preferences=1;occ=3;job=[J_Low.name];level=4\">\></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		category_counter = 0
		HTML += {"<td valign="top"><center>"}
		for (var/J in src.jobs_unwanted)
			var/datum/job/J_Un = find_job_in_controller_by_string(J)
			if (!J_Un) continue
			if (J_Un.requires_whitelist && !NT.Find(ckey(user.mind.key))) continue
			if (J_Un.cant_allocate_unwanted)
				boutput(user, "<span style=\"color:red\"><b>[J_Un.name] is not supposed to be in the Unwanted category. It has been moved to Low Priority.</b></span>")
				boutput(user, "<span style=\"color:red\"><b>You may need to refresh your job preferences page to correct the job count.</b></span>")
				src.jobs_unwanted -= J_Un.name
				src.jobs_low_priority += J_Un.name
			if (jobban_isbanned(user,J_Un.name))
				HTML += "<strike>[J_Un.name]</strike><br>"
				category_counter++
			else
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=4;job=[J_Un.name];level=3\">\<</a> "
				HTML += "<a href=\"byond://?src=\ref[user];preferences=1;occ=4;job=[J_Un.name];level=0\"><font color=[J_Un.linkcolor]>[J_Un.name]</font></a>"
				HTML += "<br>"
				category_counter++
		if (category_counter == 0)
			HTML += "No Jobs are in this category."
		HTML += "</center></td>"

		HTML += "</tr></table>"

		HTML += "<br><b>Antagonist Roles:</b>"
		HTML += "<a href=\"byond://?src=\ref[user];preferences=1;help=antags\"><small>(Help)</small></a></a><br>"

		if (jobban_isbanned(user, "Syndicate"))
			HTML += "You are banned from playing antagonist roles.<br>"
			src.be_changeling = 0
			src.be_revhead = 0
			src.be_syndicate = 0
			src.be_wizard = 0
			src.be_traitor = 0
			src.be_vampire = 0
			src.be_spy = 0
			src.be_gangleader = 0
		else
			if (src.be_traitor) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_traitor=1\"><font color=#00CC00>Traitor</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_traitor=1\"><font color=#FF0000><strike>Traitor</strike></font></a>"

			HTML += " * "

			if (src.be_syndicate) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_syndicate=1\"><font color=#00CC00>Syndicate Operative</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_syndicate=1\"><font color=#FF0000><strike>Syndicate Operative</strike></font></a>"

			HTML += " * "
			/*
			if (src.be_spy) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_spy=1\"><font color=#00CC00>Spy</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_spy=1\"><font color=#FF0000><strike>Spy</strike></font></a>"

			HTML += " * "
			*/
			if (src.be_gangleader) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_gangleader=1\"><font color=#00CC00>Gang Leader</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_gangleader=1\"><font color=#FF0000><strike>Gang Leader</strike></font></a>"

			HTML += " * "

			/*
			if (src.be_revhead) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_revhead=1\"><font color=#00CC00>Revolution Leader</font></a><br>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_revhead=1\"><font color=#FF0000><strike>Revolution Leader</strike></font></a><br>"
			*/

			if (src.be_changeling) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_changeling=1\"><font color=#00CC00>Changeling</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_changeling=1\"><font color=#FF0000><strike>Changeling</strike></font></a>"

			HTML += "<br>"

			if (src.be_wizard) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wizard=1\"><font color=#00CC00>Wizard</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wizard=1\"><font color=#FF0000><strike>Wizard</strike></font></a>"

			HTML += " * "

			if (src.be_vampire) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_vampire=1\"><font color=#00CC00>Vampire</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_vampire=1\"><font color=#FF0000><strike>Vampire</strike></font></a>"

			HTML += " * "

			if (src.be_wraith) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wraith=1\"><font color=#00CC00>Wraith</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_wraith=1\"><font color=#FF0000><strike>Wraith</strike></font></a>"

			HTML += " * "

			if (src.be_blob) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_blob=1\"><font color=#00CC00>Blob</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_blob=1\"><font color=#FF0000><strike>Blob</strike></font></a>"

			HTML += " * "

			if (src.be_misc) HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_misc=1\"><font color=#00CC00>Other Foes</font></a>"
			else HTML += "<a href =\"byond://?src=\ref[user];preferences=1;b_misc=1\"><font color=#FF0000><strike>Other Foes</strike></font></a>"

		HTML += "<hr>"
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;help=jobs\"><b>Help</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;jobswindow=1\"><b>Refresh</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;resetalljobs=1\"><b>Reset All Jobs</b></a> * "}
		HTML += {"<a href=\"byond://?src=\ref[user];preferences=1;closejobswindow=1\"><b>Close Window</b></a>"}

		user << browse(null, "window=preferences")
		user << browse(HTML, "window=mob_occupation;size=550x400")
		return

	proc/SetJob(mob/user, occ=1, job="Captain",var/level = 0)
		if (src.antispam)
			return
		if (!find_job_in_controller_by_string(job,1))
			boutput(user, "<span style=\"color:red\"><b>The game could not find that job in the internal list of jobs.</b></span>")
			switch(occ)
				if (1) src.job_favorite = null
				if (2) src.jobs_med_priority -= job
				if (3) src.jobs_low_priority -= job
				if (4) src.jobs_unwanted -= job
			return
		if (job=="AI" && (!config.allow_ai))
			boutput(user, "<span style=\"color:red\"><b>Selecting the AI is not currently allowed.</b></span>")
			if (occ != 4)
				switch(occ)
					if (1) src.job_favorite = null
					if (2) src.jobs_med_priority -= job
					if (3) src.jobs_low_priority -= job
				src.jobs_unwanted += job
			return

		if (jobban_isbanned(user, job))
			boutput(user, "<span style=\"color:red\"><b>You are banned from this job and may not select it.</b></span>")
			if (occ != 4)
				switch(occ)
					if (1) src.job_favorite = null
					if (2) src.jobs_med_priority -= job
					if (3) src.jobs_low_priority -= job
				src.jobs_unwanted += job
			return

		src.antispam = 1

		var/picker = "Low Priority"
		if (level == 0)
			var/list/valid_actions = list("Favorite","Medium Priority","Low Priority","Unwanted")

			switch(occ)
				if (1) valid_actions -= "Favorite"
				if (2) valid_actions -= "Medium Priority"
				if (3) valid_actions -= "Low Priority"
				if (4) valid_actions -= "Unwanted"

			picker = input("Which bracket would you like to move this job to?","Job Preferences") as null|anything in valid_actions
			if (!picker)
				src.antispam = 0
				return
		else
			switch(level)
				if (1) picker = "Favorite"
				if (2) picker = "Medium Priority"
				if (3) picker = "Low Priority"
				if (4) picker = "Unwanted"
		var/datum/job/J = find_job_in_controller_by_string(job)
		if (J.cant_allocate_unwanted && picker == "Unwanted")
			boutput(user, "<span style=\"color:red\"><b>[job] cannot be set to Unwanted.</b></span>")
			src.antispam = 0
			return

		var/successful_move = 0

		switch(picker)
			if ("Favorite")
				if (src.job_favorite)
					src.jobs_med_priority += src.job_favorite
				src.job_favorite = job
				successful_move = 1
			if ("Medium Priority")
				src.jobs_med_priority += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1
			if ("Low Priority")
				src.jobs_low_priority += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1
			if ("Unwanted")
				src.jobs_unwanted += job
				if (occ == 1)
					src.job_favorite = null
				successful_move = 1

		if (successful_move)
			switch(occ)
				// i know, repetitive, but its the safest way i can think of right now
				if (2) src.jobs_med_priority -= job
				if (3) src.jobs_low_priority -= job
				if (4) src.jobs_unwanted -= job

		src.antispam = 0
		return 1

	proc/process_link(mob/user, list/link_tags)
		if (!user.client)
			return

		if (link_tags["help"])
			var/helptext = "<html><body><title>Jobs Help</title><b><u>Job Preferences Help:</u></b><br>"
			switch(link_tags["help"])
				if ("favjobs")
					helptext = {"The Favorite Job slot is for the one job you like the most - the game will always try to
					get you into this job first if it can.<br><br>
					During round setup, favorite jobs are always looked at first - the game will loop through every player
					who has not been currently granted a job and see if they have a favorite set. If they do, and there
					are still slots for that job open, they will be assigned their favorite. The list of players is
					randomized in order before this happens, to make sure the same players don't get priority every time.<br><br>
					You might not always get your favorite job, especially if it's a single-slot role like a Head, but
					don't be discouraged if you don't get it - it's just luck of the draw. You might get it next time."}
				if ("medjobs")
					helptext = {"Medium Priority Jobs are any jobs you would like to play that aren't your favorite. People with
					jobs in this category get priority over those who have the same job in their low priority bracket. It's best
					to put jobs here that you actively enjoy playing and wouldn't mind ending up with if you don't get your favorite."}
				if ("lowjobs")
					helptext = {"Low Priority Jobs are jobs that you don't mind doing. When the game is finding candidates for a job,
					it will try to fill it with Medium Priority players first, then Low Priority players if there are still free slots."}
				if ("unjobs")
					helptext = {"Unwanted Jobs are jobs that you absolutely don't want to have. Putting a job here will make sure you
					are never allocated this job at all. However, certain jobs can't be added to this category, such as Civilian.
					This is because these jobs are flagged as low-end jobs that will only be given out once all the other job slots are
					taken up - so don't worry, as long as you have jobs in your Medium or Low brackets and the server doesn't have a
					large player count at the time, you most likely won't end up as an Assistant unless you have it as your favorite."}
				if ("jobs")
					helptext = {"This is the Job Preference panel. Hold your mouse over a job icon and a tooltip will appear telling you
					what job it corresponds to. Clicking on one of these icons will prompt you for which category you want to move it to.
					More information about how the categories work can be obtained by clicking on the help icon next to the category name.<br><br>
					If you don't see all the job icons here (or if you don't see any at all), try resetting your job preferences."}
				if ("antags")
					helptext = {"These are your preferences for antagonist roles. If you have any of these disabled, you will never be
					selected automatically by the game to play as one of these enemy types. Green is enabled, Red is disabled. Bear in
					mind that admins can still select you by hand to play enemy roles during a round. Generally if you don't want to go
					along with whatever the admin has in mind, just adminhelp it and say so. Most of us are cool about that kind of thing."}

			user << browse(helptext, "window=jobs_help;size=400x400")
			return

		if (link_tags["job"])
			src.SetJob(user, text2num(link_tags["occ"]), link_tags["job"], text2num(link_tags["level"]))
			src.SetChoices(user)
			return

		if (link_tags["jobswindow"])
			src.SetChoices(user)
			return

		if (link_tags["traitswindow"])
			traitPreferences.showTraits(user)
			return

		if (link_tags["closejobswindow"])
			user << browse(null, "window=mob_occupation")
			src.ShowChoices(user)
			return


		if (link_tags["resetalljobs"])
			var/resetwhat = input("Reset all jobs to which level?","Job Preferences") as null|anything in list("Medium Priority","Low Priority","Unwanted")
			switch(resetwhat)
				if ("Medium Priority")
					src.ResetAllPrefsToMed(user)
				if ("Low Priority")
					src.ResetAllPrefsToLow(user)
				if ("Unwanted")
					src.ResetAllPrefsToUnwanted(user)
				else
					return
			src.SetChoices(user)
			return

		if (link_tags["profile_name"])
			var/new_profile_name

			new_profile_name = input(user, "Please select a name:", "Character Creation")  as null|text

			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_profile_name = replacetext(new_profile_name, c, "")

			new_profile_name = trim(new_profile_name)

			if (new_profile_name)
				if (length(new_profile_name) >= 26)
					new_profile_name = copytext(new_profile_name, 1, 26)
				src.profile_name = new_profile_name

		if (link_tags["real_name"])
			var/new_name

			switch(link_tags["real_name"])
				if ("input")
					new_name = input(user, "Please select a name:", "Character Creation")  as null|text
					var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
					for (var/c in bad_characters)
						new_name = replacetext(new_name, c, "")

					new_name = trim(new_name)
					if (!new_name || (lowertext(new_name) in list("unknown", "floor", "wall", "r wall")))
						alert("That name is reserved for use by the game. Please select another.")
						return
					if (!usr.client.holder)
						var/list/namecheck = splittext(trim(new_name), " ")
						if (namecheck.len < 2)
							alert("Your name must have at least a First and Last name, e.g. John Smith")
							return
						if (length(new_name) < 5)
							alert("Your name is too short. It must be at least 5 characters long.")
							return
						for (var/i = 1, i <= namecheck.len, i++)
							namecheck[i] = capitalize(namecheck[i])
						new_name = jointext(namecheck, " ")

				if ("random")
					if (src.gender == MALE)
						new_name = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
					else
						new_name = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
					randomizeLook()
			if (new_name)
				if (length(new_name) >= 26)
					new_name = copytext(new_name, 1, 26)
				src.real_name = new_name

		if (link_tags["hud_style"])
			var/new_hud = input(user, "Please select HUD style:", "HUD") as null|anything in hud_style_selection

			if (new_hud)
				src.hud_style = new_hud

		if (link_tags["set_resolution"])
			var/tempview = input(user, "Select your screen resolution:", "Resolution Changer")  as null|anything in reslist
			if (tempview)
				src.selectedview = tempview

		if (link_tags["tcursor"])
			var/new_cursor = input(user, "Please select cursor:", "Cursor") as null|anything in cursors_selection

			if (new_cursor)
				src.target_cursor = new_cursor

		if (link_tags["age"])
			var/new_age = input(user, "Please select type in age: 14-80", "Character Creation")  as null|num

			if (new_age)
				src.age = max(min(round(text2num(new_age)), 80), 14)


		if (link_tags["pin"])
			var/new_pin = input(user, "Please set a four digit PIN:", "Character Creation")  as null|num

			if (new_pin)
				src.pin = max(min(round(text2num(new_pin)), 9999), 1000)

		if (link_tags["charsheet"])
			var/newsheet = input(user, "Write your character sheet:", "Character Creation", charsheet)  as null|message
			var/list/bad_characters = list("<", ">")
			for (var/c in bad_characters)
				newsheet = replacetext(newsheet, c, "")
			charsheet = newsheet

		if (link_tags["blType"])
			var/blTypeNew = input(user, "Please select a blood type:", "Character Creation")  as null|anything in list("Random", "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

			if (blTypeNew)
				if (blTypeNew == "Random")
					src.random_blood = 1
				else
					src.random_blood = 0
					blType = blTypeNew

		if (link_tags["hair"])
			var/new_hair = input(user, "Please select hair color.", "Character Creation", AH.customization_first_color) as null|color
			if (new_hair)
				AH.customization_first_color = new_hair

		if (link_tags["facial"])
			var/new_facial = input(user, "Please select facial hair color.", "Character Creation", AH.customization_third_color) as null|color
			if (new_facial)
				AH.customization_third_color = new_facial

		/*if (link_tags["detail"])
			var/new_detail = input(user, "Please select detail 2 color.", "Character Creation", AH.customization_third_color) as null|color
			if (new_detail)
				AH.customization_third_color = new_detail*/


		if (link_tags["underwear"])
			var/new_style = input(user, "Please select the underwear you want.", "Character Generation")  as null|anything in underwears

			if (new_style)
				underwear = new_style

		if (link_tags["underwear_color"])
			var/new_ucolor = input(user, "Please select primary underwear color.", "Character Generation", underwear_color) as null|color
			if (new_ucolor)
				underwear_color = new_ucolor

		if (link_tags["underwear_detail_color"])
			var/new_ucolor = input(user, "Please select secondary underwear color.", "Character Generation", underwear_detail_color) as null|color
			if (new_ucolor)
				underwear_detail_color = new_ucolor

		if (link_tags["shirt"])
			var/new_style = input(user, "Please select the shirt you want.", "Character Generation")  as null|anything in tops

			if (new_style)
				shirt = new_style

		if (link_tags["shirt_color"])
			var/new_ucolor = input(user, "Please select primary shirt color.", "Character Generation", shirt_color) as null|color
			if (new_ucolor)
				shirt_color = new_ucolor

		if (link_tags["shirt_detail_color"])
			var/new_ucolor = input(user, "Please select secondary shirt color.", "Character Generation", shirt_detail_color) as null|color
			if (new_ucolor)
				shirt_detail_color = new_ucolor

		if (link_tags["jacket"])
			var/new_style = input(user, "Please select the overcoat you want.", "Character Generation")  as null|anything in jackets

			if (new_style)
				jacket = new_style

		if (link_tags["jacket_color"])
			var/new_ucolor = input(user, "Please select primary overcoat color.", "Character Generation", jacket_color) as null|color
			if (new_ucolor)
				jacket_color = new_ucolor

		if (link_tags["jacket_detail_color"])
			var/new_ucolor = input(user, "Please select secondary overcoat color.", "Character Generation", jacket_detail_color) as null|color
			if (new_ucolor)
				jacket_detail_color = new_ucolor

		if (link_tags["bottom"])
			var/new_style = input(user, "Please select the bottoms you want.", "Character Generation")  as null|anything in bottoms

			if (new_style)
				bottom = new_style

		if (link_tags["bottom_color"])
			var/new_ucolor = input(user, "Please select primary bottoms color.", "Character Generation", bottom_color) as null|color
			if (new_ucolor)
				bottom_color = new_ucolor

		if (link_tags["bottom_detail_color"])
			var/new_ucolor = input(user, "Please select secondary bottoms color.", "Character Generation", bottom_detail_color) as null|color
			if (new_ucolor)
				bottom_detail_color = new_ucolor


		if (link_tags["sock"])
			var/new_style = input(user, "Please select the socks you want.", "Character Generation")  as null|anything in socks

			if (new_style)
				sock = new_style

		if (link_tags["sock_color"])
			var/new_ucolor = input(user, "Please select primary socks color.", "Character Generation", sock_color) as null|color
			if (new_ucolor)
				sock_color = new_ucolor

		if (link_tags["sock_detail_color"])
			var/new_ucolor = input(user, "Please select secondary socks detail color.", "Character Generation", sock_detail_color) as null|color
			if (new_ucolor)
				sock_detail_color = new_ucolor


		if (link_tags["shoe"])
			var/new_style = input(user, "Please select the shoes you want.", "Character Generation")  as null|anything in shoes

			if (new_style)
				shoe = new_style

		if (link_tags["shoe_color"])
			var/new_ucolor = input(user, "Please select primary shoe color.", "Character Generation", shoe_color) as null|color
			if (new_ucolor)
				shoe_color = new_ucolor

		if (link_tags["shoe_detail_color"])
			var/new_ucolor = input(user, "Please select secondary shoe color.", "Character Generation", shoe_detail_color) as null|color
			if (new_ucolor)
				shoe_detail_color = new_ucolor


		if (link_tags["eyes"])
			var/new_eyes = input(user, "Please select eye color.", "Character Creation", AH.e_color) as null|color
			if (new_eyes)
				AH.e_color = new_eyes

		if (link_tags["s_color"])
			var/new_tone = input(user, "Please select a skin colour.", "Character Creation", AH.s_color) as null|color
			if (new_tone)
				AH.s_color = new_tone
/*
		if (link_tags["s_tone"])
			var/new_tone = input(user, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation")  as null|num

			if (new_tone)
				AH.s_tone = max(min(round(new_tone), 220), 1)
				AH.s_tone =  -AH.s_tone + 35
*/
		if (link_tags["customization_first"])
			var/new_style = input(user, "Please select the hair style you want.", "Character Creation")  as null|anything in d_hhairs

			if (new_style)
				AH.customization_first = new_style

		/*
		if (link_tags["customization_second"])
			var/new_style = input(user, "Please select the detail style you want.", "Character Creation")  as null|anything in customization_styles

			if (new_style)
				AH.customization_second = new_style
			*/

		if (link_tags["customization_third"])
			var/new_style = input(user, "Please select the detail style you want.", "Character Creation")  as null|anything in d_fhairs

			if (new_style)
				AH.customization_third = new_style


		//start furry shit
		if (link_tags["ears"])
			var/new_style = input(user, "Please select the ears you want.", "Character Creation")  as null|anything in d_ears

			if (new_style)
				AH.ears = new_style

		if (link_tags["ears_color"])
			var/new_ucolor = input(user, "Please select ear color.", "Character Creation", AH.ear_color) as null|color
			if (new_ucolor)
				AH.ear_color = new_ucolor

		if (link_tags["ears_detail_color"])
			var/new_ucolor = input(user, "Please select ear detail color.", "Character Creation", AH.ear_detail_color) as null|color
			if (new_ucolor)
				AH.ear_detail_color = new_ucolor


		if (link_tags["tails"])
			var/new_style = input(user, "Please select the tail you want.", "Character Creation")  as null|anything in d_tails

			if (new_style)
				AH.tail = new_style

		if (link_tags["tails_color"])
			var/new_ucolor = input(user, "Please select tail color.", "Character Creation", AH.tail_color) as null|color
			if (new_ucolor)
				AH.tail_color = new_ucolor

		if (link_tags["tails_detail_color"])
			var/new_ucolor = input(user, "Please select tail detail color.", "Character Creation", AH.tail_detail_color) as null|color
			if (new_ucolor)
				AH.tail_detail_color = new_ucolor


		if (link_tags["chest_detail"])
			var/new_style = input(user, "Please select your chest detail.", "Character Creation")  as null|anything in d_chests

			if (new_style)
				AH.chest_detail = new_style

		if (link_tags["chest_detail_color"])
			var/new_ucolor = input(user, "Please select chest detail color.", "Character Creation", AH.chest_detail_color) as null|color
			if (new_ucolor)
				AH.chest_detail_color = new_ucolor


		if (link_tags["arm_detail"])
			var/new_style = input(user, "Please select your arm detail.", "Character Creation")  as null|anything in d_arms

			if (new_style)
				AH.arm_detail = new_style

		if (link_tags["arm_detail_color"])
			var/new_ucolor = input(user, "Please select arm detail color.", "Character Creation", AH.arm_detail_color) as null|color
			if (new_ucolor)
				AH.arm_detail_color = new_ucolor


		if (link_tags["leg_detail"])
			var/new_style = input(user, "Please select your leg detail.", "Character Creation")  as null|anything in d_legs

			if (new_style)
				AH.leg_detail = new_style

		if (link_tags["leg_detail_color"])
			var/new_ucolor = input(user, "Please select arm detail color.", "Character Creation", AH.leg_detail_color) as null|color
			if (new_ucolor)
				AH.leg_detail_color = new_ucolor

		if (link_tags["face_detail"])
			var/new_style = input(user, "Please select your face detail.", "Character Creation")  as null|anything in d_faces

			if (new_style)
				AH.face_detail = new_style

		if (link_tags["face_detail_color"])
			var/new_ucolor = input(user, "Please select face detail color.", "Character Creation", AH.face_detail_color) as null|color
			if (new_ucolor)
				AH.face_detail_color = new_ucolor
		//end furry shit

		if (link_tags["gender"])
			var/new_gender = input(user, "Please write your gender:", "Character Creation")  as null|text
			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_gender = replacetext(new_gender, c, "")

			new_gender = trim(new_gender)

			if(new_gender == "male")
				src.gender = MALE
				AH.gender = MALE
				src.writtengender = new_gender
				AH.writtengender = new_gender
			else if(new_gender == "female")
				src.gender = FEMALE
				AH.gender = FEMALE
				src.writtengender = new_gender
				AH.writtengender = new_gender
			else
				src.gender = FEMALE
				AH.gender = FEMALE
				src.writtengender = new_gender
				AH.writtengender = new_gender


		if (link_tags["changelog"])
			src.view_changelog = !(src.view_changelog)

		if (link_tags["toggle_mentorhelp"])
			if (user && user.client && user.client.mentor_authed)
				src.see_mentor_pms = !(src.see_mentor_pms)
				user.client.set_mentorhelp_visibility(src.see_mentor_pms)

		if (link_tags["listen_ooc"])
			src.listen_ooc = !(src.listen_ooc)

		if (link_tags["listen_looc"])
			src.listen_looc = !(src.listen_looc)

		if (link_tags["volume"])
			src.admin_music_volume = input("Goes from 0 to 100.","Admin Music Volume", src.admin_music_volume) as num
			src.admin_music_volume = max(0,min(src.admin_music_volume,100))

		if (link_tags["clickbuffer"])
			src.use_click_buffer = !(src.use_click_buffer)

		if (link_tags["default_wasd"])
			src.default_wasd = !(src.default_wasd)

		if (link_tags["use_azerty"])
			src.use_azerty = !(src.use_azerty)
			if (user && user.client)
				user.client.use_azerty = src.use_azerty

		if (link_tags["scores"])
			src.view_score = !(src.view_score)

		if (link_tags["tickets"])
			src.view_tickets = !(src.view_tickets)

		if (link_tags["b_changeling"])
			src.be_changeling = !( src.be_changeling )
			src.SetChoices(user)
			return

		if (link_tags["b_revhead"])
			src.be_revhead = !( src.be_revhead )
			src.SetChoices(user)
			return

		if (link_tags["b_syndicate"])
			src.be_syndicate = !( src.be_syndicate )
			src.SetChoices(user)
			return

		if (link_tags["b_wizard"])
			src.be_wizard = !( src.be_wizard)
			src.SetChoices(user)
			return

		if (link_tags["b_traitor"])
			src.be_traitor = !( src.be_traitor)
			src.SetChoices(user)
			return

		if (link_tags["b_vampire"])
			src.be_vampire = !( src.be_vampire)
			src.SetChoices(user)
			return

		if (link_tags["b_spy"])
			src.be_spy = !( src.be_spy)
			src.SetChoices(user)
			return

		if (link_tags["b_gangleader"])
			src.be_gangleader = !( src.be_gangleader)
			src.SetChoices(user)
			return

		if (link_tags["b_wraith"])
			src.be_wraith = !( src.be_wraith)
			src.SetChoices(user)
			return

		if (link_tags["b_blob"])
			src.be_blob = !( src.be_blob)
			src.SetChoices(user)
			return

		if (link_tags["b_misc"])
			src.be_misc = !src.be_misc
			src.SetChoices(user)
			return

		if (link_tags["b_random_name"])
			if (!force_random_names)
				src.be_random_name = !src.be_random_name
			else
				src.be_random_name = 1

		if (link_tags["b_random_look"])
			if (!force_random_looks)
				src.be_random_look = !src.be_random_look
			else
				src.be_random_look = 1

		/* Wire: a little thing i'll finish up eventually
		if (link_tags["set_will"])
			var/new_will = input(user, "Write a Will that shall appear in the event of your death. (250 max)", "Character Creation")  as text
			var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
			for (var/c in bad_characters)
				new_will = replacetext(new_will, c, "")

			if (new_will)
				if (length(new_will) > 250)
					new_will = copytext(new_will, 1, 251)
				src.will = new_will
		*/

		if (!IsGuestKey(user.key))
			if (link_tags["save"])
				src.savefile_save(user, (isnum(text2num(link_tags["save"])) ? text2num(link_tags["save"]) : 1))
				boutput(user, "<span style=\"color:orange\"><b>Character saved to Slot [text2num(link_tags["save"])].</b></span>")

			else if (link_tags["load"])
				if (!src.savefile_load(user, (isnum(text2num(link_tags["load"])) ? text2num(link_tags["load"]) : 1)))
					alert(user, "You do not have a savefile.")
				else if (!user.client.holder)
					sanitize_name()
					boutput(user, "<span style=\"color:orange\"><b>Character loaded from Slot [text2num(link_tags["load"])].</b></span>")
				else
					boutput(user, "<span style=\"color:orange\"><b>Character loaded from Slot [text2num(link_tags["load"])].</b></span>")

			else if (link_tags["spacetopiaload"])
				if (!user.client.authed)
					alert(user, "You are not authorized.")
				else
					boutput(user, "<span class=\"[user.client.api["username"]]\"><b>Character profile for [user.client.api["real_name"]] loaded.</b></span>")
					src.profile_name = user.client.api["username"]
					src.real_name = user.client.api["real_name"]
					src.age = user.client.api["age"]
					user.bioHolder.age = user.client.api["age"]
					AH.writtengender = user.client.api["gender"]
					user.bioHolder.charsheet = user.client.api["bio"]

					var/new_gender = user.client.api["gender"]
					var/list/bad_characters = list("_", "'", "\"", "<", ">", ";", "[", "]", "{", "}", "|", "\\", "/")
					for (var/c in bad_characters)
						new_gender = replacetext(new_gender, c, "")

					new_gender = trim(new_gender)


		if (link_tags["previewrotation"])
			switch(previewrotation)
				if(SOUTH) previewrotation = EAST
				if(EAST) previewrotation = NORTH
				if(NORTH) previewrotation = WEST
				if(WEST) previewrotation = SOUTH


		if (link_tags["reset_all"])
			src.gender = MALE
			AH.gender = MALE
			src.writtengender = "None"
			AH.writtengender = "None"
			randomize_name()

			AH.customization_first = "None"
			//AH.customization_second = "None"
			AH.customization_third = "None"

			//furry shit
			AH.tail = "None"
			AH.ears = "None"

			AH.customization_first_color = 0
			//AH.customization_second_color = 0
			AH.customization_third_color = 0
			AH.e_color = 0
			underwear_color = "#FFFFFF"
			underwear = "None"

			AH.s_tone = 0.0

			AH.s_color = "#fec081"
			age = 18
			pin = null
			src.ResetAllPrefsToLow(user)
			listen_ooc = 1
			view_changelog = 1
			view_score = 1
			view_tickets = 1
			admin_music_volume = 50
			use_click_buffer = 0
			be_changeling = 0
			be_revhead = 0
			be_syndicate = 0
			be_wizard = 0
			be_wraith = 0
			be_blob = 0
			be_misc = 0
			be_traitor = 0
			be_vampire = 0
			be_spy = 0
			be_gangleader = 0
			selectedview = "800x600"
			if (!force_random_names)
				be_random_name = 0
			else
				be_random_name = 1
			if (!force_random_looks)
				be_random_look = 0
			else
				be_random_look = 1
			blType = "A+"
			charsheet = ""

		src.ShowChoices(user)

	proc/copy_to(mob/character,var/mob/user,ignore_randomizer = 0)
		sanitize_null_values()
		if (!ignore_randomizer)
			var/namebanned = jobban_isbanned(user, "Custom Names")
			if (be_random_name || namebanned)
				randomize_name()

			if (be_random_look || namebanned)
				randomizeLook()

			if (character.bioHolder)
				if (random_blood || namebanned)
					character.bioHolder.bloodType = random_blood_type()
				else
					character.bioHolder.bloodType = blType

		character.real_name = real_name

		//Wire: Not everything has a bioholder you morons
		if (character.bioHolder)
			character.bioHolder.age = age
			character.bioHolder.mobAppearance.CopyOther(AH)
			character.bioHolder.mobAppearance.gender = src.gender
			character.bioHolder.charsheet = src.charsheet

		//Also I think stuff other than human mobs can call this proc jesus christ
		if (ishuman(character))
			var/mob/living/carbon/human/H = character
			H.pin = pin
			H.gender = src.gender

		if (traitPreferences.isValid() && character.traitHolder)
			for (var/T in traitPreferences.traits_selected)
				character.traitHolder.addTrait(T)

		character.update_face()
		character.update_body()


		if(shirt != "None")
			var/obj/item/clothing/under/shirt/wear = new /obj/item/clothing/under/shirt

			wear.name = src.tops[shirt]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.tops[shirt]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.tops[shirt]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.tops[shirt]["options"] == "1") wear.color = shirt_color
			wear.detail_color = shirt_detail_color
			if(src.tops[shirt]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(shirt_color, shirt_detail_color, null, null)
				wearicon.MapColors(shirt_color, shirt_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_w_uniform)
			//world.log << "trying to equip: item: [shirt] color: [wear.color] detail color:[wear.detail_color] icon: icons/custom_icons/[src.tops[shirt]["icon"]]"

		if(jacket != "None")
			var/obj/item/clothing/suit/overcoat/wear = new /obj/item/clothing/suit/overcoat

			wear.name = src.jackets[jacket]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.jackets[jacket]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.jackets[jacket]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.jackets[jacket]["options"] == "1") wear.color = jacket_color
			wear.detail_color = jacket_detail_color
			if(src.jackets[jacket]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(jacket_color, jacket_detail_color, null, null)
				wearicon.MapColors(jacket_color, jacket_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_wear_suit)

		if(bottom != "None")
			var/obj/item/clothing/bottom/wear = new /obj/item/clothing/bottom

			wear.name = src.bottoms[bottom]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.bottoms[bottom]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.bottoms[bottom]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.bottoms[bottom]["options"] == "1") wear.color = bottom_color
			wear.detail_color = bottom_detail_color
			if(src.bottoms[bottom]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(bottom_color, bottom_detail_color, null, null)
				wearicon.MapColors(bottom_color, bottom_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_bottom)
			//world.log << "trying to equip: item: [shirt] color: [wear.color] detail color:[wear.detail_color] icon: icons/custom_icons/[src.bottoms[bottom]["icon"]]"

		if(sock != "None")
			var/obj/item/clothing/socks/wear = new /obj/item/clothing/socks

			wear.name = src.socks[sock]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.socks[sock]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.socks[sock]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.socks[sock]["options"] == "1") wear.color = sock_color
			wear.detail_color = sock_detail_color
			if(src.socks[sock]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(sock_color, sock_detail_color, null, null)
				wearicon.MapColors(sock_color, sock_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_socks)

		if(shoe != "None")
			var/obj/item/clothing/shoes/wear = new /obj/item/clothing/shoes

			wear.name = src.shoes[shoe]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.shoes[shoe]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.shoes[shoe]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.shoes[shoe]["options"] == "1") wear.color = shoe_color
			wear.detail_color = shoe_detail_color
			if(src.shoes[shoe]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(shoe_color, shoe_detail_color, null, null)
				wearicon.MapColors(shoe_color, shoe_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_shoes)

		if(underwear != "None")
			var/obj/item/clothing/underwear/wear = new /obj/item/clothing/underwear

			wear.name = src.underwears[underwear]["name"]

			var/icon/itemicon = icon(file("icons/custom_icons/" + src.underwears[underwear]["icon"]), "item", SOUTH)
			var/icon/wearicon = icon(file("icons/custom_icons/" + src.underwears[underwear]["icon"]))

			wear.icon_state = "worn"
			wear.item_state = "item"

			if(src.underwears[underwear]["options"] == "1") wear.color = underwear_color
			wear.detail_color = underwear_detail_color
			if(src.underwears[underwear]["options"] == "2")
				wear.has_detail = 1
				itemicon.MapColors(underwear_color, underwear_detail_color, null, null)
				wearicon.MapColors(underwear_color, underwear_detail_color, null, null)

			wear.wear_image.icon = wearicon
			wear.icon = itemicon

			character:equip_if_possible(wear, character:slot_underwear)

	proc/sanitize_null_values()
		if (!src.gender || !(src.gender == MALE || src.gender == FEMALE))
			src.gender = MALE
		if (!AH)
			AH = new
		if (AH.gender != src.gender)
			AH.gender = src.gender
		if (AH.customization_first_color == null)
			AH.customization_first_color = "#101010"
		if (AH.customization_first == null)
			AH.customization_first = "None"
		if (AH.customization_second_color == null)
			AH.customization_second_color = "#101010"
		if (AH.customization_second == null)
			AH.customization_second = "None"
		if (AH.customization_third_color == null)
			AH.customization_third_color = "#101010"
		if (AH.customization_third == null)
			AH.customization_third = "None"
		if (AH.e_color == null)
			AH.e_color = "#101010"
		if (underwear_color == null)
			underwear_color = "#FFFFFF"

/* ---------------------- RANDOMIZER PROC STUFF */

/proc/random_blood_type(var/weighted = 1)
	var/return_type
	// set a default one so that, if none of the weighted ones happen, they at least have SOME kind of blood type
	return_type = pick("O", "A", "B", "AB") + pick("+", "-")
	if (weighted)
		var/list/types_and_probs = list(\
		"O" = 40,\
		"A" = 30,\
		"B" = 15,\
		"AB" = 5)
		for (var/i in types_and_probs)
			if (prob(types_and_probs[i]))
				return_type = i
				if (prob(80))
					return_type += "+"
				else
					return_type += "-"
	return return_type

/proc/random_saturated_hex_color(var/pound = 0)
	var/R
	var/G
	var/B
	var/return_RGB

	var/colorpick = rand(1,3)

	switch (colorpick)
		if (1)
			R = "FF"
			G = random_hex(2)
			B = random_hex(2)
		if (2)
			R = random_hex(2)
			G = "FF"
			B = random_hex(2)
		if (3)
			R = random_hex(2)
			G = random_hex(2)
			B = "FF"

	return_RGB = (pound ? "#" : null) + R + G + B
	return return_RGB

/proc/randomize_hair_color(var/hcolor)
	if (!hcolor)
		return
	var/adj = 0
	if (copytext(hcolor, 1, 2) == "#")
		adj = 1
	//DEBUG("HAIR initial: [hcolor]")
	var/hR_adj = num2hex(hex2num(copytext(hcolor, 1 + adj, 3 + adj)) + rand(-25,25))
	//DEBUG("HAIR R: [hR_adj]")
	var/hG_adj = num2hex(hex2num(copytext(hcolor, 3 + adj, 5 + adj)) + rand(-5,5))
	//DEBUG("HAIR G: [hG_adj]")
	var/hB_adj = num2hex(hex2num(copytext(hcolor, 5 + adj, 7 + adj)) + rand(-10,10))
	//DEBUG("HAIR B: [hB_adj]")
	var/return_color = "#" + hR_adj + hG_adj + hB_adj
	//DEBUG("HAIR final: [return_color]")
	return return_color

/proc/randomize_eye_color(var/ecolor)
	if (!ecolor)
		return
	var/adj = 0
	if (copytext(ecolor, 1, 2) == "#")
		adj = 1
	//DEBUG("EYE initial: [ecolor]")
	var/eR_adj = num2hex(hex2num(copytext(ecolor, 1 + adj, 3 + adj)) + rand(-10,10))
	//DEBUG("EYE R: [eR_adj]")
	var/eG_adj = num2hex(hex2num(copytext(ecolor, 3 + adj, 5 + adj)) + rand(-10,10))
	//DEBUG("EYE G: [eG_adj]")
	var/eB_adj = num2hex(hex2num(copytext(ecolor, 5 + adj, 7 + adj)) + rand(-10,10))
	//DEBUG("EYE B: [eB_adj]")
	var/return_color = "#" + eR_adj + eG_adj + eB_adj
	//DEBUG("EYE final: [return_color]")
	return return_color


/* DEPRECATED
var/global/list/underwear_styles = list("None" = "none",
	"Briefs" = "/obj/item/clothing/underwear/briefs",
	"Boxers" = "/obj/item/clothing/underwear/boxers",
	"Bra and Panties" = "/obj/item/clothing/underwear/brapan",
	"Tanktop and Panties" = "/obj/item/clothing/underwear/tankpan",
	"Bra and Boyshorts" = "/obj/item/clothing/underwear/braboy",
	"Tanktop and Boyshorts" = "/obj/item/clothing/underwear/tankboy",
	"Panties" = "/obj/item/clothing/underwear/panties",
	"Boyshorts" = "/obj/item/clothing/underwear/boyshorts")

var/global/list/shirt_styles = list("None" = "none",
	"Plain Shirt" = "/obj/item/clothing/under/shirt",
	"Shirt with Vest" = "/obj/item/clothing/under/shirt/with_vest",
	"Shirt with Shoulder Stripes" = "/obj/item/clothing/under/shirt/shoulder_s",
	"Buttoned Shirt" = "/obj/item/clothing/under/shirt/buttoned",
	"Formal Shirt w/ Tie" = "/obj/item/clothing/under/shirt/w_tie",
	"Short-Sleeved Shirt w/ Tie" = "/obj/item/clothing/under/shirt/short_w_tie",
	"Tank Top" = "/obj/item/clothing/under/shirt/tanktop",
	"T-Shirt" = "/obj/item/clothing/under/shirt/tshirt")

var/global/list/bottom_styles = list("None" = "none",
	"Plain Trousers" = "/obj/item/clothing/bottom",
	"Checkered Trousers" = "/obj/item/clothing/bottom/checkered",
	"Track Trousers" = "/obj/item/clothing/bottom/track",
	"Shorts" = "/obj/item/clothing/bottom/shorts",
	"Plain Skirt" = "/obj/item/clothing/bottom/skirt",
	"Striped Skirt" = "/obj/item/clothing/bottom/skirt/striped")

var/global/list/sock_styles = list("None" = "none",
	"Socks" = "/obj/item/clothing/socks",
	"Stockings" = "/obj/item/clothing/socks/stockings",
	"Striped Stockings"= "/obj/item/clothing/socks/stockings/striped")

var/global/list/shoe_styles = list("None" = "none",
	"Shoes" = "/obj/item/clothing/shoes/color",
	"Boots" = "/obj/item/clothing/shoes/boots")
*/

var/global/list/feminine_hstyles = list("Mohawk" = "mohawk",\
	"Pompadour" = "pomp",\
	"Ponytail" = "ponytail",\
	"Mullet" = "long",\
	"Emo" = "emo",\
	"Lucy" = "lucy",\
	"Nyu" = "nyu",\
	"Scene" = "scene",\
	"Girly" = "girly",\
	"Messy" = "messyfemale",\
	"Bun" = "bun",\
	"Bieber" = "bieb",\
	"Parted Hair" = "part",\
	"Draped" = "shoulders",\
	"Bedhead" = "bedhead",\
	"Afro" = "afro",\
	"Long Braid" = "longbraid",\
	"Very Long" = "vlong",\
	"Hairmetal" = "80s",\
	"Glammetal" = "glammetal",\
	"Fabio" = "fabio",\
	"Right Half-Shaved" = "halfshavedL",\
	"Left Half-Shaved" = "halfshavedR",\
	"High Ponytail" = "spud",\
	"Low Ponytail" = "band",\
	"Indian" = "indian",\
	"Shoulder Drape" = "pulledf",\
	"Punky Flip" = "shortflip",\
	"Pigtails" = "pig",\
	"Low Pigtails" = "lowpig",\
	"Mid-Back Length" = "midb",\
	"Shoulder Length" = "shoulderl",\
	"Pulled Back" = "pulledb",\
	"Choppy Short" = "chop_short",\
	"Long and Froofy" = "froofy_long",\
	"Wavy Ponytail" = "wavy_tail")

var/global/list/masculine_hstyles = list("None" = "None",\
	"Balding" = "balding",\
	"Tonsure" = "tonsure",\
	"Buzzcut" = "cut",\
	"Trimmed" = "short",\
	"Mohawk" = "mohawk",\
	"Flat Top" = "flattop",\
	"Pompadour" = "pomp",\
	"Ponytail" = "ponytail",\
	"Mullet" = "long",\
	"Emo" = "emo",\
	"Lucy" = "lucy",\
	"Nyu" = "nyu",\
	"Scene" = "scene",\
	"Girly" = "girly",\
	"Messy" = "messyfemale",\
	"Bieber" = "bieb",\
	"Persh Cut" = "bowl",\
	"Parted Hair" = "part",\
	"Einstein" = "einstein",\
	"Bedhead" = "bedhead",\
	"Dreadlocks" = "dreads",\
	"Afro" = "afro",\
	"Kingmetal" = "king-of-rock-and-roll",\
	"Scraggly" = "scraggly",\
	"Right Half-Shaved" = "halfshavedL",\
	"Left Half-Shaved" = "halfshavedR",\
	"High Flat Top" = "charioteers",\
	"Punky Flip" = "shortflip",\
	"Mid-Back Length" = "midb",\
	"Split-Tails" = "twotail",\
	"Choppy Short" = "chop_short")

var/global/list/facial_hair = list("None" = "none",\
	"Chaplin" = "chaplin",\
	"Selleck" = "selleck",\
	"Watson" = "watson",\
	"Old Nick" = "devil",\
	"Fu Manchu" = "fu",\
	"Twirly" = "villain",\
	"Dali" = "dali",\
	"Hogan" = "hogan",\
	"Van Dyke" = "vandyke",\
	"Hipster" = "hip",\
	"Robotnik" = "robo",\
	"Elvis" = "elvis",\
	"Goatee" = "gt",\
	"Chinstrap" = "chin",\
	"Neckbeard" = "neckbeard",\
	"Abe" = "abe",\
	"Full Beard" = "fullbeard",\
	"Braided Beard" = "braided",\
	"Puffy Beard" = "puffbeard",\
	"Long Beard" = "longbeard",\
	"Tramp" = "tramp",\
	"Eyebrows" = "eyebrows",\
	"Huge Eyebrows" = "thufir")

var/global/list/reslist = list("640x480" = 5,\
	"800x600" = 7,\
	"1024x768" = 9,\
	"1280x720" = 9,\
	"1280x800" = 10,\
	"1440x900" = 11,\
	"1600x900" = 11,\
	"1280x960" = 12,\
	"1600x1200" = 12,\
	"1280x1024" = 13,\
	"1920x1080" = 14,\
	"1920x1200" = 16)


//furry shit
var/global/list/ears_styles = list("None" = "none",\
	"Cat Ears" = "cat", \
	"Fox Ears" = "fox")
var/global/list/tails_styles = list("None" = "none",\
	"Cat Tail" = "cat_tail_still",\
	"Fox Tail" = "fox_tail_still")
var/global/list/chest_detail_styles = list("None" = "none",\
	"Full Chest" = "chest",\
	"Chest Tuft" = "tuft")
var/global/list/arm_detail_styles = list("None" = "none",\
	"Full Arms" = "arm")
var/global/list/leg_detail_styles = list("None" = "none",\
	"Full Legs" = "leg")
var/global/list/face_detail_styles = list("None" = "none",\
	"Fox Nose" = "fox")

// this is weird but basically: a list of hairstyles and their appropriate detail styles, aka hair_details["80s"] would return the Hairmetal: Faded style
// further on in the randomize_look() proc we'll see if we've got one of the styles in here and if so, we have a chance to add the detailing
// if it's a list then we'll pick from the options in the list
var/global/list/hair_details = list("einstein" = "einalt",\
	"80s" = "80sfade",\
	"glammetal" = "glammetalO",\
	"pomp" = "pompS",\
	"mohawk" = list("mohawkFT", "mohawkFB", "mohawkS"),\
	"emo" = "emoH",\
	"clown" = list("clownT", "clownM", "clownB"),\
	"dreads" = "dreadsA",\
	"afro" = list("afroHR", "afroHL", "afroST", "afroSM", "afroSB", "afroSL", "afroSR", "afroSC", "afroCNE", "afroCNW", "afroCSE", "afroCSW", "afroSV", "afroSH"))



/proc/randomize_look(var/to_randomize, var/change_gender = 1, var/change_blood = 1, var/change_age = 1, var/change_name = 1, var/change_underwear = 1, var/remove_effects = 1)
	if (!to_randomize)
		return

	var/mob/living/carbon/human/H
	var/datum/appearanceHolder/AH

	if (ishuman(to_randomize))
		H = to_randomize
		if (H.bioHolder && H.bioHolder.mobAppearance)
			AH = H.bioHolder.mobAppearance

	else if (istype(to_randomize, /datum/appearanceHolder))
		AH = to_randomize
		if (ishuman(AH.owner))
			H = AH.owner

	else
		return

	var/list/hair_colors = list("#101010", "#924D28", "#61301B", "#E0721D", "#D7A83D",\
	"#D8C078", "#E3CC88", "#F2DA91", "#F21AE", "#664F3C", "#8C684A", "#EE2A22", "#B89778", "#3B3024", "#A56b46")
	var/hair_color
	if (prob(75))
		hair_color = randomize_hair_color(pick(hair_colors))
	else
		hair_color = randomize_hair_color(random_saturated_hex_color())

	AH.customization_first_color = hair_color
	AH.customization_second_color = hair_color
	AH.customization_third_color = hair_color

	//var/list/skintones = list("#de7979", "#924D28", "#61301B", "#E0721D", "#D7A83D",\
	"#D8C078", "#E3CC88", "#F2DA91", "#F21AE", "#664F3C", "#8C684A", "#EE2A22", "#B89778", "#3B3024", "#A56b46")
	//AH.s_color = randomize_hair_color(pick(skintones))
	AH.s_tone = rand(34,-184)
	if (AH.s_tone < -30)
		AH.s_tone = rand(34,-184)
	if (AH.s_tone < -50)
		AH.s_tone = rand(34,-184)
	if (H)
		if (H.limbs)
			H.limbs.reset_stone()

	var/list/eye_colors = list("#101010", "#613F1D", "#808000", "#3333CC")
	AH.e_color = randomize_eye_color(pick(eye_colors))

	if (H && change_blood)
		H.bioHolder.bloodType = random_blood_type(1)

	if (H && change_age)
		H.bioHolder.age = rand(18,80)

	if (H && H.organHolder && H.organHolder.head && H.organHolder.head.donor_appearance) // aaaa
		H.organHolder.head.donor_appearance.CopyOther(AH)

	if(AH.gender == "male")
		AH.gender = MALE
		AH.writtengender = AH.writtengender
		//bottom = "Plain Trousers"
		//underwear = "Briefs"
		AH.customization_first = "Bedhead"
	else if(AH.gender == "female")
		AH.gender = FEMALE
		AH.writtengender = AH.writtengender
		//bottom = "Plain Skirt"
		//sock = "Stockings"
		//sock_color = "#101010"
		//underwear = "Bra and Panties"
		AH.customization_first = "Messy"
	else
		AH.gender = FEMALE
		AH.writtengender = AH.writtengender
		//bottom = "Plain Skirt"
		//sock = "Striped Stockings"
		//underwear = "Bra and Panties"
		//sock_color = "#101010"
		AH.customization_first = "Scene"

	spawn(1)
		AH.UpdateMob()
		if (H)
			H.set_face_icon_dirty()
			H.set_body_icon_dirty()
