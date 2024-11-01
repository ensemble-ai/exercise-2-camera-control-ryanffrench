class_name LerpSmoothTargetCamera
extends CameraControllerBase


@export var cross_size:float = 20
@export var lead_speed:float = 25
@export var catchup_speed:float = 3
@export var leash_distance:float = 9
@export var catchup_delay_duration:float = 0.2
@export var timeStationary = 0

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
	
	#Calculates the camera target
	var lookahead = target.global_position + (target.velocity.normalized() * leash_distance)
	#If the player stops the camera waits before catching up
	if target.velocity == Vector3(0,0,0):
		timeStationary += delta
		if timeStationary >= catchup_delay_duration:
			global_position = lerp(global_position,target.global_position,catchup_speed * delta)
	else:
		#Camera is ahead of the player
		global_position = lerp(global_position,lookahead, lead_speed * delta)
		timeStationary = 0
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
