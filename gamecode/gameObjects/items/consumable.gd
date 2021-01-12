extends BaseItem
class_name Consumable

export (bool) var needs_targets = true

# every use of a consumable will reduce the amount by 1
# item-logic is in specific classes
# overwrite/call this function in inherited classes to implement item logic
func use(user, targets):
	current_stacks -= 1
	
	# TODO: implement itemEffects applying here
