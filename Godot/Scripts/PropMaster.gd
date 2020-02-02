extends Spatial
var label
var box
var player


func _ready():
	label = get_node("Label")
	box = get_node("Box")
	player = get_parent().get_node("Player")


func prop_disturbed(prop):
	print("Prop disturbed")
	if !player.hit_props.has(prop):
		player.hit_props.append(prop)
