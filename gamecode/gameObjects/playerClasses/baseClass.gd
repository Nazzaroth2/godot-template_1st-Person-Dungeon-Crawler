extends BaseGameObject
class_name BasePlayerClass

# all skills for a class with named keys
export (Dictionary) onready var classSkills
# bool-array to check if classSkill is unlocked through skillPoints
# and usable in fight etc.
var unlockedSkills:Array

export (Dictionary) var equipment


var activeEffects = []
# maybe use these variables to decide if player is usable or targetable
var is_usable = true
var is_targetable = true

export (int) var hp_max
export (int) var hp
export (int) var mp_max
export (int) var mp
export (int) var stamina_max
export (int) var stamina

export (int) var strength
export (int) var dexterity
export (int) var intelligence
export (int) var luck

var level:int
var experiencePoints:int
var nextLevel_experiencePoints:int
var attributePoints:int
var skillPoints:int


# TODO: check how to loop over dictionary in gdscript and get keys
#func _init():
#	for skill in classSkills:
#		unlockedSkills[skill.key] = false
		

func useSkill(skillname, targets):
	classSkills[skillname].use(self, targets)
	

# checks what skills the character has unlocked and returns all
# unlocked skillNames(Strings) in an Array(same order as Dict.)
func _getUnlockedSkills():
	var actualUnlockedSkills = []
	var idx = 0
	for skillName in classSkills:
		if unlockedSkills[idx]:
			actualUnlockedSkills.append(skillName)
		idx += 1
		
	return actualUnlockedSkills
	
