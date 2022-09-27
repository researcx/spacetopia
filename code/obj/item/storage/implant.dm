// Most of these aren't in use anymore, but there's enough of them that they may as well get their own file.

/obj/item/storage/box/trackimp_kit
	name = "tracking implant kit"
	icon_state = "implant"
	desc = "A box containing an implanting tool, four tracking implant cases, a locator, and an implant pad. The implanter can remove the implants from their cases and inject them in a person, and the locator can tell you where they are."
	spawn_contents = list(/obj/item/implantcase/tracking = 4,\
	/obj/item/implanter,\
	/obj/item/implantpad,\
	/obj/item/locator)

/obj/item/storage/box/trackimp_kit2
	name = "tracking implant kit"
	icon_state = "implant"
	desc = "A box containing an implanting tool, four tracking implant cases, and two GPS devices. The implanter can remove the implants from their cases and inject them in a person, and the GPS devices can tell you where they are."
	spawn_contents = list(/obj/item/implantcase/tracking = 4,\
	/obj/item/device/gps = 2,\
	/obj/item/implanter)

/obj/item/storage/box/securityimp_kit
	name = "security implant kit"
	icon_state = "implant"
	desc = "A box containing an implanting tool and five tracking implant cases. The implanter can remove the implants from their cases and inject them into a subject, granting them security access."
	spawn_contents = list(/obj/item/implantcase/sec = 6,\
	/obj/item/implanter)

/obj/item/storage/box/revimp_kit
	name = "loyalty implant kit"
	icon_state = "implant"
	desc = "A box containing an implanting tool and five tracking implant cases. The implanter can remove the implants from their cases and inject them in a person, forcing them to be loyal to the Captain and crew."
	spawn_contents = list(/obj/item/implantcase/antirev = 6,\
	/obj/item/implanter)
