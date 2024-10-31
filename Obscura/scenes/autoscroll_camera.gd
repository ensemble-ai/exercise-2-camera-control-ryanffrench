class_name AutoscrollCameraController
extends CameraControllerBase

#Made the box_height and width bigger for fun
@export var box_width: float = 15.0
@export var box_height: float = 15.0
@export var autoscroll_speed:Vector3 = Vector3(0.1, 0.0, 0.1)
@export var bottom_right:Vector2
@export var top_left:Vector2

func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
		
	#Updates top left and bottom right
	top_left = Vector2(position.x - box_width / 2, position.z - box_height / 2)
	bottom_right = Vector2(position.x + box_width / 2, position.z + box_height / 2)
	
	#player and camera move at autoscroll speed
	position += autoscroll_speed
	target.global_position += autoscroll_speed
	
	#Boundary checks. Moves player when the corners are hit
	#Top left
	if target.global_position.x < top_left.x:
		target.global_position.x = top_left.x
	elif target.global_position.x > bottom_right.x:
		target.global_position.x = bottom_right.x
	
	#Bottom right
	if target.global_position.z < top_left.y:
		target.global_position.z = top_left.y
	elif target.global_position.z > bottom_right.y:
		target.global_position.z = bottom_right.y
	
	

	super(delta)


func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -box_width / 2
	var right:float = box_width / 2
	var top:float = -box_height / 2
	var bottom:float = box_height / 2
	
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
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
