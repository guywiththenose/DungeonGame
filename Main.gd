extends Node2D

var Room = preload("res://Room.tscn")
var Player = preload("res://player.tscn")
const ENEMY_1 = preload("res://enemy_1.tscn")
const FINISH_PORTAL = preload("res://finish_portal.tscn")
@onready var map = $TileMap
@onready var main = get_node("/root/Main")

@export var tile_size = 16
@export var num_rooms = 30
@export var min_size = 4
@export var max_size = 10
@export var hspread = -10
@export var cull = 0.2
@export var enemy_min = 1
@export var enemy_max = 10

var path 
var start_room
var end_room
@onready var player = $Player
@onready var spawners
@onready var piss = $Spawners

@export var draw_rooms = false

func _ready():
	randomize()
	await make_rooms()
	await make_map()
	await find_end_room()
	await find_start_room()
	await level_finish_generator()
	await spawn_enemies()
	await generate_player()
	PlayerStats.dead.connect(player_death)

func generate_player():
	player.position = start_room.position

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randf_range(-hspread, hspread), 0)
		var r = Room.instantiate()
		var w = min_size + randi() % (max_size - min_size)
		var h = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(w, h) * tile_size)
		$Rooms.add_child(r)
	await(get_tree().create_timer(1.1).timeout)
	var room_positions = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			room_positions.append(Vector2(room.position.x, room.position.y))
			var marker = Marker2D.new()
			marker.global_position= Vector2(room.position.x, room.position.y)
			piss.add_child(marker)
			
	await get_tree().process_frame
	path = find_mst(room_positions)

func spawn_enemies():
	spawners = $Spawners.get_children()
	for spawn in spawners:
		if spawn.global_position == start_room.global_position or spawn.global_position == end_room.global_position:
			continue
		else:
			#var enemy = ENEMY_1.instantiate()
			#var spawn_point = spawn
			#enemy.global_position = spawn_point.global_position
			#main.add_child(enemy)
			
			var enemy_number = round(randi_range(enemy_min,enemy_max))
			for i in range(0, enemy_number):
				var enemy = ENEMY_1.instantiate()
				var spawn_point = spawn
				enemy.global_position = spawn_point.global_position
				main.add_child(enemy)
				enemy.global_position += Vector2(randi_range(-30,30), randi_range(-30,30))

func level_finish_generator():
	var portal = FINISH_PORTAL.instantiate()
	portal.global_position = end_room.global_position
	main.add_child(portal)

func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_distance = INF
		var min_p = null
		var p = null
		for p1 in path.get_point_ids():
			var p3
			p3 = path.get_point_position(p1)
			for p2 in nodes:
				if p3.distance_to(p2) < min_distance:
					min_distance = p3.distance_to(p2)
					min_p = p2
					p = p3
		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path

func _draw():
	if not draw_rooms:
		return
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size *2),
			Color(32,228,0), false)
	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(Vector2(pp.x, pp.y), Vector2(cp.x, cp.y), Color(1,1,0), 15, true)

func make_map():
	map.clear()
	var full_rect = Rect2()
	for room in $Rooms.get_children():
			var r = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents*2)
			full_rect = full_rect.merge(r)
	var topleft = map.local_to_map(full_rect.position)
	var bottomright = map.local_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			map.set_cell(0, Vector2i(x, y), 4, Vector2i(1, 1), 0)
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 -1):
			for y in range(2, s.y * 2 -1):
				map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 4, Vector2i(4, 7), 0)
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = map.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = map.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)

func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: 
		x_diff = pow(-1.0, randi() % 2)
	if y_diff == 0: 
		y_diff = pow(-1.0, randi() % 2)
	var x_y = pos1
	var y_x = pos2
	if (randi() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		map.set_cell(0, Vector2i(x, x_y.y), 4, Vector2i(4, 7), 0);
		map.set_cell(0, Vector2i(x, x_y.y + y_diff), 4, Vector2i(4, 7), 0);
	for y in range(pos1.y, pos2.y, y_diff):
		map.set_cell(0, Vector2i(y_x.x, y), 4, Vector2i(4, 7), 0);
		map.set_cell(0, Vector2i(y_x.x + x_diff, y), 4, Vector2i(4, 7), 0);

func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x

func player_death():
	get_tree().change_scene_to_file("res://Menu.tscn")
	

func _process(delta):
	queue_redraw()
