extends GridContainer

export (Resource) var inventory
#export (Resource) var inventory = preload("res://gamecode/gameObjects/inventory/playerInventory.tres").duplicate()

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")

#	var newInventory = inventory.duplicate()
#	inventory = newInventory

	inventory.make_items_unique()
	update_inventory_display()
	

	
	print(inventory)
	print(inventory.items)



func update_inventory_display():
	for item_index in len(inventory.items):
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	inventorySlotDisplay.display_item(item)
	

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)


func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary:
			inventory.set_item(inventory.drag_data.item_index,
								inventory.drag_data.item)
