extends BaseEffect
class_name Stun

func apply(targets = null):
	#implement the effect logic, in this case that target skips a round
	
	# if an effect does not damage/heal we show
	# that by returning null
	return null
