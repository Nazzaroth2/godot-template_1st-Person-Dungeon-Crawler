extends Control

export (Resource) var rewardInventory
onready var referencedPlayerGroup = $"../../playerGroup"
var playersDict = {}
# TODO: change enemies to multiple pandemoniums = enemy combinations
# per fightscene we choose a random pandemonium
# per dungeonLevel we have diffrent combinations of pandemoniums
export (Array, Resource) var levelPandemonien
var enemiesDict = {}
var enemyAmount = 2
var enemyType = 0

var playerTurn = true

# Player Input Variables
var choosenPlayer
var playerActionChoice
var is_player_attacking = false
#var choosenTargetsResources = []
#var choosenTargetsNodes = []
var choosenTargets
var choosenTargetsName

var rng = RandomNumberGenerator.new()

# GUI-Variables
onready var players = $"../GUI/characters/players"
onready var enemies = $"../GUI/characters/enemies"
onready var menuChoices = $"../GUI/playerMenu/menuChoices"

signal player_won
signal lootEvent
signal dealtDamage
signal healed



func _ready():
	# instanciate Enemies
	rng.randomize()
	# random Pandeomonium out of all levelPandemoni
	var activePandemonium = levelPandemonien[rng.randi_range(
								0,len(levelPandemonien)-1)].duplicate(true)
	
	# duplicate every enemy resource to make unique enemies
	activePandemonium.makeUniqueEnemies()
	# add all enemie-resources into dictionary
	var enemyCounter = 0
	for enemy in activePandemonium.enemies:
		var enemyName = "enemy" + str(enemyCounter)
		enemiesDict[enemyName] = enemy
		enemyCounter += 1

	# important: keep naming-sceme for dictionary and nodes the same!
	var playerCounter = 0
	for player in referencedPlayerGroup.playerGroup:
		var playerName = "player" + str(playerCounter)
		playersDict[playerName] = player
		playerCounter += 1
	
	
	
	# TODO: possibly move the setup of characters to the characterSprite-Script
	var characterScript = preload("res://gamecode/scenes/fightingScene/characterSprite.gd")
	var fightCharacter = preload("res://gamecode/scenes/fightingScene/fightCharacter.tscn")
	# create icon-objects for enemies and players here later
	var charCnt = 0
	for player in referencedPlayerGroup.playerGroup:
		var playerCharacterScene = fightCharacter.instance()
		playerCharacterScene.name = "player" + str(charCnt)
		
		playerCharacterScene.texture = player.icon
		playerCharacterScene.get_node("name").text = player.name
		# players need to look to the left
		playerCharacterScene.flip_h = true
		
		# set script and give reference to Player Resource
#		playerCharacterScene.set_script(characterScript)
		playerCharacterScene.characterResource = player
		
		players.add_child(playerCharacterScene)
		player.guiNode = players.get_child(charCnt)
		
		charCnt += 1
	
	charCnt = 0
	for enemy in activePandemonium.enemies:
		var enemyCharacterScene = fightCharacter.instance()
		enemyCharacterScene.name = "enemy" + str(charCnt)
		
		
		enemyCharacterScene.texture = enemy.icon
		enemyCharacterScene.get_node("name").text = enemy.name

		# set script and give reference to Player Resource
#		enemyCharacterScene.set_script(characterScript)
		enemyCharacterScene.characterResource = enemy
		
		enemies.add_child(enemyCharacterScene)
		enemy.guiNode = enemies.get_child(charCnt)
		
		charCnt += 1
		
	
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
	if checkFightover() == "WON":
		playerWon()
	elif checkFightover() == "LOST":
		playerLost()
	else:
		# reseting all usable/targetable variables to true
		resetCharacterVariables()

		if playerTurn:
			# checkPreTurnEffects, Stune etc #for enemies and players

			for playerResource in playersDict.values():
				for effect in playerResource.activeEffects:
					if effect.preTurn:
						effect.apply(playerResource)
						effect.updateLifetime(playerResource)
					
			playerTurn()
		else:
			for enemyResource in enemiesDict.values():
				for effect in enemyResource.activeEffects:
					if effect.preTurn:
						effect.apply(enemyResource)
						effect.updateLifetime(enemyResource)
			
			enemyTurn()




func playerTurn():
	
	var usablePlayers = createCharacterArray(players, "usable")
	var targetableEnemies = createCharacterArray(enemies, "targetable")
	
	# if no enemies are left, but players could still take action
	# we break out and go immedeatly to next round
	if targetableEnemies.empty():
		gameRound()
	else:
		# if no more usable Players are left we go to next round
		# which will be enemie-turn
		if usablePlayers.empty():
			# add postTurn effects here
			for playerResource in playersDict.values():
				for effect in playerResource.activeEffects:
					if not(effect.preTurn):
						var result = effect.apply(playerResource)
						effect.updateLifetime(playerResource)
						# if effect deals damage we play animation
						if result != null:
							emit_signal("dealtDamage",playerResource.guiNode.name,null,null,result)
							yield(playerResource.guiNode,"valueAnimationDone")
							
			
			# check if any Player died cause of postTurn effect
			for playerName in playersDict:
				if playersDict[playerName].hp <= 0:
					playersDict[playerName].is_targetable = false
					playersDict[playerName].is_usable = false
					
					playersDict.erase(playerName)
								
					for playerIcon in players.get_children():
						if playerIcon.name == playerName:
							playerIcon.visible = false
			
			
			playerTurn = false
	#		print_debug("playerTurn is over")
			gameRound()
		else:
			# get active Player through gui/playeractions
			# when choosing a player the first usable player gets focused
			# choosen by name
			# is_player_attacking = true hinders player input. we
			# only allow playerinput when we have choosen a new character
			usablePlayers[0].grab_focus()
			is_player_attacking = false



# signalFunctions that set all the playerChoices into variables
func _on_player_choosen(player):
	choosenPlayer = player

	# set playerMenu visible (should have been invisible at this point)
	menuChoices.get_child(0).grab_focus()
	
func _on_skillButton_pressed(choice):
	playerActionChoice = choice
	var targetableEnemies = createCharacterArray(enemies,"targetable")
	# CHECK FOR AOE-SKILLS HERE!
	if choosenPlayer.classSkills[playerActionChoice.name].is_aoe:
			#maybe deal somehow with showing aoe-targets as active first?
			for enemy in targetableEnemies:
				choosenTargets.append(enemy.characterResource)
			# if its aoe damage all targets show damage, this
			# will be shown by having no name for targets
			choosenTargetsName = null
	else:
		targetableEnemies[0].grab_focus()

func _on_itemButton_pressed(item, itemIdx):
	if not(item.needs_targets):
		playerActionChoice = [item, itemIdx]
		finishCharacterAction()
	#TODO: add target-choice for items (bomb etc.)
		
	
	

func _on_enemy_choosen(enemy, enemyName):
#	choosenTargetsNodes = enemy
	choosenTargets = [enemy]
	choosenTargetsName = enemyName
	# set playerMenu visible (should have been invisible at this point)
	finishCharacterAction()


# actually use the choosen skill on a target and restart playerTurn
func finishCharacterAction():
	# depending on what choice the player did we
	# either use the playerSKill
	if playerActionChoice is BaseSkill:
		var dealtDamage = choosenPlayer.useSkill(playerActionChoice.name,choosenTargets)
		emit_signal("dealtDamage",choosenTargetsName,choosenPlayer,playerActionChoice.name,dealtDamage)
		for target in choosenTargets:
			yield(target.guiNode,"valueAnimationDone")
	# or we use an item
	elif playerActionChoice[0] is Consumable:
		var itemValue = playerActionChoice[0].use(choosenPlayer, null)
		# need to emit signal so inventory gets updated with new current stack
		referencedPlayerGroup.inventory.emit_signal("items_changed",[playerActionChoice[1]])
		# if all stacks get used we remove item from inventory by setting array index = null
		if playerActionChoice[0].current_stacks <= 0:
			referencedPlayerGroup.inventory.items[playerActionChoice[1]] = null
		
#		print_debug(referencedPlayerGroup.inventory.items)
#		print_debug(playerActionChoice)
#		print_debug(playerActionChoice.current_stacks)
		if itemValue != null:
			emit_signal("healed",choosenPlayer.guiNode.name,itemValue)
			yield(choosenPlayer.guiNode,"valueAnimationDone")
		
	
	# check if any of the choosenTargets got killed and remove them from dictionary
	# also make them untargetable and unusable and make the invisible (here
	# you could show blowup-effects etc.)
	for enemyName in enemiesDict:
		if enemiesDict[enemyName].hp <= 0:
			enemiesDict.erase(enemyName)
						
			for enemyCharacter in enemies.get_children():
				if enemyCharacter.name == enemyName:
					enemyCharacter.queue_free()
					# neccesary to make sure the enemy is freed
					# before another player can take an action.
					# results in no damage shown when enemy dies,
					# if time is left maybe rework this?
					yield(get_tree(),"idle_frame")



	# make player that did action unusable
	choosenPlayer.is_usable = false

	# call playerTurn so often till all players have taken a turn
	playerTurn()




func enemyTurn():
	# enemies that can take an action
	var usableEnemies = [] 
	for enemy in createCharacterArray(enemies,"usable"):
		usableEnemies.append(enemy.characterResource)
	# enemies that can be targeted by enemies (eg.healspells)
	var targetableEnemies = []
	for enemy in createCharacterArray(enemies,"targetable"):
		targetableEnemies.append(enemy.characterResource)
	# players that can be targeted by enemies (eg.damagespells)
	var targetablePlayers = []
	for player in createCharacterArray(players,"targetable"):
		targetablePlayers.append([player.name,player.characterResource])
	
	for enemy in usableEnemies:
		# [0] = choosenTargetsNames,[1] = choosenSkillName, [2] = dealtDamage, [3] = choosenTargets
		var decisions = enemy.ki(targetableEnemies, targetablePlayers)
		
		emit_signal("dealtDamage",decisions[0], enemy, decisions[1], decisions[2])
		
		for target in decisions[3]:
			yield(target.guiNode,"valueAnimationDone")
		
		# after enemy has acted we need to check if any players died.
		for playerName in playersDict:
			if playersDict[playerName].hp <= 0:
				playersDict[playerName].is_targetable = false
				playersDict[playerName].is_usable = false
				
				playersDict.erase(playerName)
							
				for playerIcon in players.get_children():
					if playerIcon.name == playerName:
						playerIcon.visible = false
	
	# postEffect check on enemies
	for enemyResource in enemiesDict.values():
		for effect in enemyResource.activeEffects:
			if not(effect.preTurn):
				var result = effect.apply(enemyResource)
				effect.updateLifetime(enemyResource)
				# if effect deals damage we play animation
				if result != null:
					emit_signal("dealtDamage",enemyResource.guiNode.name,null,null,result)
					yield(enemyResource.guiNode,"valueAnimationDone")
	
	# check if any enemie died through postEffect
	for enemyName in enemiesDict:
		if enemiesDict[enemyName].hp <= 0:
			enemiesDict.erase(enemyName)
						
			for enemyCharacter in enemies.get_children():
				if enemyCharacter.name == enemyName:
					enemyCharacter.queue_free()
					# neccesary to make sure the enemy is freed
					# before another player can take an action.
					# results in no damage shown when enemy dies,
					# if time is left maybe rework this?
					yield(get_tree(),"idle_frame")

	
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
		return "WON"
	elif playersDict.empty():
		return "LOST"


# when player wins a fight we show a reward-window with the items/gold he
# got for the fight, handled by world-script
func playerWon():
	emit_signal("lootEvent", rewardInventory)

# depending on how you want to handle loosing in your game, gameover code
# can go here.
func playerLost():
	print("player has lost")





