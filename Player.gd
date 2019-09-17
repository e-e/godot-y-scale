extends KinematicBody2D

const SPEED = 100

var movements = {
	'move_left': Vector2.LEFT,
	'move_right': Vector2.RIGHT,
	'move_up': Vector2.UP,
	'move_down': Vector2.DOWN,
}

var max_size = 1.5
var min_size = 0.1

var movement = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta : float):
	movement = Vector2()
	
	for dir in movements.keys():
		if Input.is_action_pressed(dir):
			movement += movements[dir]
	
	movement.normalized()
	
	move_and_collide(movement * SPEED * delta)

	calc_scale()
	
func calc_scale():
	var bounds : Dictionary = get_min_max()
	
	var size = get_viewport().size
	var ratio = (position.y - bounds.min.position.y) / (bounds.max.position.y - bounds.min.position.y)
	var new_scale = interpolate(bounds.min.scale_magnitude, bounds.max.scale_magnitude, ratio)
	
	scale = Vector2(new_scale, new_scale)

func get_min_max() -> Dictionary:
	var size = get_viewport().size
	var bounds = {
		'min': {
			'position': {
				'y': 0
			}
		},
		'max': {
			'position': {
				'y': size.y,
			}
		}
	}
	var size_nodes = get_tree().get_nodes_in_group('size_position')
	
	for node in size_nodes:
		if node.position.y < position.y and bounds.min.position.y < node.position.y:
			bounds.min = node
		
		if node.position.y > position.y and bounds.max.position.y > node.position.y:
			bounds.max = node
	
	return bounds

func interpolate(a, b, t):
	return a + (b - a) * t