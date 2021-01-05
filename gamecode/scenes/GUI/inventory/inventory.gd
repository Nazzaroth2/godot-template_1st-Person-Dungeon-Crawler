extends ColorRect

export (Resource) var inventory


func _ready():
	# sets inventory-minSize to Content-Size, so later Window-Nodes will resize
	# properly
	self.rect_min_size = $CenterContainer/InventoryContent.rect_size + Vector2(5,5)
