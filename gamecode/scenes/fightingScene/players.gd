extends VBoxContainer

var activePlayer = 0 setget set_activePlayer
var oldActivePlayer
# right now this hack is needed to only loop over usablePlayers.
onready var fightManager = $"../../.."


func _ready():
	self.get_child(0).text = "active"
	fightManager.connect("actionDone",self,"_on_action_done")

func set_activePlayer(new_activePlayer):
	oldActivePlayer = activePlayer
	resetActiveCharacter(fightManager.usablePlayers[activePlayer])
	activePlayer = new_activePlayer
	self.get_child(fightManager.usablePlayers[activePlayer]).text = "active"
	
func get_activePlayer():
	return activePlayer
	
func resetActiveCharacter(childIdx):
	self.get_child(childIdx).text = self.get_child(childIdx).name

func _on_action_done():
	
	resetActiveCharacter(oldActivePlayer)
