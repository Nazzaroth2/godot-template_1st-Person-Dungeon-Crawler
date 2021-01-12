extends TextureRect

var characterResource
onready var fightManagerNode = get_tree().get_root().get_node("world/fightScene/fightManager")

signal player_choosen
signal enemy_choosen
signal valueAnimationDone

func _ready():
	self.connect("focus_entered",self,"_on_focus_entered")
	self.connect("focus_exited",self,"_on_focus_exited")
	fightManagerNode.connect("dealtDamage",self,"_on_dealtDamage")
	fightManagerNode.connect("healed",self,"_on_healed")

func _on_dealtDamage(targetsName, user, activeSkillName, damage):
	# if this characterSprite is the user it playes the corresponding
	# attackAnimation
	if characterResource == user:
		pass
		# TODO: deal with attackAnimations, they need to
		# play inPlace!
#		$AnimationPlayer.play(activeSkillName)
		# placeholder demo Animation for testing
#		$AnimationPlayer.play("demoAttack02")
	else:
		# check if you are a target and then play the damaged Animation
		if targetsName == null:
			$damage.text = str(damage)
			$damage.visible = true
			$AnimationPlayer.play("damageLabel")
			yield($AnimationPlayer,"animation_finished")
			$damage.visible = false
		elif targetsName == self.name:
			$damage.text = str(damage)
			$damage.visible = true
			$AnimationPlayer.play("damageLabel")
			yield($AnimationPlayer,"animation_finished")
			$damage.visible = false	
				
		emit_signal("valueAnimationDone")

func _on_healed(healedCharacterName, healValue):
	if healedCharacterName == self.name:
		$damage.text = str(healValue)
		$damage.set("custom_colors/font_color",Color(Color.green))
		$damage.visible = true
		$AnimationPlayer.play("damageLabel")
		yield($AnimationPlayer,"animation_finished")
		$damage.visible = false	
			
	emit_signal("valueAnimationDone")
	
	
func _on_focus_entered():
	_set_focus_neighbours()
	$name.set("custom_colors/font_color",Color(Color.gold))
	
func _on_focus_exited():
	pass
	$name.set("custom_colors/font_color",Color(Color.white))
	

func _set_focus_neighbours():
	var siblings = get_parent().get_children()
	var ownIdx = siblings.find(self)
	
	var leftNeighbour = _findLeftNeighbour(siblings, ownIdx)
	var rightNeighbour = _findRightNeighbour(siblings, ownIdx)
	
	self.focus_next = rightNeighbour.get_path()
	self.focus_previous = leftNeighbour.get_path()
	
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
	if not(fightManagerNode.is_player_attacking):
		if get_focus_owner() == self:
			if event.is_action_pressed("ui_accept"):
				if get_parent().name == "players":
					emit_signal("player_choosen",self.characterResource)
				elif get_parent().name == "enemies":
					emit_signal("enemy_choosen",self.characterResource, self.name)
					fightManagerNode.is_player_attacking = true
