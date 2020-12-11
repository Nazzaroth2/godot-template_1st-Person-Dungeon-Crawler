extends BaseGameObject
class_name BaseSkill

export (int) var cost
#export (String) var skillCategory
enum SKILLCATEGORY{PHYSICAL, MAGIC}
export (SKILLCATEGORY) var skillCategory = SKILLCATEGORY.PHYSICAL
enum TARGETEDSTAT{HP, MP, STAMINA}
export (TARGETEDSTAT) var targetedStat = TARGETEDSTAT.HP

export (Array, Resource) var skillEffects
export (int) var skillValue

export (bool) var is_aoe

# overwrite this function in inherited objects if you want to have unusual
# skill behaviour (eg. diffrent amounts of damage per target)
func use(user, targets:Array):
	match skillCategory:
		SKILLCATEGORY.PHYSICAL:
			user.stamina -= cost
		SKILLCATEGORY.MAGIC:
			user.mp -= cost
	
	if skillEffects != null:
		applyEffects(targets)
		
	#skillValue = calculateSkillValue(user)

	if is_aoe:
		for target in targets:
			match targetedStat:
				TARGETEDSTAT.HP:
					target.hp += skillValue
				TARGETEDSTAT.MP:
					target.mp += skillValue
				TARGETEDSTAT.STAMINA:
					target.stamina += skillValue
	else:
		match targetedStat:
			TARGETEDSTAT.HP:
				targets[0].hp += skillValue
			TARGETEDSTAT.MP:
				targets[0].mp += skillValue
			TARGETEDSTAT.STAMINA:
				targets[0].stamina += skillValue
	
	
func applyEffects(targets:Array):
	for effect in skillEffects:
		for target in targets:
			target.activeEffects.append(effect)

# change this function to change how the system calculates skillvalues
# eg. take elemental types into account, add percentages etc.
func calculateSkillValue(user):
	skillValue = skillValue
