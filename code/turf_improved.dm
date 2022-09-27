/turf/simulated/floor/improved
	name = "floor"
	icon = 'icons/turf/improved_floors.dmi'
	icon_state = "floor"
	thermal_conductivity = 0.040
	heat_capacity = 225000
	broken = 0
	burnt = 0

	New()
		..()
		var/obj/plan_marker/floor/P = locate() in src
		if (P)
			src.icon = P.icon
			src.icon_state = P.icon_state
			src.icon_old = P.icon_state
			allows_vehicles = P.allows_vehicles
			var/pdir = P.dir
			spawn(5)
				src.dir = pdir
			qdel(P)

	airless
		name = "airless floor"
		oxygen = 0.01
		nitrogen = 0.01
		temperature = TCMB

		New()
			..()
			name = "floor"


	airless/solar
		icon_state = "solarbase"

/turf/unsimulated/floor/improved
	name = "floor"
	icon = 'icons/turf/improved_floors.dmi'
	icon_state = "floor"

/turf/unsimulated/floor/exterior
	name = ""
	icon = 'icons/turf/dome_exteriors.dmi'
	icon_state = "grass"

/turf/unsimulated/floor/interior
	name = ""
	icon = 'icons/turf/dome_interiors.dmi'
	icon_state = "white-black"