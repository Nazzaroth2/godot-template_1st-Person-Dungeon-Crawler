extends BaseGameObject
class_name BaseEffect

export (int) var lifetime
export (bool) var preTurn

# overwrite this function in inherited classes to implement effect logic
func apply(target):
	pass

# easiest way seems to just give the user and then delete entry in activeEffects
# array of that user
func destroy(user):
	var idx = user.activeEffects.find(self)
	user.activeEffects.remove(idx)
	removeIcon(user, idx)

# removes the effect texture from gui
func removeIcon(user, idx):
	var effectBar = user.guiNode.get_node("activeEffects")
	
	effectBar.get_child(idx).queue_free()

# addes effect texture to gui
func addIcon(user):
	var effectBar = user.guiNode.get_node("activeEffects")
	
	var newIcon = TextureRect.new()
	newIcon.texture = self.icon
	
	effectBar.add_child(newIcon)
	

func updateLifetime(user):
	lifetime -= 1
	
	if lifetime == 0:
		destroy(user)
	
