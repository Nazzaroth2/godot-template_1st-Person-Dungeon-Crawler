extends BaseGameObject
class_name BaseItem

export (int) var price_buy
export (int) var price_sell
export (int) var max_stacks
export (int) var current_stacks
export (Array, Resource) var itemEffects



# overwrite/call this function in inherited classes to implement item logic
func use(user, targets: Array):
	current_stacks -= 1
	
	# TODO: implement itemEffects applying here



