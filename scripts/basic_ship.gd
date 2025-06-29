extends Sprite2D
class_name PlayerShip


var current_velocity: Vector2 = Vector2.ZERO # Manually track the spaceship's velocity
var rotation_direction:float = 0
@export var thrust_acceleration = 320.0;
@export var rotateSpeed = 180
@export var bulletSpeed = 300;
@onready var thrust: Sprite2D = %thrust
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2


const SHOT = preload("res://scenes/shot.tscn")

var isAlive:bool
var isThrusting:bool = false;
var worldbounds:Rect2
func _ready() -> void:
	isAlive = true
	worldbounds = Globals.level_manager.camera_2d.get_viewport_rect()
	position = Globals.level_manager.player_spawn.position
	
func die():
	isAlive = false
	
func _process(delta: float) -> void:
	if isAlive:
		if (rotation_direction != 0):
			rotation += rotation_direction * deg_to_rad(rotateSpeed) * delta
		if isThrusting:
			var forward_vector = Vector2(0, -1).rotated(rotation)
			current_velocity += forward_vector * thrust_acceleration * delta
			thrust.show() 
		else:
			if thrust.visible:
				thrust.hide()
		position += current_velocity * delta	
		#lazylooping 
		if position.x < 0:
			position.x = worldbounds.size.x
		if position.y < 0:
			position.y = worldbounds.size.y
		if position.x > worldbounds.size.x:
			position.x = 0;
		if position.y > worldbounds.size.y:
			position.y = 0
	else:
		queue_free()
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Thrust"):
		isThrusting = true;
		audio_stream_player_2d_2.play()
	if event.is_action_released("Thrust"):
		isThrusting = false;
		audio_stream_player_2d_2.stop()
	if event.is_action_pressed("RotateCCW"):
		rotation_direction = -1.0;
	if event.is_action_released("RotateCCW"):
		rotation_direction = 0.0;
	if event.is_action_pressed("RotateCW"):
		rotation_direction = 1.0;
	if event.is_action_released("RotateCW"):
		rotation_direction = 0.0;
	if event.is_action_pressed("Shoot"):
		if Globals.level_manager.live_bullets < Globals.level_manager.total_bullets:
			var blt = SHOT.instantiate()
			audio_stream_player_2d.play()
			var forward_vector = Vector2(0, -1).rotated(rotation)
			var shorV = current_velocity + (forward_vector * bulletSpeed)
			blt.global_position =global_position
			blt.rotation = rotation
			blt.current_velocity = shorV
			get_parent().add_child(blt)
			Globals.level_manager.live_bullets = Globals.level_manager.live_bullets + 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.level_manager.destroy_player()
	pass # Replace with function body.
