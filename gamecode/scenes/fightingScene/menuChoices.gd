extends VBoxContainer

onready var actionsContainer = $"../actions"
onready var enemies = $"../../characters/enemies"
onready var fightManager = $"../../../fightManager"

func _ready():
	# connect skills-button signals
	$skills.connect("pressed",self,"_on_choiceButton_pressed")
	$skills.connect("focus_entered", self,
		 "_on_menuChoice_focus_entered",["skills"])
	# connect items-button signals
	$items.connect("pressed",self,"_on_choiceButton_pressed")
	$items.connect("focus_entered", self,
		 "_on_menuChoice_focus_entered",["items"])
	# connect items-button signals
	$attack.connect("pressed", fightManager, "_on_attackButton_pressed")
	$attack.connect("focus_entered", self,"_clearActionContainer")
	


# sets focus on the first skill/item in the actions-container
func _on_choiceButton_pressed():
	actionsContainer.get_child(0).grab_focus()


func _on_menuChoice_focus_entered(menuChoice):
	# remove any old existing Buttons
	_clearActionContainer()
	
	# add new action-buttons depending on the menuChoice that is focused
	if menuChoice == "skills":
		for skill in fightManager.choosenPlayer.classSkills.values():
			if not(skill.name == "Basic Attack"):
				var newButton = Button.new()
				newButton.text = skill.name
				newButton.size_flags_horizontal = Button.SIZE_EXPAND_FILL
				newButton.connect("pressed", fightManager, "_on_skillButton_pressed",[skill])
				newButton.connect("pressed", self, "_on_actionButton_pressed")
				actionsContainer.add_child(newButton)
	if menuChoice == "items":
		var itemIdx = 0
		for item in fightManager.referencedPlayerGroup.inventory.items:
			if item is Consumable:
				var newButton = Button.new()
				newButton.text = item.name
				newButton.size_flags_horizontal = Button.SIZE_EXPAND_FILL
				newButton.connect("pressed", fightManager, "_on_itemButton_pressed",[item, itemIdx])
				newButton.connect("pressed", self, "_on_actionButton_pressed")
				actionsContainer.add_child(newButton)
			itemIdx += 1	

func _on_actionButton_pressed():
	_clearActionContainer()

			
func _clearActionContainer():
	for node in actionsContainer.get_children():
		node.queue_free()
