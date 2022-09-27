/obj/item/cell/artifact
	name = "artifact power cell"
	icon = 'icons/obj/artifacts/artifactsitemS.dmi'
	maxcharge = 10000
	genrate = 50
	specialicon = 1
	artifact = 1
	mat_changename = 0
	mat_changedesc = 0

	New(var/loc, var/forceartitype)
		//src.artifact = new /datum/artifact/powercell(src)
		var/datum/artifact/powercell/AS = new /datum/artifact/powercell(src)
		if (forceartitype)
			AS.validtypes = list("[forceartitype]")
		src.artifact = AS
		spawn(0)
			src.ArtifactSetup()
			var/datum/artifact/A = src.artifact
			src.maxcharge = rand(15,1000)
			src.maxcharge *= 100
			A.react_elec[2] = src.maxcharge
			..()

	examine()
		set src in oview()
		boutput(usr, "You have no idea what this thing is!")
		if (!src.ArtifactSanityCheck())
			return
		var/datum/artifact/A = src.artifact
		if (istext(A.examine_hint))
			boutput(usr, "[A.examine_hint]")

	UpdateName()
		src.name = "[name_prefix(null, 1)][src.real_name][name_suffix(null, 1)]"

	attackby(obj/item/W as obj, mob/user as mob)
		if (src.Artifact_attackby(W,user))
			..()

/datum/artifact/powercell
	associated_object = /obj/item/cell/artifact
	rarity_class = 1
	validtypes = list("ancient","martian","wizard","precursor")
	automatic_activation = 1
	react_elec = list("equal",0,10)
	react_xray = list(10,80,95,11,"SEGMENTED")
	examine_hint = "It kinda looks like it's supposed to be inserted into something."

	New()
		..()
		src.react_heat[2] = "VOLATILE REACTION DETECTED"