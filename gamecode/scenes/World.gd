extends Node

var fightSceneReference = preload("res://gamecode/scenes/fightingScene/fightScene.tscn")
onready var dungeonScene = $dungeon


# this idea more or less works but somehow the focus
# in the fightingScene bugges out even though the neighbours
# are given correctly in the inspector.
func _unhandled_input(event):
	if event.is_action_pressed("test_scene_toggle"):
		if get_node("dungeon"):
			self.remove_child(dungeonScene)
			var fightScene = fightSceneReference.instance()
			self.add_child(fightScene)
		else:
			self.get_node("fightScene").queue_free()
			self.add_child(dungeonScene)
