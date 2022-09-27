//this is scummy but loadouts are cool

/mob/proc/apply_specialstuff(M)
//erika
	if((M:key == "-faggqt") && (M:name == "Elena Vorobyova"))
		var/obj/item/clothing/under/d2k5/darkfem/dress = new /obj/item/clothing/under/d2k5/darkfem(M)
		var/obj/item/clothing/suit/d2k5/darkcoat/coat = new /obj/item/clothing/suit/d2k5/darkcoat(M)
		M:equip_if_possible(dress, M:slot_w_uniform)
		M:equip_if_possible(coat, M:slot_wear_suit)

//emily
	if((M:key == "Emyylii") && (M:name == "Emily Guest"))
		var/obj/item/clothing/under/d2k5/lla/anime/lucy/lucy = new /obj/item/clothing/under/d2k5/lla/anime/lucy(M)
		M:equip_if_possible(lucy, M:slot_w_uniform)