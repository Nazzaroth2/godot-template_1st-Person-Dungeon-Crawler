extends Spatial

func _ready():
	pass








# dungeon events like loot and shop will get triggered here
func _on_playerArea_area_entered(area):
	if area.eventType == "shop":
		# here will go stuff that deals with shop event
		# (instance gui, load items from area.parent etc.)
		pass
		
	if area.eventType == "loot":
		print("you found some awesome loot")
