extends Spatial

var in_Event: bool = false

func _ready():
	pass








# dungeon events like loot and shop will get triggered from this
# signal
func _on_playerArea_area_entered(area):
	in_Event = true
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
	
	in_Event = false

# if no event gets triggered on next cell we randomly
# spawn an enemy encounter
func _on_playerCamera_movement_finished():
	# before transition to the fight scene we need to save
	# level-scene and player position for later
	if !in_Event:
		print("we could go into a fight now")
	else:
		print("fighting would be impossible now")
	
