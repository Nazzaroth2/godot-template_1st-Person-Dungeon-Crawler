extends Consumable

export (int) var healingValue

func use(user, targets: Array):
	.use(user, targets)
	
	if targets != null:
		targets[0].hp += healingValue
	