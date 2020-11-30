extends Spatial

func _ready():
	pass








# dungeon events like loot and shop will get triggered here
func _on_playerArea_area_entered(area):
	# basic setup for a shop event
	if area.eventType == "shop":
		# here will go stuff that deals with shop event
		# (instance gui, load items from area.parent etc.)
		yield($playerCamera, "movement_finished")
		pass
	
	# basic setup for a loot event	
	if area.eventType == "loot":
		yield($playerCamera, "movement_finished")
		print("you found some awesome loot")
		
	# basic setup for a custom enemy event	
	if area.eventType == "enemy":
		yield($playerCamera, "movement_finished")
		pass


func _on_playerCamera_movement_finished():
	# here we would randomly choose if a enemy encounter
	# is started and transition to the fight scene. plus save
	# position of player in dungeon for later.
	# but i will also need to check if no other event would
	# happen, so we dont trigger fights when entering shops
	pass # Replace with function body.
