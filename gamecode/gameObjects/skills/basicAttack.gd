extends DamageSkill
class_name basicAttack

func _calculateSkillValue(user):
	return user.strength
