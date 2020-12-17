extends ColorRect

onready var fightManager = $"../../../../fightManager"
var characterResource

signal player_choosen

func _ready():
	self.connect("focus_entered",self,"_on_focus_entered")
	self.connect("focus_exited",self,"_on_focus_exited")

	
func _on_focus_entered():
#	_set_focus_neighbours(fightManager.usablePlayers)
	self.color = Color(Color.blue)
	
func _on_focus_exited():
	self.color = Color(Color.red)
	

	
func _set_focus_neighbours(usablePlayers):
	var siblings = get_parent().get_children()
	var thisPlayerIdx = usablePlayers.find(self.name)
	var neighbourIdx = _calculateNeighbours(thisPlayerIdx)
	
	# setting up focus-neighbours structure depending on what
	# usablePlayers still exist
	for sibling in siblings:
		if sibling.name == usablePlayers[neighbourIdx[0]]:
			self.focus_neighbour_bottom = sibling.get_path()
			self.focus_neighbour_right = sibling.get_path()
		if sibling.name == usablePlayers[neighbourIdx[1]]:
			self.focus_neighbour_top = sibling.get_path()
			self.focus_neighbour_left = sibling.get_path()
		
	
func _calculateNeighbours(thisPlayerIdx):
	var rightNeighbour = thisPlayerIdx + 1
	var leftNeighbour = thisPlayerIdx - 1
	# if rightNeighbour is outside players we wrap back to first player
	# to get correct indexes we have to remove 1 from len of array
	if rightNeighbour > len(fightManager.usablePlayers) - 1:
		rightNeighbour = 0
	# conversly we wrap to last player if leftNeighbour is negative
	elif leftNeighbour < 0:
		leftNeighbour = len(fightManager.usablePlayers) - 1
		
	return [rightNeighbour, leftNeighbour]


func _unhandled_input(event):
	if get_focus_owner() == self:
		if event.is_action_pressed("ui_accept"):
			emit_signal("player_choosen",self.characterResource)
