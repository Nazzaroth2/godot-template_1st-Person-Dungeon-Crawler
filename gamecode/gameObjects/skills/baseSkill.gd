extends BaseGameObject
class_name BaseSkill

export (int) var cost
export (String) var skillCategory
export (Array, Resource) var skillEffects
export (int) var skillValue
export (String) var targetStat
export (bool) var is_aoe

# overwrite this function in inherited objects if you want to have unusual
# skill behaviour (eg. diffrent amounts of damage per target)
func use(user:BaseGameObject, targets:Array):
	match (skillCategory):
		"physical":
			user.stamina -= cost
		"magic":
			user.mp -= cost
	
	if skillEffects != null:
		applyEffects(targets)
		
	if is_aoe:
		for target in targets:
			match (targetStat):
				"hp":
					target.hp += skillValue
				"mp":
					target.mp += skillValue
				"stamina":
					target.stamina += skillValue
	else:
		match(targetStat):
			"hp":
				targets[0].hp += skillValue
			"mp":
				targets[0].mp += skillValue
			"stamina":
				targets[0].stamina += skillValue
	
	
func applyEffects(targets:Array):
	for effect in skillEffects:
		for target in targets:
			target.activeEffects.append(effect)

# change this function to change how the system calculates skillvalues
# eg. take elemental types into account, add percentages etc.
func calculateSkillValue():
	skillValue = skillValue
