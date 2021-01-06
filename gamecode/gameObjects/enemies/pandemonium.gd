extends Resource
class_name Pandemonium

# a class to hold enemy-resources for a fight setup.
# setup multiple resources per level and load them into the
# variable in fightmanager. This way you get randomly diffrent
# fightscenarios on a per level basis.

export (Array, Resource) var enemies
