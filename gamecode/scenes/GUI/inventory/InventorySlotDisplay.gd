extends CenterContainer

onready var inventory
onready var itemTextureRect = $ItemTextureRect
onready var stacksLabel = $ItemTextureRect/StacksLabel

var inputFlag = ""

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
		if inventory.check_sell(data.parent, inventory, data.item):
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
		if inventory.check_buy(inventory, data.parent, data.item):
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
						# TODO: show message "full inventory" here
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
			

func _gui_input(event):
	if event.is_action_pressed("ui_right_mouse"):
		_createNewSingleStack()
	if event.is_action_pressed("ui_left_mouse"):
		if event.doubleclick:
			_showUseGui(get_viewport().get_mouse_position())

# removes 1 stack from clicked on item and creates
# a new item in a diffrent slot with 1 stack
func _createNewSingleStack():
	# get the item we clicked on
	var item_index = get_index()
	var item = inventory.items[item_index]
	if item is BaseItem:
		# find an empty inventory slot
		var emptyIdx = _find_next_empty_idx()
		if emptyIdx != null:
			# add item into empty slot and set stacks to 1
			inventory.items[emptyIdx] = item.duplicate()
			inventory.items[emptyIdx].current_stacks = 1
			# remove 1 stack from original item stack
			item.current_stacks -= 1
			
			inventory.emit_signal("items_changed",[item_index, emptyIdx])


func _showUseGui(mousePosition):
	var item_index = get_index()
	var item = inventory.items[item_index]
	var useGui = load("res://gamecode/scenes/GUI/inventory/useGui.tscn").instance()
	useGui.choosen_item = item
	useGui.choosen_item_index = item_index
	
	self.add_child(useGui)
	useGui.rect_position = mousePosition
	useGui.popup()

