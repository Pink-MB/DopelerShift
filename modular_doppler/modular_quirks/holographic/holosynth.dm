/datum/quirk/holosynth
	name = "Holographic"
	desc = "Android only. You are a being made of soft-light rather than metal or plastic. A holographic film\
	flows over items and clothes for you to hold. Your form is VERY ephemeral. On the bright side, you can walk through glass and regenerate slowly."
	gain_text = span_notice("You glance down at your semi-opaque blue hands.")
	lose_text = span_notice("Your body seems to solidify.")
	medical_record_text = "Patient presents with a mild skin condition" //You should make me change this probably
	value = -6
	mob_trait = TRAIT_HOLOSYNTH
	icon = FA_ICON_PHONE_SQUARE
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_CHANGES_APPEARANCE

	var/holosynth_brute_multiplier = 3
	var/holosynth_burn_multiplier = 5

	var/list/holosynth_traits = list(
		TRAIT_UNDENSE,
		TRAIT_NEVER_WOUNDED,
		TRAIT_GRABRESISTANCE,
	)

/datum/quirk/holosynth/is_species_appropriate(datum/species/mob_species)
	if(mob_species != /datum/species/android)
		return FALSE
	return ..()

/datum/quirk/holosynth/add_unique(client/client_source)
	var/mob/living/carbon/human/human_holder = quirk_holder

	human_holder.makeHologram()
	human_holder.add_traits(holosynth_traits, QUIRK_TRAIT)

	human_holder.physiology.brute_mod *= holosynth_brute_multiplier //I could make this incompatible with Fragile
	human_holder.physiology.burn_mod *= holosynth_burn_multiplier	//Or we could simply embrace the 25x damage multiplier
	human_holder.max_grab = GRAB_PASSIVE //you're like, only half solid yk

	human_holder.AddComponent(/datum/component/glass_passer/holosynth, pass_time = 1 SECONDS)
	human_holder.AddComponent(/datum/component/regenerator, brute_per_second = 0.2, burn_per_second = 0.2, outline_colour = COLOR_HEALING_CYAN)

/datum/quirk/holosynth/remove()
	var/mob/living/carbon/human/human_holder = quirk_holder

	human_holder.remove_traits(holosynth_traits, QUIRK_TRAIT)

	human_holder.physiology.brute_mod /= holosynth_brute_multiplier
	human_holder.physiology.burn_mod /= holosynth_burn_multiplier
	human_holder.max_grab = GRAB_KILL

	var/datum/component/glass_passer/holosynth/glasscomp = human_holder.GetComponent(/datum/component/glass_passer/holosynth)
	var/datum/component/glass_passer/holosynth/regencomp = human_holder.GetComponent(/datum/component/regenerator)
	qdel(glasscomp)
	qdel(regencomp)

	//There's no maken'tHologram() proc please hep
	human_holder.remove_filter(list("HOLO: Color and Transparent","HOLO: Scanline")) //this part works but then they still glow

	//I don't know how to make them glown't
	//TODO: make them glown't
