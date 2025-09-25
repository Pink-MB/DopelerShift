/datum/component/glass_passer/holosynth/phase_through_glass(mob/living/owner, atom/bumpee)
	var/mob/living/carbon/ascarbon = owner
	var/obj/structure/window/wumpee = bumpee
	var/modified_pass_time = pass_time

	//I want it to take longer if it's a fulltile
	if(wumpee.fulltile)
		modified_pass_time = 3 * pass_time
	else
		modified_pass_time = pass_time

	if(!do_after(owner, modified_pass_time, bumpee))
		return

	if(ascarbon.handcuffed || ascarbon.legcuffed)
		ascarbon.balloon_alert(ascarbon, "Restrained!")
		return

	passwindow_on(owner, type)

	//Need this to happen post timer but pre move. Otherwise touching glass will instantly strip ppl
	//for(var/obj/item/real in owner)
	//.	owner.dropItemToGround(real)
	owner.unequip_everything()

	//We need to do this twice if it's a full window bc otherwise they could reach behind them for their items
	var/dirToMove = get_dir(owner, bumpee)
	try_move_adjacent(owner, dirToMove)
	if(wumpee.fulltile)
		try_move_adjacent(owner, dirToMove)
	//TODO: Make sure this works as intended with fulltile and directional windows and doesn't runtime when bumped on other things

	passwindow_off(owner, type)
