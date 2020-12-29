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

#func _on_gui_input(inputEvent):
#	if inputEvent is InputEvent:
#		if inputEvent.is_action_pressed("ui_left_mouse"):



func can_drop_data(_position, data):
	return data is Dictionary and data.has("gold")
	
func get_drag_data(_position):
	var goldAmount = inventory.gold
	var data = {}
	data.gold = goldAmount
	var dragPreview = Label.new()
	dragPreview.text = "Gold: " + str(goldAmount)
	set_drag_preview(dragPreview)
	
	inventory.gold = 0
	
	return data
	
func drop_data(_position, data):
	inventory.gold += data.gold
