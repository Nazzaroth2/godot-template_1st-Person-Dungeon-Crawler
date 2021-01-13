extends Node

var fightSceneReference = preload("res://gamecode/scenes/fightingScene/fightScene.tscn")
onready var dungeonScene = $dungeon
#onready var playerCamera = dungeonScene.get_node("playerCamera")
var rng = RandomNumberGenerator.new()
var stepCnt
var encounterLimit
var minEncounterSteps = 1
var maxEncounterSteps = 1

signal fight_over

func _ready():
	dungeonScene.connect("lootEvent",self,"_on_lootEvent")
	dungeonScene.connect("shopEvent",self,"_on_shopEvent")
	$GUI/rewardWindow.connect("popup_hide", self, "_on_rewardGUI_hide")
	$GUI/shopWindow.connect("popup_hide", self, "_on_shopGUI_hide")
	
	dungeonScene.get_node("playerCamera").connect("movement_finished",
											 self, "_on_playerCamera_movement_finished")
	
	self.connect("fight_over",self, "_on_fight_over")
	
	_setupEncounterVar()


# player gui input
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
#		$GUI/playerGUI.set_as_minsize()
		$GUI/playerGUI.popup_centered()



# if no event gets triggered on next cell we randomly
# spawn an enemy encounter
func _on_playerCamera_movement_finished():
	# before transition to the fight scene we need to save
	# level-scene and player position for later
	if !dungeonScene.in_Event:
		_randomEncounter()
	# even if we go onto event-cell we need to increas taken steps by 1
	else:
		stepCnt += 1

# when we trigger a lootEvent (eg. Chest) we create a new chestInventoryGUI Scene
# and overwrite the gui-inventory with the event-inventory
func _on_lootEvent(lootInventory):
	var lootInventoryScene = load("res://gamecode/scenes/GUI/inventory/inventoryChest.tscn").instance()

	lootInventoryScene.inventory = lootInventory
	
	$GUI/rewardWindow/rewardGUI.add_child(lootInventoryScene)
	$GUI/rewardWindow.set_as_minsize()
	$GUI/rewardWindow.popup_centered()
	
	# block cameraMovement by setting flag
	dungeonScene.get_node("playerCamera").movement_flag = "event"

# what happens when we close rewardWindow
func _on_rewardGUI_hide():
	if len($GUI/rewardWindow/rewardGUI.get_children()) > 1:
		var chestInv = $GUI/rewardWindow/rewardGUI.get_child(1)
		# if its a chest we only remove inventory-child from window
		if chestInv.inventory.type == "CHEST":
			$GUI/rewardWindow/rewardGUI.remove_child(chestInv)
		# if its a fight-reward we remove inventory-child and finish fight
		# which will quit the fight-scene and go back to dungeon
		elif chestInv.inventory.type == "FIGHT":
			$GUI/rewardWindow/rewardGUI.remove_child(chestInv)
			emit_signal("fight_over")
		
	# reseting flag, so playerCamera can move again
	dungeonScene.get_node("playerCamera").movement_flag = "stop"

# handling shop extra for now in case we want to change the shop-layout
# later down the line.
func _on_shopEvent(shopInventory):
	var shopInventoryScene = load("res://gamecode/scenes/GUI/inventory/inventoryShop.tscn").instance()

	shopInventoryScene.inventory = shopInventory
	
	$GUI/shopWindow/shopGUI.add_child(shopInventoryScene)
	$GUI/shopWindow.set_as_minsize()
	$GUI/shopWindow.popup_centered()
	
	# block cameraMovement by setting flag
	dungeonScene.get_node("playerCamera").movement_flag = "event"


# what happens when we close shopWindow
func _on_shopGUI_hide():
#	if len($GUI/rewardWindow/rewardGUI.get_children()) > 1:
	var shopInv = $GUI/shopWindow/shopGUI.get_child(1)
	
	$GUI/shopWindow/shopGUI.remove_child(shopInv)

	# reseting flag, so playerCamera can move again
	dungeonScene.get_node("playerCamera").movement_flag = "stop"


func _setupEncounterVar():
	stepCnt = 0
	rng.randomize()
	encounterLimit = rng.randi_range(minEncounterSteps, maxEncounterSteps)
	
func _randomEncounter():
	stepCnt += 1
	if stepCnt >= encounterLimit:
		_setupEncounterVar()
		_startEncounter()

# when fight starts we remove dungeonScene from tree but not from
# memory. that way the position in the dungeon stays the same and
# we can easily get back to it after fight is over.
func _startEncounter():
	self.remove_child(dungeonScene)
	var fightScene = fightSceneReference.instance()
	self.add_child_below_node($playerGroup,fightScene)
#	$"fightScene/fightManager".connect("player_won",self,"_on_player_won")
	$"fightScene/fightManager".connect("lootEvent",self,"_on_lootEvent")
	
	
func _on_fight_over():
	$fightScene.queue_free()
	self.add_child(dungeonScene)








