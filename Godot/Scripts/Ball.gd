extends RigidBody
signal hit_prop
signal caught
var glove_live: bool = 0
var player

func _ready():
	#glove = get_node("../Player/CameraHelper/Glove")
	self.connect("hit_prop", get_node("../Player"), "ball_hit")
	self.connect("body_entered", self, "body_entered")
	#get_node("../Player/CameraHelper/Glove").connect("body_entered", self, "ball_hit")
	player = get_node("../Player")
	self.connect("caught", player, "caught")
	pass

#func _process(delta):
	
func body_entered(body):
	print("Hit "+String(body.name))
	if glove_live==false and body.name!="Glove":
		glove_live = 1
		return

	if (body is PropP):
		emit_signal("hit_prop", body)
	
	if body.name=="Glove" and glove_live == true:
		get_parent().remove_child(self)
		emit_signal("caught")
