extends Node

var fightSceneReference = preload("res://gamecode/scenes/fightingScene/fightScene.tscn")
onready var dungeonScene = $dungeon
#onready var playerCamera = dungeonScene.get_node("playerCamera")
var rng = RandomNumberGenerator.new()
var stepCnt
var encounterLimit
var minEncounterSteps = 5
var maxEncounterSteps = 10

func _ready():
	dungeonScene.connect("lootEvent",self,"_on_lootEvent")
	dungeonScene.get_node("playerCamera").connect("movement_finished",
											 self, "_on_playerCamera_movement_finished")
	_setupEncounterVar()


# player gui input
func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if $playerGroup/inventory.visible:
			$playerGroup/inventory.visible = false
		else:
			$playerGroup/inventory.visible = true



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

	$Control/rewardGUI.add_child(lootInventoryScene)
	$Control/rewardGUI.visible = true
	

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
	$"fightScene/fightManager".connect("player_won",self,"_on_player_won")
	$"fightScene/fightManager".connect("lootEvent",self,"_on_lootEvent")
	
	
func _on_player_won():
	$fightScene.queue_free()
	self.add_child(dungeonScene)








