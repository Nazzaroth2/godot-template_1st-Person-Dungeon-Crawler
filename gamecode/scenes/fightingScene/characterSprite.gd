extends ColorRect

var characterResource

signal player_choosen
signal enemy_choosen

func _ready():
	self.connect("focus_entered",self,"_on_focus_entered")
	self.connect("focus_exited",self,"_on_focus_exited")

	
func _on_focus_entered():
	_set_focus_neighbours()
	self.color = Color(Color.blue)
	
func _on_focus_exited():
	self.color = Color(Color.red)
	

func _set_focus_neighbours():
	var siblings = get_parent().get_children()
	var ownIdx = siblings.find(self)
	
	var leftNeighbour = _findLeftNeighbour(siblings, ownIdx)
	var rightNeighbour = _findRightNeighbour(siblings, ownIdx)
	
	self.focus_neighbour_bottom = rightNeighbour.get_path()
	self.focus_neighbour_right = rightNeighbour.get_path()
	
	self.focus_neighbour_top = leftNeighbour.get_path()
	self.focus_neighbour_left = leftNeighbour.get_path()
	
	
	
func _findLeftNeighbour(siblings, ownIdx):
	var leftNeighbour = null
	var searchIdx = _setSearchIdxLeft(siblings, ownIdx)
		
	while leftNeighbour == null:
		if siblings[searchIdx].characterResource.is_usable:
			leftNeighbour = siblings[searchIdx]
		else:
			searchIdx = _setSearchIdxLeft(siblings, searchIdx)
			
	return leftNeighbour
			

# iterates the idx over siblingsArray, while also wrapping around to last entry
# when we reach the beginning of array
func _setSearchIdxLeft(siblings, searchIdx):
	if searchIdx - 1 < 0:
		searchIdx = len(siblings) - 1
	else:
		searchIdx = searchIdx - 1
	
	return searchIdx
		

func _findRightNeighbour(siblings, ownIdx):
	var rightNeighbour = null
	var searchIdx = _setSearchIdxRight(siblings, ownIdx)
		
	while rightNeighbour == null:
		if siblings[searchIdx].characterResource.is_usable:
			rightNeighbour = siblings[searchIdx]
		else:
			searchIdx = _setSearchIdxRight(siblings, searchIdx)
			
	return rightNeighbour
	
# iterates the idx over siblingsArray, while also wrapping around to last entry
# when we reach the beginning of array
func _setSearchIdxRight(siblings, searchIdx):
	if searchIdx + 1 > len(siblings) - 1:
		searchIdx = 0
	else:
		searchIdx = searchIdx + 1
		
	return searchIdx
		
	

func _unhandled_input(event):
	if get_focus_owner() == self:
		if event.is_action_pressed("ui_accept"):
			if get_parent().name == "players":
				emit_signal("player_choosen",self.characterResource)
			elif get_parent().name == "enemies":
				emit_signal("enemy_choosen",self.characterResource)
