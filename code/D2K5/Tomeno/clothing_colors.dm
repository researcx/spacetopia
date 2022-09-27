var/list/csscolors = list("light pink" = "#FFB6C1", "pink" = "#FFC0CB0", "crimson" = "#DC143C", "lavender blush" = "#FFF0F5", "pale violet-red" = "#DB7093", "hot pink" = "#FF69B4", "deep pink" = "#FF1493", "medium violet-red" = "#C71585", "orchid" = "#DA70D6", "thistle" = "#D8BFD8", "plum" = "#DDAA0DD", "violet" = "EE82EE", "magenta" = "#FF00FF", "fuchsia" = "#FF00FF", "dark magenta" = "#8B008B", "purple" = "#800080", "medium orchid" = "#BA55D3", "dark violet" = "#9400D3", "dark orchid" = "#9932CC", "indigo" = "#4B0082", "blue-violet" = "#8A2BE2", "medium purple" = "#9370DB", "medium slate blue" = "#7B68EE", "slate blue" = "#6A5ACD", "dark slate blue" = "#483D8B", "lavender" = "#E6E6FA", "ghost white" = "#F8F8FF", "blue" = "#0000FF", "medium blue" = "#0000CD", "midnight blue" = "#191970", "dark blue" = "#00008B", "navy" = "#000080", "royal blue" = "#4169E1", "cornflower blue" = "#6495ED", "light steel blue" = "#B0C4DE", "light slate gray" = "#778899", "slate gray" = "#708090", "dodger blue" = "#1F90FF", "alice blue", "#F0F8FF", "steel blue" = "#4682b4", "light sky blue" = "#87CEFA", "sky blue" = "#87CEEB", "deep sky blue" = "#00BFFF", "light blue" = "#ADD8E6", "powder blue" = "#B0E0E6", "cadet blue" = "#5F9EA0", "azure" = "#F0FFFF", "light cyan" = "#E0FFFF", "pale turquoise" = "#AFEEEE", "cyan" = "#00FFFF", "aqua" = "#00FFFF", "dark turquoise" = "#00ced1", "dark slate gray" = "#2f4f4f", "dark cyan" = "#008b8b", "teal" = "#008080", "medium turquoise" = "#48d1cc", "light sea green" = "#20b2aa", "turquoise" = "#40e0d0", "aquamarine" = "#7fffd4", "medium aquamarine" = "#66cdaa", "medium spring green" = "#00fa9a", "mint cream" = "#f5fffa", "spring green" = "#00ff7f", "medium sea green" = "#3cb371", "sea green" = "#2e8b57", "honeydew" = "#f0fff0", "light green" = "#90ee90", "pale green" = "#98fb98", "dark sea green" = "#8fbc8f", "lime green" = "#32cd32", "lime" = "#00ff00", "forest green" = "#228b22", "green" = "#008000", "dark green" = "#006400", "chartreuse" = "#7fff00", "lawn green" = "#7cfc00", "green-yellow" = "#adff2f", "dark olive green" = "#556b2f", "yellow-green" = "#9acd32", "olive drab" = "#6b8e23", "beige" = "#f5f5dc", "light goldenrod" = "#fafad2", "ivory" = "#fffff0", "light yellow" = "#ffffe0", "yellow" = "#ffff00", "olive" = "#808000", "dark khaki" = "#bdb76b", "lemon chiffon" = "#fffacd", "pale goldenrod" = "#eee8aa", "khaki" = "#f0e68c", "gold" = "#ffd700", "cornsilk" = "#fff8dc", "goldenrod" = "#daa520", "dark goldenrod" = "#b8860b", "floral white" = "#fffaf0", "old lace" = "#fdf5e6", "wheat" = "#f5deb3", "moccasin" = "#ffe4b5", "orange" = "#ffa500", "papaya whip" = "#ffefd5", "blanched almond" = "#ffebcd", "navajo white" = "#FFDEAD", "antique white" = "#FAEBD7", "tan" = "#d2b48c", "burly wood" = "#deb887", "bisque" = "#ffe4c4", "dark orange" = "#ff8c00", "linen" = "#faf0e6", "peru" = "#cd853f", "peach puff" = "#ffdab9", "sandy brown" = "#f4a460", "chocolate" = "#d2691e", "saddle brown" = "#8b4513", "seashell" = "#fff5ee", "sienna" = "#a0522d", "light salmon" = "#ffa07a", "coral" = "#ff7f50", "orange-red" = "#ff4500", "dark salmon" = "#e9967a", "tomato" = "#ff6347", "misty rose" = "#ffe4e1", "salmon" = "#fa8072", "snow" = "#fffafa", "light coral" = "#f08080", "rosy brown" = "#bc8f8f", "indian red" = "#cd2c2c", "red" = "#ff0000", "brown" = "#a52a2a", "fire brick" = "#b22222", "dark red" = "#8b0000", "maroon" = "#800000", "white" = "#FFFFFF", "white smoke" = "#f5f5f5", "gainsboro" = "#dcdcdc", "light grey" = "#d3d3d3", "silver" = "#c0c0c0", "dark gray" = "#a9a9a9", "gray" = "#808080", "dim gray" = "#696969", "black" = "#000000")

/obj/item/clothing
	var/has_detail = 0
	var/detail_color = null
	var/detail2_color = null

	proc/colorMe()
		if(!src.has_detail) return
		var/icon/overworld = new(src.icon)
		var/icon/worn = new(src.wear_image_icon)
		if(!src.detail2_color) src.detail2_color = src.detail_color
		if(src.color)
			overworld.MapColors(src.color, src.detail_color, src.detail2_color, null)
			worn.MapColors(src.color, src.detail_color, src.detail2_color, null)
			src.color = null
		else
			overworld.MapColors(rgb(255,255,255), src.detail_color, src.detail2_color, null)
			worn.MapColors(rgb(255,255,255), src.detail_color, src.detail2_color, null)
		src.icon = overworld
		src.wear_image_icon = worn
		src.wear_image.icon = worn

	New()
		..()
		if(src.has_detail && src.detail_color) src.colorMe()

/obj/item/clothing/under/shirt/randomcolor
	name = "shirt"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()

/obj/item/clothing/bottom/randomcolor
	name = "trousers"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()

/obj/item/clothing/socks/randomcolor
	name = "socks"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()

/obj/item/clothing/underwear/brapan/randomcolor
	name = "bra and panties"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()

/obj/item/clothing/underwear/boxers/randomcolor
	name = "boxers"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()

/obj/item/clothing/shoes/color/randomcolor
	name = "shoes"
	New()
		var/randcolor = pick(csscolors)
		src.name = randcolor + " " + src.name
		src.color = csscolors[randcolor]
		..()