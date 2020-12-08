extends Consumable

export (int) var healingValue

func use(targets: Array):
	.use(targets)
	
	if targets != null:
		targets[0].hp += healingValue
	
