/datum/component/glass_passer/holosynth/phase_through_glass(mob/living/owner, atom/bumpee)
	var/mob/living/carbon/ascarbon = owner

	if(!do_after(owner, pass_time, bumpee))
		return

	if(ascarbon.handcuffed || ascarbon.legcuffed)
		ascarbon.balloon_alert(ascarbon, "Restrained!")
		return

	passwindow_on(owner, type)

	//Need this to happen post timer but pre move. Otherwise touching glass will instantly strip ppl
	for(var/obj/item/real in owner)
		owner.dropItemToGround(real)

	try_move_adjacent(owner, get_dir(owner, bumpee))
	passwindow_off(owner, type)
