
extends CharacterBody2D
@onready var letter: Label = $Letter


func _physics_process(delta: float) -> void:
	move_and_collide(Vector2(0,Global.SPEED*delta))

func ControlLetter(char:String):
	letter.text=char
	Global.show_word_en+=char
	letter.add_theme_font_size_override("font_size", 100)
	
