extends Sprite2D


@export var bulletSpeed = 20;
var current_velocity: Vector2 = Vector2.ZERO # Manually track the spaceship's velocity

func _process(delta: float) -> void:
	position += current_velocity * delta


func _on_timer_timeout() -> void:
	Globals.level_manager.live_bullets = Globals.level_manager.live_bullets - 1
	queue_free(); 


func _on_area_2d_area_entered(area: Area2D) -> void:
	Globals.level_manager.destroy_rock( area.get_parent())
	Globals.level_manager.live_bullets = Globals.level_manager.live_bullets - 1
	queue_free()
