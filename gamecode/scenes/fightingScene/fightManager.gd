extends Control

onready var referencedPlayerGroup = $"../../playerGroup"
var playersDict = {}
onready var pandemonium = preload("res://gamecode/gameObjects/enemies/pandemoniumDemo.tres")
var enemiesDict = {}
var enemyAmount = 2
var enemyType = 0

var playerTurn = true

var choosenPlayer
var choosenPlayerName
var activeSkillName
var choosenTargets

# GUI-Variables
onready var players = $"../GUI/characters/players"
onready var enemies = $"../GUI/characters/enemies"
onready var menuChoices = $"../GUI/playerMenu/menuChoices"


#var rng = RandomNumberGenerator.new()



func _ready():
	# instanciate Enemies
#	rng.randomize()
#	enemyAmount = rng.randi_range(1,2)
	# duplicate to keep instanced enemies unique to a fight
	var enemyCounter = 1
	for i in range(enemyAmount):
		var enemyName = "enemy" + str(enemyCounter)
		enemiesDict[enemyName] = pandemonium.enemies[enemyType].duplicate()
		enemyCounter += 1

	# important: keep naming-sceme for dictionary and nodes the same!
	var playerCounter = 1
	for player in referencedPlayerGroup.playerGroup:
		var playerName = "player" + str(playerCounter)
		playersDict[playerName] = player
		playerCounter += 1
	
	
	var characterScript = preload("res://gamecode/scenes/fightingScene/characterSprite.gd")
	# create icon-objects for enemies and players here later
	for player in playersDict:
		var playerIcon = ColorRect.new()
		
		playerIcon.name = player
		playerIcon.color = Color(Color.red)
		playerIcon.size_flags_vertical = Control.SIZE_EXPAND_FILL
		playerIcon.focus_mode = Control.FOCUS_ALL
		
		# set script and give reference to Player Resource
		playerIcon.set_script(characterScript)
		playerIcon.characterResource = playersDict[player]
		
		players.add_child(playerIcon)
		
	for enemy in enemiesDict:
		var enemiesIcon = ColorRect.new()
		
		enemiesIcon.name = enemy
		enemiesIcon.color = Color(Color.red)
		enemiesIcon.size_flags_vertical = Control.SIZE_EXPAND_FILL
		enemiesIcon.focus_mode = Control.FOCUS_ALL
		
		# set script and give reference to Player Resource
		enemiesIcon.set_script(characterScript)
		enemiesIcon.characterResource = enemiesDict[enemy]
		
		enemies.add_child(enemiesIcon)
		
	
	# connect to the signal thats emitted when pressing ui_accept
	for player in players.get_children():
		player.connect("player_choosen",self,"_on_player_choosen")

	for enemy in enemies.get_children():
		enemy.connect("enemy_choosen",self,"_on_enemy_choosen")

	# start the fight
	gameRound()





# reset all is_usable and is_targetable-variables to true, next step we reapply
# potential effects
func resetCharacterVariables():
	for player in playersDict.values():
		player.is_usable = true
		player.is_targetable = true
	
	for enemy in enemiesDict.values():
		enemy.is_usable = true
		enemy.is_targetable = true



# returns a array with all characters of either players or enemies that
# are either usable or targetable, used respectivly for getting
# potential users of a skill are targets of a skill
func createCharacterArray(parent, ableType):
	var ableCharacters = []
	for child in parent.get_children():
		if ableType == "usable":
			if child.characterResource.is_usable:
				ableCharacters.append(child)
		if ableType == "targetable":
			if child.characterResource.is_targetable:
				ableCharacters.append(child)
				
	return ableCharacters
		
		
	

# the big turnbased function that checks for win-lose-state and which turn it is.
func gameRound():
	# check if any group won the fight and finish the scene
	if checkFightover():
		# here we would call a sceneOverFunction that shows the fight-
		# reward and switches back to dungeon.
		pass
	else:
		# reseting all usable/targetable variables to true
		resetCharacterVariables()
		# here and then check for preEffects and then start either
		# turn of players or enemies
		#checkPreTurnEffects #for enemies and players
		
		if playerTurn:
			playerTurn()
		else:
			enemyTurn()



func playerTurn():
	
	var usablePlayers = createCharacterArray(players, "usable")
	
	if not(usablePlayers.empty()):
		#get active Player through gui/playeractions
		# when choosing a player the first usable player gets focused
		# choosen by name
		usablePlayers[0].grab_focus()
	else:
		# add postTurn effects here
		playerTurn = false
		print_debug("playerTurn is over")
		gameRound()


# signalFunctions that set all the playerChoices into variables
func _on_player_choosen(player):
	choosenPlayer = player
#	choosenPlayerName = playerName
	# set playerMenu visible (should have been invisible at this point)
	menuChoices.get_child(0).grab_focus()
	
func _on_actionButton_pressed(skillName):
	activeSkillName = skillName
	
	var targetableEnemies = createCharacterArray(enemies,"targetable")
	# CHECK FOR AOE-SKILLS HERE!
	if choosenPlayer.classSkills[activeSkillName].is_aoe:
			#maybe deal somehow with showing aoe-targets as active first?
			for enemy in targetableEnemies:
				choosenTargets.append(enemy.characterResource)
	else:
		targetableEnemies[0].grab_focus()

func _on_enemy_choosen(enemy):
	choosenTargets = [enemy]
	# set playerMenu visible (should have been invisible at this point)
	finishCharacterAction()


# actually use the choosen skill on a target and restart playerTurn
func finishCharacterAction():
	# after we got all variables we needed we actually invoke the skill
	choosenPlayer.useSkill(activeSkillName,choosenTargets)
	
	# check if any of the choosenTargets got killed and remove them from dictionary
	# also make them untargetable and unusable and make the invisible (here
	# you could show blowup-effects etc.)
	for enemyName in enemiesDict:
		if enemiesDict[enemyName].hp <= 0:
			enemiesDict[enemyName].is_targetable = false
			enemiesDict[enemyName].is_usable = false
			
			enemiesDict.erase(enemyName)
						
			for enemyIcon in enemies.get_children():
				if enemyIcon.name == enemyName:
					enemyIcon.visible = false


	#debug state of the game print
	print_debug("")
	print_debug("choosenPlayer: ",choosenPlayer.name)
#	print_debug("MP : ",choosenPlayer.mp)
	print_debug("activeTarget: ",choosenTargets[0].name)
	print_debug("activeTarget HP: ",choosenTargets[0].hp)
#	print_debug("activeTarget first active Effect: ",choosenTargets[0].activeEffects[0].name)

	# make player that did action unusable
#	usablePlayers.remove(useablePlayers.find(choosenPlayerName))
	choosenPlayer.is_usable = false
	# reseting all choice-variables

#	get_focus_owner().release_focus()

	# call playerTurn so often till all players have taken a turn
	playerTurn()




func enemyTurn():
	var usableEnemies = [] 
	for enemy in createCharacterArray(enemies,"usable"):
		usableEnemies.append(enemy.characterResource)
	var targetableEnemies = []
	for enemy in createCharacterArray(enemies,"targetable"):
		targetableEnemies.append(enemy.characterResource)
	var targetablePlayers = []
	for player in createCharacterArray(players,"targetable"):
		targetablePlayers.append(player.characterResource)
	
	for enemy in usableEnemies:
		enemy.ki(targetableEnemies, targetablePlayers)
		
		# after enemy has acted we need to check if any players died.
		for playerName in playersDict:
			if playersDict[playerName].hp <= 0:
				playersDict[playerName].is_targetable = false
				playersDict[playerName].is_usable = false
				
				playersDict.erase(playerName)
							
				for playerIcon in players.get_children():
					if playerIcon.name == playerName:
						playerIcon.visible = false
#		resetUsableCharacters("players")
		

	# after fight effects like poison take effect
#	for enemie in instancedEnemies:
		# check for postRoundEffects and apply them
	
	playerTurn = true
	gameRound()

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

func checkFightover():
	if enemiesDict.empty():
		playerWon()
		return true
	elif playersDict.empty():
		playerLost()
		return true
	else:
		return false

func playerWon():
	print("player has won")
	
func playerLost():
	print("player has lost")





