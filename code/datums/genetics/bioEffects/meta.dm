/datum/bioEffect/activator
	name = "Booster Gene X"
	desc = "This function of this gene is not well-researched."
	researched_desc = "This gene will activate every latent mutation in the subject when activated."
	id = "activator"
	secret = 1
	probability = 33
	blockCount = 2
	blockGaps = 4
	lockProb = 100
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	curable_by_mutadone = 0

	New(var/for_global_list = 0)
		..()
		if (!for_global_list)
			name = "Booster Gene"

	OnAdd()
		var/mob/living/L = owner
		var/datum/bioHolder/B = L.bioHolder

		for(var/ID in B.effectPool)
			B.ActivatePoolEffect(B.effectPool[ID], 1, 0)
			//Overrides incomplete DNA sequences
		return

/datum/bioEffect/scrambler
	name = "Booster Gene Y"
	desc = "This function of this gene is not well-researched."
	researched_desc = "This gene will completely randomise the subject's gene pool and remove all active effects."
	id = "gene_scrambler"
	secret = 1
	probability = 33
	blockCount = 2
	blockGaps = 4
	lockProb = 100
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	curable_by_mutadone = 0

	New(var/for_global_list = 0)
		..()
		if (!for_global_list)
			name = "Booster Gene"

	OnAdd()
		var/mob/living/L = owner
		var/datum/bioHolder/B = L.bioHolder

		B.RemoveAllEffects()
		B.BuildEffectPool()
		return

/datum/bioEffect/remove_all
	name = "Booster Gene Z"
	desc = "This function of this gene is not well-researched."
	researched_desc = "This gene will remove all active and latent effects from the subject."
	id = "gene_clearer"
	secret = 1
	probability = 33
	blockCount = 2
	blockGaps = 4
	lockProb = 100
	lockedGaps = 1
	lockedDiff = 4
	lockedChars = list("G","C","A","T")
	lockedTries = 10
	curable_by_mutadone = 0

	New(var/for_global_list = 0)
		..()
		if (!for_global_list)
			name = "Booster Gene"

	OnAdd()
		var/mob/living/L = owner
		var/datum/bioHolder/B = L.bioHolder

		B.RemoveAllEffects()
		B.RemoveAllPoolEffects()
		return

/datum/bioEffect/early_secret_access
	name = "High Complexity DNA"
	desc = "No effect on subject. Unlocks new research possibilities and can be used as a wildcard in combinations."
	id = "early_secret_access"
	secret = 1
	effectType = effectTypePower
	mob_exclusive = /mob/living/carbon/human/
	can_research = 0
	blockCount = 1
	probability = 35
	reclaim_fail = 100
	lockProb = 100
	blockGaps = 0
	lockedGaps = 2
	lockedDiff = 6
	lockedChars = list("G","C","A","T","U")
	lockedTries = 12
	wildcard = 1