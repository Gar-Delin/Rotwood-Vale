/*
Consuming extracts:
	Can eat food items.
	After consuming enough, produces special cookies.
*/
/obj/item/slimecross/consuming
	name = "consuming extract"
	desc = "" //My slimecross has finally decided to eat... my buffet!
	icon_state = "consuming"
	effect = "consuming"
	var/nutriment_eaten = 0
	var/nutriment_required = 10
	var/cooldown = 600 //1 minute.
	var/last_produced = 0
	var/cookies = 5 //Number of cookies to spawn
	var/cookietype = /obj/item/slime_cookie

/obj/item/slimecross/consuming/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/reagent_containers/food/snacks))
		if(last_produced + cooldown > world.time)
			to_chat(user, span_warning("[src] is still digesting after its last meal!"))
			return
		var/datum/reagent/N = O.reagents.has_reagent(/datum/reagent/consumable/nutriment)
		if(N)
			nutriment_eaten += N.volume
			to_chat(user, span_notice("[src] opens up and swallows [O] whole!"))
			qdel(O)
			playsound(src, 'sound/blank.ogg', 20, TRUE)
		else
			to_chat(user, span_warning("[src] burbles unhappily at the offering."))
		if(nutriment_eaten >= nutriment_required)
			nutriment_eaten = 0
			user.visible_message(span_notice("[src] swells up and produces a small pile of cookies!"))
			playsound(src, 'sound/blank.ogg', 40, TRUE)
			last_produced = world.time
			for(var/i in 1 to cookies)
				var/obj/item/S = spawncookie()
				S.pixel_x = rand(-5, 5)
				S.pixel_y = rand(-5, 5)
		return
	..()

/obj/item/slimecross/consuming/proc/spawncookie()
	return new cookietype(get_turf(src))

/obj/item/slime_cookie //While this technically acts like food, it's so removed from it that I made it its' own type.
	name = "error cookie"
	desc = ""
	icon = 'icons/obj/food/slimecookies.dmi'
	var/taste = "error"
	var/nutrition = 5
	icon_state = "base"
	force = 0
	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	throw_speed = 3
	throw_range = 6

/obj/item/slime_cookie/proc/do_effect(mob/living/M, mob/user)
	return

/obj/item/slime_cookie/attack(mob/living/M, mob/user)
	var/fed = FALSE
	if(M == user)
		M.visible_message(span_notice("[user] eats [src]!"), span_notice("I eat [src]."))
		fed = TRUE
	else
		M.visible_message(span_danger("[user] tries to force [M] to eat [src]!"), span_danger("[user] tries to force you to eat [src]!"))
		if(do_after(user, 20, target = M))
			fed = TRUE
			M.visible_message(span_danger("[user] forces [M] to eat [src]!"), span_warning("[user] forces you to eat [src]."))
	if(fed)
		var/mob/living/carbon/human/H = M

		if(!istype(H) || !HAS_TRAIT(H, TRAIT_AGEUSIA))
			to_chat(M, span_notice("Tastes like [taste]."))
		playsound(get_turf(M), 'sound/blank.ogg', 20, TRUE)
		if(nutrition)
			M.reagents.add_reagent(/datum/reagent/consumable/nutriment,nutrition)
		do_effect(M, user)
		qdel(src)
		return
	..()

/obj/item/slimecross/consuming/grey
	colour = "grey"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/grey

/obj/item/slime_cookie/grey
	name = "slime cookie"
	desc = ""
	icon_state = "grey"
	taste = "goo"
	nutrition = 15

/obj/item/slimecross/consuming/orange
	colour = "orange"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/orange

/obj/item/slime_cookie/orange
	name = "fiery cookie"
	desc = ""
	icon_state = "orange"
	taste = "cinnamon and burning"

/obj/item/slime_cookie/orange/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/firecookie)

/obj/item/slimecross/consuming/purple
	colour = "purple"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/purple

/obj/item/slime_cookie/purple
	name = "health cookie"
	desc = ""
	icon_state = "purple"
	taste = "fruit jam and cough medicine"

/obj/item/slime_cookie/purple/do_effect(mob/living/M, mob/user)
	M.adjustBruteLoss(-5)
	M.adjustFireLoss(-5)
	M.adjustToxLoss(-5, forced=1) //To heal slimepeople.
	M.adjustOxyLoss(-5)
	M.adjustCloneLoss(-5)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5)

/obj/item/slimecross/consuming/blue
	colour = "blue"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/blue

/obj/item/slime_cookie/blue
	name = "water cookie"
	desc = ""
	icon_state = "blue"
	taste = /datum/reagent/water

/obj/item/slime_cookie/blue/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/watercookie)

/obj/item/slimecross/consuming/metal
	colour = "metal"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/metal

/obj/item/slime_cookie/metal
	name = "metallic cookie"
	desc = ""
	icon_state = "metal"
	taste = /datum/reagent/copper

/obj/item/slime_cookie/metal/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/metalcookie)

/obj/item/slimecross/consuming/yellow
	colour = "yellow"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/yellow

/obj/item/slime_cookie/yellow
	name = "sparking cookie"
	desc = ""
	icon_state = "yellow"
	taste = "lemon cake and rubber gloves"

/obj/item/slime_cookie/yellow/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/sparkcookie)

/obj/item/slimecross/consuming/darkpurple
	colour = "dark purple"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/darkpurple

/obj/item/slime_cookie/darkpurple
	name = "toxic cookie"
	desc = ""
	icon_state = "darkpurple"
	taste = "slime jelly and toxins"

/obj/item/slime_cookie/darkpurple/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/toxincookie)

/obj/item/slimecross/consuming/darkblue
	colour = "dark blue"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/darkblue

/obj/item/slime_cookie/darkblue
	name = "frosty cookie"
	desc = ""
	icon_state = "darkblue"
	taste = "mint and bitter cold"

/obj/item/slime_cookie/darkblue/do_effect(mob/living/M, mob/user)
	M.adjust_bodytemperature(-110)
	M.ExtinguishMob()

/obj/item/slimecross/consuming/silver
	colour = "silver"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/silver

/obj/item/slime_cookie/silver
	name = "waybread cookie"
	desc = ""
	icon_state = "silver"
	taste = "masterful elven baking"
	nutrition = 0 //We don't want normal nutriment

/obj/item/slime_cookie/silver/do_effect(mob/living/M, mob/user)
	M.reagents.add_reagent(/datum/reagent/consumable/nutriment/stabilized,10)

/obj/item/slimecross/consuming/bluespace
	colour = "bluespace"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/bluespace

/obj/item/slime_cookie/bluespace
	name = "space cookie"
	desc = ""
	icon_state = "bluespace"
	taste = "sugar and starlight"

/obj/item/slime_cookie/bluespace/do_effect(mob/living/M, mob/user)
	var/list/L = get_area_turfs(get_area(get_turf(M)))
	var/turf/target
	while (L.len && !target)
		var/I = rand(1, L.len)
		var/turf/T = L[I]
		if (is_centcom_level(T.z))
			L.Cut(I,I+1)
			continue
		if(!T.density)
			var/clear = TRUE
			for(var/obj/O in T)
				if(O.density)
					clear = FALSE
					break
			if(clear)
				target = T
		if (!target)
			L.Cut(I,I+1)

	if(target)
		do_teleport(M, target, 0, asoundin = 'sound/blank.ogg', channel = TELEPORT_CHANNEL_BLUESPACE)
		new /obj/effect/particle_effect/sparks(get_turf(M))
		playsound(get_turf(M), "sparks", 50, TRUE)

/obj/item/slimecross/consuming/sepia
	colour = "sepia"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/sepia

/obj/item/slime_cookie/sepia
	name = "time cookie"
	desc = ""
	icon_state = "sepia"
	taste = "brown sugar and a metronome"

/obj/item/slime_cookie/sepia/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/timecookie)

/obj/item/slimecross/consuming/cerulean
	colour = "cerulean"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/cerulean
	cookies = 3 //You're gonna get more.

/obj/item/slime_cookie/cerulean
	name = "duplicookie"
	desc = ""
	icon_state = "cerulean"
	taste = "a sugar cookie"

/obj/item/slime_cookie/cerulean/do_effect(mob/living/M, mob/user)
	if(prob(50))
		to_chat(M, span_notice("A piece of [src] breaks off while you chew, and falls to the ground."))
		var/obj/item/slime_cookie/cerulean/C = new(get_turf(M))
		C.taste = taste + " and a sugar cookie"

/obj/item/slimecross/consuming/pyrite
	colour = "pyrite"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/pyrite

/obj/item/slime_cookie/pyrite
	name = "color cookie"
	desc = ""
	icon_state = "pyrite"
	taste = "vanilla and " //Randomly selected color dye.
	var/colour = "#FFFFFF"

/obj/item/slime_cookie/pyrite/Initialize()
	. = ..()
	var/tastemessage = "paint remover"
	switch(rand(1,7))
		if(1)
			tastemessage = "red dye"
			colour = "#FF0000"
		if(2)
			tastemessage = "orange dye"
			colour = "#FFA500"
		if(3)
			tastemessage = "yellow dye"
			colour = "#FFFF00"
		if(4)
			tastemessage = "green dye"
			colour = "#00FF00"
		if(5)
			tastemessage = "blue dye"
			colour = "#0000FF"
		if(6)
			tastemessage = "indigo dye"
			colour = "#4B0082"
		if(7)
			tastemessage = "violet dye"
			colour = "#FF00FF"
	taste += tastemessage

/obj/item/slime_cookie/pyrite/do_effect(mob/living/M, mob/user)
	M.add_atom_colour(colour,WASHABLE_COLOUR_PRIORITY)

/obj/item/slimecross/consuming/red
	colour = "red"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/red

/obj/item/slime_cookie/red
	name = "blood cookie"
	desc = ""
	icon_state = "red"
	taste = "red velvet and iron"

/obj/item/slime_cookie/red/do_effect(mob/living/M, mob/user)
	new /obj/effect/decal/cleanable/blood(get_turf(M))
	playsound(get_turf(M), 'sound/blank.ogg', 10, TRUE)
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		C.blood_volume += 25 //Half a vampire drain.

/obj/item/slimecross/consuming/green
	colour = "green"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/green

/obj/item/slime_cookie/green
	name = "gross cookie"
	desc = ""
	icon_state = "green"
	taste = "the contents of your stomach"

/obj/item/slime_cookie/green/do_effect(mob/living/M, mob/user)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit(25)
	M.reagents.remove_all()

/obj/item/slimecross/consuming/pink
	colour = "pink"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/pink

/obj/item/slime_cookie/pink
	name = "love cookie"
	desc = ""
	icon_state = "pink"
	taste = "love and hugs"

/obj/item/slime_cookie/pink/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/lovecookie)

/obj/item/slimecross/consuming/gold
	colour = "gold"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/gold

/obj/item/slime_cookie/gold
	name = "gilded cookie"
	desc = ""
	icon_state = "gold"
	taste = "sweet cornbread and wealth"

/obj/item/slime_cookie/gold/do_effect(mob/living/M, mob/user)
	var/obj/item/held = M.get_active_held_item() //This should be itself, but just in case...
	M.dropItemToGround(held)
	var/newcoin = /obj/item/coin/gold
	var/obj/item/coin/C = new newcoin(get_turf(M))
	playsound(get_turf(C), 'sound/blank.ogg', 50, TRUE)
	M.put_in_hand(C)

/obj/item/slimecross/consuming/oil
	colour = "oil"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/oil

/obj/item/slime_cookie/oil
	name = "tar cookie"
	desc = ""
	icon_state = "oil"
	taste = "rich molten chocolate and tar"

/obj/item/slime_cookie/oil/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/tarcookie)

/obj/item/slimecross/consuming/black
	colour = "black"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/black

/obj/item/slime_cookie/black
	name = "spooky cookie"
	desc = ""
	icon_state = "black"
	taste = "ghosts and stuff"

/obj/item/slime_cookie/black/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/spookcookie)

/obj/item/slimecross/consuming/lightpink
	colour = "light pink"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/lightpink

/obj/item/slime_cookie/lightpink
	name = "peace cookie"
	desc = ""
	icon_state = "lightpink"
	taste = "strawberry icing and P.L.U.R" //Literal candy raver.

/obj/item/slime_cookie/lightpink/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/peacecookie)

/obj/item/slimecross/consuming/adamantine
	colour = "adamantine"
	effect_desc = ""
	cookietype = /obj/item/slime_cookie/adamantine

/obj/item/slime_cookie/adamantine
	name = "crystal cookie"
	desc = ""
	icon_state = "adamantine"
	taste = "crystalline sugar and metal"

/obj/item/slime_cookie/adamantine/do_effect(mob/living/M, mob/user)
	M.apply_status_effect(/datum/status_effect/adamantinecookie)

/obj/item/slimecross/consuming/rainbow
	colour = "rainbow"
	effect_desc = ""

/obj/item/slimecross/consuming/rainbow/spawncookie()
	var/cookie_type = pick(subtypesof(/obj/item/slime_cookie))
	var/obj/item/slime_cookie/S = new cookie_type(get_turf(src))
	S.name = "rainbow cookie"
	S.desc = ""
	S.icon_state = "rainbow"
	return S
