world/view = "3x2"
world/name = "Spacetopia Preview Tool"
turf/icon = 'PreviewTool.dmi'
turf/icon_state = "turf"
obj/dummy/icon = 'PreviewTool.dmi'
obj/dummy/icon_state = "dummy_m"
obj/clothing/layer = OBJ_LAYER + 1
obj/dummy/color = "#fec081"
var/defaultcolor = "#fec081"
mob/var/heard = 0
world/New()
	world.log << "<big><b>Some icons might not work in the preview. If that happens, add a blank icon state and test the icon again."
	..()
mob/verb
	Change_Dummy_Color()
		var/c = input(usr,"Choose a skin tone/color","Skin Tone/Color", defaultcolor) as color
		for(var/obj/dummy/d in world)
			d.color = c
		defaultcolor = c
	Change_Dummy_Gender()
		for(var/obj/dummy/d in world)
			if(d.icon_state == "dummy_m")
				d.icon_state = "dummy_f"
			else
				d.icon_state = "dummy_m"
	Change_Turf_Color(var/c as color)
		for(var/turf/t in world)
			t.color = c
	Screenshot()
		winset(src, null, "command=\".screenshot auto\"")
	Color_Preview()
		var/mode = input(usr, "Which mode to color the preview in?", "Color preview") as anything in list("Normal", "With Detail", "Cancel")
		switch(mode)
			if("Cancel") return
			if("Normal")
				var/col = input(usr,"Choose preview color","Color preview") as color
				for(var/obj/clothing/c in world) c.color = col
			if("With Detail")
				var/col1 = input(usr,"Choose preview color one","Color preview") as color
				var/col2 = input(usr,"Choose preview color one","Color preview") as color
				for(var/obj/clothing/c in world)
					var/icon/i = icon(c.icon)
					i.MapColors(col1, col2, null, null)
					c.icon = i
	Test_Clothing()
		if(!usr.heard)
			usr << "<big><b>Some icons might not work in the preview. If that happens, add a blank icon state and test the icon again."
			usr.heard = 1
		var/icon/f = input(usr,"Choose icon file to test","Preview") as null|icon
		for(var/obj/clothing/c in world) del c
		var/mode = input(usr, "Which mode to test icon in?", "Preview") as anything in list("Tops/Bottoms/Underwear", "Head/Facial Hair", "Character Details", "Socks/Shoes")
		switch(mode)
			if("Tops/Bottoms/Underwear")
				var/obj/clothing/s = new(locate(1,2,1))
				var/obj/clothing/n = new(locate(1,1,1))
				var/obj/clothing/e = new(locate(2,2,1))
				var/obj/clothing/w = new(locate(2,1,1))
				var/obj/clothing/item = new(locate(3,1,1))
				s.icon = f
				n.icon = f
				e.icon = f
				w.icon = f
				item.icon = f
				s.dir = SOUTH
				n.dir = NORTH
				e.dir = EAST
				w.dir = WEST
				s.icon_state = "worn"
				n.icon_state = "worn"
				e.icon_state = "worn"
				w.icon_state = "worn"
				item.icon_state = "item"
			if("Head/Facial Hair")
				var/obj/clothing/s = new(locate(1,2,1))
				var/obj/clothing/n = new(locate(1,1,1))
				var/obj/clothing/e = new(locate(2,2,1))
				var/obj/clothing/w = new(locate(2,1,1))
				var/obj/clothing/item = new(locate(3,1,1))
				s.icon = f
				n.icon = f
				e.icon = f
				w.icon = f
				item.icon = f
				s.dir = SOUTH
				n.dir = NORTH
				e.dir = EAST
				w.dir = WEST
				s.icon_state = ""
				n.icon_state = ""
				e.icon_state = ""
				w.icon_state = ""
				item.icon_state = ""
			if("Character Details")
				var/obj/clothing/s = new(locate(1,2,1))
				var/obj/clothing/n = new(locate(1,1,1))
				var/obj/clothing/e = new(locate(2,2,1))
				var/obj/clothing/w = new(locate(2,1,1))
				var/obj/clothing/item = new(locate(3,1,1))
				s.icon = f
				n.icon = f
				e.icon = f
				w.icon = f
				item.icon = f
				s.dir = SOUTH
				n.dir = NORTH
				e.dir = EAST
				w.dir = WEST
				s.icon_state = ""
				n.icon_state = ""
				e.icon_state = ""
				w.icon_state = ""
				item.icon_state = ""
			if("Socks/Shoes")
				var/obj/clothing/s1 = new(locate(1,2,1))
				var/obj/clothing/n1 = new(locate(1,1,1))
				var/obj/clothing/e1 = new(locate(2,2,1))
				var/obj/clothing/w1 = new(locate(2,1,1))
				var/obj/clothing/s2 = new(locate(1,2,1))
				var/obj/clothing/n2 = new(locate(1,1,1))
				var/obj/clothing/e2 = new(locate(2,2,1))
				var/obj/clothing/w2 = new(locate(2,1,1))
				var/obj/clothing/item = new(locate(3,1,1))
				s1.icon = f
				n1.icon = f
				e1.icon = f
				w1.icon = f
				item.icon = f
				s1.dir = SOUTH
				n1.dir = NORTH
				e1.dir = EAST
				w1.dir = WEST
				s1.icon_state = "left_worn"
				n1.icon_state = "left_worn"
				e1.icon_state = "left_worn"
				w1.icon_state = "left_worn"
				item.icon_state = "item"
				s2.icon = f
				n2.icon = f
				e2.icon = f
				w2.icon = f
				s2.dir = SOUTH
				n2.dir = NORTH
				e2.dir = EAST
				w2.dir = WEST
				s2.icon_state = "right_worn"
				n2.icon_state = "right_worn"
				e2.icon_state = "right_worn"
				w2.icon_state = "right_worn"