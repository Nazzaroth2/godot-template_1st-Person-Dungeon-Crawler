extends VBoxContainer

onready var actionsContainer = $"../actions"
onready var enemies = $"../../characters/enemies"
onready var fightManager = $"../../../fightManager"

func _ready():
	# connect signals from menuChoice-Buttons
	for choice in self.get_children():
		choice.connect("pressed",self,"_on_choiceButton_pressed")
		choice.connect("focus_entered", self,
		 "_on_menuChoice_focus_entered",[choice.name])
		

# sets focus on the first skill/item in the actions-container
func _on_choiceButton_pressed():
	actionsContainer.get_child(0).grab_focus()


func _on_menuChoice_focus_entered(menuChoice):
	# remove any old existing Buttons
	_clearActionContainer()
	
	# add new action-buttons depending on the menuChoice that is focused
	if menuChoice == "attackSkills":
		for skill in fightManager.choosenPlayer.classSkills.values():
			var newButton = Button.new()
			newButton.text = skill.name
			newButton.size_flags_horizontal = Button.SIZE_EXPAND_FILL
			newButton.connect("pressed", fightManager, "_on_actionButton_pressed",[skill])
			actionsContainer.add_child(newButton)
	if menuChoice == "items":
		for item in fightManager.referencedPlayerGroup.inventory.items:
			if item is Consumable:
				var newButton = Button.new()
				newButton.text = item.name
				newButton.size_flags_horizontal = Button.SIZE_EXPAND_FILL
				newButton.connect("pressed", fightManager, "_on_actionButton_pressed",[item])
				actionsContainer.add_child(newButton)
				



			
func _clearActionContainer():
	for node in actionsContainer.get_children():
		node.queue_free()
