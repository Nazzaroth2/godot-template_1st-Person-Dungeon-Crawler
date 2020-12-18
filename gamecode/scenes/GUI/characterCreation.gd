extends Control

#export (Resource) onready var player
var player = preload("res://gamecode/gameObjects/playerClasses/Mage.tres")

func _ready():
#	pass
	var targets = 0
#	player.classSkills["Slash"].use(player, [null])
	player.useSkill("Slash", [targets])
	
	
