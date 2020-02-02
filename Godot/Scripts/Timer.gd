extends Timer

var text

func _ready():
	text = get_node("TextTimer")
	self.connect("timeout", self, "lose")


func _process(delta):
	text.text = String(int(self.time_left)) + "\n" + String(self.time_left)


func lose():
	get_tree().change_scene("res://tscn/Scenes/GameOverScreen.tscn")
