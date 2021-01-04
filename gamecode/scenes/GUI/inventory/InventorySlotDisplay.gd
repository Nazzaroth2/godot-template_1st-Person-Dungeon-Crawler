extends CenterContainer

onready var inventory
onready var itemTextureRect = $ItemTextureRect
onready var stacksLabel = $ItemTextureRect/StacksLabel

func _ready():
	# wait till root-node of inventory is ready, then get inventoryResource-
	# Reference from InventoryDisplay.inventory-Variable.
	yield($"../../..", "ready")
	inventory = get_parent().inventory


func display_item(item):
	if item is BaseItem:
		itemTextureRect.texture = item.icon
		stacksLabel.text = str(item.current_stacks)
	else:
		itemTextureRect.texture = load("res://assets/textures/item-Icons/border_small.png")
		stacksLabel.text = ""

func get_drag_data(_position):
	var item_index = get_index()
	var item = inventory.remove_item(item_index)
	if item is BaseItem:
		var data = {}
		data.item = item
		data.item_index = item_index
		data.parent = inventory
		var dragPreview = TextureRect.new()
		dragPreview.texture = item.icon
		set_drag_preview(dragPreview)
		inventory.drag_data = data
		
		return data
		
	
func can_drop_data(_position, data):
	return data is Dictionary and data.has("item")
	
func drop_data(_position, data):
	var my_item_index = get_index()
	var my_item = inventory.items[my_item_index]
	
	if data.parent == inventory:
		# if we drop onto an item
		if my_item is BaseItem:
			# if both items are same type and can be stacked
			if my_item.name == data.item.name:
				my_item.current_stacks += data.item.current_stacks
				inventory.emit_signal("items_changed",[my_item_index])
			# if not same type we swap items
			else:
				inventory.swap_items(my_item_index, data.item_index)
				inventory.set_item(my_item_index, data.item)
		# in case we drop on empty slot we put item into empty slot
		else:
			inventory.swap_items(my_item_index, data.item_index)
			inventory.set_item(my_item_index, data.item)
		inventory.drag_data = null
		
	# if we drop on a shop (selling item)
	elif inventory.type == "SHOP":
		# if we drop onto an item
		if my_item is BaseItem:
			# if both items are same type and can be stacked
			if my_item.name == data.item.name:
				for i in range(data.item.current_stacks):
					inventory.sell_item(data.parent,inventory,data.item)
				my_item.current_stacks += data.item.current_stacks
				inventory.emit_signal("items_changed",[my_item_index])
				get_tree().set_input_as_handled()
				data.parent.drag_data = null
			# if not same type we seach for next free slot and drop item there
			else:
				var freeIdx = _find_next_empty_idx()
				if freeIdx == null:
					# TODO: print out full inventory here
					pass
				else:
					inventory.sell_item(data.parent,inventory,data.item)
					inventory.set_item(freeIdx, data.item)
					get_tree().set_input_as_handled()
					data.parent.drag_data = null
		# in case we drop on empty slot we put item into empty slot
		else:
			if data.item.current_stacks > 1:
				for i in range(data.item.current_stacks):
					inventory.sell_item(data.parent,inventory,data.item)
				inventory.set_item(my_item_index, data.item)
				# set the input of dropping item on diffrent inventory
				# as handled so old inventory doesnt reset it.
				get_tree().set_input_as_handled()
				# reset old inventory drag_data so we have clean state again
				data.parent.drag_data = null
			else:
				inventory.sell_item(data.parent,inventory,data.item)
				inventory.set_item(my_item_index, data.item)
				# set the input of dropping item on diffrent inventory
				# as handled so old inventory doesnt reset it.
				get_tree().set_input_as_handled()
				# reset old inventory drag_data so we have clean state again
				data.parent.drag_data = null
		inventory.drag_data = null
	# if we drop from a shop (buying item)
	elif data.parent.type == "SHOP":
		# if we drop onto an item
		if my_item is BaseItem:
			# if both items are same type and can be stacked
			if my_item.name == data.item.name:
				for i in range(data.item.current_stacks):
					inventory.buy_item(inventory,data.parent,data.item)
				my_item.current_stacks += data.item.current_stacks
				inventory.emit_signal("items_changed",[my_item_index])
				get_tree().set_input_as_handled()
				data.parent.drag_data = null
			# if not same type we seach for next free slot and drop item there
			else:
				var freeIdx = _find_next_empty_idx()
				if freeIdx == null:
					# TODO: print out full inventory here
					pass
				else:
					inventory.buy_item(inventory,data.parent,data.item)
					inventory.set_item(freeIdx, data.item)
					get_tree().set_input_as_handled()
					data.parent.drag_data = null
		# in case we drop on empty slot we put item into empty slot
		else:
			if data.item.current_stacks > 1:
				for i in range(data.item.current_stacks):
					inventory.buy_item(inventory,data.parent,data.item)
				inventory.set_item(my_item_index, data.item)
				# set the input of dropping item on diffrent inventory
				# as handled so old inventory doesnt reset it.
				get_tree().set_input_as_handled()
				# reset old inventory drag_data so we have clean state again
				data.parent.drag_data = null
			else:
				inventory.buy_item(inventory,data.parent,data.item)
				inventory.set_item(my_item_index, data.item)
				# set the input of dropping item on diffrent inventory
				# as handled so old inventory doesnt reset it.
				get_tree().set_input_as_handled()
				# reset old inventory drag_data so we have clean state again
				data.parent.drag_data = null
		inventory.drag_data = null
	# if we drop or take from any other inventory (chest, player etc.)
	else:
		# if we drop onto an item
		if my_item is BaseItem:
			# if both items are same type and can be stacked
			if my_item.name == data.item.name:
				my_item.current_stacks += data.item.current_stacks
				inventory.emit_signal("items_changed",[my_item_index])
				get_tree().set_input_as_handled()
				data.parent.drag_data = null
			# if not same type we seach for next free slot and drop item there
			else:
				var freeIdx = _find_next_empty_idx()
				if freeIdx == null:
					# TODO: print out full inventory here
					pass
				else:
					inventory.set_item(freeIdx, data.item)
					get_tree().set_input_as_handled()
					data.parent.drag_data = null
		# in case we drop on empty slot we put item into empty slot
		else:
			inventory.set_item(my_item_index, data.item)
			# set the input of dropping item on diffrent inventory
			# as handled so old inventory doesnt reset it.
			get_tree().set_input_as_handled()
			# reset old inventory drag_data so we have clean state again
			data.parent.drag_data = null
		inventory.drag_data = null



func _find_next_empty_idx():
	for idx in range(len(inventory.items)):
		if inventory.items[idx] == null:
			return idx
			











