extends Control

onready var referencedPlayerGroup = $"../playerGroup"
onready var playerGroup = referencedPlayerGroup.playerGroup
onready var pandemonium = preload("res://gamecode/gameObjects/enemies/pandemoniumDemo.tres")
var instancedEnemies = []
var enemyAmount = 2
var enemyType = 0

var playerTurn = true

var choosenPlayer
var activeSkill
var usablePlayers = []
var activeTargets

# GUI-Variables
onready var players = $GUI/characters/players
onready var enemies = $GUI/characters/enemies
onready var playerMenu = $GUI/playerMenu


var rng = RandomNumberGenerator.new()

signal actionDone

func _ready():
	# instanciate Enemies
#	rng.randomize()
#	enemyAmount = rng.randi_range(1,2)
	# duplicate to keep instanced enemies unique to a fight
	for i in range(enemyAmount):
		instancedEnemies.append(pandemonium.enemies[enemyType].duplicate())


#	$demoSkill.text = playerGroup[0].classSkills["Fire Ball"].name
#	$demoSkill.connect("pressed", self, "_on_Button_pressed",[$demoSkill.text])

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
			if choosenPlayer == null:
				# change players.activePlayer number which changes the ui
				# through setter-function and later is used as index for
				# the choosenPlayer
				if Input.is_action_just_pressed("ui_focus_next"):
					# wrap around the usablePlayersArray when outside of lenght
					if players.activePlayer + 1 > len(usablePlayers)-1:
						players.activePlayer = 0
					# or go to next array-element
					else:
						players.activePlayer += 1	
				if Input.is_action_just_pressed("ui_focus_prev"):
					if players.activePlayer - 1 < 0:
						players.activePlayer = len(usablePlayers)-1
					else:
						players.activePlayer -= 1
				if Input.is_action_just_pressed("ui_accept"):
					# the choosen player is indexed throgh the usablePlayers-array
					# this way we cannot choose a player 2 times per turn, if
					# we remove the playerIndex from usablePlayers after action
					choosenPlayer = playerGroup[usablePlayers[players.activePlayer]]
					# show playerMenu and set focus on first menuChoice
					#playerMenu.visible = true
					playerMenu.get_child(0).get_child(0).grab_focus()
					


			else:
				if activeSkill == null:
					pass
					# show skillChoice-Menu
				# if aoe-attack just pass all enemies as targets
				elif choosenPlayer.classSkills[activeSkill].is_aoe:
					activeTargets = instancedEnemies
				# for singleTarget we get target
				else:
					if activeTargets == null:
						#change tempPlayer number which will become
						#activePlayer when choosen
						if Input.is_action_just_pressed("ui_focus_next"):
							#wrap around the enemies-array
							if enemies.activeEnemy + 1 > len(instancedEnemies)-1:
								enemies.activeEnemy = 0
							else:
								enemies.activeEnemy += 1
						if Input.is_action_just_pressed("ui_focus_prev"):
							if enemies.activeEnemy - 1 < 0:
								enemies.activeEnemy = len(instancedEnemies)-1
							else:
								enemies.activeEnemy -= 1
						if Input.is_action_just_pressed("ui_accept"):
							activeTargets = [instancedEnemies[enemies.activeEnemy]]


					# after we got all variables we needed we actually invoke the skill
					else:
						choosenPlayer.useSkill(activeSkill,activeTargets)

						emit_signal("actionDone")
						
						
						#debug state of the game print
						print_debug("choosenPlayer: ",choosenPlayer.name)
						print_debug("MP : ",choosenPlayer.mp)
						print_debug("activeTarget: ",activeTargets[0].name)
						print_debug("activeTarget HP: ",activeTargets[0].hp)
						print_debug("activeTarget first active Effect: ",activeTargets[0].activeEffects[0].name)
						






						# make player that did action unusable
						usablePlayers.remove(players.activePlayer)
						# reseting all choice-variables
#						players.activePlayer = 0
						choosenPlayer = null
						activeSkill = null
						activeTargets = null

						
						
		else:
			playerTurn = false






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






