extends RigidBody
class_name PropP

var start_transform


# Called when the node enters the scene tree for the first time.
func _ready():
	start_transform=self.get_global_transform()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
