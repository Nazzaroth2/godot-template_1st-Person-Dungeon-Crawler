extends BaseGameObject
class_name BaseItem

export (int) var price_buy
export (int) var price_sell
export (int) var max_stacks
export (int) var current_stacks
export (Array, Resource) var itemEffects


# implement logic to move items from one Inventory to another and
# also update gold-values depending on prices and modifiers
func buyItem(activeInv, passivInv):
	pass

# implement logic to move items from one Inventory to another and
# also update gold-values depending on prices and modifiers	
func sellItem(activeInv, passivInv):
	pass

# implement logic to move Item without calculating costs
# used for treasureChests and Quest-Rewards
func moveItem(activeInv, passivInv):
	pass

# overwrite/call this function in inherited classes to implement item logic
func use(user, targets: Array):
	current_stacks -= 1
	
	# TODO: implement itemEffects applying here

# implement logic to destroy/unlink itemResource when stacks are 0
func destroy():
	pass
