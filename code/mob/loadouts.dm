//this is scummy but loadouts are cool

/mob/proc/apply_specialstuff(M)
//erika
	if((M:key == "-researcx") && (M:name == "Elena Vorobyova"))
		var/obj/item/clothing/under/[PLACEHOLDERD]/darkfem/dress = new /obj/item/clothing/under/[PLACEHOLDERD]/darkfem(M)
		var/obj/item/clothing/suit/[PLACEHOLDERD]/darkcoat/coat = new /obj/item/clothing/suit/[PLACEHOLDERD]/darkcoat(M)
		M:equip_if_possible(dress, M:slot_w_uniform)
		M:equip_if_possible(coat, M:slot_wear_suit)

//emily
	if((M:key == "Emyylii") && (M:name == "Emily Guest"))
		var/obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/lucy/lucy = new /obj/item/clothing/under/[PLACEHOLDERD]/lla/anime/lucy(M)
		M:equip_if_possible(lucy, M:slot_w_uniform)