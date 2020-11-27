extends KinematicBody

# Constants
const GRAVITY = 9.8

# Mouse sensitivity
export(float, 0.1, 1.0) var sensitivity_x = 0.5
export(float, 0.1, 1.0) var sensitivity_y = 0.4

# Physics
export var speed = 15.0
export var jump_height = 25.0
export var mass = 8.0
export var gravity_scl = 1.0

# Instances ref
onready var player_cam = $Camera
onready var ground_ray = $GroundRay

# Variables (public members)
var mouse_motion = Vector2()
var gravity_speed = 0
var mouse_captured = true
var cellsize = 100


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	ground_ray.enabled = true
	pass

#func _unhandled_input(event):
#	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
#		player_cam.rotate_x(-event.relative.y * 0.002)
#		rotate_y(-event.relative.x * 0.002)
#		player_cam.rotation.x = clamp(player_cam.rotation.x, -1.2, 1.2)

func _physics_process(delta):
	var movementFlag = false
	
	# Camera and Body rotation
#	rotate_y(deg2rad(20)* - mouse_motion.x * sensitivity_x * delta)
#	player_cam.rotate_x(deg2rad(20)* - mouse_motion.y * sensitivity_y * delta)
#	player_cam.rotation.x = clamp(player_cam.rotation.x, deg2rad(-47), deg2rad(47))
#	mouse_motion = Vector2()
	
	# Gravity
	gravity_speed -= GRAVITY * gravity_scl * mass * delta
	
	# Character movement
	var velocity = Vector3()
	velocity = _axis() * speed
	if Input.is_key_pressed(KEY_SHIFT):
		velocity.x *= 1.5
		velocity.z *= 1.5
	#always set vertical movement 0, cause no jumping allowed!
	velocity.y = 0
	
	if not movementFlag:
		movementFlag = movement(velocity, ground_ray)
		
	
#	gravity_speed = move_and_slide(velocity, ground_ray.get_collision_normal(), true).y
	
func movement(velocity,ground_ray):
	#move the player for time length so he ends up always at the center of
	#next cell
	var time = cellsize/speed
	for i in range(time):
		move_and_slide(velocity, ground_ray.get_collision_normal(), true)
		
	return true
	
	

func _input(event):
	if event is InputEventMouseMotion:
		mouse_motion = event.relative
	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		player_cam.rotate_x(-event.relative.y * 0.002)
		rotate_y(-event.relative.x * 0.002)
		player_cam.rotation.x = clamp(player_cam.rotation.x, -1.2, 1.2)
	
	# Scene reset
	if Input.is_action_just_pressed("aSceneReset"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Tgl_Mouse_Capture"):  # Toggle mouse captured
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			mouse_captured = false
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			mouse_captured = true
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and !mouse_captured:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		mouse_captured = true
	
		

func _axis():
	var direction = Vector3()
	
#	if Input.is_key_pressed(KEY_W):
	if Input.is_action_pressed("forward"):  # Needs to be setted on Project Settings -> InputMap
		direction -= get_global_transform().basis.z.normalized()
	
#	if Input.is_key_pressed(KEY_S):
	if Input.is_action_pressed("backward"):  # Needs to be setted on Project Settings -> InputMap
		direction += get_global_transform().basis.z.normalized()
	
#	if Input.is_key_pressed(KEY_A):
	if Input.is_action_pressed("left"):  # Needs to be setted on Project Settings -> InputMap
		direction -= get_global_transform().basis.x.normalized()
	
#	if Input.is_key_pressed(KEY_D):
	if Input.is_action_pressed("right"):  # Needs to be setted on Project Settings -> InputMap
		direction += get_global_transform().basis.x.normalized()
	
	return direction.normalized()
