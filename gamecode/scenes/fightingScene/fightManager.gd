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
var activeSkill
var usablePlayers = []
var usableEnemies = []
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
	
	# create icon-objects for enemies and players here later
	
	for playerLabel in players.get_children():
		playerLabel.connect("player_choosen",self,"_on_player_choosen")
		
	for enemyLabel in enemies.get_children():
		enemyLabel.connect("enemy_choosen",self,"_on_enemy_choosen")



	resetUsableCharacters("both")


	gameRound()





# for every player in group that is alive we put his index into
# usable players
func resetUsableCharacters(characters):
	
	if characters == "players":
		usablePlayers = []
		for playerName in playersDict:
			if playersDict[playerName].hp > 0:
				usablePlayers.append(playerName)
	elif characters == "enemies":
		usableEnemies = []
		for enemyName in enemiesDict:
			usableEnemies.append(enemyName)
	elif characters == "both":
		usablePlayers = []
		for playerName in playersDict:
			if playersDict[playerName].hp > 0:
				usablePlayers.append(playerName)
				
		usableEnemies = []
		for enemyName in enemiesDict:
			usableEnemies.append(enemyName)
		
	

# the big turnbased function that checks for win-lose-state and which turn it is.
func gameRound():
	# check if any group won the fight and finish the scene
	if checkFightover():
		pass
	else:		
		if playerTurn:
			playerTurn()
		else:
			enemyTurn()



func playerTurn():
	# add preTurn effects here	
	
	if not(usablePlayers.empty()):
		#get active Player through gui/playeractions
		# when choosing a player the first usable player gets focused
		# choosen by name
		var firstPlayer = players.get_node(usablePlayers[0])
		firstPlayer.grab_focus()

		
				
	else:
		# add postTurn effects here
		playerTurn = false
		print_debug("playerTurn is over")
		gameRound()

func finishCharacterAction():
	# after we got all variables we needed we actually invoke the skill
	choosenPlayer.useSkill(activeSkill,choosenTargets)
	
	# check if any of the choosenTargets got killed and remove them from dictionary
	for enemyName in enemiesDict:
		if enemiesDict[enemyName].hp <= 0:
			enemiesDict.erase(enemyName)
	resetUsableCharacters("enemies")


	#debug state of the game print
	print_debug("")
	print_debug("choosenPlayer: ",choosenPlayer.name)
#	print_debug("MP : ",choosenPlayer.mp)
	print_debug("activeTarget: ",choosenTargets[0].name)
	print_debug("activeTarget HP: ",choosenTargets[0].hp)
#	print_debug("activeTarget first active Effect: ",choosenTargets[0].activeEffects[0].name)

	# make player that did action unusable
	usablePlayers.remove(usablePlayers.find(choosenPlayerName))
	# reseting all choice-variables

	get_focus_owner().release_focus()

	# call playerTurn so often till all players have taken a turn
	playerTurn()


func _on_player_choosen(playerName):
	choosenPlayer = playersDict[playerName]
	choosenPlayerName = playerName
	# set playerMenu visible (should have been invisible at this point)
	menuChoices.get_child(0).grab_focus()
	
func _on_enemy_choosen(enemyName):
	choosenTargets = [enemiesDict[enemyName]]
	# set playerMenu visible (should have been invisible at this point)
	finishCharacterAction()
	
func _on_actionButton_pressed(skillName):
	activeSkill = skillName
	# CHECK FOR AOE-SKILLS HERE!
	if choosenPlayer.classSkills[activeSkill].is_aoe:
			#maybe deal somehow with showing aoe-targets as active first?
			choosenTargets = [enemiesDict.values()]
	else:
		enemies.get_node(usableEnemies[0]).grab_focus()

			






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
	for enemy in enemiesDict.values():
		enemy.ki(enemiesDict.values(), playersDict.values())
		
		# after enemy has acted we need to check if any players died.
		for playerName in playersDict:
			if playersDict[playerName].hp <= 0:
				playersDict.erase(playerName)
		resetUsableCharacters("players")
		

	# after fight effects like poison take effect
#	for enemie in instancedEnemies:
		# check for postRoundEffects and apply them


	
	playerTurn = true
	gameRound()


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





