

/obj/machinery/bot/goosebot
	name = "THE GOOSE"
	desc = "How did this manage to pass Nanotrasen's safety regulations?"
	icon = 'icons/obj/aibots.dmi'
	icon_state = "goosebot"
	layer = 5.0 //TODO LAYER
	density = 0
	anchored = 0
	on = 1
	health = 10
	no_camera = 1

/obj/machinery/bot/goosebot/proc/quack(var/message)
	if (!src.on || !message || src.muted)
		return
	src.visible_message("<span class='game say'><span class='name'>[src]</span> blares, \"[message]\"")
	return

/obj/machinery/bot/goosebot/proc/wakka_wakka()
		var/turf/moveto = locate(src.x + rand(-1,1),src.y + rand(-1, 1),src.z)
		if(isturf(moveto) && !moveto.density) step_towards(src, moveto)

/obj/machinery/bot/goosebot/process()
	if(prob(50) && src.on == 1)
		spawn(0)
			var/message = pick("HONK", "HOOOOOOONK","WACK WACK","GOWGOW","SCREEEEEE")
			quack(message)
			wakka_wakka()
			if(prob(50))
				playsound(src.loc, "sound/misc/thegoose_honk.ogg", 100, 0)
				throw_egg_is_true()
			else
				playsound(src.loc, "sound/misc/thegoose_song.ogg", 100, 0)



/obj/machinery/bot/goosebot/attack_hand(mob/user as mob)
	var/dat
	dat += "<TT><I>YOU CHOICE</I></TT><BR>"
	dat += "<TT><B>THE GOOSE</B></TT><BR>"
	dat += "NEW EDITION!<BR><BR>"
	dat += "LATEST TECHNOLOGY SPECIAL STYLE<BR><BR>"
	dat += "SPECIFICATIONS COLOURS AND CONTENTS MAY VARY FROM ILLUSTRATIONS<BR>"
	dat += "THE HEAD CAN TURN<BR>"
	dat += "Lamplight beautiful melody THE WHOLE BODY WILL SWING<BR>"
	dat += "WILL LAY EGG<BR>"
	dat += "USE 3 AA BATTERIES (BOT INCLUDED)<BR>"
	dat += "BUMP THE SHOT WILL TURN A CORNER<BR>"
	dat += "INSTALL THE EGG<BR>"
	user << browse("<HEAD><TITLE>THE GOOSE</TITLE>[css_interfaces]</head>[dat]", "window=GOOSE")
	onclose(user, "GOOSE")
	return

/obj/machinery/bot/goosebot/attackby(obj/item/W as obj, mob/user as mob)
	src.visible_message("<span class='combat'>[user] hits [src] with [W]!</span>")
	switch(W.damtype)
		if("fire")
			src.health -= W.force * 0.5
		if("brute")
			src.health -= W.force * 0.5
	if (src.health <= 0)
		src.explode()

/obj/machinery/bot/goosebot/gib()
	return src.explode()

/obj/machinery/bot/goosebot/explode()
	src.on = 0
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='combat'><B>[src] blows apart!</B></span>", 1)
	explosion(src, src.loc , 0, 0, 1, 1)
	qdel(src)
	return



/obj/machinery/bot/goosebot/proc/throw_egg_is_true()
	var/mob/living/target = locate() in view(7,src)
	if(target && !target.lying)
		var/obj/item/a_gift/easter/duck/E = new /obj/item/a_gift/easter/duck(src.loc)
		E.throwforce = 40
		E.name = "Goose egg"
		E.desc = "A goose's egg, apparently."
		E.throw_at(target, 16, 3)

		icon_state = "goosebot-spaz"
		src.visible_message("<span class='combat'><b>[src] fires an egg at [target.name]!</b></span>")
		playsound(src.loc, "sound/effects/pump.ogg", 50, 1)
		spawn(10)
			E.throwforce = 1
		spawn(50)
			icon_state = "goosebot"

	return