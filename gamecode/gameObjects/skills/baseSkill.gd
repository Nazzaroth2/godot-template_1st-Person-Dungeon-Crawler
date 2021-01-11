extends BaseGameObject
class_name BaseSkill

export(Animation) var skillAnimation

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
func use(user, targets:Array) -> int:
	match skillCategory:
		SKILLCATEGORY.PHYSICAL:
			user.stamina -= cost
		SKILLCATEGORY.MAGIC:
			user.mp -= cost
	
	if skillEffects != null:
		_applyEffects(targets)
		
	skillValue = _calculateSkillValue(user)

	_applySkillValue(targets)
	
	return skillValue
	

# loops over all effects the skill has and adds them to targets
# activeEffects-Array for later processing in the fightManager
func _applyEffects(targets:Array):
	for effect in skillEffects:
		for target in targets:
			var oldEffectNames = []
			for oldEffect in target.activeEffects:
				oldEffectNames.append(oldEffect.name)
			
			# hinder adding effect to targets that already
			# have such an active effect
			if effect.name in oldEffectNames:
				pass
			else:
				# add duplicate of effect to target (so lifetime is unique)
				target.activeEffects.append(effect.duplicate())
				# add the effect icon of last array-item
				target.activeEffects[-1].addIcon(target)
			


# change this function to change how the system calculates skillvalues
# eg. take elemental types into account, add percentages etc.
func _calculateSkillValue(user):
	return skillValue


# virtual function that decides how to apply the given SkillValue
# to the targets. best example is subtract or add for damaging or healing
# targets respectivly
func _applySkillValue(targets):
	pass
