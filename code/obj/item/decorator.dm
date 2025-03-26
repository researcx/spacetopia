/obj/item/decorator
	name = "decoration device"
	desc = "A device used to change the decoration and furniture of your housing."
	icon = 'icons/obj/items.dmi'
	inhand_image_icon = 'icons/mob/inhand/hand_tools.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0

	var/mode = 1
	var/list/contained_objects
	var/list/buyable = list("Table (D5)" = "/obj/table/auto",\
	"Chair (D2)" = "/obj/stool/chair",\
	"Bar stool (D2)" = "/obj/stool/bar",\
	"Bed (D2)" = "/obj/stool/bed",\
	"Bedsheet (D2)" = "/obj/item/clothing/suit/bedsheet",\
	"Linen bin (D5)" = "/obj/bedsheetbin",\
	"Fridge (D50)" = "/obj/storage/secure/closet/fridge",\
	"Table sink (D5)" = "/obj/submachine/chef_sink/table",\
	"Mixer (D50)" = "/obj/submachine/mixer",\
	"Microwave (D100)" = "/obj/machinery/microwave",\
	"Oven (D150)" = "/obj/submachine/chef_oven",\
	"Closet (D50)" = "/obj/storage/closet",\
	"Bath Tub (D100)" = "/obj/machinery/bathtub",\
	"Towel bin (D50)" = "/obj/towelbin",\
	"Toilet (D100)" = "/obj/item/storage/toilet")


/obj/item/decorator/attack_self(mob/user as mob)
	if (mode == 1)
		mode = 2
		boutput(user, "Changed mode to 'Buy'")
		return
	if (mode == 2)
		mode = 1
		boutput(user, "Changed mode to 'Move'")
		return

/obj/item/decorator/afterattack(atom/A, mob/user as mob)
	//var/turf/L = get_turf(user)
	if (mode == 1)
		//if(istype(A, /obj))
			//if(A.housingitem == 1)
			//	contained_objects += A
			//	del(A)
			//	world.log << contained_objects
		return

	else if (mode == 2)
		if(istype(A, /turf))
			var/new_item = input(user, "Please select item you wish to buy", "Housing Customization")  as null|anything in buyable
			if (new_item)
				world.log << new_item
				if(buyable[new_item])
					world.log << buyable[new_item]

					var/itempath = text2path(buyable[new_item])
					var/obj/I = new itempath(A)
					I.housingitem = 1
					I.dir = user.dir
		return