/obj/item/pen/cyborg
	name = "inking aparatus"
	desc = "Yeah it's just a pen. Usually connected by servo gantry to a cyborg's clipboard"
	font = PRINTER_FONT
	requires_gravity = TRUE //it's a frickin cyber pen that ball tip is motorized and the ink's got a pump

/obj/item/clipboard/cyborg
	name = "cyborg clipboard"
	icon = 'icons/obj/service/bureaucracy.dmi'
	icon_state = "clipboard"

	integrated_pen = TRUE

/obj/item/clipboard/cyborg/Initialize(mapload)
	. = ..()
	pen = new /obj/item/pen/cyborg

/obj/item/clipboard/cyborg/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()


// /obj/item/borg/apparatus/paperwork
// 	name = "A collection of devices"
// 	desc = "This device seems nonfunctional."
// 	icon = 'icons/mob/silicon/robot_items.dmi'
// 	icon_state = "borg_stack_apparatus"
// 	/// The item stored inside of this apparatus
// 	/// Whitelist of types allowed in this apparatus
// 	storable = list(
// 		/obj/item/paper,
// 		/obj/item/folder,
// 		/obj/item/clipboard,
// 		/obj/item/pen,
// 	)

/obj/item/robot_model/service
	basic_modules = list(
		/obj/item/assembly/flash/cyborg,
		/obj/item/reagent_containers/borghypo/borgshaker,
		/obj/item/borg/apparatus/beaker/service,
		/obj/item/reagent_containers/cup/beaker/large, //I know a shaker is more appropiate but this is for ease of identification
		/obj/item/reagent_containers/condiment/enzyme,
		/obj/item/reagent_containers/dropper,
		/obj/item/rsf,
		/obj/item/storage/bag/tray,
		/obj/item/pen,
		/obj/item/toy/crayon/spraycan/borg,
		/obj/item/extinguisher/mini,
		/obj/item/hand_labeler/borg,
		/obj/item/razor,
		/obj/item/instrument/guitar,
		/obj/item/instrument/piano_synth,
		/obj/item/lighter,
		/obj/item/borg/lollipop,
		/obj/item/stack/pipe_cleaner_coil/cyborg,
		/obj/item/chisel,
		/obj/item/rag,
		/obj/item/storage/bag/money,
		/obj/item/clipboard/cyborg,
		/obj/item/borg/apparatus/paperwork,
	)
