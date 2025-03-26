world
	New()
		..()
		lighting.icon = 'icons/effects/ss13_dark_alpha7.dmi'
		lighting.init()
atom
	movable
		Move()
			if(loc)
				var/shading/old = loc:shading
				. = ..()

				// if the object moved and is opaque, we need to check
				// for nearby light sources that need to update in case
				// the object changes how shadows are cast
				if(opaque && .)

					// for all nearby light sources...
					for(var/light/l in range(10,src))
						if(!l.effect) continue

						// if you moved to or from a tile that was
						// affected by this light source...
						var/shading/s = loc:shading
						if(!isnull(l.effect[s]) || !isnull(l.effect[old]))

							// set the stale flag so they'll be updated automatically
							l.changed = 1

atom
	var/opaque = 0

turf
	proc
		opaque(atom/ignore)
			if(opaque) return 1

			for(var/atom/a in src)
				if(a == ignore) continue
				if(a.opaque) return 1

			return 0