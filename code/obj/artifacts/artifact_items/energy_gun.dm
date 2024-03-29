/obj/item/gun/energy/artifact
	// an energy gun, it shoots things as you might expect
	name = "artifact energy gun"
	icon = 'icons/obj/artifacts/artifactsitem.dmi'
	icon_state = "laser"
	force = 5.0
	artifact = 1
	is_syndicate = 1
	mat_changename = 0
	mat_changedesc = 0

	New(var/loc, var/forceartitype)
		var/datum/artifact/energygun/AS = new /datum/artifact/energygun(src)
		if (forceartitype)
			AS.validtypes = list("[forceartitype]")
		src.artifact = AS
		// The other three are normal for energy gun setup, so proceed as usual i guess
		cell = null

		spawn(0)
			src.ArtifactSetup()
			var/datum/artifact/A = src.artifact
			cell = new/obj/item/ammo/power_cell/self_charging/artifact(src,A.artitype)
			src.ArtifactDevelopFault(15)

			current_projectile = AS.bullet
			projectiles = list(src.current_projectile)
			cell.max_charge = max(cell.max_charge, current_projectile.cost)

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

	process_ammo(var/mob/user)
		if(istype(user,/mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			if(R.cell)
				if(R.cell.charge >= src.robocharge)
					R.cell.charge -= src.robocharge
					return 1
			return 0
		else
			if(src.current_projectile)
				if(src.cell)
					if(src.cell.use(src.current_projectile.cost))
						return 1
			return 0

	shoot(var/target,var/start,var/mob/user)
		if (!src.ArtifactSanityCheck())
			return
		var/datum/artifact/energygun/A = src.artifact

		if (!istype(A))
			return

		if (!A.activated)
			return

		..()

		A.ReduceHealth(src)

		src.ArtifactFaultUsed(user)
		return

/datum/artifact/energygun
	associated_object = /obj/item/gun/energy/artifact
	rarity_class = 2
	validtypes = list("ancient","eldritch","precursor")
	react_elec = list(0.02,0,5)
	react_xray = list(10,75,100,11,"CAVITY")
	var/integrity = 100
	var/integrity_loss = 5
	var/datum/projectile/artifact/bullet = null
	examine_hint = "It seems to have a handle you're supposed to hold it by."

	New()
		..()
		bullet = new/datum/projectile/artifact
		bullet.randomise()
		integrity = rand(50, 100)
		integrity_loss = rand(1, 7)
		react_xray[3] = integrity

	proc/ReduceHealth(var/obj/item/gun/energy/artifact/O)
		var/prev_health = integrity
		integrity -= integrity_loss
		if (integrity <= 20 && prev_health > 20)
			O.visible_message("<span style=\"color:red\">[O] emits a terrible cracking noise.</span>")
		if (integrity <= 0)
			O.visible_message("<span style=\"color:red\">[O] crumbles into nothingness.</span>")
			qdel(O)
		react_xray[3] = integrity