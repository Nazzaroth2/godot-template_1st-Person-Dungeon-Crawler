extends Control


func _ready():
	var baseInventoryScene = preload("res://gamecode/scenes/GUI/inventory/inventory.tscn")
	
	for i in range(2):
		var inventory = baseInventoryScene.instance()
		add_child(inventory)
		inventory.set_size(Vector2(200,200))
		inventory.set_position(Vector2(200*i,100))
	
	
	
	