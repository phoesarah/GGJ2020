extends KinematicBody
export (float) var GRAVITY=-24
export (bool) var invert_mouse = 0
const MOUSE_SENSITIVITY=0.1
var camera_helper
var camera

var vel = Vector3()
const MAX_SPEED = 25
const JUMP_SPEED = 18
const ACCEL = 8

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

var debugtext


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera = $Rotation_Helper/Camera
	camera = get_node("CameraHelper/Camera")
	camera_helper = get_node("CameraHelper")


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		camera_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = camera_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		camera_helper.rotation_degrees = camera_rot


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)


func process_input(delta):
	# ----------------------------------
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
		get_tree().kill()
	input_movement_vector = input_movement_vector.normalized()

	# Basis vectors are already normalized.
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

	# Jumping
	if is_on_floor():
		if Input.is_action_just_pressed("movement_jump"):
			vel.y = JUMP_SPEED

	# Capturing/Freeing the cursor
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	debugtext=String(vel)
	get_node("Debug").text= debugtext