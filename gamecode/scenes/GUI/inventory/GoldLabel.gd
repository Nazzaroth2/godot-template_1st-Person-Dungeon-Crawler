extends Label

onready var inventory = $"../InventoryDisplay".inventory

func _ready():
	inventory.connect("gold_changed",self,"_on_gold_changed")
	# initilize inventory gold
	self.text = "Gold: " + str(inventory.gold)
	
#	if inventory.type == "CHEST":
#		self.connect("gui_input",self,"_on_gui_input")

# update gold ui-label	
func _on_gold_changed(goldAmount):
	self.text = "Gold: " + str(goldAmount)



func can_drop_data(_position, data):
	return data is Dictionary and data.has("gold")
	
func get_drag_data(_position):
	var goldAmount = inventory.gold
	var data = {}
	data.gold = goldAmount
	data.parent = inventory
	var dragPreview = Label.new()
	dragPreview.text = "Gold: " + str(goldAmount)
	set_drag_preview(dragPreview)
	inventory.drag_data = data
	
	inventory.gold = 0
	
	return data
	
func drop_data(_position, data):
	inventory.gold += data.gold
	# when we correctly drop we need to set the input to handled
	# so not to call below _unhandled_input()
	get_tree().set_input_as_handled()
	data.parent.drag_data = null
	

# make sure outside dropped gold gets reset to original inventory
func _unhandled_input(event):
	if event.is_action_released("ui_left_mouse"):
		if inventory.drag_data is Dictionary and inventory.drag_data.has("gold"):
			inventory.gold = inventory.drag_data.gold
			inventory.drag_data = null
