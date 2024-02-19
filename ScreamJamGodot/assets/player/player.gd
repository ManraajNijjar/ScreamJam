extends CharacterBody3D


const SPEED = 3.0
const mouseSensitivity = 0.2;

@onready var camera = $head/Camera3D
@onready var head = $head
@onready var animationPlayer = $AnimationPlayer
var phoneInPlace = true;

@export var canMove = true;
@export var lockMouseOnStart = true;

@export var xClamp = 90;
@export var clampY = false;
@export var yClamp = 90;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if(lockMouseOnStart):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion && !Input.is_action_pressed("viewPhone"):
		rotate_y(deg_to_rad(-event.relative.x * mouseSensitivity))
		head.rotate_x(deg_to_rad(-event.relative.y * mouseSensitivity))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-xClamp), deg_to_rad(xClamp))
		if(clampY):
			rotation.y = clamp(rotation.y, deg_to_rad(-yClamp), deg_to_rad(yClamp))	


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	
	if Input.is_action_pressed("viewPhone"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
		if(phoneInPlace):
			phoneInPlace = false;
			animationPlayer.play("MovePhoneToFace");
	elif lockMouseOnStart:
		if(!phoneInPlace):
			phoneInPlace = true;
			animationPlayer.play("MovePhoneBack");
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	
	if !canMove:
		return;
	

	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
