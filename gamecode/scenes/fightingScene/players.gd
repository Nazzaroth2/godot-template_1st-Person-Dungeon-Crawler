extends VBoxContainer

var activePlayer = 0 setget set_activePlayer

func set_activePlayer(new_activePlayer):
	self.get_child(self.activePlayer).text = self.get_child(self.activePlayer).name
	activePlayer = new_activePlayer
	self.get_child(self.activePlayer).text = "active"
	
func get_activePlayer():
	return activePlayer
