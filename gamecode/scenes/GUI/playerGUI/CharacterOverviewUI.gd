extends ColorRect

onready var statsNode = $"HBoxContainer/VBoxContainer/stats"
onready var attributesNode = $"HBoxContainer/VBoxContainer/attributes"
	
# update stat-label when its stats-value changed
func _on_stat_changed(stat, player):
	match stat:
		"hp":
			statsNode.get_node("hp").text = "HP: " + str(player.hp) + "/" + str(player.hp_max)
		"mp":
			statsNode.get_node("mp").text = "MP: " + str(player.mp) + "/" + str(player.mp_max)
		"stamina":
			statsNode.get_node("stamina").text = "Stamina: " + str(player.stamina) + "/" + str(player.stamina_max)
		"str":
			attributesNode.get_node("strength").text = "STR: " + str(player.strength)
		"dex":
			attributesNode.get_node("dexterity").text = "DEX: " + str(player.dexterity)
		"int":
			attributesNode.get_node("intelligence").text = "INT: " + str(player.intelligence)
		"luck":
			attributesNode.get_node("luck").text = "LUCK: " + str(player.luck)
			


func _setupCharacterUI(player):
	$"HBoxContainer/TextureRect".texture = player.icon
	
	statsNode.get_node("hp").text = "HP: " + str(player.hp) + "/" + str(player.hp_max)
	statsNode.get_node("mp").text = "MP: " + str(player.mp) + "/" + str(player.mp_max)
	statsNode.get_node("stamina").text = "Stamina: " + str(player.stamina) + "/" + str(player.stamina_max)
	
	attributesNode.get_node("strength").text = "STR: " + str(player.strength)
	attributesNode.get_node("dexterity").text = "DEX: " + str(player.dexterity)
	attributesNode.get_node("intelligence").text = "INT: " + str(player.intelligence)
	attributesNode.get_node("luck").text = "LUCK: " + str(player.luck)
	
