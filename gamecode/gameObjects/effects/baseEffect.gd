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

func updateLifetime(user):
	if lifetime == 0:
		destroy(user)
	else:
		lifetime -= 1
