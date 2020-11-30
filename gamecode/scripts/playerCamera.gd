extends Camera

#This Script deals with the movement of the player camera. Events will trigger
#when they collide with this node. You can adjust movement Behaviour with 
#the exported variables, also keep the level-grid size the same as this gridSize
#variable.
#If you dont want to use random Encounters and rather use real Enemies that move
#on the map, one possible adjustment ist this:
#Dont reset the movement_flag after a movement, rather emit a signal that player
#has moved. Then let the pc handle all enemy movement and emit a signal again.
#On this signal we set movement_flag back to "stop" and can move the player again.


export var gridSize: int = 2
export var movementSpeed: int = 2
export var rotationSpeed: float = 10

var movement_flag: String = "stop"
var movementStep: float = 0
var target_rotation = Vector3()
var directionDict: Dictionary = {
	"N":[Vector3(0,0,-1)],
	"S":[Vector3(0,0,1)],
	"E":[Vector3(1,0,0)],
	"W":[Vector3(-1,0,0)]
}
onready var collissionDict: Dictionary = {
	"N":$NRay,"S":$SRay,"E":$ERay,"W":$WRay
}


func _process(delta):
	#setting the direction flag if no prior movement is running
	if movement_flag == "stop":
		if Input.is_action_pressed("N") and !collissionDict["N"].is_colliding():
			movement_flag = "N"
		if Input.is_action_pressed("S") and !collissionDict["S"].is_colliding():
			movement_flag = "S"
		if Input.is_action_pressed("E") and !collissionDict["E"].is_colliding():
			movement_flag = "E"
		if Input.is_action_pressed("W") and !collissionDict["W"].is_colliding():
			movement_flag = "W"
		if Input.is_action_pressed("rotateLeft"):
			movement_flag = "rotate"
			target_rotation = rotation_degrees + Vector3(0,90,0)
			target_rotation.round()
		if Input.is_action_pressed("rotateRight"):
			movement_flag = "rotate"
			target_rotation = rotation_degrees + Vector3(0,-90,0)
			target_rotation.round()
		
	#running movement function every frame until flag is reset
	if movement_flag in ["N","S","E","W"]:
		move_player(delta, movement_flag)
	elif movement_flag == "rotate":
		rotate_player(delta)
		



func move_player(delta, moveDir):
	#moving camera one microstep towards direction
	translate_object_local(directionDict[moveDir][0]*delta*movementSpeed)
	#keeping track of step progress
	movementStep += delta*movementSpeed
	#one step is same as gridSize. When we finished one full Step we
	#stop the step and reset the flags plus rounding towards closest grid-position
	#we then either immediatly start next step in the same direction(if button pressed)
	#or we can do any other movement action
	if movementStep >= gridSize:
		#fix small offset from goal by rounding towards step goal
		global_transform.origin = Vector3(round(global_transform.origin.x),
				round(global_transform.origin.y),round(global_transform.origin.z))
		movement_flag = "stop"
		movementStep = 0



func rotate_player(delta):
	#rotation towards target_rotation-direction with lerp function for smooth rotation
	rotation_degrees = Vector3(0, 
			lerp(rotation_degrees.y, target_rotation.y, rotationSpeed * delta),0)
	
	#when we reach the target close enough we stop rotation and set the rotation
	#cleanly ourselfs
	if rotation_degrees.round() == target_rotation.round():
		movement_flag = "stop"
		rotation_degrees = Vector3(round(rotation_degrees.x),
				round(rotation_degrees.y),round(rotation_degrees.z))
