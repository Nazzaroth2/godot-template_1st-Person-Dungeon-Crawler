extends BaseItem
class_name Consumable

# every use of a consumable will reduce the amount by 1
# item-logic is in specific classes
func use(targets: Array):
	.use(targets)
