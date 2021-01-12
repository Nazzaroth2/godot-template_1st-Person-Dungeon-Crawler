extends PopupMenu


var choosen_item
var choosen_item_index

func _enter_tree():
	var playerGroupNode = get_tree().get_root().get_node("world/playerGroup")
	
	for player in playerGroupNode.playerGroup:
		self.add_icon_item(player.icon,player.name)
	self.connect("id_pressed",self,"_on_item_pressed")
	self.connect("popup_hide",self,"_on_popup_hide")	

func _on_popup_hide():
	self.queue_free()

func _on_item_pressed(ID):
	var playerGroupNode = get_tree().get_root().get_node("world/playerGroup")
	
	choosen_item.use(playerGroupNode.playerGroup[ID],null)
	playerGroupNode.inventory.emit_signal("items_changed",[choosen_item_index])
	if choosen_item.current_stacks <= 0:
		playerGroupNode.inventory.items[choosen_item_index] = null
	self.queue_free()
	













