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
		_applyEffects(targets)
		
	#skillValue = _calculateSkillValue(user)

	_applySkillValue(targets)
	

# loops over all effects the skill has and adds them to targets
# activeEffects-Array for later processing in the fightManager
func _applyEffects(targets:Array):
	for effect in skillEffects:
		for target in targets:
			target.activeEffects.append(effect)

# change this function to change how the system calculates skillvalues
# eg. take elemental types into account, add percentages etc.
func _calculateSkillValue(user):
	skillValue = skillValue


# virtual function that decides how to apply the given SkillValue
# to the targets. best example is subtract or add for damaging or healing
# targets respectivly
func _applySkillValue(targets):
	pass
