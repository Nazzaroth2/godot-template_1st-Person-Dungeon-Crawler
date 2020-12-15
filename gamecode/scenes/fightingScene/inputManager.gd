extends Control

onready var fightManager = $".."
onready var menuChoices = $"../GUI/playerMenu/menuChoices"

func _process(delta):
	if fightManager.choosenPlayer == null:
		if Input.is_action_just_pressed("ui_accept"):
			# the choosen player is indexed throgh the usablePlayers-array
			# this way we cannot choose a player 2 times per turn, if
			# we remove the playerIndex from usablePlayers after action
#			choosenPlayer = playerGroup[usablePlayers[players.activePlayer]]
			fightManager.choosenPlayer = fightManager.playerGroupDict[get_focus_owner().name]
			fightManager.choosenPlayerName = get_focus_owner().name
			# show playerMenu and set focus on first menuChoice
			#playerMenu.visible = true
			menuChoices.get_child(0).grab_focus()
	
	else:
		if fightManager.activeSkill == null:
			pass
			# show skillChoice-Menu
			# if aoe-attack just pass all enemies as targets
		elif fightManager.choosenPlayer.classSkills[fightManager.activeSkill].is_aoe:
			fightManager.activeTargets = fightManager.instancedEnemies
		# for singleTarget we get target
		else:
			if fightManager.activeTargets == null:
				if Input.is_action_just_pressed("ui_accept"):
#					activeTargets = [instancedEnemies[enemies.activeEnemy]]
					fightManager.activeTargets = [fightManager.enemiesDict[get_focus_owner().name]]
					
					fightManager.finishCharacterAction()
