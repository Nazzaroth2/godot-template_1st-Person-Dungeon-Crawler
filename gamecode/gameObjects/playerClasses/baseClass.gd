extends BaseGameObject
class_name BasePlayerClass

var guiNode

# all skills for a class with named keys
export (Dictionary) onready var classSkills
# bool-array to check if classSkill is unlocked through skillPoints
# and usable in fight etc.
var unlockedSkills:Array

export (Dictionary) var equipment = {
	"head": null,
	"chest": null,
	"feet": null,
	"rArm": null,
	"lArm": null
} setget set_equipment


var activeEffects = []
# maybe use these variables to decide if player is usable or targetable
var is_usable = true
var is_targetable = true

export (int) var hp_max setget set_hp_max
export (int) var hp setget set_hp
export (int) var mp_max setget set_mp_max
export (int) var mp setget set_mp
export (int) var stamina_max setget set_stamina_max
export (int) var stamina setget set_stamina

export (int) var strength setget set_str
export (int) var dexterity setget set_dex
export (int) var intelligence setget set_int
export (int) var luck setget set_luck

var attack setget set_attack
var defense setget set_defense

var level:int
var experiencePoints:int
var nextLevel_experiencePoints:int
var attributePoints:int
var skillPoints:int

signal stat_changed

func set_hp_max(value):
	hp_max = value
	emit_signal("stat_changed", "hp", self)

func set_hp(value):
	hp = value
	emit_signal("stat_changed", "hp", self)

func set_mp_max(value):
	mp_max = value
	emit_signal("stat_changed", "mp", self)
	
func set_mp(value):
	mp = value
	emit_signal("stat_changed", "mp", self)
	
func set_stamina_max(value):
	stamina_max = value
	emit_signal("stat_changed", "stamina", self)
	
func set_stamina(value):
	stamina = value
	emit_signal("stat_changed", "stamina", self)

func set_str(value):
	strength = value
	emit_signal("stat_changed", "str", self)

func set_dex(value):
	dexterity = value
	emit_signal("stat_changed", "dex", self)

func set_int(value):
	intelligence = value
	emit_signal("stat_changed", "int", self)
	
func set_luck(value):
	luck = value
	emit_signal("stat_changed", "luck", self)

func set_attack(value):
	attack = value
	emit_signal("stat_changed", "attack", self)

func set_defense(value):
	defense = value
	emit_signal("stat_changed", "defense", self)

func set_equipment(value):
	equipment = value
	
	_updateAttackDefense(equipment)

func useSkill(skillname, targets):
	# use the given skill on given targets and return the damage dealt
	return classSkills[skillname].use(self, targets)
	

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

func _updateAttackDefense(equipment):
	var tempAttack = 0
	var tempDefense = 0
	
	# simply count together all attack and defense values
	# of equited items
	for item in equipment.values():
		if item != null:
			tempAttack += item.attack
			tempDefense += item.defense
		
	self.attack = tempAttack
	self.defense = tempDefense
		

# TODO: check how to loop over dictionary in gdscript and get keys
#func _init():
#	for skill in classSkills:
#		unlockedSkills[skill.key] = false
