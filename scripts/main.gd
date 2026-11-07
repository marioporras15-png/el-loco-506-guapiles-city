extends Node3D

const PlayerScript = preload("res://scripts/player.gd")
var player
var hud
var mission_index := 0
var mission_names := [
    "NIVEL 1: TRAVESÍA DEL BOULEVARD",
    "NIVEL 2: PARKOUR EN EL PARQUE",
    "NIVEL 3: EL GRAN TOPE",
    "NIVEL 4: BATALLA DE LOS COLEGIOS"
]
var rewards := ["Rice and Beans", "Copo + pan de chumino", "Patty con pollo de Mogambos", "¡Graduación!"]
var mission_markers: Array[Node3D] = []

func _ready():
    _make_environment()
    _make_town()
    player = CharacterBody3D.new()
    player.set_script(PlayerScript)
    player.position = Vector3(0, 0.2, 8)
    add_child(player)
    _make_missions()
    _make_hud()

func _make_environment():
    var world := WorldEnvironment.new()
    var env := Environment.new()
    env.background_mode = Environment.BG_SKY
    env.sky = Sky.new()
    env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    env.ambient_light_color = Color(0.72, 0.78, 0.82)
    env.ambient_light_energy = 0.8
    world.environment = env
    add_child(world)
    var sun := DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-48, -30, 0)
    sun.light_energy = 1.1
    add_child(sun)

func _box(parent: Node, name: String, pos: Vector3, size: Vector3, color: Color):
    var mesh_node := MeshInstance3D.new()
    mesh_node.name = name
    var mesh := BoxMesh.new()
    mesh.size = size
    mesh_node.mesh = mesh
    mesh_node.position = pos
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    mesh_node.material_override = material
    parent.add_child(mesh_node)
    var body := StaticBody3D.new()
    body.position = pos
    var shape := CollisionShape3D.new()
    var box_shape := BoxShape3D.new()
    box_shape.size = size
    shape.shape = box_shape
    body.add_child(shape)
    parent.add_child(body)
    return mesh_node

func _make_town():
    # Blockout jugable inspirado en el centro de Guápiles.
    # No es un levantamiento topográfico ni una réplica métrica del mapa.
    _box(self, "Terreno", Vector3(0, -0.35, 0), Vector3(180, 0.5, 180), Color(0.25, 0.48, 0.25))
    _box(self, "Avenida principal", Vector3(0, -0.08, 0), Vector3(15, 0.12, 170), Color(0.17, 0.18, 0.19))
    _box(self, "Calle transversal", Vector3(0, -0.07, 0), Vector3(170, 0.13, 12), Color(0.17, 0.18, 0.19))
    for x in [-55, -35, 35, 55]:
        for z in [-55, -30, 30, 55]:
            var c := Color(0.72, 0.56, 0.38) if int(abs(x+z)) % 2 == 0 else Color(0.76,0.72,0.61)
            _box(self, "Edificio", Vector3(x, 3, z), Vector3(17, 6, 18), c)
    # Parque central aproximado, al costado del cruce principal
    _box(self, "Parque Central", Vector3(23, 0.04, -4), Vector3(30, 0.2, 32), Color(0.25, 0.55, 0.28))
    for x in [12, 20, 28, 36]:
        _palm(Vector3(x, 0, -13))
        _palm(Vector3(x, 0, 5))
    _label("PARQUE CENTRAL DE GUÁPILES", Vector3(23, 3, -4), Color(0.1,0.25,0.1))
    _label("CENTRO DE GUÁPILES", Vector3(0, 1, 15), Color.WHITE)

func _palm(pos: Vector3):
    var trunk := MeshInstance3D.new()
    var cyl := CylinderMesh.new()
    cyl.top_radius = 0.16
    cyl.bottom_radius = 0.25
    cyl.height = 5.5
    trunk.mesh = cyl
    trunk.position = pos + Vector3(0,2.75,0)
    var m := StandardMaterial3D.new()
    m.albedo_color = Color(0.38,0.25,0.12)
    trunk.material_override = m
    add_child(trunk)
    for i in range(5):
        var leaf := MeshInstance3D.new()
        var box := BoxMesh.new()
        box.size = Vector3(3.4,0.12,0.38)
        leaf.mesh = box
        leaf.position = pos + Vector3(0,5.4,0)
        leaf.rotation.y = i * TAU / 5
        var lm := StandardMaterial3D.new()
        lm.albedo_color = Color(0.12,0.38,0.16)
        leaf.material_override = lm
        add_child(leaf)

func _label(text_value: String, pos: Vector3, color: Color):
    var label := Label3D.new()
    label.text = text_value
    label.position = pos
    label.font_size = 42
    label.modulate = color
    label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
    add_child(label)

func _make_missions():
    var spots := [Vector3(-5,0.3,55), Vector3(23,0.3,-4), Vector3(-48,0.3,-2), Vector3(48,0.3,48)]
    for i in range(4):
        var marker := MeshInstance3D.new()
        var mesh := CylinderMesh.new()
        mesh.top_radius = 1.4
        mesh.bottom_radius = 1.4
        mesh.height = 0.3
        marker.mesh = mesh
        marker.position = spots[i]
        var mat := StandardMaterial3D.new()
        mat.albedo_color = [Color.ORANGE, Color.CYAN, Color.GOLD, Color.MAGENTA][i]
        marker.material_override = mat
        add_child(marker)
        _label("MISIÓN %d" % (i+1), spots[i]+Vector3(0,2,0), Color.WHITE)
        mission_markers.append(marker)

func _make_hud():
    var layer := CanvasLayer.new()
    add_child(layer)
    var panel := PanelContainer.new()
    panel.position = Vector2(20, 18)
    panel.custom_minimum_size = Vector2(490, 100)
    layer.add_child(panel)
    var v := VBoxContainer.new()
    panel.add_child(v)
    var title := Label.new()
    title.text = "EL LOCO 506: GUÁPILES CITY"
    title.add_theme_font_size_override("font_size", 22)
    v.add_child(title)
    hud = Label.new()
    hud.text = "Explora el centro y busca los marcadores de misión."
    v.add_child(hud)
    var hint := Label.new()
    hint.text = "PC: WASD + ESPACIO  |  Android: controles táctiles en pantalla"
    v.add_child(hint)

    var controls := HBoxContainer.new()
    controls.position = Vector2(20, 560)
    layer.add_child(controls)
    for item in [["◀","left"],["▲","up"],["▼","down"],["▶","right"],["SALTAR","jump"],["MISIÓN","mission"]]:
        var b := Button.new()
        b.text = item[0]
        b.custom_minimum_size = Vector2(82, 76)
        b.pressed.connect(_button_action.bind(item[1]))
        controls.add_child(b)

func _button_action(action: String):
    if action == "jump":
        player.jump_requested = true
    elif action == "mission":
        _try_mission()
    else:
        var v := Vector2.ZERO
        if action == "left": v.x = -1
        if action == "right": v.x = 1
        if action == "up": v.y = -1
        if action == "down": v.y = 1
        player.input_vector = v
        await get_tree().create_timer(0.22).timeout
        if is_instance_valid(player):
            player.input_vector = Vector2.ZERO

func _process(_delta):
    if player:
        var nearest := 999999.0
        var nearest_i := -1
        for i in range(mission_markers.size()):
            var d := player.global_position.distance_to(mission_markers[i].global_position)
            if d < nearest:
                nearest = d
                nearest_i = i
        if nearest_i >= 0 and nearest < 9:
            hud.text = "Marcador cerca: %s\nPulsa MISIÓN para iniciar." % mission_names[nearest_i]
        else:
            hud.text = "Explora Guápiles. Próxima misión: %s" % mission_names[mission_index]

func _try_mission():
    var best := 999999.0
    var idx := -1
    for i in range(mission_markers.size()):
        var d := player.global_position.distance_to(mission_markers[i].global_position)
        if d < best:
            best = d
            idx = i
    if idx >= 0 and best < 10:
        if idx == mission_index:
            hud.text = "¡Misión completada!\nRecompensa: %s" % rewards[idx]
            mission_index = min(mission_index + 1, 3)
        else:
            hud.text = "Primero completa el nivel %d." % (mission_index + 1)
    else:
        hud.text = "Acércate a un marcador de misión."
