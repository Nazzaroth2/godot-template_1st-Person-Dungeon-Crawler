extends Resource
class_name Inventory

var drag_data = null

signal items_changed(indexes)

export(Array, Resource) var items = [
	null, null, null, null, null, null, null, null, null
]

func set_item(item_index, item):
	var previousItem = items[item_index]
	# decide here if you want to set the item as duplicate (unique)
	# on next line or as shared resource
	items[item_index] = item
	emit_signal("items_changed", [item_index])
	# reseting drag_data, it should stay null if no item
	# is getting dragged.
	drag_data = null
	return previousItem
	
	
func swap_items(item_index, target_item_index):
	var targetItem = items[target_item_index]
	var item = items[item_index]
	items[target_item_index] = item
	items[item_index] = targetItem
	emit_signal("items_changed", [item_index, target_item_index])
	
func remove_item(item_index):
	var previousItem = items[item_index]
	items[item_index] = null
	emit_signal("items_changed", [item_index])
	return previousItem
	
func make_items_unique():
	var unique_items = []
	for item in items:
		if item is BaseItem:
			unique_items.append(item.duplicate())
		else:
			unique_items.append(null)
	items = unique_items
			
			
			
			
			
			
			
			
			
			
			
			
			
