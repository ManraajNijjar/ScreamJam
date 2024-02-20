extends Node3D

@onready var display = $MeshInstance3D
@onready var viewport : SubViewport = $SubViewport
@onready var area = $Area3D
@onready var phoneScreenUI = $SubViewport/PhoneScreenBasic

var mesh_size = Vector2();

var mouse_entered = false;
var mouse_held = false;
var mouse_inside = false;

var last_mouse_pos_3D = null;
var last_mouse_pos_2D = null;

# Called when the node enters the scene tree for the first time.
func _ready():
	area.mouse_entered.connect(func(): mouse_entered = true)
	viewport.set_process_input(true);
	pass # Replace with function body.

func _unhandled_input(event):
	var is_mouse_event = false;
	if event is InputEventMouseMotion || event is InputEventMouseButton:
		is_mouse_event = true;
	
	if mouse_entered && (is_mouse_event || mouse_held):
		handle_mouse(event);
	elif !is_mouse_event:
		viewport.push_input(event);

func handle_mouse(event):
	mesh_size = display.mesh.size;

	if event is InputEventMouseButton || event is InputEventScreenTouch:
		
		mouse_held = event.pressed;
	
	var mouse_pos3d = find_mouse(event.global_position);
	mouse_inside = mouse_pos3d != null;

	if mouse_inside:
		mouse_pos3d = area.global_transform.affine_inverse() * mouse_pos3d;
		last_mouse_pos_3D = mouse_pos3d;
	else:
		mouse_pos3d = last_mouse_pos_3D;
		if mouse_pos3d == null:
			mouse_pos3d = Vector3.ZERO;

	var mouse_pos2d = Vector2(mouse_pos3d.x, -mouse_pos3d.y);

	#Converts from -mesh_size/2 to mesh_size/2
	mouse_pos2d.x += mesh_size.x / 2;
	mouse_pos2d.y += mesh_size.y / 2;

	#Converts to 0 to 1
	mouse_pos2d.x = mouse_pos2d.x / mesh_size.x;
	mouse_pos2d.y = mouse_pos2d.y / mesh_size.y;
	
	#Converts to viewport range
	mouse_pos2d.x = mouse_pos2d.x * viewport.size.x;
	mouse_pos2d.y = mouse_pos2d.y * viewport.size.y;

	event.position = mouse_pos2d;
	event.global_position = mouse_pos2d;

	if event is InputEventMouseMotion:
		if last_mouse_pos_2D == null:
			event.relative = Vector2.ZERO;
		else:
			event.relative = mouse_pos2d - last_mouse_pos_2D;
		
	last_mouse_pos_2D = mouse_pos2d;
	viewport.push_input(event);

func find_mouse(pos: Vector2):
	var camera = get_viewport().get_camera_3d();

	var dss:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state;

	var rayparam = PhysicsRayQueryParameters3D.new();
	rayparam.from = camera.project_ray_origin(pos);

	var distance = 5;

	rayparam.to = rayparam.from + camera.project_ray_normal(pos) * distance;
	rayparam.collide_with_bodies = false;
	rayparam.collide_with_areas = true;

	var result = dss.intersect_ray(rayparam);
	if result.size() > 0:
		return result.position;
	else:
		return null;

func showMomCall():
	phoneScreenUI.showMomCall();