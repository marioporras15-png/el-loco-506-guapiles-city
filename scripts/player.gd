extends CharacterBody3D

@export var speed := 5.2
@export var jump_velocity := 5.0
var gravity := 18.0
var input_vector := Vector2.ZERO
var jump_requested := false
var camera_pivot: Node3D

func _ready():
    name = "ElLoco"
    var body_mesh := MeshInstance3D.new()
    var capsule := CapsuleMesh.new()
    capsule.radius = 0.42
    capsule.height = 1.75
    body_mesh.mesh = capsule
    body_mesh.position.y = 0.9
    var mat := StandardMaterial3D.new()
    mat.albedo_color = Color(0.12, 0.34, 0.82)
    body_mesh.material_override = mat
    add_child(body_mesh)

    var head := MeshInstance3D.new()
    var head_mesh := SphereMesh.new()
    head_mesh.radius = 0.27
    head_mesh.height = 0.54
    head.mesh = head_mesh
    head.position.y = 1.98
    var skin := StandardMaterial3D.new()
    skin.albedo_color = Color(0.72, 0.48, 0.32)
    head.material_override = skin
    add_child(head)

    var shorts := MeshInstance3D.new()
    var box := BoxMesh.new()
    box.size = Vector3(0.65, 0.38, 0.38)
    shorts.mesh = box
    shorts.position = Vector3(0, 0.43, 0)
    var gray := StandardMaterial3D.new()
    gray.albedo_color = Color(0.72, 0.72, 0.7)
    shorts.material_override = gray
    add_child(shorts)

    camera_pivot = Node3D.new()
    camera_pivot.position.y = 1.55
    add_child(camera_pivot)
    var cam := Camera3D.new()
    cam.position = Vector3(0, 3.0, 6.5)
    cam.rotation_degrees.x = -17
    cam.current = true
    camera_pivot.add_child(cam)

func _physics_process(delta):
    var direction := Vector3(input_vector.x, 0, input_vector.y)
    if direction.length() > 1.0:
        direction = direction.normalized()
    velocity.x = direction.x * speed
    velocity.z = direction.z * speed
    if not is_on_floor():
        velocity.y -= gravity * delta
    elif jump_requested:
        velocity.y = jump_velocity
    jump_requested = false
    move_and_slide()
    if direction.length() > 0.1:
        rotation.y = lerp_angle(rotation.y, atan2(-direction.x, -direction.z), delta * 9.0)
