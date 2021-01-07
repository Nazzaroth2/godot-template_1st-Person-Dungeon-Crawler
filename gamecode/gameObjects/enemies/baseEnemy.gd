extends BaseGameObject
class_name BaseEnemy

export (int) var hp_max
export (int) var hp
export (int) var mp_max
export (int) var mp
export (int) var stamina_max
export (int) var stamina

export (Dictionary) onready var classSkills

var guiNode

var activeEffects = []
# maybe use these variables to decide if player is usable or targetable
var is_usable = true
var is_targetable = true

var rng = RandomNumberGenerator.new()

# overwrite this function to give specific enemies their own ki-routines
# possibleEnemy are used for healingSpells from enemies and
# possiblePlayer are used for damageSpells respectivly
func ki(possibleEnemyTargets, possiblePlayerTargets):
	rng.randomize()
	
	var choosenSkillName
	var choosenTargets
	var choosenTargetsNames
	# check if skill is damage or healing here
	
	choosenSkillName = chooseSkill()
	
	# for aoe skill we use full targets-array or we randomly choose a target
	if classSkills[choosenSkillName].is_aoe:
		choosenTargets = possiblePlayerTargets
		choosenTargetsNames = null
	else:
		var randomTargetIdx = rng.randi_range(0,len(possiblePlayerTargets)-1)
		choosenTargets = [possiblePlayerTargets[randomTargetIdx][1]]
		choosenTargetsNames = possiblePlayerTargets[randomTargetIdx][0]
		
	var dealtDamage = useSkill(choosenSkillName,choosenTargets)
	
	#debug state of the game print
#	print_debug("")
#	print_debug("enemy: ",self.name)
##	print_debug("MP : ",self.mp)
#	print_debug("activeTarget: ",choosenTargets[0].name)
#	print_debug("activeTarget HP: ",choosenTargets[0].hp)
#	print_debug("activeTarget first active Effect: ",choosenTargets[0].activeEffects[0].name)
	
	return [choosenTargetsNames, choosenSkillName, dealtDamage, choosenTargets]

	

func chooseSkill():
	rng.randomize()
	var skillIdx = rng.randi_range(0,len(classSkills)-1)
	return classSkills.keys()[skillIdx]


func useSkill(skillname, targets):
	return classSkills[skillname].use(self, targets)
