extends BaseGameObject
class_name BaseEffect

export (int) var lifetime

# overwrite this function in inherited classes to implement effect logic
func activate(targets):
	pass

func destroy():
	pass

func updateLifetime(lifetime):
	if lifetime == 0:
		destroy()
	else:
		lifetime -= 1
