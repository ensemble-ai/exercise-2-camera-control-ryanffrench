class_name PosLockLerpCamera
extends CameraControllerBase

@export var box_width:float = 10.0
@export var box_height:float = 10.0
@export var cross_size:float = 20
@export var follow_speed:float = 10
@export var catchup_speed:float = 15
@export var leash_distance:float = 13

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
	
	var cameraDistToPlayer = global_position.distance_to(target.global_position)
	
	if target.velocity == Vector3(0,0,0):
		global_position = lerp(global_position,target.global_position,catchup_speed * delta)
	elif cameraDistToPlayer >= leash_distance: 
		#Camera essentially turns into a push box when the player gets too far.
		var tpos = target.global_position
		var cpos = global_position
		
		#boundary checks
		#left
		var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
		if diff_between_left_edges < 0:
			global_position.x += diff_between_left_edges
		#right
		var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
		if diff_between_right_edges > 0:
			global_position.x += diff_between_right_edges
		#top
		var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
		if diff_between_top_edges < 0:
			global_position.z += diff_between_top_edges
		#bottom
		var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
		if diff_between_bottom_edges > 0:
			global_position.z += diff_between_bottom_edges
	else:
		global_position = lerp(global_position,target.global_position,follow_speed * delta)
	
	super(delta)
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var half_size = cross_size / 5
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(0, 0, half_size))  # Top point
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -half_size)) # Bottom point

	immediate_mesh.surface_add_vertex(Vector3(half_size, 0, 0))  # Right point
	immediate_mesh.surface_add_vertex(Vector3(-half_size, 0, 0)) # Left point
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
