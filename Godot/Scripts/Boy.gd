extends Spatial
var anim
var speed = 8
var timer
var endT: Transform

# Called when the node enters the scene tree for the first time.
func _ready():
	anim=get_node("BoyDAE/AnimationPlayer")
	anim.play("imopen")
	timer=get_node("Timer")
	#endT=self.get_global_transform()+Transform()
	

func _physics_process(delta):
	if anim.current_animation == "Duck":
		translate(Vector3(0,-3,0)*delta)
		if timer.time_left<.1:
			print("Crawl")
			anim.play("Crawl")
	#linearinter
	if anim.current_animation == "Crawl":
		translate(Vector3(-1,0,0)*speed*delta)

func throw():
	anim.play("Duck")
	timer.start(1)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
