extends RigidBody
class_name PropP

var start_transform = Transform()


# Called when the node enters the scene tree for the first time.
func _ready():
	start_transform=self.get_global_transform()
	#call_deferred("self.connect()", "sleeping_state_changed", get_node("../Player"), "prop_disturbed")
	#self.connect("sleeping_state_changed", get_node("../Payer"), "prop_disturbed")
	#self.connect("sleeping_state_changed", get_parent(), "prop_disturbed", [self])
	self.connect("body_entered", self, "body_entered")
	pass # Replace with function body.

func reset_transform():
	self.global_transform=start_transform
	#lock_axes(true)
	self.MODE_STATIC
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func body_entered(body):
	set_deferred("self.contact_monitor", false)
	self.contacts_reported=0
	get_parent().prop_disturbed(self)

func lock_axes(flag:bool):
	axis_lock_linear_x=flag
	axis_lock_linear_y=flag
	axis_lock_linear_z=flag
	axis_lock_angular_x=flag
	axis_lock_angular_y=flag
	axis_lock_angular_z=flag
