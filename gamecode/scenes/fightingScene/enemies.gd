extends VBoxContainer

var activeEnemy = 0 setget set_activeEnemy

func set_activeEnemy(new_activeEnemy):
	self.get_child(self.activeEnemy).text = self.get_child(self.activeEnemy).name
	activeEnemy = new_activeEnemy
	self.get_child(self.activeEnemy).text = "active"
	
func get_activeEnemy():
	return activeEnemy
