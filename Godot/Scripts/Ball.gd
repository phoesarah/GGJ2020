extends RigidBody
signal hit_prop
var glove_live: bool = 0

func _ready():
	self.connect("hit_prop", get_node("../Player"), "ball_hit")
	self.connect("body_entered", self, "body_entered")
	pass

#func _process(delta):
	
func body_entered(body):
	print("Hit "+String(body.name))
	if glove_live==false and body.name!="Glove":
		glove_live = 1
		return
	if (body is PropP):
		print("Hit propp")
		emit_signal("hit_prop", body)
