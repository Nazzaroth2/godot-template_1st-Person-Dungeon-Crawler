extends KinematicBody

#interpolation Variable
#t is needed for rotation
var t = 0.0
var moveSpeed = 4
#gridcell Size
var cellsize = 2
#needed to disallow actions while interpolation
var movingFlag = false
#needed to update movepoints in right orientation
var rotationCounter = 0

var forwardPoint = {"name" : 		"forward",
					"origin":		self.transform.origin,
					"moveVec":		Vector3(0,0,-moveSpeed),
					"flag":			false}
var backwardPoint = {"name" : 		"backward",
					"origin":		self.transform.origin,
					"moveVec":		Vector3(0,0,moveSpeed),
					"flag":			false}
var leftPoint = {	"name" : 		"left",
					"origin":		self.transform.origin,
					"moveVec":		Vector3(-moveSpeed,0,0),
					"flag":			false}
var rightPoint = {	"name" : 		"right",
					"origin":		self.transform.origin,
					"moveVec":		Vector3(moveSpeed,0,0),
					"flag":			false}
var leftTurnPoint = {"name" : 		"leftTurn",
					"transform":	self.transform,
					"flag":			false}
var rightTurnPoint = {"name" : 		"rightTurn",
					"transform":	self.transform,
					"flag":			false}



func _ready():
	_pointIni()

func _physics_process(delta):
	
	
	#cant allow movement while interpolations till happening
	#thus this extra movingFlag check
	if not movingFlag:
		#setting corresponding actionflags
		_actionCheck()
		
	if forwardPoint.flag:
		_move(forwardPoint)
	if backwardPoint.flag:
		_move(backwardPoint)
	if leftPoint.flag:
		_move(leftPoint)
	if rightPoint.flag:
		_move(rightPoint)
	if leftTurnPoint.flag:
		_rotateChar(leftTurnPoint, delta)
	if rightTurnPoint.flag:
		_rotateChar(rightTurnPoint, delta)
	

#Public methods (not used yet and dont quite work right from outside yet,
#not sure if needed for now if i go with random monster encounters)
#func moveForward(delta):
#	self._interpolateToPoint(self.forwardPoint, delta)
#func moveBackward(delta):
#	self._interpolateToPoint(self.backwardPoint, delta)
#func moveLeft(delta):
#	self._interpolateToPoint(self.leftPoint, delta)
#func moveRight(delta):
#	self._interpolateToPoint(self.rightPoint, delta)
#func turnLeft(delta):
#	self._interpolateToPoint(self.leftTurnPoint, delta)
#func turnRight(delta):
#	self._interpolateToPoint(self.rightTurnPoint, delta)


#Functions that should not be touched!
#moving char to the point given
func _move(point):
	self.move_and_slide(point.moveVec)
	
	if _vector3IsEqual(self.transform.origin, point.origin):
		point.flag = false
		self.movingFlag = false
		_updateMovePointOrigins()

#rotates char around y axis
func _rotateChar(point, delta):
	if point.name == 'leftTurn':
		t += delta

		self.transform = self.transform.interpolate_with(point.transform,t * moveSpeed)

		if _ownIsEqual(self.transform.basis, point.transform.basis):
			_updateRotation('left')
			_updateMovePointOrigins()
			#reset t for interpolation speed
			t = 0
			#change flag last so everything is done and updated
			point.flag = false
			movingFlag = false
	if point.name == 'rightTurn':
		t += delta

		self.transform = self.transform.interpolate_with(point.transform,t * moveSpeed)

		if _ownIsEqual(self.transform.basis, point.transform.basis):
			_updateRotation('right')
			_updateMovePointOrigins()
			#reset t for interpolation speed
			t = 0
			#change flag last so everything is done and updated
			point.flag = false
			movingFlag = false

#check if movement would create collision
func _collisionCheck(point):
	var colVec = (point.moveVec/moveSpeed) * cellsize
	print(colVec)
	if self.move_and_collide(colVec,true,true,true) != null:
		return true

#sets flags for each action when key is pressed
func _actionCheck():
	if Input.is_action_just_pressed("forward"):
		if _collisionCheck(forwardPoint):
			print("i can't walk through walls")
		else:
			forwardPoint.flag = true
			movingFlag = true
	elif Input.is_action_just_pressed("backward"):
		if _collisionCheck(backwardPoint):
			print("i can't walk through walls")
		else:
			backwardPoint.flag = true
			movingFlag = true
	elif Input.is_action_just_pressed("left"):
		if _collisionCheck(leftPoint):
			print("i can't walk through walls")
		else:
			leftPoint.flag = true
			movingFlag = true
	elif Input.is_action_just_pressed("right"):
		if _collisionCheck(rightPoint):
			print("i can't walk through walls")
		else:
			rightPoint.flag = true
			movingFlag = true
	elif Input.is_action_just_pressed("leftTurn"):
		leftTurnPoint.flag = true
		movingFlag = true
	elif Input.is_action_just_pressed("rightTurn"):
		rightTurnPoint.flag = true
		movingFlag = true
	else:
		pass

#update movePoint origins and moveVecs
#also keeping rotation in mind
func _updateMovePointOrigins():
	forwardPoint.origin = self.transform.origin.round()
	backwardPoint.origin = self.transform.origin.round()
	leftPoint.origin = self.transform.origin.round()
	rightPoint.origin = self.transform.origin.round()
	#dont want to tamper with rotation points rotation here
	rightTurnPoint.transform.origin = self.transform.origin
	leftTurnPoint.transform.origin = self.transform.origin
	if rotationCounter == 0:
		#update origin for the stopcheck
		forwardPoint.origin += Vector3(0,0,-cellsize)
		backwardPoint.origin += Vector3(0,0,cellsize)
		leftPoint.origin += Vector3(-cellsize,0,0)
		rightPoint.origin += Vector3(cellsize,0,0)
		#update moveVec for move_and_collide() with variable Speed
		forwardPoint.moveVec = Vector3(0,0,-moveSpeed)
		backwardPoint.moveVec = Vector3(0,0,moveSpeed)
		leftPoint.moveVec = Vector3(-moveSpeed,0,0)
		rightPoint.moveVec = Vector3(moveSpeed,0,0)
	elif rotationCounter == 90:
		#update origin for the stopcheck
		leftPoint.origin += Vector3(0,0,-cellsize)
		rightPoint.origin += Vector3(0,0,cellsize)
		backwardPoint.origin += Vector3(-cellsize,0,0)
		forwardPoint.origin += Vector3(cellsize,0,0)
		#update moveVec for move_and_collide() with variable Speed
		leftPoint.moveVec = Vector3(0,0,-moveSpeed)
		rightPoint.moveVec = Vector3(0,0,moveSpeed)
		backwardPoint.moveVec = Vector3(-moveSpeed,0,0)
		forwardPoint.moveVec = Vector3(moveSpeed,0,0)
	elif rotationCounter == 180:
		backwardPoint.origin += Vector3(0,0,-cellsize)
		forwardPoint.origin += Vector3(0,0,cellsize)
		rightPoint.origin += Vector3(-cellsize,0,0)
		leftPoint.origin += Vector3(cellsize,0,0)
		#update moveVec for move_and_collide() with variable Speed
		backwardPoint.moveVec = Vector3(0,0,-moveSpeed)
		forwardPoint.moveVec = Vector3(0,0,moveSpeed)
		rightPoint.moveVec = Vector3(-moveSpeed,0,0)
		leftPoint.moveVec = Vector3(moveSpeed,0,0)
	else:
		rightPoint.origin += Vector3(0,0,-cellsize)
		leftPoint.origin += Vector3(0,0,cellsize)
		forwardPoint.origin += Vector3(-cellsize,0,0)
		backwardPoint.origin += Vector3(cellsize,0,0)
		#update moveVec for move_and_collide() with variable Speed
		rightPoint.moveVec = Vector3(0,0,-moveSpeed)
		leftPoint.moveVec = Vector3(0,0,moveSpeed)
		forwardPoint.moveVec = Vector3(-moveSpeed,0,0)
		backwardPoint.moveVec = Vector3(moveSpeed,0,0)
	
#updates the rotationCounter State so the move points can be corectly updated
func _updateRotation(direction):
	if direction == 'left':
		leftTurnPoint.transform = leftTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(90))
		#TODO: Find a better way to update the corresponding turnPoint
		#than changing it as globalVar
		rightTurnPoint.transform = rightTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(90))
		leftTurnPoint.transform = leftTurnPoint.transform.orthonormalized()
		self.transform = self.transform.orthonormalized()
		
		#update rotationCounter also
		if rotationCounter == 0:
			rotationCounter = 270
		else:
			rotationCounter -= 90
	elif direction == 'right':
		rightTurnPoint.transform = rightTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(-90))
		#TODO: Find a better way to update the corresponding turnPoint
		#than changing it as globalVar
		leftTurnPoint.transform = leftTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(-90))
		rightTurnPoint.transform = rightTurnPoint.transform.orthonormalized()
		self.transform = self.transform.orthonormalized()
		
		if rotationCounter == 270:
			rotationCounter = 0
		else:
			rotationCounter += 90

#setup for all movementpoints with standard orientation
func _pointIni():
	forwardPoint.origin += Vector3(0,0,-cellsize)
	backwardPoint.origin += Vector3(0,0,cellsize)
	leftPoint.origin += Vector3(-cellsize,0,0)
	rightPoint.origin += Vector3(cellsize,0,0)
	leftTurnPoint.transform = leftTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(90))
	leftTurnPoint.transform = leftTurnPoint.transform.orthonormalized()
	rightTurnPoint.transform = rightTurnPoint.transform.rotated(Vector3(0,1,0), deg2rad(-90))
	rightTurnPoint.transform = rightTurnPoint.transform.orthonormalized()

#compares 2 vector3 for equality
func _vector3IsEqual(v1, v2):	
	for i in range(3):
		if v1[i] < v2[i]:
			if not stepify(v1[i],0.001) >= v2[i]:
				return false
		else:
			if not stepify(v1[i],0.001) <= v2[i]:
				return false
	
	return true

#compares the Basis points of transforms so i can do rotation interpolation
#obsolete for now, using the _vector3IsEqual
func _ownIsEqual(basisA, basisB):
	var is_equal = true
	var tolerance = 0.000001
	for i in range(3):
		for j in range(3):
			is_equal = abs(basisA[i][j] - basisB[i][j]) < tolerance

	return is_equal


























