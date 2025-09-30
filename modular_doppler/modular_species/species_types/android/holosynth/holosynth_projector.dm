/obj/item/holosynth_pen
	name = "Holosynth Projector-Magnet Combo"
	desc = "A complex mechanism that both projects the form of a hologram and manipulates its aerogel canvas. \
	Miraculously, it also doubles as a pen."
	icon = 'modular_doppler/modular_species/species_types/android/holosynth/holosynth_pen.dmi'
	worn_icon = 'modular_doppler/modular_species/species_types/android/holosynth/holosynth_pen.dmi'
	icon_state = "Holopen"
	worn_icon_state = "w_holopen"
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_EARS
	w_class = WEIGHT_CLASS_TINY
	var/colour = BLOOD_COLOR_HOLOGEL
	var/font = FOUNTAIN_PEN_FONT
	damtype = BURN
	force = 5

	var/mob/living/carbon/human/linked_mob
	var/turf/saved_loc


/obj/item/holosynth_pen/Initialize(mapload, linked_mob)
	. = ..()
	AddElement(/datum/element/tool_renaming)

	if(linked_mob)
		src.linked_mob = linked_mob
		saved_loc = get_turf(linked_mob)

		create_transform_component()
		RegisterSignal(src, COMSIG_TRANSFORMING_ON_TRANSFORM, PROC_REF(on_transform))
	else
		src.linked_mob = null

	AddComponent( \
		/datum/component/aura_healing, \
		range = 1, \
		brute_heal = 1, \
		burn_heal = 1.5, \
		blood_heal = 2, \
		simple_heal = 1.2, \
		wound_clotting = 0.1, \
		organ_healing = list(ORGAN_SLOT_BRAIN = 1, ORGAN_SLOT_HEART = 0.5, ORGAN_SLOT_EARS = 1, ORGAN_SLOT_EYES = 1, ORGAN_SLOT_TONGUE = 1.5), \
		requires_visibility = FALSE, \
		limit_to_trait = TRAIT_HOLOSYNTH, \
		healing_color = BLOOD_COLOR_HOLOGEL, \
	)

/obj/item/holosynth_pen/proc/create_transform_component()
	AddComponent( \
		/datum/component/transforming, \
		start_transformed = FALSE, \
		force_on = 14, \
		inhand_icon_change = FALSE, \
		w_class_on = w_class, \
	)

/obj/item/holosynth_pen/proc/on_transform(obj/item/source, mob/user, active)
	SIGNAL_HANDLER

	if(user)
		balloon_alert(user, "clicked")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)
	icon_state = initial(icon_state) + (active ? "_writing" : "")
	worn_icon_state = initial(worn_icon_state) + (active ? "_writing" : "")
	update_appearance(UPDATE_ICON)

	if(isnull(linked_mob))
		return

	if(active) //If you WERE active we save loc and place our creature into pen
		saved_loc = get_turf(linked_mob)
		new /obj/effect/temp_visual/guardian/phase/out (saved_loc)
		linked_mob.unequip_everything()
		linked_mob.loc = src
	else	//Otherwise, put the hologram back
		linked_mob.loc = saved_loc
		new /obj/effect/temp_visual/guardian/phase (get_turf(linked_mob))

	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/holosynth_pen/Destroy()
	if(linked_mob)
		ASYNC
			kill_that_mob()
			linked_mob = null
	. = ..()

/obj/item/holosynth_pen/attack_self(mob/user)
	if(user == linked_mob)
		balloon_alert(user, "your projector will not allow you to modify it!")
		return
	. = ..()

/obj/item/holosynth_pen/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isnull(linked_mob))
		return
	if(user == linked_mob)
		return
	if(linked_mob.loc != src)
		balloon_alert(user, "can't target while projection is active!")
		return
	var/turf/turf_target = get_turf(interacting_with)
	if(turf_target.density == 1)
		balloon_alert(user, "can't target a solid object!")
		return
	saved_loc = turf_target
	balloon_alert(user, "location targetted.")
	playsound(src, 'sound/items/pen_click.ogg', 30, TRUE, -3)

/obj/item/holosynth_pen/proc/kill_that_mob()
	if(isnull(linked_mob))
		return

	linked_mob.visible_message(
		span_danger("[linked_mob]'s whole body begins to flicker, shudder and fall apart!"),
		span_userdanger("You feel your projector being destroyed! Your form loses cohesion!")
	)
	// You are GOING to GO no matter WHAT
	var/holodestroyflags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_INCAPACITATED | IGNORE_SLOWDOWNS
	if(do_after(linked_mob, 20 SECONDS, linked_mob, holodestroyflags))
		linked_mob.gib(DROP_ALL_REMAINS & ~DROP_BODYPARTS) //bright side, your brain's in there. Someone'll use it I'm sure.

/obj/item/holosynth_pen/examine()
	. = ..()
	if(linked_mob)
		. += span_info("This one belongs to [linked_mob].")

/obj/item/holosynth_pen/get_writing_implement_details()
	if (HAS_TRAIT(src, TRAIT_TRANSFORM_ACTIVE))
		return list(
		interaction_mode = MODE_WRITING,
		font = font,
		color = colour,
		use_bold = FALSE,
		)
	else
		return null
