extends CenterContainer

onready var playerGroupNode = get_tree().get_root().get_node("world/playerGroup")
onready var activePlayer = playerGroupNode.playerGroup[0] setget set_activePlayer



func _ready():
	for slot in $equipmentSlots.get_children():
		slot.connect("equipment_dropped", self, "_on_equipment_dropped")
		slot.connect("equipment_dragged", self, "_on_equipment_dragged")
	
	_update_equipment_slots()

func set_activePlayer(value):
	activePlayer = value
	
	_update_equipment_slots()

func _update_equipment_slots():
	$playerIcon.texture = activePlayer.icon
	
	for slot in $equipmentSlots.get_children():
				
		match slot.name:
			"headSlot":
				slot.my_item = activePlayer.equipment["head"]
				slot.display_update()
			"rArmSlot":
				slot.my_item = activePlayer.equipment["rArm"]
				slot.display_update()
			"lArmSlot":
				slot.my_item = activePlayer.equipment["lArm"]
				slot.display_update()
			"feetSlot":
				slot.my_item = activePlayer.equipment["feet"]
				slot.display_update()
			"chestSlot":
				slot.my_item = activePlayer.equipment["chest"]
				slot.display_update()

# change item in equipment Dictionary of player to new
# equiped item
func _on_equipment_dropped(slotName, equipmentItem):
	match slotName:
		"headSlot":
			activePlayer.equipment["head"] = equipmentItem
		"rArmSlot":
			activePlayer.equipment["rArm"] = equipmentItem
		"lArmSlot":
			activePlayer.equipment["lArm"] = equipmentItem
		"feetSlot":
			activePlayer.equipment["feet"] = equipmentItem
		"chestSlot":
			activePlayer.equipment["chest"] = equipmentItem
			
func _on_equipment_dragged(slotName):
	match slotName:
		"headSlot":
			activePlayer.equipment["head"] = null
		"rArmSlot":
			activePlayer.equipment["rArm"] = null
		"lArmSlot":
			activePlayer.equipment["lArm"] = null
		"feetSlot":
			activePlayer.equipment["feet"] = null
		"chestSlot":
			activePlayer.equipment["chest"] = null
			
func _input(event):
	if event.is_action_pressed("next_activePlayer"):
		_change_activePlayer("next")
	elif event.is_action_pressed("prev_activePlayer"):
		_change_activePlayer("prev")

func _change_activePlayer(direction):
	var activeIdx = playerGroupNode.playerGroup.find(activePlayer)
	var newIdx
	
	if direction == "next":
		# if active Player is last in group we wrap around
		# to first player in group
		if activeIdx == len(playerGroupNode.playerGroup)-1:
			newIdx = 0
		else:
			newIdx = activeIdx + 1
	if direction == "prev":
		# if activ Player is first in group we wrap around
		# to last player in group
		if activeIdx == 0:
			newIdx = len(playerGroupNode.playerGroup)-1
		else:
			newIdx = activeIdx - 1
	
	self.activePlayer = playerGroupNode.playerGroup[newIdx]
