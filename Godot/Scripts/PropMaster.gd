extends Spatial
var hit_props = Array()
var label
var box

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("Label")
	box = get_node("Box")
	pass # Replace with function body.

func prop_disturbed(prop):
	print("Prop disturbed")
	print(String(prop.sleeping))
	if prop.sleeping:
		print ("Prop not sleeping")
		if !hit_props.has(prop):
			hit_props.append(prop)
			

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	label.text=String(hit_props.size()) + "\n"
	#print("Box is sleeping" + String(box.sleeping))
#	pass
