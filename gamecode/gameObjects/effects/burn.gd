extends BaseEffect
class_name Burn

export (int) var effectStrength

func apply(target):
	target.hp -= effectStrength
	return effectStrength
