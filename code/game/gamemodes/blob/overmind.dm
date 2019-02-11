/mob/camera/blob
	name = "Blob Overmind"
	real_name = "Blob Overmind"
	icon = 'icons/mob/blob.dmi'
	icon_state = "marker"

	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_MINIMUM
	invisibility = INVISIBILITY_OBSERVER

	pass_flags = PASSBLOB
	faction = "blob"

	var/obj/effect/blob/core/blob_core = null // The blob overmind's core
	var/blob_points = 0
	var/max_blob_points = 100

/mob/camera/blob/atom_init()
	var/new_name = "[initial(name)] ([rand(1, 999)])"
	name = new_name
	real_name = new_name
	. = ..()

/mob/camera/blob/Login()
	..()
	sync_mind()
	to_chat(src, "<span class='notice'>You are the overmind!</span>")
	to_chat(src, "You are the overmind and can control the blob! You can expand, which will attack people, and place new blob pieces such as...")
	to_chat(src, "<b>Normal Blob</b> will expand your reach and allow you to upgrade into special blobs that perform certain functions.")
	to_chat(src, "<b>Shield Blob</b> is a strong and expensive blob which can take more damage. It is fireproof and can block air, use this to protect yourself from station fires.")
	to_chat(src, "<b>Resource Blob</b> is a blob which will collect more resources for you, try to build these earlier to get a strong income. It will benefit from being near your core or multiple nodes, by having an increased resource rate; put it alone and it won't create resources at all.")
	to_chat(src, "<b>Node Blob</b> is a blob which will grow, like the core. Unlike the core it won't give you a small income but it can power resource and factory blobs to increase their rate.")
	to_chat(src, "<b>Factory Blob</b> is a blob which will spawn blob spores which will attack nearby food. Putting this nearby nodes and your core will increase the spawn rate; put it alone and it will not spawn any spores.")
	to_chat(src, "<b>Shortcuts:</b> CTRL Click = Expand Blob / Middle Mouse Click = Rally Spores / Alt Click = Create Shield")

/mob/camera/blob/proc/add_points(points)
	if(points != 0)
		blob_points = Clamp(blob_points + points, 0, max_blob_points)
/mob/camera/blob/say(var/message)
	if (!message)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "You cannot send IC messages (muted).")
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	if (stat)
		return

	blob_talk(message)

/mob/camera/blob/proc/blob_talk(message)
	message = sanitize(message)

	log_say("[key_name(src)] : [message]")

	if (!message)
		return

	//var/message_a = say_quote(message)
	var/message_a = "<span class='say_quote'>says,</span> \"<span class='body'>[message]</span>\""
	var/rendered = "<font color=\"#EE4000\"><i><span class='game say'>Blob Telepathy, <span class='name'>[name]</span> <span class='message'>[message_a]</span></span></i></font>"

	for (var/mob/M in mob_list)
		if(isovermind(M) || isobserver(M))
			M.show_message(rendered, 2)

/mob/camera/blob/emote(act,m_type=1,message = null)
	return

/mob/camera/blob/blob_act()
	return

/mob/camera/blob/Stat()
	..()
	if(statpanel("Status"))
		if(blob_core)
			stat(null, "Core Health: [blob_core.health]")
		stat(null, "Power Stored: [blob_points]/[max_blob_points]")

/mob/camera/blob/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0)
	. = FALSE
	var/obj/effect/blob/B = locate() in range(3, NewLoc)
	if(NewLoc && B)
		loc = NewLoc
		return TRUE
