extends CenterContainer

# holds the actual item
onready var my_item
# holds the item when we dragged it from slot
# in case we drop it not on a slot, we can reset it from
# this variable
onready var my_item_backup
onready var itemTextureRect = $ItemTextureRect
onready var stacksLabel = $ItemTextureRect/StacksLabel

signal equipment_dropped
signal equipment_dragged



# this enum has to be the same as
# equipment.gd enum
enum EQUIPMENTSLOT{HEAD,CHEST,FEET,L_ARM,R_ARM}
export (EQUIPMENTSLOT) var equipSlot

func _ready():
	display_update()

func display_update():
	if my_item != null:
		itemTextureRect.texture = my_item.icon
		stacksLabel.text = str(my_item.current_stacks)
	else:
		itemTextureRect.texture = load("res://assets/textures/item-Icons/border_small.png")
		stacksLabel.text = ""


func get_drag_data(_position):
	if my_item is Equipment:
		var data = {}
		data.item = my_item
		data.parent = self
		var dragPreview = TextureRect.new()
		dragPreview.texture = my_item.icon
		set_drag_preview(dragPreview)
		
		my_item_backup = my_item
		my_item = null
		display_update()
		emit_signal("equipment_dragged",self.name)

		return data

		
	
func can_drop_data(_position, data):
	if data["item"] is Equipment:
		return data is Dictionary and data["item"].equipSlot == self.equipSlot
	
func drop_data(_position, data):
	# incase we drag item from equipSlot and then drop
	# it back into slot
	if not(data.has("parent")):
		my_item = data.item
		display_update()
	else:
		var playerInv = data.parent
		
		# if already equiped item we need to put new item into
		# slot, put old item into empty slot in inventory and
		# reduce stacks from dragged item
		if my_item != null:
			if data.item.current_stacks > 1:
				# need to keep original equiped item in temp
				# var, cause we can only put it into inventory
				# after we have put the dragged item into inventory
				var tempOriginalItem = my_item

				# put new equipment into slot
				my_item = data.item.duplicate()
				my_item.current_stacks = 1
				# reduce dragged item stacks and put back
				# into original slot of Inventory
				data.item.current_stacks -= 1
				playerInv.set_item(data.item_index, data.item)
				
				var newIdx = _find_next_empty_idx(playerInv)
				# remove equiped item from slot and put it into an
				# empty slot in the player Inventory
				playerInv.set_item(newIdx, tempOriginalItem)
				
				# update visuals for equip-slot and playerInv
				display_update()
				playerInv.emit_signal("items_changed",[data.item_index,
														newIdx])
				get_tree().set_input_as_handled()
			else:
				var newIdx = _find_next_empty_idx(playerInv)
				# remove equiped item from slot and put it into an
				# empty slot in the player Inventory
				playerInv.set_item(newIdx, my_item)
				# put new equipment into slot
				my_item = data.item
				# update visuals for equip-slot and playerInv
				display_update()
				playerInv.emit_signal("items_changed",[newIdx])
				get_tree().set_input_as_handled()
			
		# in case we drop on empty equip slot
		else:
			# if we drag an equipment item with more than 1 stack
			# we duplicate the item to have a unique item with 1
			# stack and return the dragged item to the inventory
			# with stacks reduced by 1
			if data.item.current_stacks > 1:
				my_item = data.item.duplicate()
				my_item.current_stacks = 1
				data.item.current_stacks -= 1
				playerInv.set_item(data.item_index, data.item)
				
				display_update()
				playerInv.emit_signal("items_changed",[data.item_index])
				get_tree().set_input_as_handled()
			# else we can drag the whole item into equipSlot
			else:
				my_item = data.item
				# update visuals for equip-slot and playerInv
				display_update()
				playerInv.emit_signal("items_changed",[data.item_index])
				get_tree().set_input_as_handled()
		playerInv.drag_data = null
		my_item_backup = null
	
	# no matter how we drop item into slot we emit changed signal
	emit_signal("equipment_dropped",self.name,my_item)


func _find_next_empty_idx(inventory):
	for idx in range(len(inventory.items)):
		if inventory.items[idx] == null:
			return idx

func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if my_item_backup != null:
			my_item = my_item_backup
			emit_signal("equipment_dropped",self.name,my_item)
			display_update()
			my_item_backup = null
