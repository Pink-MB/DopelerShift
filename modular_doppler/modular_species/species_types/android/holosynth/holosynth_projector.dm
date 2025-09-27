/obj/item/pen/holoprojector
	name = "Holosynth Projector-Magnet Combo"
	desc = "A complex mechanism that both projects the form of a hologram and manipulates its aerogel canvas.\
	Miraculously, it also doubles as a pen."
	icon_state = "pen_blue"
	var/mob/living/carbon/human/linked_mob
	var/turf/saved_loc
	var/contents/interior
	var/beam

/obj/item/pen/holoprojector/Initialize(mapload, linked_mob)
	. = ..()
	if(linked_mob)
		src.linked_mob = linked_mob
		saved_loc = get_turf(linked_mob)
	else
		src.linked_mob = null

/obj/item/pen/holoprojector/create_transform_component()
	AddComponent( \
		/datum/component/transforming, \
		start_transformed = FALSE, \
		sharpness_on = NONE, \
		inhand_icon_change = FALSE, \
		w_class_on = w_class, \
	)

/obj/item/pen/holoprojector/on_transform(obj/item/source, mob/user, active)
	. = ..()
	if(active) //If you WERE active we save loc and place our creature into pen
		saved_loc = get_turf(linked_mob)
		new /obj/effect/temp_visual/guardian/phase/out (saved_loc)
		linked_mob.unequip_everything()
		linked_mob.loc = src
	else	//Otherwise, put the hologram back
		linked_mob.loc = saved_loc
		new /obj/effect/temp_visual/guardian/phase (get_turf(linked_mob))

	return COMPONENT_NO_DEFAULT_MESSAGE

/obj/item/pen/holoprojector/Destroy()
	ASYNC
		kill_that_mob()
	linked_mob = null
	. = ..()

/obj/item/pen/holoprojector/attack_self(mob/user)
	if(user == linked_mob)
		balloon_alert(user, "Your Projector will not allow you to modify it!")
		return
	. = ..()

/obj/item/pen/holoprojector/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(user == linked_mob)
		return
	if(linked_mob.loc != src)
		balloon_alert(user, "Can't target while projection is active")
		return

	saved_loc = get_turf(interacting_with)
	balloon_alert(user, "location targetted")

/obj/item/pen/holoprojector/proc/kill_that_mob()
	linked_mob.visible_message(
		span_danger("[linked_mob]'s whole body begins to flicker, shudder and fall apart!"),
		span_userdanger("You feel your projector being destroyed! Your form loses cohesion!")
	)
	// You are GOING to GO no matter WHAT
	var/holodestroyflags = IGNORE_USER_LOC_CHANGE | IGNORE_TARGET_LOC_CHANGE | IGNORE_HELD_ITEM | IGNORE_INCAPACITATED | IGNORE_SLOWDOWNS
	if(do_after(linked_mob, 20 SECONDS, linked_mob, holodestroyflags))
		linked_mob.gib(DROP_ALL_REMAINS & ~DROP_BODYPARTS) //bright side, your brain's in there. Someone'll use it I'm sure.

/*To Test
Glass phasing/item dropping
Pen clicking/writing/targetting
*/
