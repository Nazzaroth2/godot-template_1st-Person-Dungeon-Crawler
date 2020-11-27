extends Camera

var movement_flag: String = "stop"

var is_moving: String = "stop"
var movementStep: float = 0
var gridSize: int = 2
var movementSpeed: int = 2
export var rotationSpeed: float = 10
var rotationLimit: float = 100/rotationSpeed
var rotationStep: float = 1.570796 / rotationLimit
var rotationState: float = 0
var elapsed: float = 0.0
var target_rotation = Vector3()


var directionDict: Dictionary = {
	"N":[Vector3(0,0,-1)],
	"S":[Vector3(0,0,1)],
	"E":[Vector3(1,0,0)],
	"W":[Vector3(-1,0,0)]
}



#func _unhandled_input(event):
#	if event.is_action_pressed("N"):
#		move_forward()
#	if event.is_action_released("N"):
#		N_flag = false
		
func _process(delta):
	#setting the direction flag if no prior movement is running
	if movement_flag == "stop":
		if Input.is_action_pressed("N"):
			movement_flag = "N"
		if Input.is_action_pressed("S"):
			movement_flag = "S"
		if Input.is_action_pressed("E"):
			movement_flag = "E"
		if Input.is_action_pressed("W"):
			movement_flag = "W"
		if Input.is_action_pressed("rotateLeft"):
			movement_flag = "rotateLeft"
			target_rotation = rotation_degrees + Vector3(0,90,0)
			target_rotation.round()
		if Input.is_action_pressed("rotateRight"):
			movement_flag = "rotateRight"
			target_rotation = rotation_degrees + Vector3(0,-90,0)
			target_rotation.round()
		
		
	if movement_flag in ["N","S","E","W"]:
		move(delta, movement_flag)
	elif movement_flag != "stop":
		rotate(delta, movement_flag)
		




func move(delta, moveDir):
	#moving camera one microstep towards direction
	translate_object_local(directionDict[moveDir][0]*delta*movementSpeed)
	#keeping track of step progress
	movementStep += delta*movementSpeed
	#one step is same as gridSize. When we finished one full Step we
	#stop the step and reset the flags plus rounding towards closest grid-position
	#we than either immediatly start next step in the same direction(continious walking)
	#or we can do any other movement action
	if movementStep >= gridSize:
		#fix small offset from goal by rounding towards step goal
		global_transform.origin = Vector3(round(global_transform.origin.x),
				round(global_transform.origin.y),round(global_transform.origin.z))
		movement_flag = "stop"
		movementStep = 0
		print(global_transform.origin)
	
func rotate(delta, rotDir):
	if rotDir == "rotateLeft":
		rotation_degrees = Vector3(0, 
				lerp(rotation_degrees.y, target_rotation.y, rotationSpeed * delta),0)
		
#		rotate_y(rotationStep * delta)
#		rotationState += rotationStep * delta
#
#		print(rotationState)
#		print(rotationStep*delta)

		print(rotation_degrees)
		print(target_rotation)
#		print("-----")
#		print(rotation_degrees.round())
#		print(target_rotation.round())
#
		if rotation_degrees.round() == target_rotation.round():
			movement_flag = "stop"
			rotationState = 0
			print("finished")
#			set_rotation_degrees(rotation_degrees.floor())
			set_rotation_degrees(Vector3(floor(rotation_degrees.x),
					round(rotation_degrees.y),round(rotation_degrees.z)))
#			print(rotation_degrees)
	elif rotDir == "rotateRight":
		rotation_degrees = Vector3(0, 
				lerp(rotation_degrees.y, target_rotation.y, rotationSpeed * delta),0)
		
#		rotate_y(rotationStep * delta)
#		rotationState += rotationStep * delta
#
#		print(rotationState)
#		print(rotationStep*delta)

		print(rotation_degrees)
		print(target_rotation)
#		print("-----")
#		print(rotation_degrees.round())
#		print(target_rotation.round())
#
		if rotation_degrees.round() == target_rotation.round():
			movement_flag = "stop"
			rotationState = 0
			print("finished")
#			set_rotation_degrees(rotation_degrees.floor())
			set_rotation_degrees(Vector3(floor(rotation_degrees.x),
					round(rotation_degrees.y),round(rotation_degrees.z)))
#			print(rotation_degrees)

