extends BaseSkill
class_name HealingSkill

func _applySkillValue(targets):
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
