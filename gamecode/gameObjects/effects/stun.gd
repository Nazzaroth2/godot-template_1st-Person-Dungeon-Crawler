extends BaseEffect
class_name Stun

func apply(target):
	#implement the effect logic, in this case that target skips a round
	target.is_usable = false
	
	
	# if an effect does not damage/heal we show
	# that by returning null
	return null
