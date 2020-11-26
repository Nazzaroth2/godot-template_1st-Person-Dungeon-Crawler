extends Camera

var N_flag: bool = false

var is_moving: String = "stop"
var movementStep: float = 0
var gridSize: int = 1
var movementSpeed: int = 1



#func _unhandled_input(event):
#	if event.is_action_pressed("N"):
#		move_forward()
#	if event.is_action_released("N"):
#		N_flag = false
		
func _process(delta):
	if Input.is_action_pressed("N"):
		N_flag = true
		
		
	if N_flag:
		move_forward(delta)
		




func move_forward(delta):
	
	#simulating counting the forward movement
	movementStep += movementSpeed * delta
	#when reached the goal for one step we stop the movement
	#and set the flag to false plus resetting the movementStep
	#if we keep pushing down the action button we will immediatly set the flag to
	#true again and keep moving another step
	if movementStep >= gridSize:
		print("we walked forward once")
		N_flag = false
		movementStep = 0
	
	
	
	
	
	
	
	
#	if is_moving == "stop":
#		#when we were stopped we start initilizing one movement step
#		is_moving == "moving"
#		movementStep = 0
#
#
#		pass
#	#if we are already moving we do not do anything on actionpresses
#	else:
#		pass


