extends Sprite2D
class_name SpaceRock
var current_velocity: Vector2 = Vector2.ZERO # Manually track the spaceship's velocity
var worldbounds:Rect2
var bDead = false
@export var rock_size:int 

func _ready() -> void:
	randomize()
	worldbounds = get_viewport_rect()
	current_velocity = current_velocity + Vector2.UP *( randf() * 80)
	current_velocity = current_velocity +  current_velocity.rotated(randf() * 6.20 )
	rotate(randf() * 14.0 - 7.0)
	
func die():
	bDead = true;
func _process(delta: float) -> void:
	if bDead:
		queue_free()
	position += current_velocity * delta
	#lazylooping 
	if position.x < -40:
		position.x = worldbounds.size.x +40
	if position.y < -40:
		position.y = worldbounds.size.y +40
	if position.x > worldbounds.size.x +40:
		position.x = -40;
	if position.y > worldbounds.size.y +40:
		position.y = -40
