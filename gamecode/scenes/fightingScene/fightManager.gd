extends Control

onready var referencedPlayerGroup = $"../playerGroup"
onready var playerGroup = referencedPlayerGroup.playerGroup
onready var pandemonium = preload("res://gamecode/gameObjects/enemies/pandemoniumDemo.tres")
var instancedEnemies = []
var enemyAmount = 1

var playerTurn = true
var activePlayer
var activeSkill
var tempPlayer = 0
var usablePlayers = []
var activeTarget
var tempTarget = 0

var rng = RandomNumberGenerator.new()

func _init():
	pass

	
	

func _ready():
	# instanciate Enemies
	rng.randomize()
#	enemyAmount = rng.randi_range(1,2)
	# duplicate to keep instanced enemies unique to a fight
	for i in range(enemyAmount):
		instancedEnemies.append(pandemonium.enemies[i].duplicate())
	
	# initilizeGUI()
	$demoSkill.text = playerGroup[0].classSkills["Fire Ball"].name
	$demoSkill.connect("pressed", self, "_on_Button_pressed",[$demoSkill.text])
	
	## change this variable if you dont automatically want the player to start
	# playerRound = true
	
	
	resetUsablePlayers()
#	for player in referencedPlayerGroup.playerGroup:
#		print(player.name)
#		print(player.classSkills["Fire Ball"].skillValue)

# for every player in group that is alive we put his index into
# usable players
func resetUsablePlayers():
	usablePlayers = []
	for i in range(len(playerGroup)):
		if playerGroup[i].hp > 0:
			usablePlayers.append(i)
		
	
# you REAAAALLY need to refactor this monstrosity
# remember to resetUsablePlayers() after enemyTurn
func _process(delta):
	if playerTurn:
		if not(usablePlayers.empty()):
			#get active Player through gui/playeractions
			if activePlayer == null:
				print(tempPlayer)
				#change tempPlayer number which will become
				#activePlayer when choosen
				if Input.is_action_just_pressed("ui_focus_next"):
					tempPlayer += 1
					#wrap around the playerGroupArray
					if tempPlayer > len(usablePlayers)-1:
						tempPlayer = 0
				if Input.is_action_just_pressed("ui_focus_prev"):
					tempPlayer -= 1
					if tempPlayer < 0:
						tempPlayer = len(usablePlayers)-1
				if Input.is_action_just_pressed("ui_accept"):
					activePlayer = usablePlayers[tempPlayer]


			else:
				if activeSkill == null:
					pass
					# show skillChoice-Menu
				# if aoe-attack just pass all enemies as targets
				elif playerGroup[activePlayer].classSkills[activeSkill].is_aoe:
					activeTarget = instancedEnemies
				# for singleTarget we get target
				else:
					if activeTarget == null:
						print(tempTarget)
						#change tempPlayer number which will become
						#activePlayer when choosen
						if Input.is_action_just_pressed("ui_focus_next"):
							tempTarget += 1
							#wrap around the playerGroupArray
							if tempTarget > len(instancedEnemies)-1:
								tempTarget = 0
						if Input.is_action_just_pressed("ui_focus_prev"):
							tempTarget -= 1
							if tempTarget < 0:
								tempTarget = len(instancedEnemies)-1
						if Input.is_action_just_pressed("ui_accept"):
							activeTarget = [instancedEnemies[tempTarget]]
							
					
					# after we got all variables we needed we actually invoke the skill
					else:
						playerGroup[activePlayer].useSkill(activeSkill,activeTarget)
						
						
						#debug state of the game print
						print(playerGroup[activePlayer].mp)
						print(activeTarget[0].hp)
						print(activeTarget[0].activeEffects)
						
						
						
						
						
						
						# make player that did action unusable
						usablePlayers.remove(tempPlayer)
						# reseting all choice-variables
						tempPlayer = 0
						tempTarget = 0
						activePlayer = null
						activeSkill = null
						activeTarget = null
		else:
			playerTurn = false

			
func _on_Button_pressed(skillName):
	activeSkill = skillName



func playerTurn():
	pass
	
	var possiblePlayers = []
	for i in range(referencedPlayerGroup):
		possiblePlayers.append(i)
	
#	#every player in Group takes a turn with one action
#	for playerNum in range(possiblePlayers):
#
#		# check for preTurnEffects (stun) and apply them
#		checkEffects(true, player)
		# choose action from GUI -> choosenAction
		# choose targets from GUI -> targets
		# var choosenAction = "Fire Ball"
		# var targets = [target, target, etc]
		# player.useSkill(choosenAction, targets)

		
	# after fight effects like poison take effect
	for player in referencedPlayerGroup:
		checkEffects(false, player)
	
	# before enemies are allowed to act we check if playeractions have
	# killed any enemies and we remove them from the array		
#	for enemie in instancedEnemies:
#		if enemy.hp <= 0:
#			enemy.destroy() #OR
#			instancedEenemies.remove(enemie)

#	playerRound = false
#	disablePlayerGUI()
#	gameplay()

# check and apply pre or post turn effects when they exist
func checkEffects(preTurn:bool, target):
	if preTurn:
		for effect in target.activeEffects:
			if effect.preTurn:
				effect.apply(target)
	else:
		for effect in target.activeEffects:
			if not(effect.preTurn):
				effect.apply(target)


func enemyTurn():
	pass
	
#	for enemie in instancedEnemies:
		# check for preTurnEffects (stun) and apply them
		# enemie.ki()

	# after fight effects like poison take effect
#	for enemie in instancedEnemies:
		# check for postRoundEffects and apply them
		
	# before players are allowed to act we check if enemieactions have
	# killed any players and we remove them from the array		
#	for player in referencedPlayerGroup:
#		if player.hp <= 0:
#			player.destroy() #OR
#			referencedPlayerGroup.remove(player)

#	playerRound = true
#	enablePlayerGUI()
#	gameplay()


func checkFightover():
	pass
	
#	if referencedPlayerGroup is empty:
#		playerWon()
#	elif instancedEnemies is empty:
#		playerLost()
#






