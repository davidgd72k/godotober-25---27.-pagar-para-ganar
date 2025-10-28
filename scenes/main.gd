extends Node3D

var dragging_collider: Node3D
var mouse_position
var do_drag := false

@onready var label: Label = $UI/Label

func _ready() -> void:
	label.hide()
	$Cashbox.get_coin.connect(_show_win_text)
	

func _process(delta: float) -> void:
	if dragging_collider:
		dragging_collider.global_position = mouse_position


func _input(event: InputEvent) -> void:
	var intersect
	
	# TODO: si el event es InputEventMouse.
	if event is InputEventMouse:
		intersect = get_mouse_intersect(event.position)
		if intersect: 
			mouse_position = intersect.position
	
	# TODO: si el event es un InputEventMouseButton.
	if event is InputEventMouseButton:
		var left_button_pressed = event.button_index == MOUSE_BUTTON_LEFT && event.pressed
		var left_button_released = event.button_index == MOUSE_BUTTON_LEFT && !event.pressed
	
		if left_button_released:
			do_drag = false
			drag_and_drop(intersect)
		elif left_button_pressed:
			do_drag = true
			drag_and_drop(intersect)
			

func drag_and_drop(intersect) -> void:
	var can_move = intersect.collider.is_in_group("movible")
		
	if !dragging_collider && do_drag && can_move:
		dragging_collider = intersect.collider
	elif dragging_collider:
		dragging_collider = null


func get_mouse_intersect(mouse_position):
	var current_camera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = current_camera.project_ray_origin(mouse_position)
	params.to = current_camera.project_position(mouse_position, 1000)
	
	if dragging_collider:
		params.exclude = [dragging_collider]
		
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	return result


func _show_win_text() -> void:
	label.show()
	$AudioStreamPlayer.play()
