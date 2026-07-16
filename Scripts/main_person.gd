extends  CharacterBody2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var MainPerson:= self.get_node("AnimatedSprite2D")


func _ready() -> void:

	Global.PositionMain=MainPerson.global_position.x
	add_to_group("Hero")


func _process(delta):
	if Global.LIFE <= 0 and MainPerson.animation != "Death":
		MainPerson.play("Death")
		await get_tree().create_timer(3).timeout
		Global.SPEED=200
		Global.Letter=false
		Global.Points=0
		Global.LIFE=33
		Global.PositionMain=0
		get_parent().get_tree().reload_current_scene()

func _on_area_2d_body_entered(body: Node2D) -> void:
		body.queue_free()

func Attack(color,txt,area,status,num_sprite,sprite):
	if Global.LIFE >0 and MainPerson !=null:
		MainPerson.play("Attack")
		STATUS(status,area,txt,color,num_sprite,sprite)

	else:
		MainPerson.play("Death")

func _on_animated_sprite_2d_animation_finished() -> void:
	if MainPerson.animation=="Attack":
		collision_shape_2d.disabled=false
		await get_tree().create_timer(0.7).timeout
		collision_shape_2d.disabled=true
		
func STATUS(status,area,txt,color,num_sprite,sprite):
#		area.modulate=color
		status.visible=true
		status.text=txt
		status.modulate=color
		sprite.frame=num_sprite
		await get_tree().create_timer(0.7).timeout
		sprite.frame=0
		collision_shape_2d.disabled=true
		MainPerson.play("Idle")
#		area.modulate=Color(0.20,0.14,0.36,0.70)
		status.visible=false
