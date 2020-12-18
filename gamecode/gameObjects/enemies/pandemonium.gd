extends Resource
class_name Pandemonium

# a class to hold enemy-resources for a level. put all your enemies
# into this array, then load this resource from fightManager and
# randomly duplicate enemy resources for the fight

export (Array, Resource) var enemies
