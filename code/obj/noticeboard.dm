/obj/noticeboard
	name = "Notice Board"
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "nboard00"
	flags = FPRINT
	desc = "A board for pinning important notices upon."
	density = 0
	anchored = 1
	var/notices = 0

//attaching papers!!
/obj/noticeboard/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if (istype(O, /obj/item/paper))
		if (src.notices < 5)
			O.add_fingerprint(user)
			src.add_fingerprint(user)
			user.drop_item()
			O.set_loc(src)
			src.notices++
			src.icon_state = text("nboard0[]", src.notices) //update sprite
			boutput(user, "<span style=\"color:orange\">You pin the paper to the noticeboard.</span>")
		else
			boutput(user, "<span style=\"color:red\">You reach to pin your paper to the board but hesitate. You are certain your paper will not be seen among the many others already attached.</span>")
//
/obj/noticeboard/attack_hand(user as mob)
	var/dat = "<B>Noticeboard</B><BR>"
	for(var/obj/item/paper/P in src)
		dat += text("<A href='?src=\ref[];read=\ref[]'>[]</A> <A href='?src=\ref[];write=\ref[]'>Write</A> <A href='?src=\ref[];remove=\ref[]'>Remove</A><BR>", src, P, P.name, src, P, src, P)
	user << browse("<HEAD><TITLE>Notices</TITLE>[css_interfaces]</head>[dat]","window=noticeboard")
	onclose(user, "noticeboard")


/obj/noticeboard/Topic(href, href_list)
	if (get_dist(src, usr) > 1 || !isliving(usr) || iswraith(usr) || isintangible(usr))
		return
	if (usr.stunned > 0 || usr.weakened > 0 || usr.paralysis > 0 || usr.stat != 0 || usr.restrained())
		return

	..()

	usr.machine = src
	if (href_list["remove"])
		var/obj/item/P = locate(href_list["remove"])
		if ((P && P.loc == src))
			P.set_loc(get_turf(src)) //dump paper on the floor because you're a clumsy fuck
			P.layer = HUD_LAYER
			P.add_fingerprint(usr)
			src.add_fingerprint(usr)
			src.notices--
			src.icon_state = text("nboard0[]", src.notices)

	if(href_list["write"])
		var/obj/item/P = locate(href_list["write"])

		if((P && P.loc == src)) //if the paper's on the board
			if (istype(usr.r_hand, /obj/item/pen)) //and you're holding a pen
				src.add_fingerprint(usr)
				P.attackby(usr.r_hand, usr) //then do ittttt
			else
				if (istype(usr.l_hand, /obj/item/pen)) //check other hand for pen
					src.add_fingerprint(usr)
					P.attackby(usr.l_hand, usr)
				else
					boutput(usr, "<span style=\"color:red\">You'll need something to write with!</span>")

	if (href_list["read"])
		var/obj/item/paper/P = locate(href_list["read"])
		if ((P && P.loc == src))
			if (!( istype(usr, /mob/living/carbon/human) ))
				usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE>[css_interfaces]</head><BODY><TT>[]</TT></BODY></HTML>", P.name, stars(P.info)), text("window=[]", P.name))
				onclose(usr, "[P.name]")
			else
				usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE>[css_interfaces]</head><BODY><TT>[]</TT></BODY></HTML>", P.name, P.info), text("window=[]", P.name))
				onclose(usr, "[P.name]")
	return