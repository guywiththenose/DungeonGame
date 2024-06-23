extends Node2D

var Room = preload("res://Room.tscn")
@onready var map = $TileMap

var tile_size = 32
var num_rooms = 50
var min_size = 4
var max_size = 10
var hspread = 400
var cull = 0.6

var path 

func _ready():
	randomize()
	make_rooms()

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
	await get_tree().process_frame
	path = find_mst(room_positions)

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
			tile_map.set_cells_terrain_connect(0, [Vector2i(x, y_over_x.y)], 0, 0)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		make_map()

func _process(delta):
	queue_redraw()
