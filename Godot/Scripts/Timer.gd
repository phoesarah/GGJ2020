extends Timer

var text


func _ready():
	text = get_node("TextTimer")


func _process(delta):
	text.text = String(int(self.time_left)) + "\n" + String(self.time_left)
	pass
