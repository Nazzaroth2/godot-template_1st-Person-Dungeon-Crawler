extends BaseGameObject
class_name BaseEnemy

export (int) var hp_max
export (int) var hp
var activeEffects = []
export (Dictionary) onready var classSkills



# overwrite this function to give specific enemies their own ki-routines
# possibleEnemy are used for healingSpells from enemies and
# possiblePlayer are used for damageSpells respectivly
func ki(possibleEnemyTargets, possiblePlayerTargets):
	pass




func useSkill(skillname, targets):
	classSkills[skillname].use(self, targets)
