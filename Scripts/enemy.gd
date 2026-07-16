extends CharacterBody2D


const SPEED = -40.0
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

func _ready() -> void:

	add_to_group("Enemy")
	Global.PositionEnemy=global_position
	
func _physics_process(delta: float) -> void:
	if Global.LIFE <=0:
		sprite_2d.play("Death")
		await get_tree().create_timer(1).timeout
		queue_free()
	move(delta)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hero") and Global.LIFE > 0 and body.get_node("AnimatedSprite2D").animation!="Attack" and body.get_node("AnimatedSprite2D").animation!="Death":
		sprite_2d.play("Attack")
		var animated := body.get_node("AnimatedSprite2D")
		animated.play("Damage")

func move(delta):
	move_and_collide(Vector2(SPEED*delta,0))
	




func _on_sprite_2d_animation_looped() -> void:
	if sprite_2d.animation=="Attack" and Global.LIFE >0:
		Global.LIFE-=1
