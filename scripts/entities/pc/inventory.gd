extends Node2D

var selected_slot := 1:set = apply_slot_focus

func apply_slot_focus(new_value:int) -> void: 
	for child in get_children():
		if selected_slot != child.slot_numb:
			continue
		child.deselect()

	if new_value == 6:
		new_value -= 5
	elif new_value == 0:
		new_value += 5
	selected_slot = new_value

	for child in get_children():
		if selected_slot != child.slot_numb:
			continue
		child.select()

func manage(item : Node2D) -> void: #finds next available slot
	for child in get_children():
		if child.occupied == true:
			continue
		child.give_item(item)
		break

func increment_selection(value: int) -> int:
	selected_slot += value
	return selected_slot

func direct_selection(target_slot: int) -> int:
	selected_slot = target_slot
	return selected_slot

func get_slot() -> Node2D: #get slot's detail
	var confirmed_child:Node2D
	for child in get_children():
		if child.slot_numb == selected_slot:
			confirmed_child = child
	return confirmed_child
