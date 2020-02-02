extends KinematicBody
export (float) var time_per_prop = 3
export (float) var GRAVITY=-24
export (bool) var invert_mouse_y = 0
var invert_y = 1
const MOUSE_SENSITIVITY=0.1
var camera_helper
var camera
var has_ball: bool = 1
var can_throw: bool = 1

var vel = Vector3()
const MAX_SPEED = 25
const JUMP_SPEED = 18
const ACCEL = 8
var dir = Vector3()
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var ray
var ball
var hit_props = Array()
var timer
var scene_win = load("res://tscn/Scenes/MenuWin.tscn")

var debugtext

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera = get_node("CameraHelper/Camera")
	camera_helper = get_node("CameraHelper")
	ray = get_node("CameraHelper/Camera/RayCast")
	timer = get_node("Timer")
	ball = preload("res://tscn/Props/Ball.tscn")
	if invert_mouse_y:
		invert_y=-1


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * invert_y))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		var camera_rot = camera_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera_helper.rotation_degrees = camera_rot


func _physics_process(delta):
	debugtext = ""
	process_input(delta)
	process_movement(delta)


func process_input(delta):
	# Walking
	dir = Vector3()
	var cam_xform = camera.get_global_transform()
	var input_movement_vector = Vector2()

	if Input.is_action_pressed("move_forward"):
		input_movement_vector.y += 1
	if Input.is_action_pressed("move_backward"):
		input_movement_vector.y -= 1
	if Input.is_action_pressed("move_left"):
		input_movement_vector.x -= 1
	if Input.is_action_pressed("move_right"):
		input_movement_vector.x += 1

	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
	input_movement_vector = input_movement_vector.normalized()

	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# Jumping
#	if is_on_floor():
#		if Input.is_action_just_pressed("movement_jump"):
#			vel.y = JUMP_SPEED

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_just_pressed("interact"):
		if has_ball:
			if !can_throw:
				ray.force_raycast_update()
				if ray.is_colliding():
					var obj = ray.get_collider()
					print(" Ray cast to: " + String(obj.name))
					if hit_props.has(obj):
						hit_props.erase(obj)
						obj.reset_transform()
						if hit_props.size()==0: #Win
							scene_win.instance()
							
							#get_tree().quit()
			if can_throw:
				var ballo=ball.instance()
				var scene_root = get_tree().root.get_children()[0]
				scene_root.add_child(ballo)
				var cht=camera_helper.get_global_transform()
				ballo.transform.origin=cht.origin+(cht.basis.z*5)
				ballo.apply_impulse(Vector3(0,0,0),cht.basis.z*100)
				has_ball=0
				can_throw=0


func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * GRAVITY

	var hvel = vel
	hvel.y = 0

	var target = dir
	target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel * delta)
	vel.x = hvel.x
	vel.z = hvel.z
	vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))

	debugtext += String(vel)
	#debugtext += "\n" + String(camera_helper.get_global_transform().basis.z) + "\n"
	#debugtext += "\n" + String(Vector3(camera_helper.get_transform().basis.x.x,camera_helper.get_transform().basis.y.y,camera_helper.get_transform().basis.z.z)) + "\n"
	debugtext += "\n hit_props size " + String(hit_props.size()) + "\n"
	get_node("Debug").text= debugtext + "\n" + "FPS: " + str(Engine.get_frames_per_second())

func prop_disturbed(prop):
	print("Prop disturbed")
	if !prop.sleepping:
		print ("Prop not sleeping")
		if !hit_props.has(prop):
			hit_props.append(prop)

#func ball_hit(prop):
#	pass
#	if !hit_props.has(prop):
#		hit_props.append(prop)

func caught():
	print("Caught ball")
	has_ball=1
	timer.start(hit_props.size()*time_per_prop)
