#define HOLOSYNTH_BRUTEMULT 3
#define HOLOSYNTH_BURNMULT 5

/datum/species/android/holosynth
	name = "Holosynth"
	id = SPECIES_HOLOSYNTH
	inherent_traits = list(
		TRAIT_MUTANT_COLORS,
		TRAIT_GENELESS,
		TRAIT_NOBREATH,
		TRAIT_NOHUNGER,
		TRAIT_NOCRITDAMAGE,
		TRAIT_NO_DNA_COPY,
		TRAIT_NO_PLASMA_TRANSFORM,
		TRAIT_RADIMMUNE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_UNHUSKABLE,
		TRAIT_STABLEHEART,
		TRAIT_STABLELIVER,
		TRAIT_UNDENSE,
		TRAIT_NEVER_WOUNDED,
		TRAIT_GRABRESISTANCE,
		TRAIT_NODISMEMBER,
		TRAIT_NO_AUGMENTS,
		TRAIT_EASYBLEED
	)
	var/atom/movable/scanline
	var/static/atom/movable/render_step/emissive/glow
	var/mutable_appearance/glow_appearance

/datum/species/android/holosynth/on_species_gain(mob/living/carbon/target, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/mob/living/carbon/human/species_holder = target

	target.makeHologram()

	species_holder.physiology.brute_mod *= HOLOSYNTH_BRUTEMULT //I could make this incompatible with Fragile
	species_holder.physiology.burn_mod *= HOLOSYNTH_BURNMULT	//Or we could simply embrace the 25x damage multiplier
	species_holder.max_grab = GRAB_PASSIVE //you're like, only half solid yk

	species_holder.AddComponent(/datum/component/glass_passer/holosynth, pass_time = 1 SECONDS)
	species_holder.AddComponent(/datum/component/regenerator, brute_per_second = 0.2, burn_per_second = 0.2, outline_colour = COLOR_HEALING_CYAN)

/datum/species/android/holosynth/on_species_loss(mob/living/carbon/target, datum/species/new_species, pref_load)
	. = ..()
	var/mob/living/carbon/human/species_holder = target
	species_holder.physiology.brute_mod /= HOLOSYNTH_BRUTEMULT
	species_holder.physiology.burn_mod /= HOLOSYNTH_BURNMULT
	species_holder.max_grab = GRAB_KILL

	var/datum/component/glass_passer/holosynth/glasscomp = species_holder.GetComponent(/datum/component/glass_passer/holosynth)
	var/datum/component/regenerator/regencomp = species_holder.GetComponent(/datum/component/regenerator)
	qdel(glasscomp)
	qdel(regencomp)

	species_holder.remove_filter(list("HOLO: Color and Transparent","HOLO: Scanline"))

#undef HOLOSYNTH_BRUTEMULT
#undef HOLOSYNTH_BURNMULT
