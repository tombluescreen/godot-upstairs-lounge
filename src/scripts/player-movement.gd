extends KinematicBody

# Help: https://docs.godotengine.org/en/3.1/tutorials/3d/fps_tutorial/part_one.html

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var SPEED = 1;
var vel = Vector3.ZERO
var MAX_SPEED = 4
var JUMP_SPEED = 18
var ACCEL = 4.5
var MAX_SLOPE_ANGLE = 40
var DEACCEL = 16
var GRAVITY = 100

var dir = Vector3()

var camera
var rotation_helper
var MOUSE_SENSITIVITY = 0.05
# Called when the node enters the scene tree for the first time.
func _ready():
	camera = $rotation_helper/player_camera
	rotation_helper = $rotation_helper
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	#if Input.is_action_just_pressed("move_jump") and is_on_floor():
	#	velo.y = 10
	#velo.y -= gravity * delta
	#velo = move_and_slide(velo, Vector3.UP)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_input(delta):
	
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
	
	input_movement_vector = input_movement_vector.normalized()
	
	dir += -cam_xform.basis.z * input_movement_vector.y
	dir += cam_xform.basis.x * input_movement_vector.x

func process_movement(delta):
	dir.y = 0
	dir = dir.normalized()

	vel.y += delta * -GRAVITY

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


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))
		
		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot


