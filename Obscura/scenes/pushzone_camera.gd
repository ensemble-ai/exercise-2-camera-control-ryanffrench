class_name PushZoneCamera
extends CameraControllerBase

@export var pushbox_width:float = 13.0
@export var pushbox_height:float = 13.0
@export var speedbox_width:float = 6.0
@export var speedbox_height:float = 6.0
@export var push_ratio:float = 4
@export var speedup_zone_top_left:Vector2
@export var speedup_zone_bottom_right:Vector2
@export var pushbox_bottom_right:Vector2
@export var pushbox_top_left:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = target.position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
		
	
	var tpos = target.global_position
	var cpos = global_position
	
	pushbox_top_left = Vector2(position.x - pushbox_width / 2, position.z - pushbox_height / 2)
	pushbox_bottom_right = Vector2(position.x + pushbox_width / 2, position.z + pushbox_height / 2)
	speedup_zone_top_left = Vector2(position.x - speedbox_width / 2, position.z - speedbox_height / 2)
	speedup_zone_bottom_right = Vector2(position.x + speedbox_width / 2, position.z + speedbox_height / 2)
	
	#speedbox
	var speed_diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - speedbox_width / 2.0)
	if speed_diff_between_left_edges < 0:
		global_position = lerp(global_position,target.global_position, push_ratio * delta)
	#right
	var speed_diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + speedbox_width / 2.0)
	if speed_diff_between_right_edges > 0:
		global_position = lerp(global_position,target.global_position, push_ratio * delta)
	#top
	var speed_diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - speedbox_height / 2.0)
	if speed_diff_between_top_edges < 0:
		global_position = lerp(global_position,target.global_position, push_ratio * delta)
	#bottom
	var speed_diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + speedbox_height / 2.0)
	if speed_diff_between_bottom_edges > 0:
		global_position = lerp(global_position,target.global_position, push_ratio * delta)
	
	
	#push box
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - pushbox_width / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + pushbox_width / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - pushbox_height / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + pushbox_height / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
	
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -pushbox_width / 2
	var right:float = pushbox_width / 2
	var top:float = -pushbox_height / 2
	var bottom:float = pushbox_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	
	immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
	immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	var mesh_instance2 := MeshInstance3D.new()
	var immediate_mesh2 := ImmediateMesh.new()
	var material2 := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var speed_left:float = -speedbox_width / 2
	var speed_right:float = speedbox_width / 2
	var speed_top:float = -speedbox_height / 2
	var speed_bottom:float = speedbox_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_bottom))
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	
	immediate_mesh.surface_add_vertex(Vector3(speed_left, 0, speed_top))
	immediate_mesh.surface_add_vertex(Vector3(speed_right, 0, speed_top))
	immediate_mesh.surface_end()

	material2.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material2.albedo_color = Color.BLACK
	
	add_child(mesh_instance2)
	mesh_instance2.global_transform = Transform3D.IDENTITY
	mesh_instance2.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
	mesh_instance2.queue_free()
