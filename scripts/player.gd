extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@export var look_speed: Vector2 = Vector2(0.01, 0.01)
@export var run_speed_multiplier: float = 1.8

# Get the gravity from the project settings to be synced with RigidDynamicBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera_pivot: Node3D
var camera: Camera3D

func _ready():
	camera_pivot = get_node("CameraPivot")
	camera = get_node("CameraPivot/Camera3D")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_down", "ui_up")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	if Input.is_action_pressed("run"):
		velocity *= Vector3(run_speed_multiplier, 1, run_speed_multiplier)

	move_and_slide()


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if event.relative.x != 0:
			rotate_object_local(Vector3.UP, event.relative.x * look_speed.x)

