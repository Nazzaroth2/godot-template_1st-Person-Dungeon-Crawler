extends Spatial

var in_Event: bool = false

signal lootEvent
signal shopEvent

# dungeon events like loot and shop will get triggered from this
# signal
func _on_playerArea_area_entered(area):
	in_Event = true
	# basic setup for a shop event
	if area.get_parent().inventory.type == "SHOP":
		yield($playerCamera, "movement_finished")
		emit_signal("shopEvent", area.get_parent().inventory)
	
	# basic setup for a loot event	
	if area.get_parent().inventory.type == "CHEST":
		yield($playerCamera, "movement_finished")
		emit_signal("lootEvent",area.get_parent().inventory)
		print("you found some awesome loot")
		
	# basic setup for a custom enemy event	
#	if area.eventType == "enemy":
#		yield($playerCamera, "movement_finished")
#		pass
	
	in_Event = false


	
