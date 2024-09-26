extends RigidBody2D

var size
#codes for room collision bodies that work with the main body code
func make_room(_pos,_size):
	position = _pos
	size = _size
	var s = RectangleShape2D.new()
	s.custom_solver_bias = 0.75
	s.extents = size
	$CollisionShape2D.shape = s
