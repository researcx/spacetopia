
/obj/storage/closet/dresser
	name = "dresser"
	desc = "It's got room for all your fanciest or shabbiest outfits!"
	icon_state = "dresser"
	icon_closed = "dresser"
	icon_opened = "dresser-open"
	soundproofing = 10
	var/trick = 0 //enjoy some gimmicky bullfuckery
	var/id = null

/obj/storage/closet/wardrobe
	name = "wardrobe"
	desc = "It's a wardrobe closet! This one can be opened AND closed. Comes prestocked with some changes of clothes."
	soundproofing = 10

/* ==================== */
/* ----- Standard ----- */
/* ==================== */

/obj/storage/closet/wardrobe/black
	name = "black wardrobe"
	icon_state = "black"
	icon_closed = "black"
	spawn_contents = list(/obj/item/clothing/under/shirt/black = 4,
	/obj/item/clothing/underwear/boxers/black = 2,
	/obj/item/clothing/underwear/brapan/black = 2,
	/obj/item/clothing/bottom/black = 4,
	/obj/item/clothing/bottom/skirt/black = 2,
	/obj/item/clothing/socks/black = 4,
	/obj/item/clothing/socks/stockings/color/black = 2,
	/obj/item/clothing/shoes/black = 4,
	/obj/item/clothing/head/black = 2)

/obj/storage/closet/wardrobe/grey
	name = "grey wardrobe"
	icon_state = "grey"
	icon_closed = "grey"
	spawn_contents = list(/obj/item/clothing/under/shirt/grey = 4,
	/obj/item/clothing/underwear/boxers/grey = 2,
	/obj/item/clothing/underwear/brapan/grey = 2,
	/obj/item/clothing/bottom/grey = 4,
	/obj/item/clothing/bottom/skirt/grey = 2,
	/obj/item/clothing/socks/grey = 4,
	/obj/item/clothing/socks/stockings/color/grey = 2,
	/obj/item/clothing/shoes/brown = 4)

/obj/storage/closet/wardrobe/white
	name = "white wardrobe"
	icon_state = "white"
	icon_closed = "white"
	spawn_contents = list(/obj/item/clothing/under/shirt/white = 4,
	/obj/item/clothing/underwear/boxers = 2,
	/obj/item/clothing/underwear/brapan = 2,
	/obj/item/clothing/bottom/white = 4,
	/obj/item/clothing/bottom/skirt/white = 2,
	/obj/item/clothing/socks/white = 4,
	/obj/item/clothing/socks/stockings/color/white = 2,
	/obj/item/clothing/shoes/white = 4)

/obj/storage/closet/wardrobe/pink
	name = "pink wardrobe"
	icon_state = "pink"
	icon_closed = "pink"
	spawn_contents = list(/obj/item/clothing/under/shirt/pink = 4,
	/obj/item/clothing/underwear/boxers/pink = 2,
	/obj/item/clothing/underwear/brapan/pink = 2,
	/obj/item/clothing/bottom/brown = 4,
	/obj/item/clothing/bottom/skirt/pink = 2,
	/obj/item/clothing/socks/pink = 4,
	/obj/item/clothing/socks/stockings/color/pink = 2,
	/obj/item/clothing/shoes/brown = 4)

/obj/storage/closet/wardrobe/red
	name = "red wardrobe"
	icon_state = "red"
	icon_closed = "red"
	spawn_contents = list(/obj/item/clothing/under/shirt/red = 4,
	/obj/item/clothing/underwear/boxers/red = 2,
	/obj/item/clothing/underwear/brapan/red = 2,
	/obj/item/clothing/bottom/brown = 4,
	/obj/item/clothing/bottom/skirt/red = 2,
	/obj/item/clothing/socks/red = 4,
	/obj/item/clothing/socks/stockings/color/red = 2,
	/obj/item/clothing/shoes/brown = 4,
	/obj/item/clothing/head/red = 2)

/obj/storage/closet/wardrobe/yellow
	name = "yellow wardrobe"
	icon_state = "yellow"
	icon_closed = "yellow"
	spawn_contents = list(/obj/item/clothing/under/shirt/yellow = 4,
	/obj/item/clothing/underwear/boxers/yellow = 2,
	/obj/item/clothing/underwear/brapan/yellow = 2,
	/obj/item/clothing/bottom/yellow = 4,
	/obj/item/clothing/bottom/skirt/yellow = 2,
	/obj/item/clothing/socks/yellow = 4,
	/obj/item/clothing/socks/stockings/color/yellow = 2,
	/obj/item/clothing/shoes/brown = 4,
	/obj/item/clothing/head/yellow = 2)

/obj/storage/closet/wardrobe/green
	name = "green wardrobe"
	icon_state = "green"
	icon_closed = "green"
	spawn_contents = list(/obj/item/clothing/under/shirt/green = 4,
	/obj/item/clothing/underwear/boxers/green = 2,
	/obj/item/clothing/underwear/brapan/green = 2,
	/obj/item/clothing/bottom/brown = 4,
	/obj/item/clothing/bottom/skirt/green = 2,
	/obj/item/clothing/socks/green = 4,
	/obj/item/clothing/socks/stockings/color/green = 2,
	/obj/item/clothing/shoes/brown = 4,
	/obj/item/clothing/head/green = 2)

/obj/storage/closet/wardrobe/blue
	name = "blue wardrobe"
	icon_state = "blue"
	icon_closed = "blue"
	spawn_contents = list(/obj/item/clothing/under/shirt/blue = 4,
	/obj/item/clothing/underwear/boxers/blue = 2,
	/obj/item/clothing/underwear/brapan/blue = 2,
	/obj/item/clothing/bottom/blue = 4,
	/obj/item/clothing/bottom/skirt/blue = 2,
	/obj/item/clothing/socks/blue = 4,
	/obj/item/clothing/socks/stockings/color/blue = 2,
	/obj/item/clothing/shoes/brown = 4,
	/obj/item/clothing/head/blue = 2)

/obj/storage/closet/wardrobe/pants
	name = "mixed trouser wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"
	spawn_contents = list(/obj/item/clothing/bottom/blue = 4,
	/obj/item/clothing/bottom/brown = 4,
	/obj/item/clothing/bottom/black = 4,
	/obj/item/clothing/bottom/white = 4)

/obj/storage/closet/wardrobe/shoes
	name = "mixed shoe wardrobe"
	icon_state = "mixed"
	icon_closed = "mixed"
	spawn_contents = list(/obj/item/clothing/bottom/brown = 6,
	/obj/item/clothing/bottom/black = 6,
	/obj/item/clothing/bottom/white = 6)

/* =================== */
/* ----- Special ----- */
/* =================== */

/obj/storage/closet/wardrobe/black/chaplain
	name = "\improper Chaplain wardrobe"
	spawn_contents = list(/obj/item/clothing/under/rank/chaplain,
	/obj/item/clothing/under/misc/chaplain/atheist,
	/obj/item/clothing/under/misc/chaplain,
	/obj/item/clothing/under/misc/chaplain/rabbi,
	// drsingh is still not a real sihk
	/obj/item/clothing/under/misc/chaplain/siropa_robe,
	/obj/item/clothing/under/misc/chaplain/buddhist,
	/obj/item/clothing/under/misc/chaplain/muslim,
	/obj/item/clothing/bottom/black,
	/obj/item/clothing/suit/adeptus,
	/obj/item/clothing/head/rabbihat,
	/obj/item/clothing/head/formal_turban,
	/obj/item/clothing/head/turban,
	/obj/item/clothing/socks/black,
	/obj/item/clothing/shoes/black,
	/obj/item/clothing/shoes/sandal)

/obj/storage/closet/wardrobe/black/formalwear
	name = "formalwear closet"
	desc = "It's a closet! This one can be opened AND closed. Comes with formal clothes"
	spawn_contents = list(/obj/item/clothing/under/gimmick/maid,
	/obj/item/clothing/head/maid,
	/obj/item/clothing/under/gimmick/butler,
	/obj/item/clothing/head/that = 2,
	/obj/item/clothing/under/rank/bartender = 2,
	/obj/item/clothing/bottom/black = 2,
	/obj/item/clothing/suit/wcoat = 2,
	/obj/item/clothing/socks/white = 2,
	/obj/item/clothing/shoes/black = 2)

/obj/storage/closet/wardrobe/yellow/engineering
	name = "\improper Engineering wardrobe"
	spawn_contents = list(/obj/item/clothing/under/rank/engineer = 4,
	/obj/item/clothing/suit/jacket/job/engineer = 4,
	/obj/item/clothing/bottom/brown = 4,
	/obj/item/clothing/socks/black = 4,
	/obj/item/clothing/shoes/orange = 4)

/obj/storage/closet/wardrobe/red/security_gimmick
	name = "\improper Security wardrobe"
	spawn_contents = list(/obj/item/clothing/shoes/brown = 4,
	/obj/item/clothing/under/color/red,
	/obj/item/clothing/under/gimmick/police,
	/obj/item/clothing/under/misc/head_of_security,
	/obj/item/clothing/bottom/black,
	/obj/item/clothing/under/misc/tourist,
	/obj/item/clothing/under/misc/tourist/max_payne,
	/obj/item/clothing/under/misc/serpico,
	/obj/item/clothing/head/serpico,
	/obj/item/clothing/head/red,
	/obj/item/clothing/head/flatcap,
	/obj/item/clothing/head/policecap,
	/obj/item/clothing/head/helmet/bobby)

/obj/storage/closet/wardrobe/white/medical
	name = "\improper Medical wardrobe"
	spawn_contents = list(/obj/item/clothing/under/rank/medical = 4,
	/obj/item/clothing/suit/jacket/job/medic = 4,
	/obj/item/clothing/bottom/white = 4,
	/obj/item/clothing/socks/white = 4,
	/obj/item/clothing/shoes/red = 4,
	/obj/item/storage/box/stma_kit,
	/obj/item/clothing/suit/labcoat = 3)

/obj/storage/closet/wardrobe/white/research
	name = "\improper Research wardrobe"
	spawn_contents = list(/obj/item/clothing/under/rank/scientist = 4,
	/obj/item/clothing/suit/jacket/job/scientist = 4,
	/obj/item/clothing/bottom/white = 4,
	/obj/item/clothing/socks/white = 4,
	/obj/item/clothing/shoes/white = 4,
	/obj/item/storage/box/stma_kit,
	/obj/item/clothing/suit/labcoat = 4)

/obj/storage/closet/wardrobe/white/genetics
	name = "\improper Genetics wardrobe"
	spawn_contents = list(/obj/item/clothing/under/rank/geneticist = 4,
	/obj/item/clothing/suit/jacket/job/geneticist = 4,
	/obj/item/clothing/bottom/white = 4,
	/obj/item/clothing/socks/white= 4,
	/obj/item/clothing/shoes/white= 4,
	/obj/item/storage/box/stma_kit,
	/obj/item/clothing/suit/labcoat = 4)

/obj/storage/closet/dresser/random
	var/list/list_jump = list(/obj/item/clothing/under/color,
	/obj/item/clothing/under/color/grey,
	/obj/item/clothing/under/color/white,
	/obj/item/clothing/under/color/darkred,
	/obj/item/clothing/under/color/red,
	/obj/item/clothing/under/color/lightred,
	/obj/item/clothing/under/color/orange,
	/obj/item/clothing/under/color/brown,
	/obj/item/clothing/under/color/lightbrown,
	/obj/item/clothing/under/color/yellow,
	/obj/item/clothing/under/color/yellowgreen,
	/obj/item/clothing/under/color/lime,
	/obj/item/clothing/under/color/green,
	/obj/item/clothing/under/color/aqua,
	/obj/item/clothing/under/color/lightblue,
	/obj/item/clothing/under/color/blue,
	/obj/item/clothing/under/color/darkblue,
	/obj/item/clothing/under/color/purple,
	/obj/item/clothing/under/color/lightpurple,
	/obj/item/clothing/under/color/magenta,
	/obj/item/clothing/under/color/pink)
	var/list/list_shoe = list(/obj/item/clothing/shoes/white,
	/obj/item/clothing/shoes/black,
	/obj/item/clothing/shoes/brown,
	/obj/item/clothing/shoes/red,
	/obj/item/clothing/shoes/orange,
	/obj/item/clothing/shoes/blue,
	/obj/item/clothing/shoes/pink)

	make_my_stuff()
		..()
		for (var/i = 4, i > 0, i--)
			var/obj/item/clothing/under/color/JS = pick(src.list_jump)
			new JS(src)
			var/obj/item/clothing/shoes/SH = pick(src.list_shoe)
			new SH(src)