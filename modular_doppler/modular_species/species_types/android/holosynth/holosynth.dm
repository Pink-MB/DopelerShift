#define HOLOSYNTH_BRUTEMULT 3
#define HOLOSYNTH_BURNMULT 5
#define HOLOSYNTH_RANGE 9

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
		TRAIT_STABLELIVER,
		TRAIT_STABLEHEART,
		TRAIT_UNDENSE,
		TRAIT_GRABRESISTANCE,
		TRAIT_NODISMEMBER,
		TRAIT_NO_AUGMENTS,
		TRAIT_NEVER_WOUNDED,
		TRAIT_EASYBLEED
	)
	exotic_bloodtype = BLOOD_TYPE_HOLOGEL
	var/obj/item/pen/holoprojector/owner_projector

//Species Adding and Removal

/datum/species/android/holosynth/on_species_gain(mob/living/carbon/target, datum/species/old_species, pref_load, regenerate_icons)
	. = ..()
	var/mob/living/carbon/human/species_holder = target

	target.makeHologram()

	species_holder.physiology.brute_mod *= HOLOSYNTH_BRUTEMULT
	species_holder.physiology.burn_mod *= HOLOSYNTH_BURNMULT
	species_holder.max_grab = GRAB_PASSIVE //you're like, only half solid yk

	species_holder.AddComponent(/datum/component/glass_passer/holosynth, pass_time = 1 SECONDS)
	species_holder.AddComponent(/datum/component/regenerator, brute_per_second = 0.2, burn_per_second = 0.2, outline_colour = COLOR_HEALING_CYAN)


	//Leashing time
	owner_projector = new /obj/item/pen/holoprojector (get_turf(species_holder))
	owner_projector.linked_mob = species_holder

	species_holder.AddComponent(\
		/datum/component/leash,\
		owner = owner_projector,\
		distance = HOLOSYNTH_RANGE,\
		force_teleport_out_effect = /obj/effect/temp_visual/guardian/phase/out,\
		force_teleport_in_effect = /obj/effect/temp_visual/guardian/phase,\
	)

/datum/species/android/holosynth/on_species_loss(mob/living/carbon/target, datum/species/new_species, pref_load)
	. = ..()
	var/mob/living/carbon/human/species_holder = target
	species_holder.physiology.brute_mod /= HOLOSYNTH_BRUTEMULT
	species_holder.physiology.burn_mod /= HOLOSYNTH_BURNMULT
	species_holder.max_grab = GRAB_KILL

	var/datum/component/glass_passer/holosynth/glasscomp = species_holder.GetComponent(/datum/component/glass_passer/holosynth)
	var/datum/component/regenerator/regencomp = species_holder.GetComponent(/datum/component/regenerator)
	var/datum/component/leash/projector = species_holder.GetComponent(/datum/component/leash)
	qdel(glasscomp)
	qdel(regencomp)
	qdel(projector)

	species_holder.remove_filter(list("HOLO: Color and Transparent","HOLO: Scanline"))


// Lore Box

/datum/species/android/holosynth/get_species_description()
	return "A Subtype of Android that consists of only the bases components along with a powerful electromagnet controller - All of this floating in a ferromagnetic aerogel that coats anything they wish to touch or wear"

/datum/species/android/holosynth/get_species_lore()
	return list(
		"Somewhere between an android and a hologram, these semi-physical autonomous units are extremely vulnerable to heat and electricity\
		 while early models were incapable of causing direct harm, advancements in dynamic aerogel density have made this a possibility.\
		 A once popular choice among more wealthy customers (silicon and uploaded organics alike) though their lack of robustness makes them somewhat inept for physical work."
	)

//Blood
/datum/blood_type/holosynth
	name = BLOOD_TYPE_HOLOGEL
	color = BLOOD_COLOR_HOLOGEL
	restoration_chem = /datum/reagent/silicon
	compatible_types = list(
		/datum/blood_type/synthetic,
	)

//Character creation Perks
/datum/species/android/holosynth/create_pref_traits_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_ALT,
		SPECIES_PERK_NAME = "Android Aptitude",
		SPECIES_PERK_DESC = "As a synthetic lifeform, Androids are immune to many forms of damage humans are susceptible to. \
			Fire, cold, heat, pressure, radiation, and toxins are all ineffective against them. \
			They also can't overdose on drugs, don't need to breathe or eat, can't catch on fire, and are immune to being pierced.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_DNA,
		SPECIES_PERK_NAME = "Not Human After All",
		SPECIES_PERK_DESC = "There is no humanity behind the eyes of the Android, and as such, they have no DNA to genetically alter.",
	))
	return perks

/datum/species/android/holosynth/create_pref_unique_perks()
	var/list/perks = list()
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEUTRAL_PERK,
		SPECIES_PERK_ICON = FA_ICON_SHIELD_HEART,
		SPECIES_PERK_NAME = "Some Components Optional",
		SPECIES_PERK_DESC = "Androids have very few internal organs. While they can survive without many of them, \
			they don't have any benefits from them either.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_NEGATIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_ROBOT,
		SPECIES_PERK_NAME = "Synthetic",
		SPECIES_PERK_DESC = "Being synthetic, Androids are vulnernable to EMPs.",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_MAGNIFYING_GLASS,
		SPECIES_PERK_NAME = "Translucency",
		SPECIES_PERK_DESC = "Holosynths can pass through glass, though you'll leave any physical items behind",
	))
	perks += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = FA_ICON_NOTES_MEDICAL,
		SPECIES_PERK_NAME = "Regenerator",
		SPECIES_PERK_DESC = "Being made of light, your projector and controller will mend tears in your form and aerogel",
	))
	return perks

//THE PROJECTOR
/obj/item/pen/holoprojector
	name = "Holosynth Projector-Magnet Combo"
	desc = "A complex mechanism that both projects the form of a hologram and manipulates its gel canvas.\
	Miraculously, it also doubles as a pen - though not at the same time. ALT-click to reset the projection destination"
	icon_state = "pen_blue"
	var/mob/living/carbon/human/linked_mob
	var/turf/saved_loc
	var/contents/interior

/obj/item/pen/holoprojector/Initialize(mapload)
	. = ..()
	saved_loc = loc //Important fallback initial conditions u see

/obj/item/pen/holoprojector/create_transform_component()
	AddComponent( \
		/datum/component/transforming, \
		start_transformed = FALSE, \
		sharpness_on = NONE, \
		inhand_icon_change = FALSE, \
		w_class_on = w_class, \
	)

/obj/item/pen/holoprojector/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER		//todo: find out what this warning

	if(user)
		balloon_alert(user, "clicked")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
	icon_state = initial(icon_state) + (active ? "_retracted" : "")
	update_appearance(UPDATE_ICON)

	if(active) //If you WERE active we save loc and place our creature into pen
		saved_loc = get_turf(linked_mob)
		linked_mob.loc = src
	else	//Otherwise, put the hologram back
		linked_mob.loc = saved_loc

	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/pen/holoprojector/click_alt(mob/user)
	balloon_alert(user, "location reset")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
	saved_loc = get_turf(user) //this does not work unless the linked mob is in the pen figure it out when its not 7am and you can think

	return CLICK_ACTION_SUCCESS

//TODO: Murder the hologram if the projector is destroyed
//		Forbid a Hologram from activating their projector

#undef HOLOSYNTH_BRUTEMULT
#undef HOLOSYNTH_BURNMULT
#undef HOLOSYNTH_RANGE
