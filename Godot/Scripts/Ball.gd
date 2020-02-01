extends RigidBody
signal hit_prop

func _ready():
	self.connect("hit_prop", get_node("Player"), "hit_prop")
	pass

#func _process(delta):
	
func body_entered(body):
	if body.get_type() == PropP:
		pass
		#emit_signal("hit_prop"(body))
