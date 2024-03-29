extends GridContainer

onready var inventory = $"../../..".inventory

func _ready():
	inventory.connect("items_changed", self, "_on_items_changed")

	inventory.make_items_unique()
	update_inventory_display()


func update_inventory_display():
	for item_index in len(inventory.items):
		update_inventory_slot_display(item_index)

func update_inventory_slot_display(item_index):
	var inventorySlotDisplay = get_child(item_index)
	var item = inventory.items[item_index]
	
	# if item has 0 or less stacks we remove it from
	# inventory
	if item is BaseItem:
		if item.current_stacks <= 0:
			inventory.items[item_index] = null
			item = inventory.items[item_index]
	
	inventorySlotDisplay.display_item(item)
	

func _on_items_changed(indexes):
	for item_index in indexes:
		update_inventory_slot_display(item_index)


func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary and inventory.drag_data.has("item"):
			inventory.set_item(inventory.drag_data.item_index,
								inventory.drag_data.item)








