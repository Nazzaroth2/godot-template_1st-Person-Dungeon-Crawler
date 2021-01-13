extends VBoxContainer

onready var characterUI = preload("res://gamecode/scenes/GUI/playerGUI/CharacterOverviewUI.tscn")
onready var playerGroup = get_tree().get_root().get_node("world/playerGroup")

func _ready():
	for player in playerGroup.playerGroup:
		var newCharacterUI = characterUI.instance()
		self.add_child(newCharacterUI)
		newCharacterUI._setupCharacterUI(player)
		player.connect("stat_changed",newCharacterUI,"_on_stat_changed")
		
		

	
