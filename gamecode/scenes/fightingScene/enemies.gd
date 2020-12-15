extends VBoxContainer

#var activeEnemy = 0 setget set_activeEnemy
onready var fightManager = $"../../.."

#func _ready():
#	fightManager.connect("actionDone",self,"_on_action_done")
#
#func set_activeEnemy(new_activeEnemy):
#	resetActiveCharacter(self.activeEnemy)
#	activeEnemy = new_activeEnemy
#	self.get_child(self.activeEnemy).text = "active"
#
#func get_activeEnemy():
#	return activeEnemy
#
#func resetActiveCharacter(childIdx):
#	self.get_child(childIdx).text = self.get_child(childIdx).name
#
#func _on_action_done():
#	resetActiveCharacter(self.activeEnemy)
