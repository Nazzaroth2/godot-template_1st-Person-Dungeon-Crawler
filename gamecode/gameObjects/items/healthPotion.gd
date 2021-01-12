extends Consumable
class_name healthPotion

export (int) var healingValue

func use(user, targets):
	.use(user, targets)
	
	user.hp += healingValue
	
	return healingValue
