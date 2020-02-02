extends RigidBody
class_name PropP

var start_transform = Transform()


func _ready():
	start_transform=self.get_global_transform()
	self.connect("body_entered", self, "body_entered")


func reset_transform():
	self.global_transform=start_transform
	self.MODE_STATIC


func body_entered(body):
#	set_deferred("self.contact_monitor", false)
#	self.contacts_reported=0
	get_parent().prop_disturbed(self)
